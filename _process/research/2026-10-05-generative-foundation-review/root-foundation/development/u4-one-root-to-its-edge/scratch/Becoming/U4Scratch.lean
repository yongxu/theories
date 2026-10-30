import Becoming.GrammarLaws
import Becoming.Continuity

/-!
# Scratch for U4, lever 1 (not a module of the package): balance as the count law of a class

Feasibility only; names are provisional. A pairing (`«对»`) under a relation keeps the count on
every region the relation closes both ways. Under a class (`«类»`) decided by a test, a pairing is
exactly equal count in every class. The one (`«一»`) gives count balance; sameness gives each
place's balance; the class a relation's adjacency closes gives balance along the relation, which is
`Continuity`'s conservation on every closed family. The teleport separates them.
-/

namespace Becoming
namespace U4Scratch

universe u

variable {α : Type u}

/-! ## Counting the units a test holds of -/

/-- How many units of a list a test holds of. -/
def countIn (p : α → Bool) : List α → Nat
  | [] => 0
  | x :: a => cond (p x) 1 0 + countIn p a

theorem countIn_append (p : α → Bool) : ∀ a b : List α,
    countIn p (a ++ b) = countIn p a + countIn p b
  | [], b => (Nat.zero_add (countIn p b)).symm
  | x :: a, b => by
    show cond (p x) 1 0 + countIn p (a ++ b) = cond (p x) 1 0 + countIn p a + countIn p b
    rw [countIn_append p a b, Nat.add_assoc]

theorem countIn_insert (p : α → Bool) (y : α) : ∀ b₁ b₂ : List α,
    countIn p (b₁ ++ y :: b₂) = cond (p y) 1 0 + countIn p (b₁ ++ b₂)
  | [], _ => rfl
  | z :: b₁, b₂ => by
    show cond (p z) 1 0 + countIn p (b₁ ++ y :: b₂) = cond (p y) 1 0 + (cond (p z) 1 0 + countIn p (b₁ ++ b₂))
    rw [countIn_insert p y b₁ b₂, Nat.add_left_comm]

/-- A test that holds of every unit counts the whole list. -/
theorem countIn_all : ∀ a : List α, countIn (fun _ => true) a = a.length
  | [] => rfl
  | _ :: a => by
    show 1 + countIn (fun _ => true) a = a.length + 1
    rw [countIn_all a, Nat.add_comm]

/-- Where a test holds of some unit, the list splits at one it holds of. -/
theorem split_of_pos {p : α → Bool} : ∀ {b : List α}, 0 < countIn p b →
    ∃ b₁ y b₂, b = b₁ ++ y :: b₂ ∧ p y = true
  | [], pos => absurd pos (Nat.lt_irrefl 0)
  | y :: b, pos => by
    cases hy : p y with
    | true => exact ⟨[], y, b, rfl, hy⟩
    | false =>
      have rest : 0 < countIn p b := by
        have e : countIn p (y :: b) = countIn p b := by
          show cond (p y) 1 0 + countIn p b = countIn p b
          rw [hy]; exact Nat.zero_add _
        exact e ▸ pos
      match split_of_pos rest with
      | ⟨b₁, z, b₂, e, hz⟩ => exact ⟨y :: b₁, z, b₂, e ▸ rfl, hz⟩

/-! ## A pairing keeps the count on every region closed both ways -/

/-- A region read as a test, closed under a relation and its converse, is one on which the
relation never crosses: related units lie both in it or both outside it. -/
theorem closed_both {R : «际» α} {p : α → Bool}
    (forward : «闭» R (fun x => p x = true)) (backward : «闭» («逆» R) (fun x => p x = true)) :
    ∀ x y, R x y → p x = p y := fun x y r => by
  cases hx : p x <;> cases hy : p y
  · rfl
  · exact Bool.noConfusion (hx.symm.trans (backward y x hy r))
  · exact Bool.noConfusion (hy.symm.trans (forward x y hx r))
  · rfl

