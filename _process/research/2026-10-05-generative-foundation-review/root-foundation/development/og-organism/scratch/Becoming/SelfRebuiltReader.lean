import Becoming.GrammarLaws

/-!
# A reader rebuilt from what it reads (OG)

One rule makes a family of nets. Each holds a level, in whole units, and a reader, a list of units
by age. The members differ only in where a spent reader unit is rebuilt from. Plan §十三 item 9
asks for a model of each of plan §六's test systems; this family is the model of an organism, and
its other members are the nets where the organism's condition fails.

One step, in this order:

1. **Draw.** One unit of the level goes to a sink; at `0` nothing is drawn.
2. **Read.** While the supply is on, the units read in turn, and each takes one unit from the supply
   while the level is below its set level `m`. So the level rises by the units' count, to at most `m`.
3. **Age.** Every unit ages by one, and a unit reaching the span `s` ends. A given reader does not age.
4. **Rebuild.** Where fewer than `n` units remain, one unit of age `0` is made from the rule's
   source: the level (one unit of it, where there is one), the supply (while it is on), or nothing.

Whether the supply is on is chosen at each step, so the net of the possible (`net`) branches on it.
A cut is a run of steps with the supply off.

* **Kept while supplied** (L0). Where the reader is rebuilt from the level, with `n ≥ 1` and
  `m ≥ 1`, the region where the reader is present is closed under the supplied step, still with
  one more unit drawn at each step (`«供则读者不绝»`, `«供而多取读者不绝»`).
* **The stock buys time** (L1). Under a cut, a reader rebuilt from the level is present after
  `k + 1` steps from every level of at least `2 (k + 1)`, whatever the reader was at the start
  (`«断而有储则读者存»`). A reader rebuilt from the supply, and one never rebuilt, started as `n` new
  units, is gone after `s` steps of cut from every level (`«断则自供者尽»`, `«不复建者尽»`).
* **The end absorbing** (L2). Where the reader rebuilt from the level ends, the level is `0`
  (`«读者绝则无储»`), and that state is closed under the net, the supply on or off
  (`«绝而不复»`). A reader rebuilt from the supply comes back once the supply returns (`«自供者复»`).
* **One unit's horizon, decided.** At a span of two, a reader of one unit rebuilt from the level
  ends under a cut at step `2 (l / 3 + 1)` from the level `l`, and at a span of three at
  `3 (l / 4 + 1)`: each further `s + 1` units buy `s` steps. Rebuilt from the supply, it ends at
  step three from every level (`«一读者之时»`, `«一读者之时三»`, `«自供者之时»`; decided for the
  levels below fifteen or sixteen, the general law not proved).
* **The family law.** Over the four members with a reader, the stock buys time under a cut, with
  none bought by an empty stock, exactly where the reader is rebuilt from the level
  (`«以储买时当且仅当取于储»`).

The model's assumptions are its rule: whole units, discrete steps, one draw a step, units read in
turn, the order above. An AI reading takes the family's organism as a minimal case of
self-maintenance, one constraint with turnover regenerated from the flow it regulates; that it
describes a cell is a correspondence duty, not shown here.
-/

namespace Becoming

namespace SelfRebuiltReader

/-- Where a spent reader unit is rebuilt from. A `given` reader does not age. -/
inductive Source where
  | given
  | supply
  | level
  | none

/-- A member of the family: the span `s` of a unit, the set count `n` of units, the set level
`m`, and the source of the rebuild. -/
structure Rule where
  span : Nat
  count : Nat
  setLevel : Nat
  source : Source

/-- An occurrence: the level, and the reader's units by age. -/
structure St where
  level : Nat
  ages : List Nat

/-- The read: `k` units, in turn, each take one while the level is below `m`. -/
def read (m k l : Nat) : Nat := if l < m then (if l + k < m then l + k else m) else l

/-- Each unit ages by one, and a unit reaching the span ends. -/
def older (s : Nat) : List Nat → List Nat
  | [] => []
  | a :: as => if a + 1 < s then (a + 1) :: older s as else older s as

/-- The age step: a given reader does not age. -/
def age (r : Rule) (as : List Nat) : List Nat :=
  match r.source with
  | .given => as
  | .supply => older r.span as
  | .level => older r.span as
  | .none => older r.span as

