import Becoming.GrammarLaws

/-!
# Scratch for U4c: the census on the root (not a module of the package)

Checked outside the package, over GrammarLaws and its imports only.

* **`Moved`** copies the lemmas that move to `Becoming.Prelude` at landing, under their package
  names and stated in every universe: `mem_remove`, `length_le_of_matched` and `not_not_all`
  (Population), `steps_mem`, `steps_last`, `steps_mono`, `recurring_accumulates` and
  `pos_of_exceeds` (Change), `total_pos` (Flow), and `gaining_of_losing`, `recurs_shift`,
  `recurs_unshift` and `gaining_of_losing_from` (Population). Here they are copies, so that the
  scratch builds over the grammar alone; none of them reaches a balance anchor.
* **`Law`** holds what goes to GrammarLaws' census section, after `«后者在后则所列亡者亡»`:
  - `«定后则后并亡不过前并生»`, the census of a step counted by tests, one side;
  - `«定前则前并生不过后并亡»`, its mirror, the same law at the converse;
  - `«定后前者在前则亡屡者生屡»`, the census of a run, on the root's beginnings and endings;
  - `census_count_of_halves`, a check that the two halves give the count of HE2's census.
* **`Needed`** holds the witnesses that each hypothesis is needed.
-/

namespace Becoming
namespace U4cScratch

universe u v

/-! ## Lemmas that move to the prelude (copies) -/

section Moved

variable {α : Type u} {β : Type v}

/-- Removing one occurrence of `a` keeps every other member. -/
theorem mem_remove {a b : α} (other : ¬ b = a) : ∀ {p q : List α}, b ∈ p ++ a :: q → b ∈ p ++ q
  | [], _, mem => match ListTests.mem_cons_iff.mp mem with
    | .inl same => absurd same other
    | .inr mem => mem
  | c :: _, _, mem => match ListTests.mem_cons_iff.mp mem with
    | .inl same => Eq.subst (motive := fun x => x ∈ c :: _) same.symm (.head _)
    | .inr mem => .tail _ (mem_remove other mem)

/-- A list without repetition, each member of which is matched to a member of another
list, no member of which is matched to two: the first list is no longer. -/
theorem length_le_of_matched {S : α → β → Prop} : ∀ {l : List α} {m : List β}, Distinct l →
    (∀ a, a ∈ l → ∃ b, b ∈ m ∧ S a b) →
    (∀ a a' b, a ∈ l → a' ∈ l → S a b → S a' b → a = a') → l.length ≤ m.length
  | [], _, _, _, _ => Nat.zero_le _
  | a :: l, m, ⟨fresh, distinct⟩, matched, once => match matched a (.head l) with
    | ⟨b, mem, paired⟩ => match List.append_of_mem mem with
      | ⟨p, q, split⟩ =>
        have inner : l.length ≤ (p ++ q).length :=
          length_le_of_matched distinct
            (fun a' mem' => match matched a' (.tail a mem') with
              | ⟨b', mem_b', paired'⟩ =>
                have other : ¬ b' = b := fun same =>
                  fresh (Eq.subst (motive := fun x => x ∈ l)
                    (once a' a b' (.tail a mem') (.head l) paired'
                      (Eq.subst (motive := fun x => S a x) same.symm paired)) mem')
                ⟨b', mem_remove other (split ▸ mem_b'), paired'⟩)
            (fun x y b' mx my => once x y b' (.tail a mx) (.tail a my))
        have whole : m.length = (p ++ q).length + 1 :=
          (congrArg List.length split).trans ((ListTests.length_append p (b :: q)).trans
            ((Nat.add_succ _ _).trans (congrArg Nat.succ (ListTests.length_append p q).symm)))
        whole ▸ Nat.succ_le_succ inner

/-- Doubly negated for each member of a list, doubly negated for all of them. -/
theorem not_not_all {P : β → Prop} :
    ∀ {E : List β}, (∀ b, b ∈ E → ¬ ¬ P b) → ¬ ¬ ∀ b, b ∈ E → P b
  | [], _ => fun none => none fun _ mem => nomatch mem
  | b :: E, each => fun none =>
    each b (.head E) fun head =>
      not_not_all (E := E) (fun c mem => each c (.tail b mem)) fun rest =>
        none fun c mem => match ListTests.mem_cons_iff.mp mem with
          | .inl same => Eq.subst (motive := P) same.symm head
          | .inr mem => rest c mem

theorem steps_mem : ∀ {T n t : Nat}, t ∈ steps T n → T ≤ t
  | _, 0, _, mem => nomatch mem
  | _, _ + 1, _, .head _ => Nat.le_refl _
  | _, _ + 1, _, .tail _ mem => Nat.le_of_succ_le (steps_mem mem)

theorem steps_last (q : Nat → Nat) :
    ∀ T n, total (steps T (n + 1)) q = total (steps T n) q + q (T + n)
  | T, 0 => Nat.add_comm (q T) 0
  | T, n + 1 =>
    (congrArg (q T + ·) ((steps_last q (T + 1) n).trans
      (congrArg (_ + ·) (congrArg q (Nat.add_right_comm T 1 n))))).trans
      (Nat.add_assoc _ _ _).symm

theorem steps_mono (q : Nat → Nat) (T n : Nat) :
    ∀ m, total (steps T n) q ≤ total (steps T (n + m)) q
  | 0 => Nat.le_refl _
  | m + 1 => Nat.le_trans (steps_mono q T n m)
      (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (steps_last q T (n + m)).symm))