/-- **A pairing under a relation keeps the count on every region the relation does not cross.**
Each pair lies both in the region or both outside it. -/
theorem «对则闭域守数» {R : «际» α} {p : α → Bool} (closed : ∀ x y, R x y → p x = p y)
    {a b : List α} (h : «对» R a b) : countIn p a = countIn p b := by
  induction h with
  | nil => rfl
  | @cons x y a b₁ b₂ r _ ih =>
    show cond (p x) 1 0 + countIn p a = countIn p (b₁ ++ y :: b₂)
    rw [countIn_insert, closed x y r, ih]

/-- The same, with the region stated as closed under the relation and its converse. -/
theorem «对则闭域守数'» {R : «际» α} {p : α → Bool}
    (forward : «闭» R (fun x => p x = true)) (backward : «闭» («逆» R) (fun x => p x = true))
    {a b : List α} (h : «对» R a b) : countIn p a = countIn p b :=
  «对则闭域守数» (closed_both forward backward) h

/-! ## Under a class, a pairing is exactly equal count in every class -/

section Class

variable {E : «际» α} {e : α → α → Bool}

/-- Related units are counted alike by every class's test. -/
theorem test_congr (cls : «类» E) (dec : ∀ x y, E x y ↔ e x y = true) {x y : α} (r : E x y)
    (z : α) : e z x = e z y := by
  cases hx : e z x <;> cases hy : e z y
  · rfl
  · exact Bool.noConfusion (hx.symm.trans ((dec z x).mp (cls.trans ((dec z y).mpr hy) (cls.symm r))))
  · exact Bool.noConfusion (hy.symm.trans ((dec z y).mp (cls.trans ((dec z x).mpr hx) r)))
  · rfl

/-- Equal count in every class gives a pairing under the class. -/
theorem pair_of_counts (cls : «类» E) (dec : ∀ x y, E x y ↔ e x y = true) :
    ∀ (a b : List α), (∀ z, countIn (e z) a = countIn (e z) b) → «对» E a b
  | [], [], _ => .nil
  | [], y :: b, counts => by
    have hy : countIn (e y) (y :: b) = 1 + countIn (e y) b :=
      congrArg (fun v => cond v 1 0 + countIn (e y) b) ((dec y y).mp (cls.refl y))
    have zero : countIn (e y) (y :: b) = 0 := (counts y).symm
    exact Nat.noConfusion ((zero.symm.trans hy).trans (Nat.add_comm 1 _))
  | x :: a, b, counts => by
    have pos : 0 < countIn (e x) b := by
      have hx : countIn (e x) (x :: a) = 1 + countIn (e x) a :=
        congrArg (fun v => cond v 1 0 + countIn (e x) a) ((dec x x).mp (cls.refl x))
      have more : countIn (e x) b = countIn (e x) a + 1 :=
        (counts x).symm.trans (hx.trans (Nat.add_comm 1 _))
      rw [more]
      exact Nat.succ_pos _
    match split_of_pos pos with
    | ⟨b₁, y, b₂, e₁, hy⟩ =>
      cases e₁
      have r : E x y := (dec x y).mpr hy
      refine .cons r (pair_of_counts cls dec a (b₁ ++ b₂) fun z => ?_)
      have h : cond (e z x) 1 0 + countIn (e z) a = cond (e z y) 1 0 + countIn (e z) (b₁ ++ b₂) :=
        (counts z).trans (countIn_insert (e z) y b₁ b₂)
      rw [test_congr cls dec r z] at h
      exact Naturals.add_left_cancel h

/-- **The count law of a class.** Under a class decided by a test, two lists are paired one to
one exactly where every class holds as many units of the one as of the other. -/
theorem «类之对当且仅当类类等数» (cls : «类» E) (dec : ∀ x y, E x y ↔ e x y = true)
    {a b : List α} : «对» E a b ↔ ∀ z, countIn (e z) a = countIn (e z) b :=
  ⟨fun h z => «对则闭域守数» (p := e z) (fun _ _ r => test_congr cls dec r z) h, pair_of_counts cls dec a b⟩

end Class

/-- The one is a class decided by the test that always holds, and its count law is equal count:
`«一之对»` is a case. -/
theorem one_case {a b : List α} : «对» «一» a b ↔ a.length = b.length := by
  have law := «类之对当且仅当类类等数» (E := «一») (e := fun _ _ => true)
    ⟨fun _ => trivial, fun _ => trivial, fun _ _ => trivial⟩ (fun _ _ => ⟨fun _ => rfl, fun _ => trivial⟩)
    (a := a) (b := b)
  exact ⟨fun h => (countIn_all a).symm.trans
      ((«对则闭域守数» (p := fun _ => true) (fun _ _ _ => rfl) h).trans (countIn_all b)),
    fun h => law.mpr fun _ => (countIn_all a).trans (h.trans (countIn_all b).symm)⟩

