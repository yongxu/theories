import Becoming.GrammarLaws
import Becoming.Flow
import Becoming.SelectionReach

/-!
# Scratch for U1 (not a module of the package): balance read under the continuation of units

Feasibility only. Units are tokens; a token account says which tokens stand at a condition at a
step, which arrive and which leave. Balance read under the relation "the same token" (not the
one) is that what stands and arrives is, token for token, what stands after and leaves.
-/

namespace Becoming
namespace UnitScratch

universe u v

variable {U : Type u} {C : Type v}

/-- A token account. -/
structure Tokens (U : Type u) (C : Type v) where
  stand : Nat → C → List U
  given : Nat → C → List U
  taken : Nat → C → List U

/-- The same token: the relation balance is read under here, in place of the one. -/
def same : «际» U := fun x y => x = y

/-- **Units abide**: before and given are paired one to one with after and taken under the same
token, at every step and condition. -/
def Tokens.Abides (T : Tokens U C) : Prop :=
  ∀ t c, «对» same (T.stand t c ++ T.given t c) (T.stand (t + 1) c ++ T.taken t c)

/-- The count law follows from abiding, by the grammar's pairing law under `same`, not the one. -/
theorem Tokens.counts {T : Tokens U C} (h : T.Abides) (t : Nat) (c : C) :
    (T.stand (t + 1) c).length + (T.taken t c).length
      = (T.stand t c).length + (T.given t c).length :=
  «对则守数» (h t c)

theorem mem_cons_head (x : U) (l : List U) : x ∈ x :: l := List.Mem.head l