/-- Where a quantity is positive at arbitrarily late steps, its totals over stretches from
any step exceed every bound. -/
theorem recurring_accumulates {q : Nat → Nat} (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < q t)
    (N : Nat) : ∀ K, ∃ n, K ≤ total (steps N n) q
  | 0 => ⟨0, Nat.zero_le _⟩
  | K + 1 => match recurring_accumulates recurs N K with
    | ⟨n, many⟩ => match recurs (N + n) with
      | ⟨_, later, positive⟩ => match le_dest later with
        | ⟨m, same⟩ => ⟨n + m + 1, Nat.le_trans
            (Nat.add_le_add (Nat.le_trans many (steps_mono q N n m))
              (Nat.lt_of_lt_of_le positive
                (Nat.le_of_eq (congrArg q (same.trans (Nat.add_assoc N n m))))))
            (Nat.le_of_eq (steps_last q N (n + m)).symm)⟩

/-- What exceeds `K` and is at most `K` and `R` together leaves `R` positive. -/
theorem pos_of_exceeds {K X R : Nat} (many : K + 1 ≤ X) (within : X ≤ K + R) : 0 < R :=
  match R, within with
  | 0, within => absurd (Nat.le_trans many within) (Nat.not_succ_le_self K)
  | R + 1, _ => Nat.succ_pos R

/-- A positive total has a positive member. -/
theorem total_pos {γ : Type} {q : γ → Nat} : ∀ as : List γ, 0 < total as q → ∃ a, a ∈ as ∧ 0 < q a
  | a :: as, pos => match h : q a with
    | 0 => match total_pos as (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        ((congrArg (· + total as q) h).trans (Nat.zero_add (total as q))))) with
      | ⟨b, mem, positive⟩ => ⟨b, .tail a mem, positive⟩
    | n + 1 => ⟨a, .head as, h ▸ Nat.succ_pos n⟩

/-- Where a count, at each step, ends with what it loses at most where it started with what
it gains, losses at arbitrarily late steps need gains at arbitrarily late steps. -/
theorem gaining_of_losing {q x y : Nat → Nat} (across : ∀ t, q (t + 1) + x t ≤ q t + y t)
    (losing : ∀ N, ∃ t, N ≤ t ∧ 0 < x t) : ∀ N, ∃ t, N ≤ t ∧ 0 < y t :=
  fun N => match recurring_accumulates losing N (q N + 1) with
  | ⟨n, many⟩ => match total_pos (steps N n) (pos_of_exceeds many
      (Nat.le_trans (Nat.le_add_left _ _) (le_over_stretch across N n))) with
    | ⟨t, mem, gained⟩ => ⟨t, steps_mem mem, gained⟩

theorem recurs_shift {r : Nat → Prop} (T : Nat) (recurs : ∀ N, ∃ t, N ≤ t ∧ r t) :
    ∀ N, ∃ m, N ≤ m ∧ r (T + m) :=
  fun N => match recurs (N + T) with
  | ⟨_, later, holds⟩ => match le_dest (Nat.le_trans (Nat.le_add_left T N) later) with
    | ⟨m, same⟩ => ⟨m, le_of_add_le_add_right T
        (Nat.le_trans later (Nat.le_of_eq (same.trans (Nat.add_comm T m)))), same ▸ holds⟩