/-! ## The teleport: equal count, and no pairing under sameness -/

/-- Sameness (`«静»`) on whole numbers is a class decided by `Nat.beq`. -/
theorem nat_same_class : «类» («静» : «际» Nat) :=
  ⟨fun _ => rfl, fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

/-- **The teleport.** A unit at one place before and at another after: equal count, so paired under
the one, and no pairing under sameness, since the first place holds one unit before and none after. -/
theorem teleport : «对» «一» [0] [1] ∧ ¬ «对» («静» : «际» Nat) [0] [1] :=
  ⟨«等长则一对» [0] [1] rfl, fun h =>
    Nat.noConfusion («对则闭域守数» (p := Nat.beq 0) (fun x y (same : x = y) => congrArg (Nat.beq 0) same) h)⟩

/-! ## Balance along a relation: `Continuity`'s closed families are the regions closed both ways -/

section AlongRelation

variable {R : Type}

/-- Adjacency among the listed relata, read as a relation of the grammar. -/
def listedAdj (rel : R → R → Bool) (us : List R) : «际» R := fun a b => a ∈ us ∧ b ∈ us ∧ Continuity.adj rel a b = true

theorem listedAdj_symm (rel : R → R → Bool) (us : List R) {a b : R} (h : listedAdj rel us a b) : listedAdj rel us b a :=
  ⟨h.2.1, h.1, (Continuity.adj_symm rel b a).trans h.2.2⟩

/-- **A family `Continuity` calls closed is exactly a region closed under listed adjacency.** Since
adjacency is symmetric, closed one way is closed both ways. -/
theorem closes_iff (rel : R → R → Bool) (us : List R) {p : R → Bool} :
    Continuity.Closes rel us p ↔ «闭» (listedAdj rel us) (fun x => p x = true) :=
  ⟨fun closes x y holds r => (closes x y r.1 r.2.1 r.2.2).symm.trans holds,
   fun closed a b ma mb r => closed_both (R := listedAdj rel us) closed
     (fun x y holds back => closed x y holds (listedAdj_symm rel us back)) a b ⟨ma, mb, r⟩⟩

/-- **Balance along a relation, on the grammar.** Over relata listed once, transfers along the
relation that balance a web's levels at every step exist exactly where, at every step, the total is
conserved on every region closed under the listed adjacency (`Continuity.balancesOn_iff_conserved`
with its families read as `«闭»`). -/
theorem balancesOn_iff_closed [DecidableEq R] {us : List R} {rel : Nat → R → R → Bool} {W : Web R R}
    (distinct : Distinct us) :
    (∃ move : Nat → R → R → Nat, (∀ t a b, 0 < move t a b → Continuity.adj (rel t) a b = true ∧ a ∈ us ∧ b ∈ us) ∧
        ∀ t, (Continuity.flow us move).BalancesOn W us t) ↔
      ∀ t (p : R → Bool), «闭» (listedAdj (rel t) us) (fun x => p x = true) →
        total us (Continuity.within p (W.level (t + 1))) = total us (Continuity.within p (W.level t)) :=
  (Continuity.balancesOn_iff_conserved distinct).trans
    ⟨fun conserved t p closed => conserved t p ((closes_iff (rel t) us).mpr closed),
     fun closed t p closes => closed t p ((closes_iff (rel t) us).mp closes)⟩

end AlongRelation

/-! ## A pairing under continuation keeps the count in every class -/

/-- **What a pairing under continuation adds to equal count.** Continuation relative to a class
lies within the class, so a pairing under it keeps the count in every class. -/
theorem «续之对则类类等数» {R E : «际» α} {e : α → α → Bool} (cls : «类» E)
    (dec : ∀ x y, E x y ↔ e x y = true) {a b : List α} (h : «对» («续» R E) a b) (z : α) :
    countIn (e z) a = countIn (e z) b :=
  («类之对当且仅当类类等数» cls dec).mp
    («对之单调» (fun x y (both : R x y ∧ E x y) => both.2) h) z