theorem mem_insert_cases {y y' : U} :
    ∀ (b₁ b₂ : List U), y ∈ b₁ ++ y' :: b₂ → y = y' ∨ y ∈ b₁ ++ b₂
  | [], b₂, h => by
      change y ∈ y' :: b₂ at h
      cases h with
      | head => exact Or.inl rfl
      | tail _ h => exact Or.inr h
  | z :: b₁, b₂, h => by
      change y ∈ z :: (b₁ ++ y' :: b₂) at h
      cases h with
      | head => exact Or.inr (List.Mem.head _)
      | tail _ h =>
        match mem_insert_cases b₁ b₂ h with
        | Or.inl e => exact Or.inl e
        | Or.inr h' => exact Or.inr (List.Mem.tail _ h')

/-- What a pairing reaches: every member of the second list is paired with some member of the
first. -/
theorem mem_of_pair {R : «际» U} {a b : List U} (p : «对» R a b) :
    ∀ y, y ∈ b → ∃ x, x ∈ a ∧ R x y := by
  induction p with
  | nil => intro y h; cases h
  | @cons x y' a b₁ b₂ r _ ih =>
      intro y h
      match mem_insert_cases b₁ b₂ h with
      | Or.inl e => exact ⟨x, List.Mem.head a, e ▸ r⟩
      | Or.inr h' =>
          match ih y h' with
          | ⟨x', m, r'⟩ => exact ⟨x', List.Mem.tail x m, r'⟩

theorem mem_append_left' {x : U} : ∀ {a : List U} (b : List U), x ∈ a → x ∈ a ++ b
  | [], _, h => by cases h
  | z :: a, b, h => by
      change x ∈ z :: (a ++ b)
      cases h with
      | head => exact List.Mem.head _
      | tail _ h => exact List.Mem.tail _ (mem_append_left' (a := a) b h)

theorem mem_append_cases {x : U} : ∀ {a : List U} (b : List U), x ∈ a ++ b → x ∈ a ∨ x ∈ b
  | [], _, h => Or.inr h
  | z :: a, b, h => by
      change x ∈ z :: (a ++ b) at h
      cases h with
      | head => exact Or.inl (List.Mem.head _)
      | tail _ h =>
        match mem_append_cases (a := a) b h with
        | Or.inl m => exact Or.inl (List.Mem.tail _ m)
        | Or.inr m => exact Or.inr m

/-- **Where a standing token came from** (the token form of "a rise is drawn from what is
given"): a token standing at `c` at step `t + n` stood there at `t` or was given to `c` at some
step between. Numbers alone cannot state it: it reads which token went where. -/
theorem Tokens.came {T : Tokens U C} (h : T.Abides) {x : U} {c : C} (t : Nat) :
    ∀ n, x ∈ T.stand (t + n) c → x ∈ T.stand t c ∨ ∃ k, k < n ∧ x ∈ T.given (t + k) c
  | 0, m => Or.inl m
  | n + 1, m =>
      match mem_of_pair (h (t + n) c) x (mem_append_left' _ m) with
      | ⟨_, m', e⟩ =>
          match mem_append_cases _ m' with
          | Or.inl s =>
              match Tokens.came h t n (e ▸ s) with
              | Or.inl s0 => Or.inl s0
              | Or.inr ⟨k, lt, g⟩ => Or.inr ⟨k, Nat.lt_succ_of_lt lt, g⟩
          | Or.inr g => Or.inr ⟨n, Nat.lt_succ_self n, e ▸ g⟩

/-- Under the one, any equal counts abide (F13's case): the relation carries no identity, so it
reads nothing of where a token went. -/
theorem one_abides_of_counts {a b : List U} (e : a.length = b.length) : «对» «一» a b :=
  «等长则一对» a b e

end UnitScratch
end Becoming

namespace Becoming
namespace UnitScratch

/-- Positions `n - 1, …, 0`: the fibre of a step frame, enumerated structurally. -/
def upto : Nat → List Nat
  | 0 => []
  | n + 1 => n :: upto n

theorem length_upto : ∀ n, (upto n).length = n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (length_upto n)

variable {F C : Type}

/-- **A unit model of a flow over a web**: at each step and condition, a relation on positions
pairing the frame before ∪ given (positions below `level t c + given t c`) one to one with the
frame after ∪ taken (positions below `level (t + 1) c + taken t c`). Which unit goes where is the
model's, not the World's. -/
structure Units (L : Flow F C) (W : Web F C) where
  pair : Nat → C → «际» Nat
  matched : ∀ t c, «对» (pair t c) (upto (W.level t c + L.given t c))
    (upto (W.level (t + 1) c + L.taken t c))

/-- The count law from a unit model: balance read under the units' pairing, not the one. -/
theorem Units.balances {L : Flow F C} {W : Web F C} (U : Units L W) : L.Balances W := fun t c => by
  have e := «对之长» (U.matched t c)
  rw [length_upto, length_upto] at e
  exact e.symm

/-- **The canonical unit model of a balanced flow**: pairing by position, no choice. -/
def Units.canonical {L : Flow F C} {W : Web F C} (b : L.Balances W) : Units L W where
  pair _ _ := fun i j => i = j
  matched t c := by
    have e : W.level t c + L.given t c = W.level (t + 1) c + L.taken t c := (b t c).symm
    rw [e]
    exact «对之自反» (fun _ => rfl) _

/-- **Amounts represented at the unit selection, both ways**: a unit model exists exactly where
the flow balances. -/
theorem units_iff_balances {L : Flow F C} {W : Web F C} :
    Nonempty (Units L W) ↔ L.Balances W :=
  ⟨fun ⟨U⟩ => U.balances, fun b => ⟨Units.canonical b⟩⟩

/-- **The unit-level F2 (re-pairing changes lines, not the World)**: on the frame of one
standing unit and one given unit, paired with one standing and one taken, both the identity and
the swap are pairings. Under the identity the standing unit (position 0) stays standing (position
`0 < 1`); under the swap it goes to position 1, the taken one. -/
theorem repairing_moves_lines :
    «对» (fun i j : Nat => i = j) (upto 2) (upto 2) ∧
    «对» (fun i j : Nat => (i = 0 ∧ j = 1) ∨ (i = 1 ∧ j = 0)) (upto 2) (upto 2) := by
  refine ⟨«对之自反» (fun _ => rfl) _, ?_⟩
  -- upto 2 = [1, 0]; pair 1 with 0 and 0 with 1
  show «对» _ [1, 0] [1, 0]
  exact .cons (b₁ := [1]) (b₂ := []) (Or.inr ⟨rfl, rfl⟩)
    (.cons (b₁ := []) (b₂ := []) (Or.inl ⟨rfl, rfl⟩) .nil)

end UnitScratch
end Becoming

namespace Becoming
namespace UnitScratch

/-- Kinds of unit occurrence in a step frame: standing at a step, given at a step, taken at a step.
Kinds keep a taken position of step `t` apart from a given position of step `t + 1`. -/
inductive Kind | stand | give | take

/-- A unit occurrence: a step, a kind and a position. -/
abbrev Occ := Nat × Kind × Nat

def label (t : Nat) (k : Kind) : List Nat → List Occ
  | [] => []
  | i :: is => (t, k, i) :: label t k is

theorem length_label (t : Nat) (k : Kind) : ∀ l : List Nat, (label t k l).length = l.length
  | [] => rfl
  | _ :: l => congrArg Nat.succ (length_label t k l)

variable {F C : Type}

/-- Standing, given and taken unit occurrences of a condition at a step. -/
def standL (W : Web F C) (c : C) (t : Nat) : List Occ := label t .stand (upto (W.level t c))
def givenL (L : Flow F C) (c : C) (t : Nat) : List Occ := label t .give (upto (L.given t c))
def takenL (L : Flow F C) (c : C) (t : Nat) : List Occ := label t .take (upto (L.taken t c))

/-- **Balance over a stretch from the grammar's stretch law, for every unit pairing**: where at each
step a relation on unit occurrences pairs standing ++ given with standing after ++ taken, the
grammar's `«对之程»` pairs the stretch's start ++ all given with its end ++ all taken under the
relation's closure, and the count over the stretch follows by `«对之长»` and `«聚之长»`. -/
theorem stretch_of_units {L : Flow F C} {W : Web F C} {c : C} (R : «际» Occ)
    (paired : ∀ t, «对» R (standL W c t ++ givenL L c t) (standL W c (t + 1) ++ takenL L c t))
    (S n : Nat) :
    «对» («所闭» R) (standL W c S ++ «聚» (givenL L c) (steps S n))
      (standL W c (S + n) ++ «聚» (takenL L c) (steps S n)) :=
  «对之程» S n fun t _ _ => paired t

theorem length_givenL (L : Flow F C) (c : C) (t : Nat) : (givenL L c t).length = L.given t c :=
  (length_label _ _ _).trans (length_upto _)

theorem length_takenL (L : Flow F C) (c : C) (t : Nat) : (takenL L c t).length = L.taken t c :=
  (length_label _ _ _).trans (length_upto _)

theorem length_standL (W : Web F C) (c : C) (t : Nat) : (standL W c t).length = W.level t c :=
  (length_label _ _ _).trans (length_upto _)

/-- **The count over a stretch, from the stretch pairing**: the flow's stretch balance, for every
unit pairing, through `«对之程»`, `«对之长»` and `«聚之长»` (the counting step, where amounts come
back in). -/
theorem stretch_count_of_units {L : Flow F C} {W : Web F C} {c : C} (R : «际» Occ)
    (paired : ∀ t, «对» R (standL W c t ++ givenL L c t) (standL W c (t + 1) ++ takenL L c t))
    (S n : Nat) :
    W.level (S + n) c + total (steps S n) (fun t => L.taken t c)
      = W.level S c + total (steps S n) (fun t => L.given t c) := by
  have e := «对之长» (stretch_of_units R paired S n)
  rw [ListTests.length_append, ListTests.length_append, «聚之长», «聚之长», length_standL,
    length_standL, GrammarLaws.total_congr (fun t => length_givenL L c t),
    GrammarLaws.total_congr (fun t => length_takenL L c t)] at e
  exact e.symm

/-- Under the one, a unit pairing of each step exists exactly where the flow balances there: the
coarse relation reads counts only (F13's case), the fine relations are the model's gauge. -/
theorem one_paired_iff {L : Flow F C} {W : Web F C} {c : C} (t : Nat) :
    «对» «一» (standL W c t ++ givenL L c t) (standL W c (t + 1) ++ takenL L c t)
      ↔ W.level (t + 1) c + L.taken t c = W.level t c + L.given t c := by
  have hl : (standL W c t ++ givenL L c t).length = W.level t c + L.given t c := by
    rw [ListTests.length_append, standL, givenL, length_label, length_label, length_upto,
      length_upto]
  have hr : (standL W c (t + 1) ++ takenL L c t).length = W.level (t + 1) c + L.taken t c := by
    rw [ListTests.length_append, standL, takenL, length_label, length_label, length_upto,
      length_upto]
  exact «一之对».trans
    ⟨fun e => hr.symm.trans (e.symm.trans hl), fun e => hl.trans (e.symm.trans hr.symm)⟩

end UnitScratch
end Becoming

namespace Becoming
namespace UnitScratch

/-! ## The exchange selection: units pass through formations

At a formation, the units it gives continue units it takes; a taken unit's line either goes on as a
given unit or ends there. -/

/-- **An exchange matching at a formation**: what it takes paired one to one with what it gives and
what ends there. -/
def ExchangeMatched {α : Type} (R : «际» α) (taken given : List α) : Prop :=
  ∃ ended : List α, «对» R taken (given ++ ended)

/-- An exchange matching needs the formation to give no more than it takes: no unit begins at a
formation. -/
theorem give_le_take_of_matched {α : Type} {R : «际» α} {taken given : List α}
    (m : ExchangeMatched R taken given) : given.length ≤ taken.length :=
  match m with
  | ⟨ended, p⟩ => by
    have e := «对之长» p
    rw [ListTests.length_append] at e
    exact e ▸ Nat.le_add_right _ _

/-- Under the one, an exchange matching exists exactly where the formation gives no more than it
takes (Hume at the formation's fibre). -/
theorem one_matched_iff {taken given : List Unit} :
    ExchangeMatched «一» taken given ↔ given.length ≤ taken.length := by
  refine ⟨give_le_take_of_matched, fun le => ?_⟩
  refine ⟨List.replicate (taken.length - given.length) (), «等长则一对» _ _ ?_⟩
  rw [ListTests.length_append, GrammarLaws.length_replicate]
  exact (Naturals.add_sub_of_le le).symm

/-- **Dissipation as lines ending**: an exchange matching in which, where the formation takes, some
taken unit's line ends there, gives `DissipatesOn`'s count form at that formation. -/
theorem dissipates_of_ending {α : Type} {R : «际» α} {taken given ended : List α}
    (p : «对» R taken (given ++ ended)) (ends : 0 < taken.length → 0 < ended.length) :
    given.length + sign taken.length ≤ taken.length := by
  have e := «对之长» p
  rw [ListTests.length_append] at e
  cases h : taken.length with
  | zero =>
    rw [h] at e
    have g0 : given.length = 0 := Nat.eq_zero_of_add_eq_zero_right e.symm
    rw [g0]
    exact Nat.le_of_eq rfl
  | succ k =>
    have pos : 0 < ended.length := ends (h ▸ Nat.succ_pos k)
    rw [h] at e
    show given.length + 1 ≤ k + 1
    rw [e]
    exact Nat.add_le_add_left pos _

/-- **The witness (i)**: a formation that gives one unit and takes none has no exchange matching,
whatever the counts at the conditions: balance under the exchanges is strictly stronger than count
balance. -/
theorem no_matching_of_giving_without_taking {α : Type} {R : «际» α} (u : α) :
    ¬ ExchangeMatched R [] [u] :=
  fun m => Nat.not_succ_le_zero 0 (give_le_take_of_matched m)

end UnitScratch
end Becoming

namespace Becoming
namespace UnitScratch

theorem mem_append_right' {x : U} : ∀ (a : List U) {b : List U}, x ∈ b → x ∈ a ++ b
  | [], _, h => h
  | _ :: a, _, h => List.Mem.tail _ (mem_append_right' a h)

theorem mem_insert' {x : U} : ∀ (a : List U) (b : List U), x ∈ a ++ x :: b
  | [], _ => List.Mem.head _
  | _ :: a, b => List.Mem.tail _ (mem_insert' a b)

/-- **A crossing edge** (the counting heart of the crossing line): where a one-to-one pairing of
`b₁ ++ b₂` with `a₁ ++ a₂` (under the converse) has more in `b₁` than in `a₁`, some member of `a₂`
is related to some member of `b₁`. Constructive: the witness is found where the pairing first sends
a member of `b₁` outside `a₁`. It holds for every pairing; which edge crosses changes with the
pairing. -/
theorem crossing_edge {R : «际» U} : ∀ (b₁ : List U) {b₂ a₁ a₂ : List U},
    «对» («逆» R) (b₁ ++ b₂) (a₁ ++ a₂) → a₁.length < b₁.length →
      ∃ x, x ∈ a₂ ∧ ∃ y, y ∈ b₁ ∧ R x y
  | [], _, _, _, _, lt => absurd lt (Nat.not_lt_zero _)
  | y :: b₁, b₂, a₁, a₂, p, lt => by
    obtain ⟨c₁, z, c₂, e, r, rest⟩ := «对之取» p [] (y := y) (b₂ := b₁ ++ b₂) rfl
    cases GrammarLaws.split_append a₁ e with
    | inl hf =>
      obtain ⟨f, ha, hc⟩ := hf
      subst ha
      subst hc
      have rest' : «对» («逆» R) (b₁ ++ b₂) ((c₁ ++ f) ++ a₂) :=
        Eq.subst (motive := fun l => «对» («逆» R) (b₁ ++ b₂) l)
          (ListTests.append_assoc c₁ f a₂).symm rest
      have len : (c₁ ++ z :: f).length = (c₁ ++ f).length + 1 := by
        rw [ListTests.length_append, ListTests.length_append]
        exact rfl
      rw [len] at lt
      obtain ⟨x, m, y', m', r'⟩ := crossing_edge b₁ rest' (Nat.lt_of_succ_lt_succ lt)
      exact ⟨x, m, y', List.Mem.tail _ m', r'⟩
    | inr hf =>
      obtain ⟨f, _, ha⟩ := hf
      exact ⟨z, ha ▸ mem_insert' f c₂, y, List.Mem.head _, r⟩

/-- **The crossing line at a formation** (the line form of `Balances.rise_draws_beyond_inflow`'s
conclusion): at an exchange matching of what a formation takes (from `ds`, then from elsewhere) with
what it gives (to `ds`, then elsewhere, then what ends), where it gives `ds` more than it takes from
`ds`, some unit it took from elsewhere goes on as a unit it gives `ds`: a line crosses into `ds`
through the formation, for every pairing. -/
theorem crossing_line {R : «际» U} {fromDs fromElse toDs toElse ended : List U}
    (p : «对» R (fromDs ++ fromElse) (toDs ++ (toElse ++ ended)))
    (more : fromDs.length < toDs.length) :
    ∃ x, x ∈ fromElse ∧ ∃ y, y ∈ toDs ∧ R x y :=
  crossing_edge toDs («对之逆» p) more

end UnitScratch
end Becoming

namespace Becoming
namespace UnitScratch

/-! ## Round 2: the exchange selection at a formation, joined to the World -/

/-- Exchange occurrences at one formation and step: units it took from a condition, units it gave
to a condition, units from beyond, units whose line ends there. -/
inductive Ex (C : Type) where
  | took (c : C) (i : Nat)
  | gave (c : C) (i : Nat)
  | beyond (i : Nat)
  | ended (i : Nat)

def tag {C : Type} (k : Nat → Ex C) : List Nat → List (Ex C)
  | [] => []
  | i :: is => k i :: tag k is

theorem length_tag {C : Type} (k : Nat → Ex C) : ∀ l : List Nat, (tag k l).length = l.length
  | [] => rfl
  | _ :: l => congrArg Nat.succ (length_tag k l)

variable {F C : Type}

/-- What a formation takes from a family across the step, labelled by condition and position. -/
def takeL (L : Flow F C) (f : F) (cs : List C) (t : Nat) : List (Ex C) :=
  «聚» (fun c => tag (Ex.took c) (upto (L.take t f c))) cs

/-- What a formation gives a family across the step, labelled by condition and position. -/
def giveL (L : Flow F C) (f : F) (cs : List C) (t : Nat) : List (Ex C) :=
  «聚» (fun c => tag (Ex.gave c) (upto (L.give t f c))) cs

theorem length_takeL (L : Flow F C) (f : F) (cs : List C) (t : Nat) :
    (takeL L f cs t).length = total cs (L.take t f) :=
  («聚之长» _ cs).trans (GrammarLaws.total_congr
    (fun _ => (length_tag _ _).trans (length_upto _)) cs)

theorem length_giveL (L : Flow F C) (f : F) (cs : List C) (t : Nat) :
    (giveL L f cs t).length = total cs (L.give t f) :=
  («聚之长» _ cs).trans (GrammarLaws.total_congr
    (fun _ => (length_tag _ _).trans (length_upto _)) cs)

/-- **The crossing line joined to the World, weak form**: where a family's stock rises past the
inflow of a containing family, some formation taking part is such that, at every matching of what it
takes from the risen family, followed by any other inputs, with what it gives the risen family,
followed by any other outputs, some unit it gives the risen family continues one of the other
inputs (another condition's unit, or beyond's). One formation, then every matching. -/
theorem rise_crossing_weak {L : Flow F C} {W : Web F C} {ds es : List C} {t : Nat}
    (balances : L.Balances W) (distinct : Distinct ds) (sub : ∀ c, c ∈ ds → c ∈ es)
    (rises : W.stock ds t + L.inflow es t < W.stock ds (t + 1)) :
    ∃ f, f ∈ L.present t ∧ ∀ (R : «际» (Ex C)) (elseL outL : List (Ex C)),
      «对» R (takeL L f ds t ++ elseL) (giveL L f ds t ++ outL) →
        ∃ x, x ∈ elseL ∧ ∃ y, y ∈ giveL L f ds t ∧ R x y :=
  match balances.rise_draws_beyond_inflow distinct sub rises with
  | ⟨f, present, _, lt, _⟩ => ⟨f, present, fun _ _ _ p =>
      crossing_edge (giveL L f ds t) («对之逆» p) (by rw [length_takeL, length_giveL]; exact lt)⟩

/-- **The crossing line joined to the World, strong form**: with the containing family written as
the risen one followed by the rest, and beyond's inputs at the formation source-minimal over it
(as many as it gives the containing family beyond what it takes from it), at every matching of
what it takes from the risen family, beyond's units and what it takes from the rest, with what it
gives the risen family and any other outputs, some unit it gives the risen family continues a unit
it took from the rest: an actual line from the rest into the risen family. -/
theorem rise_crossing_strong {L : Flow F C} {W : Web F C} {ds rest : List C} {t : Nat}
    (balances : L.Balances W) (distinct : Distinct ds)
    (rises : W.stock ds t + L.inflow (ds ++ rest) t < W.stock ds (t + 1)) :
    ∃ f, f ∈ L.present t ∧ ∀ (R : «际» (Ex C)) (beyondL outL : List (Ex C)),
      beyondL.length = excess (total (ds ++ rest) (L.give t f)) (total (ds ++ rest) (L.take t f)) →
      «对» R ((takeL L f ds t ++ beyondL) ++ takeL L f rest t) (giveL L f ds t ++ outL) →
        ∃ x, x ∈ takeL L f rest t ∧ ∃ y, y ∈ giveL L f ds t ∧ R x y :=
  match balances.rise_draws_beyond_inflow distinct (fun c m => mem_append_left' rest m) rises with
  | ⟨f, present, ex, lt, _⟩ => ⟨f, present, fun _ beyondL _ hb p => by
      apply crossing_edge (giveL L f ds t) («对之逆» p)
      -- the risen family's own takes and beyond's units are fewer than what it gives the risen family
      have bal := excess_balance (total ds (L.take t f)) (total ds (L.give t f))
      rw [Flow.excess_zero_of_le (Nat.le_of_lt lt), Nat.add_zero] at bal
      rw [ListTests.length_append, length_takeL, hb, length_giveL]
      exact Nat.lt_of_lt_of_le (Nat.add_lt_add_left ex _) (Nat.le_of_eq bal)⟩

/-- **How many end, from any matching**: at a formation, a matching of what it takes from a family
and beyond's units with what it gives the family and the units ending there has, where beyond's units
are source-minimal, exactly as many endings as it takes beyond what it gives. -/
theorem endings_count {L : Flow F C} {f : F} {cs : List C} {t : Nat} {R : «际» (Ex C)}
    {beyondL endedL : List (Ex C)}
    (minimal : beyondL.length = excess (total cs (L.give t f)) (total cs (L.take t f)))
    (p : «对» R (takeL L f cs t ++ beyondL) (giveL L f cs t ++ endedL)) :
    endedL.length = excess (total cs (L.take t f)) (total cs (L.give t f)) := by
  have e := «对之长» p
  rw [ListTests.length_append, ListTests.length_append, length_takeL, length_giveL, minimal,
    excess_balance] at e
  exact Naturals.add_left_cancel e.symm

/-- **Source-free where the formation dissipates**: on a family the formation dissipates on,
beyond's source-minimal count is zero. -/
theorem source_free_of_dissipates {L : Flow F C} {cs : List C} {t : Nat} {f : F}
    (dissipates : L.DissipatesOn cs t) (present : f ∈ L.present t) :
    excess (total cs (L.give t f)) (total cs (L.take t f)) = 0 :=
  Flow.excess_zero_of_le (Nat.le_trans (Nat.le_add_right _ _) (dissipates f present))

/-- **A line ends at every taker that dissipates**: on a family the formation dissipates on and
takes from, the number of endings (taken beyond given) is positive. -/
theorem ends_of_dissipates {L : Flow F C} {cs : List C} {t : Nat} {f : F}
    (dissipates : L.DissipatesOn cs t) (present : f ∈ L.present t)
    (takes : 0 < total cs (L.take t f)) :
    0 < excess (total cs (L.take t f)) (total cs (L.give t f)) := by
  have d := dissipates f present
  cases h : total cs (L.take t f) with
  | zero => rw [h] at takes; exact absurd takes (Nat.lt_irrefl 0)
  | succ k =>
    rw [h] at d
    exact excess_pos.mpr (Nat.lt_of_succ_le d)

end UnitScratch
end Becoming

namespace Becoming
namespace UnitScratch

/-! ## Round 2: the matching as data (review finding 1)

A frame's in-positions `i < N` (standing `i < level t`, then given `level t ≤ i`) and out-positions
`j < M` (standing at `t + 1` `j < level (t + 1)`, then taken) are put in one-to-one correspondence
by a selected matching, given as data: the lines are its lines, nothing chosen. -/

/-- A selected matching of a frame: a bijection of the in-positions with the out-positions. -/
structure FrameMatch (N M : Nat) where
  fwd : Nat → Nat
  bwd : Nat → Nat
  fwd_lt : ∀ i, i < N → fwd i < M
  bwd_lt : ∀ j, j < M → bwd j < N
  bwd_fwd : ∀ i, i < N → bwd (fwd i) = i
  fwd_bwd : ∀ j, j < M → fwd (bwd j) = j

theorem mem_upto : ∀ {M j : Nat}, j < M → j ∈ upto M
  | 0, _, h => absurd h (Nat.not_lt_zero _)
  | _ + 1, _, h =>
    match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ h) with
    | Or.inl lt => List.Mem.tail _ (mem_upto lt)
    | Or.inr e => e ▸ List.Mem.head _

theorem length_upto' (M : Nat) : (upto M).length = M := length_upto M

theorem upto_lt : ∀ {M j : Nat}, j ∈ upto M → j < M
  | 0, _, h => by cases h
  | M + 1, j, h => by
    change j ∈ M :: upto M at h
    cases h with
    | head => exact Nat.lt_succ_self _
    | tail _ h => exact Nat.lt_succ_of_lt (upto_lt h)

/-- A selected matching has no more in-positions than out-positions (pigeonhole, no decidability). -/
theorem FrameMatch.le {N M : Nat} (m : FrameMatch N M) : N ≤ M :=
  match Nat.lt_or_ge M N with
  | Or.inr ge => ge
  | Or.inl lt =>
    match GrammarLaws.revisits_within (upto M) m.fwd (fun n le =>
        mem_upto (m.fwd_lt n (Nat.lt_of_le_of_lt ((length_upto M) ▸ le) lt))) with
    | ⟨i, j, ij, jle, same⟩ => by
      have jN : j < N := Nat.lt_of_le_of_lt ((length_upto M) ▸ jle) lt
      have iN : i < N := Nat.lt_trans ij jN
      have e : i = j := (m.bwd_fwd i iN).symm.trans ((congrArg m.bwd same).trans (m.bwd_fwd j jN))
      exact absurd (e ▸ ij) (Nat.lt_irrefl j)

def FrameMatch.symm {N M : Nat} (m : FrameMatch N M) : FrameMatch M N where
  fwd := m.bwd
  bwd := m.fwd
  fwd_lt := m.bwd_lt
  bwd_lt := m.fwd_lt
  bwd_fwd := m.fwd_bwd
  fwd_bwd := m.bwd_fwd

theorem FrameMatch.eq {N M : Nat} (m : FrameMatch N M) : N = M :=
  Nat.le_antisymm m.le m.symm.le

/-- Pairing by position: the identity matching, no choice. -/
def FrameMatch.id (N : Nat) : FrameMatch N N where
  fwd i := i
  bwd j := j
  fwd_lt _ h := h
  bwd_lt _ h := h
  bwd_fwd _ _ := rfl
  fwd_bwd _ _ := rfl

/-- **A fixed predecessor** (`«定前»` at a frame): an out-position has exactly one in-position the
selected matching sends to it. -/
theorem FrameMatch.predecessor_unique {N M : Nat} (m : FrameMatch N M) {i j : Nat} (iN : i < N)
    (e : m.fwd i = j) : i = m.bwd j :=
  (m.bwd_fwd i iN).symm.trans (congrArg m.bwd e)

variable {F C : Type}

/-- **A kinded unit model with the matching as data**: at every step and condition, a selected
matching of the frame. The standing out-positions of frame `t` (below `level (t + 1)`) are the
standing in-positions of frame `t + 1`, by the same index: the frames compose. -/
structure KUnits (L : Flow F C) (W : Web F C) where
  m : ∀ t c, FrameMatch (W.level t c + L.given t c) (W.level (t + 1) c + L.taken t c)

theorem KUnits.balances {L : Flow F C} {W : Web F C} (U : KUnits L W) : L.Balances W :=
  fun t c => (U.m t c).eq.symm

/-- The canonical kinded unit model of a balanced flow: pairing by position. -/
def KUnits.canonical {L : Flow F C} {W : Web F C} (b : L.Balances W) : KUnits L W where
  m t c := cast (congrArg (FrameMatch (W.level t c + L.given t c)) (b t c).symm)
    (FrameMatch.id (W.level t c + L.given t c))

/-- **The kinded unit selection, both ways**: a unit model with its matchings as data exists exactly
where the flow balances; the converse needs no choice. -/
theorem kunits_iff_balances {L : Flow F C} {W : Web F C} :
    Nonempty (KUnits L W) ↔ L.Balances W :=
  ⟨fun ⟨U⟩ => U.balances, fun b => ⟨KUnits.canonical b⟩⟩

/-- **A standing unit's next place**: a standing unit at `t` goes on as a standing unit at `t + 1`
or is taken, by the selected matching; which one is the matching's (the gauge), and that it goes
on to exactly one out-position is not. -/
theorem KUnits.next {L : Flow F C} {W : Web F C} (U : KUnits L W) {t : Nat} {c : C} {i : Nat}
    (standing : i < W.level t c) :
    (U.m t c).fwd i < W.level (t + 1) c ∨
      (W.level (t + 1) c ≤ (U.m t c).fwd i ∧ (U.m t c).fwd i < W.level (t + 1) c + L.taken t c) :=
  match Nat.lt_or_ge ((U.m t c).fwd i) (W.level (t + 1) c) with
  | Or.inl lt => Or.inl lt
  | Or.inr ge => Or.inr ⟨ge, (U.m t c).fwd_lt i (Nat.lt_of_lt_of_le standing (Nat.le_add_right _ _))⟩

end UnitScratch
end Becoming

namespace Becoming
namespace UnitScratch

variable {F C : Type}

/-! ## Round 2: storage (review finding 4) and the projection (review finding 6) -/

/-- **Lossless storage through a dissipative formation is excluded**: a formation that takes from the
family exactly what it gives the family (for instance all it took given to its own condition role,
`give t f f`), and takes something, does not dissipate on it. -/
theorem lossless_not_dissipative {L : Flow F C} {cs : List C} {t : Nat} {f : F}
    (present : f ∈ L.present t) (same : total cs (L.give t f) = total cs (L.take t f))
    (takes : 0 < total cs (L.take t f)) : ¬ L.DissipatesOn cs t := fun d => by
  have h := d f present
  rw [same] at h
  cases e : total cs (L.take t f) with
  | zero => rw [e] at takes; exact Nat.lt_irrefl 0 takes
  | succ k => rw [e] at h; exact Nat.not_succ_le_self (k + 1) h

/-- **The projection, restricted**: a standing unit that goes on as a standing unit projects, on the
occurrence model, into the names' step at its condition: from `(t, c)` to `(t + 1, c)`. This is the
only relation of the occurrence model unit continuation is claimed to preserve; conservation is not
its image (it relates different conditions, and holds at zero levels). -/
theorem KUnits.projects_along {L : Flow F C} {W : Web F C} (U : KUnits L W) {t : Nat} {c : C}
    {i : Nat} (_standing : i < W.level t c) (_goesOn : (U.m t c).fwd i < W.level (t + 1) c) :
    Steps.along (t, c) (t + 1, c) :=
  ⟨rfl, rfl⟩

end UnitScratch
end Becoming

namespace Becoming
namespace UnitScratch

variable {F C : Type}

/-- **Leaving and ending together** (second read, finding 1): where the outputs keep the units that
leave the family as well as those that end, beyond's units source-minimal, it is leaving and ending
together that number taken beyond given; which of the two a residual unit is, the matching does not
say. -/
theorem leaving_and_endings_count {L : Flow F C} {f : F} {cs : List C} {t : Nat} {R : «际» (Ex C)}
    {beyondL leaveL endedL : List (Ex C)}
    (minimal : beyondL.length = excess (total cs (L.give t f)) (total cs (L.take t f)))
    (p : «对» R (takeL L f cs t ++ beyondL) (giveL L f cs t ++ (leaveL ++ endedL))) :
    leaveL.length + endedL.length = excess (total cs (L.take t f)) (total cs (L.give t f)) := by
  have e := «对之长» p
  rw [ListTests.length_append, ListTests.length_append, ListTests.length_append, length_takeL,
    length_giveL, minimal, excess_balance] at e
  exact Naturals.add_left_cancel e.symm

/-- At a family closed for the formation, nothing leaves, and the endings alone number taken beyond
given. -/
theorem endings_count_closed {L : Flow F C} {f : F} {cs : List C} {t : Nat} {R : «际» (Ex C)}
    {beyondL endedL : List (Ex C)}
    (minimal : beyondL.length = excess (total cs (L.give t f)) (total cs (L.take t f)))
    (p : «对» R (takeL L f cs t ++ beyondL) (giveL L f cs t ++ ([] ++ endedL))) :
    endedL.length = excess (total cs (L.take t f)) (total cs (L.give t f)) :=
  (Nat.zero_add _).symm.trans (leaving_and_endings_count (leaveL := []) minimal p)

end UnitScratch
end Becoming