theorem recurs_unshift {r : Nat → Prop} (T : Nat) (recurs : ∀ N, ∃ m, N ≤ m ∧ r (T + m)) :
    ∀ N, ∃ t, N ≤ t ∧ r t :=
  fun N => match recurs N with
  | ⟨m, later, holds⟩ => ⟨T + m, Nat.le_trans later (Nat.le_add_left m T), holds⟩

theorem gaining_of_losing_from {q x y : Nat → Nat} {T : Nat}
    (across : ∀ t, T ≤ t → q (t + 1) + x t ≤ q t + y t)
    (losing : ∀ N, ∃ t, N ≤ t ∧ 0 < x t) : ∀ N, ∃ t, N ≤ t ∧ 0 < y t :=
  recurs_unshift T (gaining_of_losing (q := fun m => q (T + m)) (x := fun m => x (T + m))
    (y := fun m => y (T + m)) (fun m => across (T + m) (Nat.le_add_right T m))
    (recurs_shift T losing))

end Moved

/-! ## The laws (to GrammarLaws' census section) -/

section Law

variable {α : Type u}

/-- A list keeps as many units as a test holds of. -/
theorem length_keep (p : α → Bool) : ∀ l : List α, (GrammarLaws.keep p l).length = «计» p l
  | [] => rfl
  | x :: l => by
    show (cond (p x) (x :: GrammarLaws.keep p l) (GrammarLaws.keep p l)).length =
      cond (p x) 1 0 + «计» p l
    cases p x with
    | true => exact (congrArg (· + 1) (length_keep p l)).trans (Nat.add_comm _ _)
    | false => exact (length_keep p l).trans (Nat.zero_add _).symm

/-- A list is the units a test holds of with those it fails of. -/
theorem count_add_not (p : α → Bool) : ∀ l : List α, «计» p l + «计» (fun x => !p x) l = l.length
  | [] => rfl
  | x :: l => by
    show (cond (p x) 1 0 + «计» p l) + (cond (!p x) 1 0 + «计» (fun x => !p x) l) = l.length + 1
    cases p x with
    | true =>
      show (1 + «计» p l) + (0 + «计» (fun x => !p x) l) = l.length + 1
      rw [Nat.zero_add, Nat.add_assoc, count_add_not p l, Nat.add_comm]
    | false =>
      show (0 + «计» p l) + (1 + «计» (fun x => !p x) l) = l.length + 1
      rw [Nat.zero_add, Nat.add_left_comm, count_add_not p l, Nat.add_comm]

/-- Keeping the units a test holds of keeps a list without repetition. -/
theorem distinct_keep (p : α → Bool) : ∀ {l : List α}, Distinct l → Distinct (GrammarLaws.keep p l)
  | [], _ => trivial
  | x :: l, ⟨fresh, once⟩ => by
    show Distinct (cond (p x) (x :: GrammarLaws.keep p l) (GrammarLaws.keep p l))
    cases p x with
    | true => exact ⟨fun mem => fresh (GrammarLaws.mem_keep.mp mem).1, distinct_keep p once⟩
    | false => exact distinct_keep p once

/-- A unit a test holds of makes its count positive. -/
theorem count_pos_of_mem {p : α → Bool} {x : α} {l : List α} (mem : x ∈ l) (holds : p x = true) :
    0 < «计» p l :=
  match List.append_of_mem mem with
  | ⟨b₁, b₂, split⟩ => by
    rw [split, GrammarLaws.count_insert, holds]
    exact Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_add_right _ _)

variable {R E : «际» α}