/-! ## Each place's balance is one pairing of located units under sameness -/

section Place

variable {C : Type}

/-- Units located at places: each listed place repeated as often as a level says. -/
def place (q : C → Nat) : List C → List C
  | [] => []
  | c :: cs => List.replicate (q c) c ++ place q cs

theorem countIn_replicate (p : C → Bool) (c : C) : ∀ n, countIn p (List.replicate n c) = cond (p c) n 0
  | 0 => by cases p c <;> rfl
  | n + 1 => by
    show cond (p c) 1 0 + countIn p (List.replicate n c) = cond (p c) (n + 1) 0
    rw [countIn_replicate p c n]
    cases p c with
    | false => rfl
    | true => exact Nat.add_comm 1 n

theorem countIn_place (p : C → Bool) (q : C → Nat) : ∀ cs : List C,
    countIn p (place q cs) = total cs (fun c => cond (p c) (q c) 0)
  | [] => rfl
  | c :: cs => by
    show countIn p (List.replicate (q c) c ++ place q cs) =
      cond (p c) (q c) 0 + total cs (fun c => cond (p c) (q c) 0)
    rw [countIn_append, countIn_replicate, countIn_place p q cs]

theorem cond_add (b : Bool) (x y : Nat) : cond b (x + y) 0 = cond b x 0 + cond b y 0 := by
  cases b with
  | false => rfl
  | true => rfl

theorem total_congr {f g : C → Nat} : ∀ cs : List C, (∀ c, c ∈ cs → f c = g c) →
    total cs f = total cs g
  | [], _ => rfl
  | c :: cs, same => by
    show f c + total cs f = g c + total cs g
    rw [same c (.head cs), total_congr cs (fun d m => same d (.tail c m))]

/-- The units at two levels, counted at one place by a test. -/
theorem countIn_pair (p : C → Bool) (q₁ q₂ : C → Nat) (cs : List C) :
    countIn p (place q₁ cs ++ place q₂ cs) = total cs (fun c => cond (p c) (q₁ c + q₂ c) 0) := by
  rw [countIn_append, countIn_place, countIn_place, ← total_add]
  exact total_congr cs (fun c _ => (cond_add (p c) (q₁ c) (q₂ c)).symm)

variable {eq : C → C → Bool}

theorem total_off (dec : ∀ x y, x = y ↔ eq x y = true) (f : C → Nat) (c : C) :
    ∀ ds : List C, ¬ c ∈ ds → total ds (fun d => cond (eq c d) (f d) 0) = 0
  | [], _ => rfl
  | d :: ds, notMem => by
    cases h : eq c d with
    | false =>
      show cond (eq c d) (f d) 0 + total ds (fun d => cond (eq c d) (f d) 0) = 0
      rw [h, total_off dec f c ds (fun m => notMem (.tail d m))]
      rfl
    | true =>
      cases (dec c d).mpr h
      exact absurd (.head ds) notMem

theorem total_pick (dec : ∀ x y, x = y ↔ eq x y = true) (f : C → Nat) (c : C) :
    ∀ cs : List C, Distinct cs → c ∈ cs → total cs (fun d => cond (eq c d) (f d) 0) = f c
  | d :: ds, ⟨notMem, distinct⟩, mem => by
    cases h : eq c d with
    | true =>
      cases (dec c d).mpr h
      show cond (eq c c) (f c) 0 + total ds (fun d => cond (eq c d) (f d) 0) = f c
      rw [h, total_off dec f c ds notMem]
      rfl
    | false =>
      cases mem with
      | head => exact Bool.noConfusion (h.symm.trans ((dec c c).mp rfl))
      | tail _ m =>
        show cond (eq c d) (f d) 0 + total ds (fun d => cond (eq c d) (f d) 0) = f c
        rw [h, total_pick dec f c ds distinct m]
        exact Nat.zero_add (f c)