/-- The rebuild, where fewer than `n` units remain. -/
def rebuild (r : Rule) (on : Bool) (l : Nat) (as : List Nat) : St :=
  if as.length < r.count then
    match r.source with
    | .level =>
      match l with
      | 0 => ⟨0, as⟩
      | l + 1 => ⟨l, 0 :: as⟩
    | .supply =>
      match on with
      | true => ⟨l, 0 :: as⟩
      | false => ⟨l, as⟩
    | .given => ⟨l, as⟩
    | .none => ⟨l, as⟩
  else ⟨l, as⟩

/-- One step: draw, read while supplied, age, rebuild. -/
def step (r : Rule) (on : Bool) (x : St) : St :=
  rebuild r on (if on then read r.setLevel x.ages.length (x.level - 1) else x.level - 1)
    (age r x.ages)

/-- The net of the possible: at each step the supply is on or off. -/
def net (r : Rule) : «际» St := fun x y => ∃ on, y = step r on x

/-- The supplied step. -/
def supplied (r : Rule) : «际» St := fun x y => y = step r true x

/-- The supplied step with one more unit drawn first: a window. -/
def drawn (r : Rule) : «际» St := fun x y => y = step r true ⟨x.level - 1, x.ages⟩

/-- `k` steps, the supply on or off throughout. -/
def run (r : Rule) (on : Bool) : Nat → St → St
  | 0, x => x
  | k + 1, x => run r on k (step r on x)

/-- The reader is present. -/
def Present (x : St) : Prop := x.ages ≠ []

/-- `n` new units over the level `l`. -/
def fresh (n l : Nat) : St := ⟨l, List.replicate n 0⟩

/-! ## The rule's arithmetic -/

theorem cons_present {a : Nat} {as : List Nat} : (a :: as) ≠ [] := List.cons_ne_nil a as

theorem one_le_of_lt {a b : Nat} (h : a < b) : 1 ≤ b := Nat.lt_of_le_of_lt (Nat.zero_le a) h