/-- **The census of a step, counted, one side** (定后则后并亡不过前并生). Units listed before and
after a step under a continuation `«续» R E` that fixes successors, those after listed once: where a
test `b` fails only of units after with a predecessor among the units before, as far as can be
refuted, and a test `e` holds only of units before that no unit after continues, the units after
with those `e` holds of are at most the units before with those `b` holds of. No decision of
identity is used: a predecessor is found under a double negation, the conclusion being a decided
comparison of numbers. -/
theorem «定后则后并亡不过前并生» {b e : α → Bool} {before after : List α}
    (dA : Distinct after) (fixedAfter : «定后» («续» R E))
    (arising : ∀ y, y ∈ after → b y = false → ¬¬ ∃ x, x ∈ before ∧ «续» R E x y)
    (ceasing : ∀ x, x ∈ before → e x = true → ∀ y, y ∈ after → ¬ «续» R E x y) :
    after.length + «计» e before ≤ before.length + «计» b after :=
  have fewer : (GrammarLaws.keep (fun y => !b y) after).length ≤
      (GrammarLaws.keep (fun x => !e x) before).length :=
    Decidable.of_not_not fun more =>
      not_not_all (P := fun y => ∃ x, x ∈ GrammarLaws.keep (fun x => !e x) before ∧ «续» R E x y)
        (fun y my none =>
          have h := GrammarLaws.mem_keep.mp my
          arising y h.1 (GrammarLaws.not_eq_true_iff.mp h.2) fun ⟨x, mx, c⟩ =>
            none ⟨x, GrammarLaws.mem_keep.mpr ⟨mx, GrammarLaws.not_eq_true_iff.mpr
              (match he : e x with
               | false => rfl
               | true => absurd c (ceasing x mx he y h.1))⟩, c⟩)
        fun all => more (length_le_of_matched (S := fun y x => «续» R E x y)
          (distinct_keep _ dA) all
          fun y y' x _ _ c c' => «定后之逐点».mp fixedAfter x y y' c c')
  calc after.length + «计» e before
      = («计» b after + (GrammarLaws.keep (fun y => !b y) after).length) + «计» e before := by
        rw [length_keep, count_add_not]
    _ ≤ («计» b after + (GrammarLaws.keep (fun x => !e x) before).length) + «计» e before :=
        Nat.add_le_add_right (Nat.add_le_add_left fewer _) _
    _ = before.length + «计» b after := by
        rw [length_keep, Nat.add_assoc, Nat.add_comm («计» (fun x => !e x) before),
          count_add_not, Nat.add_comm]

/-- **Its mirror** (定前则前并生不过后并亡), the same law at the converse. Under a continuation that
fixes predecessors, the units before listed once: where `e` fails only of units before with a
successor among the units after, as far as can be refuted, and `b` holds only of units after that
no unit before continues, the units before with those `b` holds of are at most the units after
with those `e` holds of. -/
theorem «定前则前并生不过后并亡» {b e : α → Bool} {before after : List α}
    (dB : Distinct before) (fixedBefore : «定前» («续» R E))
    (ceasing : ∀ x, x ∈ before → e x = false → ¬¬ ∃ y, y ∈ after ∧ «续» R E x y)
    (arising : ∀ y, y ∈ after → b y = true → ∀ x, x ∈ before → ¬ «续» R E x y) :
    before.length + «计» b after ≤ after.length + «计» e before :=
  «定后则后并亡不过前并生» (R := «逆» R) (E := «逆» E) (b := e) (e := b)
    (before := after) (after := before) dB
    («定后之逐点».mpr fun x y z c c' => «定前之逐点».mp fixedBefore y z x c c')
    ceasing arising