/-- **Each condition's balance is one pairing under sameness.** Over conditions listed once, a flow
balances a web across a step exactly where the units standing before with those given, each at its
condition, are paired one to one under sameness with the units standing after with those taken. -/
theorem balancesOn_iff_place {F : Type} (dec : ∀ x y, x = y ↔ eq x y = true) {L : Flow F C}
    {W : Web F C} {cs : List C} {t : Nat} (distinct : Distinct cs) :
    L.BalancesOn W cs t ↔ «对» («静» : «际» C) (place (W.level t) cs ++ place (L.given t) cs)
      (place (W.level (t + 1)) cs ++ place (L.taken t) cs) := by
  have law := «类之对当且仅当类类等数» (E := («静» : «际» C)) (e := eq)
    ⟨fun _ => rfl, fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩ dec
    (a := place (W.level t) cs ++ place (L.given t) cs)
    (b := place (W.level (t + 1)) cs ++ place (L.taken t) cs)
  refine ⟨fun balances => law.mpr fun z => ?_, fun paired c mem => ?_⟩
  · rw [countIn_pair, countIn_pair]
    exact total_congr cs (fun c m => congrArg (fun v => cond (eq z c) v 0) (balances c m).symm)
  · have counts := law.mp paired c
    rw [countIn_pair, countIn_pair, total_pick dec _ c cs distinct mem,
      total_pick dec _ c cs distinct mem] at counts
    exact counts.symm

end Place

/-! ## The census: units continuing one to one are paired under continuation or sameness -/

section Census

variable {U : Type}

/-- The units a test keeps, in order. -/
def keep (p : U → Bool) : List U → List U
  | [] => []
  | x :: l => cond (p x) (x :: keep p l) (keep p l)

theorem keep_append (p : U → Bool) : ∀ a b : List U, keep p (a ++ b) = keep p a ++ keep p b
  | [], _ => rfl
  | x :: a, b => by
    show cond (p x) (x :: keep p (a ++ b)) (keep p (a ++ b)) = cond (p x) (x :: keep p a) (keep p a) ++ keep p b
    rw [keep_append p a b]
    cases p x <;> rfl

theorem keep_congr {p q : U → Bool} : ∀ l : List U, (∀ x, x ∈ l → p x = q x) → keep p l = keep q l
  | [], _ => rfl
  | x :: l, same => by
    show cond (p x) (x :: keep p l) (keep p l) = cond (q x) (x :: keep q l) (keep q l)
    rw [same x (.head l), keep_congr l (fun y m => same y (.tail x m))]

theorem keep_all {p : U → Bool} : ∀ l : List U, (∀ x, x ∈ l → p x = true) → keep p l = l
  | [], _ => rfl
  | x :: l, all => by
    show cond (p x) (x :: keep p l) (keep p l) = x :: l
    rw [all x (.head l), keep_all l (fun y m => all y (.tail x m))]
    rfl

theorem any_false_mem {p : U → Bool} : ∀ {l : List U} {x : U}, l.any p = false → x ∈ l → p x = false
  | h :: t, _, hn, .head _ => by
    cases hp : p h with
    | false => rfl
    | true => exact Bool.noConfusion ((congrArg (· || t.any p) hp).symm.trans hn)
  | h :: t, _, hn, .tail _ m => by
    cases hp : p h with
    | false => exact any_false_mem (l := t) ((congrArg (· || t.any p) hp).symm.trans hn) m
    | true => exact Bool.noConfusion ((congrArg (· || t.any p) hp).symm.trans hn)

theorem any_split {p : U → Bool} : ∀ {l : List U}, l.any p = true →
    ∃ a₁ y a₂, l = a₁ ++ y :: a₂ ∧ p y = true
  | [], hn => Bool.noConfusion hn
  | h :: t, hs => by
    cases hp : p h with
    | true => exact ⟨[], h, t, rfl, hp⟩
    | false =>
      match any_split (l := t) ((congrArg (· || t.any p) hp).symm.trans hs) with
      | ⟨a₁, y, a₂, e, hy⟩ => exact ⟨h :: a₁, y, a₂, e ▸ rfl, hy⟩

theorem any_remove {p : U → Bool} {f : U} (off : p f = false) (a₂ : List U) :
    ∀ a₁ : List U, (a₁ ++ f :: a₂).any p = (a₁ ++ a₂).any p
  | [] => by
    show (p f || a₂.any p) = a₂.any p
    rw [off]; rfl
  | h :: a₁ => congrArg (p h || ·) (any_remove off a₂ a₁)