/-- A read by at least one unit leaves at least one unit, where `m ≥ 1`. -/
theorem read_pos {m k l : Nat} (hm : 1 ≤ m) (hk : 1 ≤ k) : 1 ≤ read m k l := by
  unfold read
  by_cases h : l < m
  · rw [if_pos h]
    by_cases h' : l + k < m
    · rw [if_pos h']; exact Nat.le_trans hk (Nat.le_add_left k l)
    · rw [if_neg h']; exact hm
  · rw [if_neg h]; exact Nat.le_trans hm (Nat.le_of_not_lt h)

/-- Where the reader is rebuilt from the level and the level is positive, the rebuild leaves a
reader, unless none is wanted. -/
theorem rebuild_present {r : Rule} (hs : r.source = .level) (hn : 1 ≤ r.count) {on : Bool}
    {l : Nat} (hl : 1 ≤ l) (as : List Nat) : Present (rebuild r on l as) := by
  unfold rebuild
  by_cases h : as.length < r.count
  · rw [if_pos h]
    match l, hl with
    | 0, h => exact absurd h (Nat.not_succ_le_zero 0)
    | l + 1, _ => rw [hs]; exact cons_present
  · rw [if_neg h]
    intro e
    show False
    have e' : as = [] := e
    rw [e'] at h
    exact h hn

/-- The rebuild draws at most one unit of the level. -/
theorem rebuild_level (r : Rule) (on : Bool) (l : Nat) (as : List Nat) :
    l ≤ (rebuild r on l as).level + 1 := by
  obtain ⟨s, n, m, src⟩ := r
  unfold rebuild
  by_cases h : as.length < n
  · rw [if_pos h]
    cases src <;> cases on <;> cases l <;> first | exact Nat.le_refl _ | exact Nat.le_succ _
  · rw [if_neg h]; exact Nat.le_succ l

/-- The rebuild from the level at `0` changes nothing. -/
theorem rebuild_zero {r : Rule} (hs : r.source = .level) (on : Bool) (as : List Nat) :
    rebuild r on 0 as = ⟨0, as⟩ := by
  unfold rebuild
  by_cases h : as.length < r.count
  · rw [if_pos h, hs]
  · rw [if_neg h]

/-! ## Kept while supplied (L0) -/

/-- **Kept while supplied (供则读者不绝).** Where the reader is rebuilt from the level, with
`n ≥ 1` and `m ≥ 1`, the region where the reader is present is closed under the supplied step:
the read leaves a unit to rebuild from wherever a unit read. -/
theorem «供则读者不绝» {r : Rule} (hs : r.source = .level) (hn : 1 ≤ r.count)
    (hm : 1 ≤ r.setLevel) : «闭» (supplied r) Present := by
  intro x y present e
  rw [e]
  cases hx : x.ages with
  | nil => exact absurd hx present
  | cons a as =>
    show Present (rebuild r true (if true then read r.setLevel x.ages.length (x.level - 1)
      else x.level - 1) (age r x.ages))
    rw [if_pos rfl]
    have hk : 1 ≤ x.ages.length := by rw [hx]; exact Nat.succ_le_succ (Nat.zero_le _)
    exact rebuild_present hs hn (read_pos hm hk) _

/-- **Kept under a window too (供而多取读者不绝).** With one more unit drawn at each step, the
region where the reader is present is still closed. -/
theorem «供而多取读者不绝» {r : Rule} (hs : r.source = .level) (hn : 1 ≤ r.count)
    (hm : 1 ≤ r.setLevel) : «闭» (drawn r) Present :=
  fun x y present e => «供则读者不绝» hs hn hm ⟨x.level - 1, x.ages⟩ y present e

/-! ## The stock buys time (L1) -/

theorem le_pred_succ : ∀ a : Nat, a ≤ a - 1 + 1
  | 0 => Nat.zero_le _
  | _ + 1 => Nat.le_refl _

/-- Under a cut, a step draws at most two units. -/
theorem cut_level (r : Rule) (x : St) : x.level ≤ (step r false x).level + 2 := by
  show x.level ≤ (rebuild r false (if false then read r.setLevel x.ages.length (x.level - 1)
    else x.level - 1) (age r x.ages)).level + 2
  rw [if_neg Bool.false_ne_true]
  have h := rebuild_level r false (x.level - 1) (age r x.ages)
  have h' : x.level ≤ x.level - 1 + 1 := le_pred_succ x.level
  exact Nat.le_trans h' (Nat.succ_le_succ h)

/-- Under a cut, from a level of at least two, a reader rebuilt from the level is present after
the step. -/
theorem cut_present {r : Rule} (hs : r.source = .level) (hn : 1 ≤ r.count) {x : St}
    (hl : 2 ≤ x.level) : Present (step r false x) := by
  show Present (rebuild r false (if false then read r.setLevel x.ages.length (x.level - 1)
    else x.level - 1) (age r x.ages))
  rw [if_neg Bool.false_ne_true]
  apply rebuild_present hs hn
  match x.level, hl with
  | 0, h => exact absurd h (Nat.not_succ_le_zero 1)
  | 1, h => exact absurd h (Nat.lt_irrefl 1)
  | l + 2, _ => exact Nat.succ_le_succ (Nat.zero_le l)

/-- **The stock buys time (断而有储则读者存).** Under a cut, a reader rebuilt from the level is
present after `k + 1` steps from every level of at least `2 (k + 1)`, whatever the reader was at
the start. -/
theorem «断而有储则读者存» {r : Rule} (hs : r.source = .level) (hn : 1 ≤ r.count) :
    ∀ (k : Nat) (x : St), 2 * (k + 1) ≤ x.level → Present (run r false (k + 1) x)
  | 0, _, hl => cut_present hs hn hl
  | k + 1, x, hl => by
    show Present (run r false (k + 1) (step r false x))
    apply «断而有储则读者存» hs hn k
    have h := cut_level r x
    rw [Nat.mul_succ 2 (k + 1)] at hl
    exact Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ (Nat.le_trans hl h))

/-! ## A reader not rebuilt under a cut ends at its span -/

theorem older_replicate (s n j : Nat) :
    older s (List.replicate n j) = if j + 1 < s then List.replicate n (j + 1) else [] := by
  induction n with
  | zero =>
    by_cases h : j + 1 < s
    · rw [if_pos h]; rfl
    · rw [if_neg h]; rfl
  | succ n ih =>
    show (if j + 1 < s then (j + 1) :: older s (List.replicate n j) else older s (List.replicate n j))
      = _
    rw [ih]
    by_cases h : j + 1 < s
    · rw [if_pos h, if_pos h, if_pos h]; rfl
    · rw [if_neg h, if_neg h, if_neg h]

theorem length_replicate (n j : Nat) : (List.replicate n j).length = n := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg Nat.succ ih

/-- A rebuild with nothing to rebuild from leaves the units. -/
theorem rebuild_none {r : Rule} {on : Bool} {l : Nat} {as : List Nat}
    (hs : r.source = .supply ∧ on = false ∨ r.source = .none ∨ r.source = .level ∧ l = 0) :
    (rebuild r on l as).ages = as := by
  unfold rebuild
  by_cases h : as.length < r.count
  · rw [if_pos h]
    match hs with
    | .inl ⟨e, o⟩ => rw [e, o]
    | .inr (.inl e) => rw [e]
    | .inr (.inr ⟨e, z⟩) => rw [e, z]
  · rw [if_neg h]

/-- A full reader that is not rebuilt ages one step. -/
theorem rebuild_full {r : Rule} {on : Bool} {l : Nat} {as : List Nat}
    (h : ¬ as.length < r.count) : (rebuild r on l as).ages = as := by
  unfold rebuild; rw [if_neg h]

/-- A step with nothing to rebuild from: the reader rebuilt from the supply under a cut, the one
never rebuilt, or the one rebuilt from the level under a cut at an empty level. -/
def Quiet (r : Rule) (on : Bool) (l : Nat) : Prop :=
  (r.source = .supply ∧ on = false) ∨ r.source = .none ∨
    (r.source = .level ∧ on = false ∧ l = 0)

/-- A quiet step only ages the units, and stays quiet. -/
theorem quiet_step {r : Rule} {on : Bool} {x : St} (q : Quiet r on x.level) :
    (step r on x).ages = older r.span x.ages ∧ Quiet r on (step r on x).level := by
  have ha : age r x.ages = older r.span x.ages := by
    unfold age
    match q with
    | .inl ⟨e, _⟩ => rw [e]
    | .inr (.inl e) => rw [e]
    | .inr (.inr ⟨e, _, _⟩) => rw [e]
  show (rebuild r on (if on then read r.setLevel x.ages.length (x.level - 1) else x.level - 1)
      (age r x.ages)).ages = _ ∧ Quiet r on (rebuild r on (if on then read r.setLevel
      x.ages.length (x.level - 1) else x.level - 1) (age r x.ages)).level
  rw [ha]
  match q with
  | .inl ⟨e, o⟩ =>
    rw [o, if_neg Bool.false_ne_true]
    exact ⟨rebuild_none (.inl ⟨e, rfl⟩), .inl ⟨e, rfl⟩⟩
  | .inr (.inl e) => exact ⟨rebuild_none (.inr (.inl e)), .inr (.inl e)⟩
  | .inr (.inr ⟨e, o, z⟩) =>
    rw [o, if_neg Bool.false_ne_true, z]
    show (rebuild r false 0 _).ages = _ ∧ Quiet r false (rebuild r false 0 _).level
    rw [rebuild_zero e]
    exact ⟨rfl, .inr (.inr ⟨e, rfl, rfl⟩)⟩

/-- A quiet reader that is gone stays gone. -/
theorem quiet_empty {r : Rule} {on : Bool} :
    ∀ (k : Nat) (x : St), Quiet r on x.level → x.ages = [] → (run r on k x).ages = []
  | 0, _, _, e => e
  | k + 1, x, q, e => by
    show (run r on k (step r on x)).ages = []
    have h := quiet_step q
    apply quiet_empty k _ h.2
    rw [h.1, e]; rfl

/-- **A quiet reader of new units ends at its span.** -/
theorem quiet_end {r : Rule} {on : Bool} :
    ∀ (k j : Nat) (x : St), Quiet r on x.level → x.ages = List.replicate r.count j →
      r.span ≤ j + (k + 1) → (run r on (k + 1) x).ages = []
  | 0, j, x, q, e, hs => by
    show (run r on 0 (step r on x)).ages = []
    show (step r on x).ages = []
    rw [(quiet_step q).1, e, older_replicate, if_neg (Nat.not_lt_of_le hs)]
  | k + 1, j, x, q, e, hs => by
    show (run r on (k + 1) (step r on x)).ages = []
    have h := quiet_step q
    by_cases hj : j + 1 < r.span
    · apply quiet_end k (j + 1) _ h.2
      · rw [h.1, e, older_replicate, if_pos hj]
      · have e : j + 1 + (k + 1) = j + (k + 1 + 1) := by
          rw [Nat.add_assoc, Nat.add_comm 1 (k + 1)]
        rw [e]; exact hs
    · apply quiet_empty (k + 1) _ h.2
      rw [h.1, e, older_replicate, if_neg hj]

/-- **Rebuilt from the supply, it ends at its span under a cut (断则自供者尽).** A reader of `n` new
units rebuilt from the supply is gone after `s` steps of cut, from every level. -/
theorem «断则自供者尽» {r : Rule} (hs : r.source = .supply) (hspan : 1 ≤ r.span) (l : Nat) :
    (run r false r.span (fresh r.count l)).ages = [] := by
  match h : r.span, hspan with
  | 0, h' => exact absurd h' (Nat.not_succ_le_zero 0)
  | k + 1, _ =>
    apply quiet_end k 0 _ (.inl ⟨hs, rfl⟩) rfl
    rw [h, Nat.zero_add]; exact Nat.le_refl _

/-- **Never rebuilt, it ends at its span, supplied or not (不复建者尽).** -/
theorem «不复建者尽» {r : Rule} (hs : r.source = .none) (hspan : 1 ≤ r.span) (on : Bool)
    (l : Nat) : (run r on r.span (fresh r.count l)).ages = [] := by
  match h : r.span, hspan with
  | 0, h' => exact absurd h' (Nat.not_succ_le_zero 0)
  | k + 1, _ =>
    apply quiet_end k 0 _ (.inr (.inl hs)) rfl
    rw [h, Nat.zero_add]; exact Nat.le_refl _

/-- With an empty stock, a reader rebuilt from the level ends at its span under a cut. -/
theorem cut_empty_end {r : Rule} (hs : r.source = .level) (hspan : 1 ≤ r.span) :
    (run r false r.span (fresh r.count 0)).ages = [] := by
  match h : r.span, hspan with
  | 0, h' => exact absurd h' (Nat.not_succ_le_zero 0)
  | k + 1, _ =>
    apply quiet_end k 0 _ (.inr (.inr ⟨hs, rfl, rfl⟩)) rfl
    rw [h, Nat.zero_add]; exact Nat.le_refl _

/-! ## The end absorbing (L2) -/

/-- **The reader ends only with the stock (读者绝则无储).** Where the reader rebuilt from the level
is gone after a step, the level is `0`. -/
theorem «读者绝则无储» {r : Rule} (hs : r.source = .level) (hn : 1 ≤ r.count) (on : Bool)
    (x : St) (gone : (step r on x).ages = []) : (step r on x).level = 0 := by
  have key : ∀ (l : Nat) (as : List Nat), (rebuild r on l as).ages = [] →
      (rebuild r on l as).level = 0 := by
    intro l as e
    match l, e with
    | 0, _ => rw [rebuild_zero hs]
    | l + 1, e => exact absurd e (rebuild_present hs hn (Nat.succ_le_succ (Nat.zero_le l)) as)
  exact key _ _ gone

theorem read_zero (m : Nat) : read m 0 0 = 0 := by
  unfold read
  by_cases h : 0 < m
  · rw [if_pos h, if_pos (show 0 + 0 < m from h)]
  · rw [if_neg h]

/-- **Gone, it does not return (绝而不复).** For the reader rebuilt from the level, the empty
state is closed under the net: no branch, the supply returned or not, brings the reader back. -/
theorem «绝而不复» {r : Rule} (hs : r.source = .level) :
    «闭» (net r) (fun x => x = ⟨0, []⟩) := by
  intro x y hx ⟨on, e⟩
  rw [e, hx]
  have ha : age r [] = [] := by unfold age; rw [hs]; rfl
  cases on with
  | true =>
    show rebuild r true (if true then read r.setLevel 0 (0 - 1) else 0 - 1) (age r []) = _
    rw [if_pos rfl]
    show rebuild r true (read r.setLevel 0 0) (age r []) = _
    rw [read_zero, ha, rebuild_zero hs]
  | false =>
    show rebuild r false (if false then read r.setLevel 0 (0 - 1) else 0 - 1) (age r []) = _
    rw [if_neg Bool.false_ne_true]
    show rebuild r false 0 (age r []) = _
    rw [ha, rebuild_zero hs]

/-- **Rebuilt from the supply, it returns (自供者复).** A reader rebuilt from the supply, gone,
is present again after one supplied step, at every level. -/
theorem «自供者复» {r : Rule} (hs : r.source = .supply) (hn : 1 ≤ r.count) (l : Nat) :
    Present (step r true ⟨l, []⟩) := by
  have ha : age r [] = [] := by unfold age; rw [hs]; rfl
  show Present (rebuild r true (if true then read r.setLevel 0 (l - 1) else l - 1) (age r []))
  rw [ha]
  unfold rebuild
  rw [if_pos (show ([] : List Nat).length < r.count from hn), hs]
  exact cons_present

/-! ## The family law -/

/-- A given reader at its set count keeps its units. -/
theorem given_run {r : Rule} (hs : r.source = .given) (on : Bool) :
    ∀ (k : Nat) (x : St), x.ages = List.replicate r.count 0 →
      (run r on k x).ages = List.replicate r.count 0
  | 0, _, e => e
  | k + 1, x, e => by
    show (run r on k (step r on x)).ages = _
    apply given_run hs on k
    have ha : age r x.ages = x.ages := by unfold age; rw [hs]
    show (rebuild r on (if on then read r.setLevel x.ages.length (x.level - 1) else x.level - 1)
      (age r x.ages)).ages = _
    rw [ha, rebuild_full (by rw [e, length_replicate]; exact Nat.lt_irrefl _), e]

theorem pred_succ : ∀ {s : Nat}, 1 ≤ s → s - 1 + 1 = s
  | 0, h => absurd h (Nat.not_succ_le_zero 0)
  | _ + 1, _ => rfl

/-- The stock buys time under a cut: from enough stock the reader is present after any number of
steps, and from an empty stock it ends. -/
def BuysTime (r : Rule) : Prop :=
  (∀ k, ∃ l, Present (run r false (k + 1) (fresh r.count l))) ∧
    ∃ k, (run r false k (fresh r.count 0)).ages = []

/-- **The stock buys time exactly where the reader is rebuilt from the level
(以储买时当且仅当取于储).** Over the four members with a reader, at `n ≥ 1` and `s ≥ 1`: the
given reader never ends, the reader rebuilt from the supply and the one never rebuilt end at
their span from every level, and only the reader rebuilt from the level is carried by its stock. -/
theorem «以储买时当且仅当取于储» {r : Rule} (hn : 1 ≤ r.count) (hspan : 1 ≤ r.span) :
    BuysTime r ↔ r.source = .level := by
  have hrep : List.replicate r.count 0 ≠ [] := by
    match h : r.count, hn with
    | 0, h' => exact absurd h' (Nat.not_succ_le_zero 0)
    | c + 1, _ => exact cons_present
  have hk : r.span - 1 + 1 = r.span := pred_succ hspan
  constructor
  · intro ⟨buys, ends⟩
    match hs : r.source with
    | .level => rfl
    | .given =>
      match ends with
      | ⟨k, e⟩ => exact absurd ((given_run hs false k _ rfl).symm.trans e) hrep
    | .supply =>
      match buys (r.span - 1) with
      | ⟨l, p⟩ => rw [hk] at p; exact absurd («断则自供者尽» hs hspan l) p
    | .none =>
      match buys (r.span - 1) with
      | ⟨l, p⟩ => rw [hk] at p; exact absurd («不复建者尽» hs hspan false l) p
  · intro hs
    exact ⟨fun k => ⟨2 * (k + 1), «断而有储则读者存» hs hn k _ (Nat.le_refl _)⟩,
      ⟨r.span, cut_empty_end hs hspan⟩⟩

/-! ## The horizon of one unit, decided -/

/-- Under a cut from `n` new units over the level `l`, the reader is present after `h - 1` steps
and gone after `h`. -/
abbrev EndsAt (r : Rule) (l h : Nat) : Prop :=
  0 < (run r false (h - 1) (fresh r.count l)).ages.length ∧
    (run r false h (fresh r.count l)).ages.length = 0

/-- **One unit's horizon, at a span of two (一读者之时).** A reader of one unit, span two, rebuilt
from the level: under a cut from the level `l`, it ends at step `2 (l / 3 + 1)`, so each further
three units of stock buy two steps; decided for every level below fifteen. -/
theorem «一读者之时» : ∀ l, l < 15 → EndsAt ⟨2, 1, 2, .level⟩ l (2 * (l / 3 + 1)) := by decide

/-- At a span of three: it ends at step `3 (l / 4 + 1)`, each further four units buying three
steps; decided for every level below sixteen. -/
theorem «一读者之时三» : ∀ l, l < 16 → EndsAt ⟨3, 1, 2, .level⟩ l (3 * (l / 4 + 1)) := by decide

/-- Rebuilt from the supply, at a span of three, it ends at step three from every level below
sixteen: its stock buys nothing. -/
theorem «自供者之时» : ∀ l, l < 16 → EndsAt ⟨3, 1, 2, .supply⟩ l 3 := by decide

end SelfRebuiltReader

end Becoming