/-- **The census of a run** (定后前者在前则亡屡者生屡). Units listed at each step of a run under a
continuation that fixes successors, from step `T` on: the units after each step listed once, every
predecessor of a unit listed after a step listed before it, and the root's beginnings (`«生»`) and
endings (`«亡»`) decided on the listed units by tests. Where endings recur among the listed units
(`«屡»`), beginnings recur among the units listed after a step. -/
theorem «定后前者在前则亡屡者生屡» {b e : α → Bool} {u : Nat → List α} {T : Nat}
    (once : ∀ t, T ≤ t → Distinct (u (t + 1)))
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t)
    (fixedAfter : «定后» («续» R E))
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (ends : ∀ t, T ≤ t → ∀ x, x ∈ u t → (e x = true ↔ «亡» R E x))
    (ending : «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u) :
    «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u :=
  fun N =>
    match gaining_of_losing_from (T := T) (q := fun t => (u t).length)
        (x := fun t => «计» e (u t)) (y := fun t => «计» b (u (t + 1)))
        (fun t from_ => «定后则后并亡不过前并生» (once t from_) fixedAfter
          (fun y my off none =>
            (fun begins' : «生» R E y =>
              Bool.noConfusion (((begins t from_ y my).mpr begins').symm.trans off))
            fun ⟨x, c⟩ => none ⟨x, predecessorsBefore t from_ x y my c, c⟩)
          (fun x mx on y _ c => (ends t from_ x mx).mp on ⟨y, c⟩))
        (fun M => match ending (M + T) with
          | ⟨t, later, x, mx, en⟩ =>
            ⟨t, Nat.le_trans (Nat.le_add_right M T) later,
              count_pos_of_mem mx ((ends t (Nat.le_trans (Nat.le_add_left T M) later) x mx).mpr en)⟩)
        (N + T) with
    | ⟨t, later, pos⟩ =>
      match GrammarLaws.split_of_count_pos pos with
      | ⟨b₁, y, b₂, split, tested⟩ =>
        have my : y ∈ u (t + 1) := split ▸ GrammarLaws.mem_middle y b₂ b₁
        ⟨t, Nat.le_trans (Nat.le_add_right N T) later, y, my,
          (begins t (Nat.le_trans (Nat.le_add_left T N) later) y my).mp tested⟩

/-- A test whose negation fails holds. -/
theorem eq_true_of_not_false : ∀ {c : Bool}, (!c) = false → c = true
  | true, _ => rfl
  | false, h => Bool.noConfusion h

/-- A check, not for landing as written: under HE2's census (`«定后定前则前并生对后并亡»`), the two
halves give its count, the tests read off `k`. So the count of the census of a step is a case of the
two halves, which ask neither `k` nor the predecessors' or successors' lists. -/
theorem census_count_of_halves {k : α → α → Bool} (dec : ∀ x y, «续» R E x y ↔ k x y = true)
    (before after : List α) (dB : Distinct before) (dA : Distinct after)
    (fixedAfter : «定后» («续» R E)) (fixedBefore : «定前» («续» R E)) :
    after.length + (GrammarLaws.ceasing k before after).length =
      before.length + (GrammarLaws.arising k before after).length :=
  have one := «定后则后并亡不过前并生» (b := fun y => !(before.any fun g => k g y))
    (e := fun x => !(after.any (k x))) dA fixedAfter
    (fun y _ off none => match GrammarLaws.any_split (eq_true_of_not_false off) with
      | ⟨a₁, x, a₂, split, kx⟩ =>
        none ⟨x, split ▸ GrammarLaws.mem_middle x a₂ a₁, (dec x y).mpr kx⟩)
    (fun x _ on y my c => Bool.noConfusion ((GrammarLaws.any_false_mem
        (GrammarLaws.not_eq_true_iff.mp on) my).symm.trans ((dec x y).mp c)))
  have other := «定前则前并生不过后并亡» (b := fun y => !(before.any fun g => k g y))
    (e := fun x => !(after.any (k x))) dB fixedBefore
    (fun x _ off none => match GrammarLaws.any_split (eq_true_of_not_false off) with
      | ⟨a₁, y, a₂, split, ky⟩ =>
        none ⟨y, split ▸ GrammarLaws.mem_middle y a₂ a₁, (dec x y).mpr ky⟩)
    (fun y _ on x mx c => Bool.noConfusion ((GrammarLaws.any_false_mem (p := fun g => k g y)
        (GrammarLaws.not_eq_true_iff.mp on) mx).symm.trans ((dec x y).mp c)))
  by
    show after.length + (GrammarLaws.keep _ before).length =
      before.length + (GrammarLaws.keep _ after).length
    rw [length_keep, length_keep]
    exact Nat.le_antisymm one other

end Law

/-! ## Each hypothesis needed -/

section Needed

/-- One law's hypotheses, at one step, for the witnesses below. -/
def StepMeets (R E : «际» Nat) (b e : Nat → Bool) (before after : List Nat) : Prop :=
  «定后» («续» R E) ∧
  (∀ y, y ∈ after → b y = false → ¬¬ ∃ x, x ∈ before ∧ «续» R E x y) ∧
  (∀ x, x ∈ before → e x = true → ∀ y, y ∈ after → ¬ «续» R E x y)

/-- **Listed once is needed** (the units after): one unit before, its one successor listed twice
after; every other hypothesis holds, and the count fails. -/
theorem step_needs_once :
    StepMeets (fun x y => x = 0 ∧ y = 1) (fun _ _ => True) (fun _ => false) (fun _ => false) [0] [1, 1] ∧
    ¬ ([1, 1].length + «计» (fun _ => false) [0] ≤ [0].length + «计» (fun _ => false) [1, 1]) :=
  ⟨⟨«定后之逐点».mpr fun _ _ _ c c' => c.1.2.trans c'.1.2.symm,
    fun y my _ none => none ⟨0, .head _, ⟨rfl, match GrammarLaws.mem_cons_split my with
      | .inl s => s
      | .inr m => match GrammarLaws.mem_cons_split m with
        | .inl s => s
        | .inr m => nomatch m⟩, trivial⟩,
    fun _ _ on => Bool.noConfusion on⟩,
   by decide⟩

/-- **Fixing successors is needed:** one unit before, continuing as two units after; every other
hypothesis holds, the units after listed once, and the count fails. -/
theorem step_needs_fixedAfter :
    Distinct [1, 2] ∧
    (∀ y, y ∈ [1, 2] → (fun _ => false) y = false →
      ¬¬ ∃ x, x ∈ [0] ∧ «续» (fun x y => x = 0 ∧ 0 < y) (fun _ _ => True) x y) ∧
    (∀ x, x ∈ [0] → (fun _ => false) x = true → ∀ y, y ∈ [1, 2] →
      ¬ «续» (fun x y => x = 0 ∧ 0 < y) (fun _ _ => True) x y) ∧
    ¬ «定后» («续» (fun x y : Nat => x = 0 ∧ 0 < y) (fun _ _ => True)) ∧
    ¬ ([1, 2].length + «计» (fun _ => false) [0] ≤ [0].length + «计» (fun _ => false) [1, 2]) :=
  ⟨⟨fun m => (match GrammarLaws.mem_cons_split m with
      | .inl s => absurd s (by decide)
      | .inr m => nomatch m), (fun m => nomatch m), trivial⟩,
   fun y my _ none => none ⟨0, .head _, ⟨rfl, match GrammarLaws.mem_cons_split my with
      | .inl s => Eq.subst (motive := fun z => 0 < z) s.symm (by decide)
      | .inr m => match GrammarLaws.mem_cons_split m with
        | .inl s => Eq.subst (motive := fun z => 0 < z) s.symm (by decide)
        | .inr m => nomatch m⟩, trivial⟩,
   fun _ _ on => Bool.noConfusion on,
   fun fixed => absurd («定后之逐点».mp fixed 0 1 2 ⟨⟨rfl, by decide⟩, trivial⟩
     ⟨⟨rfl, by decide⟩, trivial⟩) (by decide),
   by decide⟩

/-- **Predecessors listed before are needed for the run** (two units a step, a listed `a` and an
unlisted `p`): `p` at each step continues as the next `a`, and each `a` continues as nothing. Every
listed unit ends; none listed after a step begins, its predecessor being unlisted. Fixing
successors, listing once and the tests hold; endings recur and beginnings do not. -/
theorem run_needs_predecessorsBefore :
    let R : «际» (Nat × Bool) := fun x y => y.1 = x.1 + 1 ∧ x.2 = false ∧ y.2 = true
    let E : «际» (Nat × Bool) := fun _ _ => True
    let u : Nat → List (Nat × Bool) := fun t => [(t, true)]
    «定后» («续» R E) ∧ (∀ t, Distinct (u t)) ∧
    (∀ t y, y ∈ u (t + 1) → (false = true ↔ «生» R E y)) ∧
    (∀ t x, x ∈ u t → (true = true ↔ «亡» R E x)) ∧
    «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u ∧
    ¬ «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u :=
  have one : ∀ {t : Nat} {y : Nat × Bool}, y ∈ [(t, true)] → y = (t, true) := fun my =>
    match GrammarLaws.mem_cons_split my with
    | .inl s => s
    | .inr m => nomatch m
  have endsAll : ∀ t, «亡» (fun x y : Nat × Bool => y.1 = x.1 + 1 ∧ x.2 = false ∧ y.2 = true)
      (fun _ _ => True) (t, true) := fun _ ⟨_, ⟨⟨_, f, _⟩, _⟩⟩ => Bool.noConfusion f
  have notBegin : ∀ t, ¬ «生» (fun x y : Nat × Bool => y.1 = x.1 + 1 ∧ x.2 = false ∧ y.2 = true)
      (fun _ _ => True) (t + 1, true) := fun t bg => bg ⟨(t, false), ⟨⟨rfl, rfl, rfl⟩, trivial⟩⟩
  ⟨«定后之逐点».mpr fun x y z ⟨⟨y1, _, y2⟩, _⟩ ⟨⟨z1, _, z2⟩, _⟩ => by
      obtain ⟨y₁, y₂⟩ := y
      obtain ⟨z₁, z₂⟩ := z
      dsimp only at y1 y2 z1 z2
      subst y1; subst z1; subst y2; subst z2; rfl,
   fun _ => ⟨(fun m => nomatch m), trivial⟩,
   fun t y my => match y, one my with
     | _, rfl => ⟨fun f => Bool.noConfusion f, fun bg => absurd bg (notBegin t)⟩,
   fun t x mx => match x, one mx with
     | _, rfl => ⟨fun _ => endsAll t, fun _ => rfl⟩,
   fun N => ⟨N, Nat.le_refl N, (N, true), .head _, endsAll N⟩,
   fun recurs => match recurs 0 with
     | ⟨t, _, y, my, bg⟩ => match y, one my, bg with
       | _, rfl, bg => notBegin t bg⟩

/-- **Fixing successors is needed for the run** (two units a step, `x` and `y`): each `x` continues
as the next `x` and the next `y`, and each `y` continues as nothing. Both are listed at each step,
each once; the predecessor of every unit listed after a step is listed before it. The tests hold
with nothing tested as beginning and `y` tested as ending: every listed unit after a step has `x`
before it, so none begins, and of the units listed at a step `x` continues and `y` ends. Endings
recur and beginnings do not. -/
theorem run_needs_fixedAfter :
    let R : «际» (Nat × Bool) := fun x y => y.1 = x.1 + 1 ∧ x.2 = true
    let E : «际» (Nat × Bool) := fun _ _ => True
    let u : Nat → List (Nat × Bool) := fun t => [(t, true), (t, false)]
    ¬ «定后» («续» R E) ∧ (∀ t, Distinct (u t)) ∧
    (∀ t x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t) ∧
    (∀ t y, y ∈ u (t + 1) → (false = true ↔ «生» R E y)) ∧
    (∀ t x, x ∈ u t → ((!x.2) = true ↔ «亡» R E x)) ∧
    «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u ∧
    ¬ «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u :=
  have cases : ∀ {t : Nat} {y : Nat × Bool}, y ∈ [(t, true), (t, false)] →
      y = (t, true) ∨ y = (t, false) := fun my =>
    match GrammarLaws.mem_cons_split my with
    | .inl s => .inl s
    | .inr m => match GrammarLaws.mem_cons_split m with
      | .inl s => .inr s
      | .inr m => nomatch m
  have two : ∀ {t : Nat} {y : Nat × Bool}, y ∈ [(t, true), (t, false)] → y.1 = t := fun my =>
    (cases my).elim (congrArg Prod.fst) (congrArg Prod.fst)
  ⟨fun fixed => Bool.noConfusion (congrArg Prod.snd («定后之逐点».mp fixed (0, true) (1, true) (1, false)
      ⟨⟨rfl, rfl⟩, trivial⟩ ⟨⟨rfl, rfl⟩, trivial⟩)),
   fun _ => ⟨fun m => (match GrammarLaws.mem_cons_split m with
      | .inl s => Bool.noConfusion (congrArg Prod.snd s)
      | .inr m => nomatch m), (fun m => nomatch m), trivial⟩,
   fun t x y my ⟨⟨h1, h2⟩, _⟩ => by
      have ht : x.1 = t := Nat.succ.inj (h1.symm.trans (two my))
      obtain ⟨x₁, x₂⟩ := x
      dsimp only at ht h2
      subst ht; subst h2
      exact .head _,
   fun t y my => ⟨fun f => Bool.noConfusion f,
     fun bg => (bg ⟨(t, true), ⟨⟨(two my).trans rfl, rfl⟩, trivial⟩⟩).elim⟩,
   fun t x mx => match x, cases mx with
     | _, .inl rfl => ⟨fun f => Bool.noConfusion f,
         fun nd => (nd ⟨(t + 1, true), ⟨⟨rfl, rfl⟩, trivial⟩⟩).elim⟩
     | _, .inr rfl => ⟨fun _ ⟨_, ⟨⟨_, f⟩, _⟩⟩ => Bool.noConfusion f, fun _ => rfl⟩,
   fun N => ⟨N, Nat.le_refl N, (N, false), .tail _ (.head _),
     fun ⟨_, ⟨⟨_, f⟩, _⟩⟩ => Bool.noConfusion f⟩,
   fun recurs => match recurs 0 with
     | ⟨t, _, y, my, bg⟩ => bg ⟨(t, true), ⟨⟨(two my).trans rfl, rfl⟩, trivial⟩⟩⟩

end Needed

end U4cScratch
end Becoming