theorem mem_middle (y : U) (a₂ : List U) : ∀ a₁ : List U, y ∈ a₁ ++ y :: a₂
  | [] => .head a₂
  | h :: a₁ => .tail h (mem_middle y a₂ a₁)

theorem mem_of_removed {x y : U} {a₂ : List U} : ∀ {a₁ : List U}, x ∈ a₁ ++ a₂ → x ∈ a₁ ++ y :: a₂
  | [], m => .tail y m
  | h :: a₁, m => by
    cases m with
    | head => exact .head _
    | tail _ m => exact .tail h (mem_of_removed m)

theorem distinct_removed {y : U} {a₂ : List U} : ∀ {a₁ : List U}, Distinct (a₁ ++ y :: a₂) →
    Distinct (a₁ ++ a₂) ∧ ¬ y ∈ a₁ ++ a₂
  | [], d => ⟨d.2, d.1⟩
  | h :: a₁, d =>
    have rest := distinct_removed (a₁ := a₁) d.2
    ⟨⟨fun m => d.1 (mem_of_removed m), rest.1⟩, fun m => by
      cases m with
      | head => exact d.1 (mem_middle _ a₂ a₁)
      | tail _ m => exact rest.2 m⟩

variable (k : U → U → Bool)

/-- The units before that no unit after continues: they cease across the step. -/
def ceasing (before after : List U) : List U := keep (fun g => !(after.any (k g))) before

/-- The units after that continue no unit before: they arise across the step. -/
def arising (before after : List U) : List U := keep (fun f => !(before.any (fun g => k g f))) after

/-- **The census as a pairing.** Where units listed once at the two ends of a step continue one to
one (no unit continues as two, no two continue as one), the units before with those arising are
paired one to one with the units after with those ceasing, each pair a continuation or the same
unit. -/
theorem census_pairs : ∀ (before after : List U), Distinct before → Distinct after →
    (∀ g f f', g ∈ before → f ∈ after → f' ∈ after → k g f = true → k g f' = true → f = f') →
    (∀ g g' f, g ∈ before → g' ∈ before → f ∈ after → k g f = true → k g' f = true → g = g') →
    «对» (fun x y => k x y = true ∨ x = y) (before ++ arising k before after)
      (after ++ ceasing k before after)
  | [], after, _, _, _, _ => by
    show «对» _ (keep (fun f => !(([] : List U).any (fun g => k g f))) after) (after ++ [])
    rw [ListTests.append_nil, keep_all (p := fun f => !(([] : List U).any fun g => k g f)) after (fun _ _ => rfl)]
    exact «对之自反» (R := fun x y => k x y = true ∨ x = y) (fun _ => Or.inr rfl) after
  | g :: before, after, ⟨gNot, dB⟩, dA, noSplit, noMerge => by
    cases hg : after.any (k g) with
    | false =>
      have cz : ceasing k (g :: before) after = g :: ceasing k before after := by
        show cond (!(after.any (k g))) (g :: ceasing k before after) (ceasing k before after) = _
        rw [hg]; rfl
      have az : arising k (g :: before) after = arising k before after :=
        keep_congr after fun f m => by
          show (!(k g f || before.any (fun g => k g f))) = !(before.any (fun g => k g f))
          rw [any_false_mem hg m]; rfl
      show «对» _ (g :: (before ++ arising k (g :: before) after)) (after ++ ceasing k (g :: before) after)
      rw [az, cz]
      exact .cons (b₁ := after) (Or.inr rfl) (census_pairs before after dB dA
        (fun g f f' mg => noSplit g f f' (.tail _ mg))
        (fun g g' f mg mg' => noMerge g g' f (.tail _ mg) (.tail _ mg')))
    | true =>
      match any_split hg with
      | ⟨a₁, f, a₂, e, kf⟩ =>
        cases e
        have dA' := distinct_removed dA
        have cz : ceasing k (g :: before) (a₁ ++ f :: a₂) = ceasing k before (a₁ ++ a₂) := by
          show cond (!((a₁ ++ f :: a₂).any (k g))) _ (ceasing k before (a₁ ++ f :: a₂)) = _
          rw [hg]
          exact keep_congr before fun g' m => by
            have off : k g' f = false := by
              cases h : k g' f with
              | false => rfl
              | true =>
                cases noMerge g g' f (.head _) (.tail _ m) (mem_middle f a₂ a₁) kf h
                exact absurd m gNot
            rw [any_remove off]
        have az : arising k (g :: before) (a₁ ++ f :: a₂) = arising k before (a₁ ++ a₂) := by
          show keep _ (a₁ ++ f :: a₂) = keep _ (a₁ ++ a₂)
          rw [keep_append, keep_append]
          show _ ++ cond (!(k g f || before.any (fun g => k g f))) _ _ = _
          rw [kf]
          show keep _ a₁ ++ keep _ a₂ = _
          rw [← keep_append, ← keep_append]
          exact keep_congr (a₁ ++ a₂) fun x m => by
            have off : k g x = false := by
              cases h : k g x with
              | false => rfl
              | true =>
                cases noSplit g x f (.head _) (mem_of_removed m) (mem_middle f a₂ a₁) h kf
                exact absurd m dA'.2
            show (!(k g x || before.any (fun g => k g x))) = !(before.any (fun g => k g x))
            rw [off]; rfl
        show «对» _ (g :: (before ++ arising k (g :: before) (a₁ ++ f :: a₂)))
          ((a₁ ++ f :: a₂) ++ ceasing k (g :: before) (a₁ ++ f :: a₂))
        rw [az, cz, ListTests.append_assoc]
        have IH := census_pairs before (a₁ ++ a₂) dB dA'.1
          (fun g x x' mg mx mx' => noSplit g x x' (.tail _ mg) (mem_of_removed mx) (mem_of_removed mx'))
          (fun g g' x mg mg' mx => noMerge g g' x (.tail _ mg) (.tail _ mg') (mem_of_removed mx))
        rw [ListTests.append_assoc] at IH
        exact .cons (b₁ := a₁) (b₂ := a₂ ++ ceasing k before (a₁ ++ a₂)) (Or.inl kf) IH

/-- **The census in the grammar's terms.** Where the continuation fixes successors (`«定后»`, no unit
continues as two) and predecessors (`«定前»`, no two continue as one), the units before with those
arising are paired, under continuation or sameness, with the units after with those ceasing. -/
theorem census_pairs_of_fixed (before after : List U) (dB : Distinct before) (dA : Distinct after)
    (fixedAfter : «定后» (fun x y => k x y = true)) (fixedBefore : «定前» (fun x y => k x y = true)) :
    «对» (fun x y => k x y = true ∨ x = y) (before ++ arising k before after)
      (after ++ ceasing k before after) :=
  census_pairs k before after dB dA
    (fun g f f' _ _ _ r r' => «定后之逐点».mp fixedAfter g f f' r r')
    (fun g g' f _ _ _ r r' => «定前之逐点».mp fixedBefore g g' f r r')

/-- **The census balance, from the pairing.** Units continuing one to one across a step: those after
with those ceasing are as many as those before with those arising. -/
theorem census_balance (before after : List U) (dB : Distinct before) (dA : Distinct after)
    (noSplit : ∀ g f f', g ∈ before → f ∈ after → f' ∈ after → k g f = true → k g f' = true → f = f')
    (noMerge : ∀ g g' f, g ∈ before → g' ∈ before → f ∈ after → k g f = true → k g' f = true → g = g') :
    after.length + (ceasing k before after).length = before.length + (arising k before after).length :=
  «对则守数» (census_pairs k before after dB dA noSplit noMerge)

/-- **Each condition's balance, from units continuing one to one.** Where a condition's level before
and after a step counts its units, and what a flow gives and takes there counts the units arising and
ceasing, with as many more passing through within the step on both sides, the flow balances there. -/
theorem balances_at_of_census {F C : Type} {L : Flow F C} {W : Web F C} {t : Nat} {c : C}
    (before after : List U) (dB : Distinct before) (dA : Distinct after)
    (noSplit : ∀ g f f', g ∈ before → f ∈ after → f' ∈ after → k g f = true → k g f' = true → f = f')
    (noMerge : ∀ g g' f, g ∈ before → g' ∈ before → f ∈ after → k g f = true → k g' f = true → g = g')
    (passing : Nat) (stands : W.level t c = before.length) (stood : W.level (t + 1) c = after.length)
    (given : L.given t c = (arising k before after).length + passing)
    (taken : L.taken t c = (ceasing k before after).length + passing) :
    W.level (t + 1) c + L.taken t c = W.level t c + L.given t c := by
  rw [stands, stood, given, taken, ← Nat.add_assoc, ← Nat.add_assoc,
    census_balance k before after dB dA noSplit noMerge]

end Census

theorem or_true_cases {a b : Bool} (h : (a || b) = true) : a = true ∨ b = true := by
  cases a <;> cases b
  · exact Bool.noConfusion h
  · exact Or.inr rfl
  · exact Or.inl rfl
  · exact Or.inl rfl

theorem and_true_cases {a b : Bool} (h : (a && b) = true) : a = true ∧ b = true := by
  cases a <;> cases b
  · exact Bool.noConfusion h
  · exact Bool.noConfusion h
  · exact Bool.noConfusion h
  · exact ⟨rfl, rfl⟩

/-- **Counts do not read it.** Two units continuing as one and one as two at the same step: nothing
arises or ceases and the count balances, so the lists are paired under the one, yet no pairing
under continuation or sameness holds, since the region of the unit that split and its two
continuations, closed under that relation both ways, holds one unit before and two after. -/
def splitAndMerge (g f : Nat) : Bool :=
  (Nat.beq g 0 && (Nat.beq f 3 || Nat.beq f 4)) || ((Nat.beq g 1 || Nat.beq g 2) && Nat.beq f 5)

/-- The region of the unit that split and its two continuations. -/
def splitRegion (z : Nat) : Bool := Nat.beq z 0 || Nat.beq z 3 || Nat.beq z 4

theorem split_and_merge :
    arising splitAndMerge [0, 1, 2] [3, 4, 5] = [] ∧ ceasing splitAndMerge [0, 1, 2] [3, 4, 5] = [] ∧
      «对» «一» [0, 1, 2] [3, 4, 5] ∧
      ¬ «对» (fun x y => splitAndMerge x y = true ∨ x = y) [0, 1, 2] [3, 4, 5] := by
  refine ⟨rfl, rfl, «等长则一对» _ _ rfl, fun h => ?_⟩
  have closed : ∀ x y : Nat, (splitAndMerge x y = true ∨ x = y) → splitRegion x = splitRegion y := by
    intro x y r
    cases r with
    | inr same => exact congrArg splitRegion same
    | inl kxy =>
      match or_true_cases kxy with
      | .inl h =>
        have xy := and_true_cases h
        have x0 := Nat.eq_of_beq_eq_true xy.1
        match or_true_cases xy.2 with
        | .inl y3 => rw [x0, Nat.eq_of_beq_eq_true y3]; rfl
        | .inr y4 => rw [x0, Nat.eq_of_beq_eq_true y4]; rfl
      | .inr h =>
        have xy := and_true_cases h
        have y5 := Nat.eq_of_beq_eq_true xy.2
        match or_true_cases xy.1 with
        | .inl x1 => rw [Nat.eq_of_beq_eq_true x1, y5]; rfl
        | .inr x2 => rw [Nat.eq_of_beq_eq_true x2, y5]; rfl
  exact absurd («对则闭域守数» (p := splitRegion) closed h) (by decide)

/-- **A split breaks it.** One unit continuing as two: nothing arises or ceases, and one before is
not two after, so no pairing under any relation holds and the census balance fails. -/
theorem split_breaks :
    arising (fun _ _ => true) [0] [1, 2] = [] ∧ ceasing (fun _ _ => true) [0] [1, 2] = [] ∧
      ∀ S : «际» Nat, ¬ «对» S [0] [1, 2] :=
  ⟨rfl, rfl, fun _ h => absurd («对之长» h) (by decide)⟩

/-- **So does a merge.** Two units continuing as one. -/
theorem merge_breaks :
    arising (fun _ _ => true) [1, 2] [0] = [] ∧ ceasing (fun _ _ => true) [1, 2] [0] = [] ∧
      ∀ S : «际» Nat, ¬ «对» S [1, 2] [0] :=
  ⟨rfl, rfl, fun _ h => absurd («对之长» h) (by decide)⟩

end U4Scratch
end Becoming
