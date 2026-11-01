import Becoming.GrammarLaws

/-! Throwaway review scratch for U4c (CENSUS-ON-THE-ROOT.md). Not part of the package. -/

namespace Becoming
namespace U4cReview

universe u v

section Lists

variable {α : Type u} {β : Type v}

theorem memCons {a b : α} {q : List α} : b ∈ a :: q → b = a ∨ b ∈ q
  | .head _ => .inl rfl
  | .tail _ m => .inr m

theorem memRemove {a b : α} (other : ¬ b = a) : ∀ {p q : List α}, b ∈ p ++ a :: q → b ∈ p ++ q
  | [], _, mem => match memCons mem with
    | .inl same => absurd same other
    | .inr mem => mem
  | c :: _, _, mem => match memCons mem with
    | .inl same => Eq.subst (motive := fun x => x ∈ c :: _) same.symm (.head _)
    | .inr mem => .tail _ (memRemove other mem)

theorem splitAt : ∀ {l : List α} {a : α}, a ∈ l → ∃ p q, l = p ++ a :: q
  | _ :: q, _, .head _ => ⟨[], q, rfl⟩
  | b :: _, _, .tail _ m => match splitAt m with
    | ⟨p, q, e⟩ => ⟨b :: p, q, congrArg (b :: ·) e⟩

theorem notNotAll {P : α → Prop} :
    ∀ {E : List α}, (∀ b, b ∈ E → ¬ ¬ P b) → ¬ ¬ ∀ b, b ∈ E → P b
  | [], _ => fun none => none fun _ mem => nomatch mem
  | b :: E, each => fun none =>
    each b (.head E) fun head =>
      notNotAll (E := E) (fun c mem => each c (.tail b mem)) fun rest =>
        none fun c mem => match memCons mem with
          | .inl same => Eq.subst (motive := P) same.symm head
          | .inr mem => rest c mem

/-- `«计» p` plus `«计»` of its negation is the length. -/
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

/-- The matching lemma, counted: a duplicate-free list whose members failing `b` are matched one
to one into members of `m` failing `e` has no more members failing `b` than `m` has failing `e`. -/
theorem count_le_of_matched {S : α → β → Prop} {b : α → Bool} {e : β → Bool} :
    ∀ {l : List α} {m : List β}, Distinct l →
    (∀ a, a ∈ l → b a = false → ∃ c, c ∈ m ∧ e c = false ∧ S a c) →
    (∀ a a' c, a ∈ l → a' ∈ l → S a c → S a' c → a = a') →
    «计» (fun a => !b a) l ≤ «计» (fun c => !e c) m
  | [], _, _, _, _ => Nat.zero_le _
  | a :: l, m, ⟨fresh, distinct⟩, matched, once => by
    have rest : ∀ {m' : List β}, (∀ a', a' ∈ l → b a' = false → ∃ c, c ∈ m' ∧ e c = false ∧ S a' c) →
        «计» (fun a => !b a) l ≤ «计» (fun c => !e c) m' := fun h =>
      count_le_of_matched distinct h (fun x y c mx my => once x y c (.tail a mx) (.tail a my))
    cases hb : b a with
    | true =>
      show cond (!b a) 1 0 + «计» (fun a => !b a) l ≤ _
      rw [hb]
      exact Nat.le_trans (Nat.le_of_eq (Nat.zero_add _))
        (rest fun a' m' f => matched a' (.tail a m') f)
    | false =>
      match matched a (.head l) hb with
      | ⟨c, mc, ec, sc⟩ => match splitAt mc with
        | ⟨p, q, split⟩ =>
          have inner : «计» (fun a => !b a) l ≤ «计» (fun c => !e c) (p ++ q) :=
            rest fun a' m' f => match matched a' (.tail a m') f with
              | ⟨c', mc', ec', sc'⟩ =>
                have other : ¬ c' = c := fun same =>
                  fresh (Eq.subst (motive := fun x => x ∈ l)
                    (once a' a c' (.tail a m') (.head l) sc'
                      (Eq.subst (motive := fun x => S a x) same.symm sc)) m')
                ⟨c', memRemove other (split ▸ mc'), ec', sc'⟩
          have whole : «计» (fun c => !e c) m = 1 + «计» (fun c => !e c) (p ++ q) := by
            rw [split, GrammarLaws.count_insert, ec]; rfl
          show cond (!b a) 1 0 + «计» (fun a => !b a) l ≤ _
          rw [hb, whole]
          exact Nat.add_le_add_left inner 1

end Lists

section Law

variable {α : Type u} {R E : «际» α}

/-- **The step form**, as the design states it (H1 at the list after; H2; H3; H4). -/
theorem step_form {b e : α → Bool} {before after : List α}
    (dA : Distinct after)
    (predecessorsBefore : ∀ x f, f ∈ after → «续» R E x f → x ∈ before)
    (fixedAfter : «定后» («续» R E))
    (begins : ∀ y, y ∈ after → (b y = true ↔ «生» R E y))
    (ends : ∀ x, x ∈ before → (e x = true ↔ «亡» R E x)) :
    after.length + «计» e before ≤ before.length + «计» b after :=
  have matched : «计» (fun a => !b a) after ≤ «计» (fun c => !e c) before :=
    match Nat.decLe («计» (fun a => !b a) after) («计» (fun c => !e c) before) with
    | .isTrue h => h
    | .isFalse beyond => absurd (fun all => beyond (count_le_of_matched
          (S := fun y x => «续» R E x y) dA all
          fun y y' x _ _ c c' => «定后之逐点».mp fixedAfter x y y' c c'))
        (notNotAll fun y my => fun none =>
          -- y has b y = false, so it does not begin: ¬¬ it has a predecessor
          (fun (nb : b y = false) =>
            have notBegins : ¬ «生» R E y := fun bg =>
              Bool.noConfusion (((begins y my).mpr bg).symm.trans nb)
            notBegins fun ⟨x, c⟩ => none fun _ =>
              ⟨x, predecessorsBefore x y my c,
               match he : e x with
               | false => rfl
               | true => absurd ⟨y, c⟩ ((ends x (predecessorsBefore x y my c)).mp he), c⟩)
          |> fun k => by
            cases hb : b y with
            | true => exact none fun f => Bool.noConfusion (hb.symm.trans f)
            | false => exact k hb)
  have splitA := count_add_not b after
  have splitB := count_add_not e before
  calc after.length + «计» e before
      = («计» b after + «计» (fun a => !b a) after) + «计» e before := by rw [splitA]
    _ ≤ («计» b after + «计» (fun c => !e c) before) + «计» e before :=
        Nat.add_le_add_right (Nat.add_le_add_left matched _) _
    _ = before.length + «计» b after := by
        rw [Nat.add_assoc, Nat.add_comm («计» (fun c => !e c) before), splitB, Nat.add_comm]

/-- Without H1 the step form fails: one unit before, the same successor listed twice after. -/
theorem step_needs_once :
    ¬ (∀ (R E : «际» Nat) (b e : Nat → Bool) (before after : List Nat),
      (∀ x f, f ∈ after → «续» R E x f → x ∈ before) → «定后» («续» R E) →
      (∀ y, y ∈ after → (b y = true ↔ «生» R E y)) →
      (∀ x, x ∈ before → (e x = true ↔ «亡» R E x)) →
      after.length + «计» e before ≤ before.length + «计» b after) := fun law =>
  have h := law (fun x y => x = 0 ∧ y = 1) (fun _ _ => True) (fun _ => false) (fun _ => false)
    [0] [1, 1]
    (fun x f _ c => match c.1.1 with | rfl => .head _)
    («定后之逐点».mpr fun _ _ _ c c' => c.1.2.trans c'.1.2.symm)
    (fun y my => ⟨fun h => Bool.noConfusion h, fun bg => absurd ⟨0, ⟨rfl, (match memCons my with
        | .inl s => s | .inr m => match memCons m with | .inl s => s | .inr m => nomatch m)⟩, trivial⟩ bg⟩)
    (fun x mx => ⟨fun h => Bool.noConfusion h, fun en => absurd ⟨1, ⟨(match memCons mx with
        | .inl s => s | .inr m => nomatch m), rfl⟩, trivial⟩ en⟩)
  absurd h (by decide)

/-- **The mirror, as the step form read backward.** Under `«定前»`, with every successor of a unit
before standing after (`«后者在后»`'s hypothesis), the units before with the beginnings after are at
most the units after with the endings before: the step form at the converse, with the lists
swapped. -/
theorem mirror_step_form {b e : α → Bool} {before after : List α}
    (dB : Distinct before)
    (successorsAfter : ∀ g y, g ∈ before → «续» R E g y → y ∈ after)
    (fixedBefore : «定前» («续» R E))
    (begins : ∀ y, y ∈ after → (b y = true ↔ «生» R E y))
    (ends : ∀ x, x ∈ before → (e x = true ↔ «亡» R E x)) :
    before.length + «计» b after ≤ after.length + «计» e before :=
  step_form (R := «逆» R) (E := «逆» E) (b := e) (e := b) (before := after) (after := before) dB
    (fun x f mf c => successorsAfter f x mf c)
    («定后之逐点».mpr fun x y z c c' => «定前之逐点».mp fixedBefore y z x c c')
    (fun y my => (ends y my).trans ⟨fun h ⟨x, c⟩ => h ⟨x, c⟩, fun h ⟨x, c⟩ => h ⟨x, c⟩⟩)
    (fun x mx => (begins x mx).trans ⟨fun h ⟨y, c⟩ => h ⟨y, c⟩, fun h ⟨y, c⟩ => h ⟨y, c⟩⟩)

end Law

/-! ## Counting from losing to gaining (copied from Change/Flow/Population for the scratch) -/

section Counting

theorem stepsLast (q : Nat → Nat) :
    ∀ T n, total (steps T (n + 1)) q = total (steps T n) q + q (T + n)
  | T, 0 => Nat.add_comm (q T) 0
  | T, n + 1 =>
    (congrArg (q T + ·) ((stepsLast q (T + 1) n).trans
      (congrArg (_ + ·) (congrArg q (Nat.add_right_comm T 1 n))))).trans
      (Nat.add_assoc _ _ _).symm

theorem stepsMono (q : Nat → Nat) (T n : Nat) :
    ∀ m, total (steps T n) q ≤ total (steps T (n + m)) q
  | 0 => Nat.le_refl _
  | m + 1 => Nat.le_trans (stepsMono q T n m)
      (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (stepsLast q T (n + m)).symm))

theorem stepsMem : ∀ {T n t : Nat}, t ∈ steps T n → T ≤ t
  | _, 0, _, mem => nomatch mem
  | _, _ + 1, _, .head _ => Nat.le_refl _
  | _, _ + 1, _, .tail _ mem => Nat.le_of_succ_le (stepsMem mem)

theorem accumulates {q : Nat → Nat} (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < q t)
    (N : Nat) : ∀ K, ∃ n, K ≤ total (steps N n) q
  | 0 => ⟨0, Nat.zero_le _⟩
  | K + 1 => match accumulates recurs N K with
    | ⟨n, many⟩ => match recurs (N + n) with
      | ⟨_, later, positive⟩ => match le_dest later with
        | ⟨m, same⟩ => ⟨n + m + 1, Nat.le_trans
            (Nat.add_le_add (Nat.le_trans many (stepsMono q N n m))
              (Nat.lt_of_lt_of_le positive
                (Nat.le_of_eq (congrArg q (same.trans (Nat.add_assoc N n m))))))
            (Nat.le_of_eq (stepsLast q N (n + m)).symm)⟩

theorem posOfExceeds {K X R : Nat} (many : K + 1 ≤ X) (within : X ≤ K + R) : 0 < R :=
  match R, within with
  | 0, within => absurd (Nat.le_trans many within) (Nat.not_succ_le_self K)
  | R + 1, _ => Nat.succ_pos R

theorem totalPos {q : Nat → Nat} : ∀ as : List Nat, 0 < total as q → ∃ a, a ∈ as ∧ 0 < q a
  | a :: as, pos => match h : q a with
    | 0 => match totalPos as (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        ((congrArg (· + total as q) h).trans (Nat.zero_add (total as q))))) with
      | ⟨b, mem, positive⟩ => ⟨b, .tail a mem, positive⟩
    | n + 1 => ⟨a, .head as, h ▸ Nat.succ_pos n⟩

/-- Losing without end, gaining without end, from step `T` on. -/
theorem gainingFrom {q x y : Nat → Nat} {T : Nat}
    (across : ∀ t, T ≤ t → q (t + 1) + x t ≤ q t + y t)
    (losing : ∀ N, ∃ t, N ≤ t ∧ 0 < x t) : ∀ N, ∃ t, N ≤ t ∧ 0 < y t :=
  fun N =>
    let M := N + T
    have across' : ∀ s, q (M + s + 1) + x (M + s) ≤ q (M + s) + y (M + s) := fun s =>
      across (M + s) (Nat.le_trans (Nat.le_add_left T N) (Nat.le_add_right _ _))
    -- le_over_stretch on the shifted functions
    have stretch := le_over_stretch (q := fun s => q (M + s)) (x := fun s => x (M + s))
      (y := fun s => y (M + s)) across' 0
    match accumulates (q := fun s => x (M + s))
        (fun K => match losing (M + K) with
          | ⟨t, later, pos⟩ => match le_dest later with
            | ⟨k, same⟩ => ⟨K + k, Nat.le_add_right K k,
                Eq.subst (motive := fun s => 0 < x s) (same.trans (Nat.add_assoc M K k)) pos⟩)
        0 (q M + 1) with
    | ⟨n, many⟩ =>
      match totalPos (steps 0 n) (posOfExceeds many
          (Nat.le_trans (Nat.le_add_left _ _)
            (Nat.le_trans (stretch n) (Nat.le_of_eq (congrArg (· + _) (congrArg q (Nat.add_zero M))))))) with
      | ⟨s, _, gained⟩ => ⟨M + s, Nat.le_trans (Nat.le_add_right N T) (Nat.le_add_right _ _), gained⟩

end Counting

section Run

variable {α : Type u} {R E : «际» α}

/-- **The run form.** From `T` on: H1 after each step, H2, H3, H4. Endings among the listed units
at arbitrarily late steps need beginnings among the units listed after a step at arbitrarily late
steps. -/
theorem run_form {b e : α → Bool} {u : Nat → List α} {T : Nat}
    (once : ∀ t, T ≤ t → Distinct (u (t + 1)))
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x f, f ∈ u (t + 1) → «续» R E x f → x ∈ u t)
    (fixedAfter : «定后» («续» R E))
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (ends : ∀ t, T ≤ t → ∀ x, x ∈ u t → (e x = true ↔ «亡» R E x))
    (ending : ∀ N, ∃ t, N ≤ t ∧ ∃ x, x ∈ u t ∧ «亡» R E x) :
    ∀ N, ∃ t, N ≤ t ∧ ∃ y, y ∈ u (t + 1) ∧ «生» R E y :=
  fun N =>
    match gainingFrom (T := T) (q := fun t => (u t).length) (x := fun t => «计» e (u t))
        (y := fun t => «计» b (u (t + 1)))
        (fun t from_ => step_form (once t from_) (predecessorsBefore t from_) fixedAfter
          (begins t from_) (ends t from_))
        (fun M => match ending (M + T) with
          | ⟨t, later, x, mx, en⟩ =>
            have from_ : T ≤ t := Nat.le_trans (Nat.le_add_left T M) later
            have ex : e x = true := (ends t from_ x mx).mpr en
            match splitAt mx with
            | ⟨p, q, split⟩ => ⟨t, Nat.le_trans (Nat.le_add_right M T) later, by
                show 0 < «计» e (u t)
                rw [split, GrammarLaws.count_insert, ex]
                exact Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_add_right _ _)⟩)
        (N + T) with
    | ⟨t, later, pos⟩ =>
      have from_ : T ≤ t := Nat.le_trans (Nat.le_add_left T N) later
      match GrammarLaws.split_of_count_pos pos with
      | ⟨b₁, y, b₂, split, by_⟩ =>
        have my : y ∈ u (t + 1) := split ▸ GrammarLaws.mem_middle y b₂ b₁
        ⟨t, Nat.le_trans (Nat.le_add_right N T) later, y, my, (begins t from_ y my).mp by_⟩

end Run

/-! ## The `Listed` case, with no decision of identity -/

section ListedCase

variable {α : Type} {p : α → Nat → Prop} [∀ a t, Decidable (p a t)]

/-- A copy of `Listed` (Population). -/
def Listed' (p : α → Nat → Prop) (l : Nat → List α) : Prop :=
  ∀ t, Distinct (l t) ∧ ∀ a, p a t ↔ a ∈ l t

/-- Occurrence relation: each member continuing only itself (the design's `R`). -/
def selfStep : «际» (Nat × α) := fun x y => y.1 = x.1 + 1 ∧ y.2 = x.2

/-- Both holding (the design's `E`). -/
def bothHold (p : α → Nat → Prop) : «际» (Nat × α) := fun x y => p x.2 x.1 ∧ p y.2 y.1

def occ (l : Nat → List α) (t : Nat) : List (Nat × α) := (l t).map fun a => (t, a)

theorem mem_map_pair {t : Nat} : ∀ {zs : List α} {y : Nat × α}, y ∈ zs.map (fun a => (t, a)) →
    y.1 = t ∧ y.2 ∈ zs
  | [], _, my => nomatch my
  | z :: zs, _, my => match memCons my with
    | .inl s => ⟨congrArg Prod.fst s, (congrArg Prod.snd s).symm ▸ .head _⟩
    | .inr m => match mem_map_pair m with | ⟨h1, h2⟩ => ⟨h1, .tail _ h2⟩

theorem mem_occ {l : Nat → List α} {t : Nat} {y : Nat × α} (my : y ∈ occ l t) :
    y.1 = t ∧ y.2 ∈ l t := mem_map_pair my

theorem pair_mem_map {t : Nat} {a : α} : ∀ {zs : List α}, a ∈ zs → (t, a) ∈ zs.map (fun a => (t, a))
  | [], m => nomatch m
  | z :: zs, m => match memCons m with
    | .inl s => s ▸ .head _
    | .inr m' => .tail _ (pair_mem_map m')

theorem occ_of_mem {l : Nat → List α} {t : Nat} {a : α} (m : a ∈ l t) : (t, a) ∈ occ l t :=
  pair_mem_map m

theorem distinct_map_pair {t : Nat} : ∀ {zs : List α}, Distinct zs → Distinct (zs.map (fun a => (t, a)))
  | [], _ => trivial
  | a :: as, ⟨fresh, d⟩ => ⟨fun m => fresh (mem_map_pair m).2, distinct_map_pair d⟩

theorem distinct_occ {l : Nat → List α} {t : Nat} (d : Distinct (l t)) : Distinct (occ l t) :=
  distinct_map_pair d

theorem fixed_selfStep : «定后» («续» (selfStep (α := α)) (bothHold p)) :=
  «定后之逐点».mpr fun x y z c c' => by
    obtain ⟨⟨h1, h2⟩, _⟩ := c
    obtain ⟨⟨h1', h2'⟩, _⟩ := c'
    obtain ⟨y1, y2⟩ := y
    obtain ⟨z1, z2⟩ := z
    dsimp only at h1 h2 h1' h2'
    subst h1; subst h2; subst h1'; subst h2'; rfl

theorem begins_iff {t : Nat} {a : α} (holds : p a (t + 1)) :
    «生» selfStep (bothHold p) (t + 1, a) ↔ ¬ p a t :=
  ⟨fun bg was => bg ⟨(t, a), ⟨⟨rfl, rfl⟩, was, holds⟩⟩,
   fun not ⟨(s, c), ⟨h1, h2⟩, hx, _⟩ => not (by
     have e1 : t = s := Nat.succ.inj h1
     have e2 : a = c := h2
     subst e1; subst e2; exact hx)⟩

theorem ends_iff {t : Nat} {a : α} (holds : p a t) :
    «亡» selfStep (bothHold p) (t, a) ↔ ¬ p a (t + 1) :=
  ⟨fun en next => en ⟨(t + 1, a), ⟨⟨rfl, rfl⟩, holds, next⟩⟩,
   fun not ⟨(s, c), ⟨h1, h2⟩, _, hy⟩ => not (by
     have e1 : s = t + 1 := h1
     have e2 : c = a := h2
     subst e1; subst e2; exact hy)⟩

/-- The beginnings' test: an occurrence after step `t` begins where the member failed at `t`. -/
def beginTest (p : α → Nat → Prop) [∀ a t, Decidable (p a t)] : Nat × α → Bool
  | (0, _) => true
  | (t + 1, a) => !decide (p a t)

theorem bool_iff_not {q : Prop} [Decidable q] : (!decide q) = true ↔ ¬ q := by
  cases h : decide q with
  | true => exact ⟨fun f => Bool.noConfusion f, fun n => absurd (of_decide_eq_true h) n⟩
  | false => exact ⟨fun _ => of_decide_eq_false h, fun _ => rfl⟩

/-- `Listed.coming_of_ceasing`, re-proved through the run form, with no `DecidableEq α`. -/
theorem coming_of_ceasing' {l : Nat → List α} (listed : Listed' p l)
    (ceasing : ∀ N, ∃ t a, N ≤ t ∧ p a t ∧ ¬ p a (t + 1)) :
    ∀ N, ∃ t a, N ≤ t ∧ ¬ p a t ∧ p a (t + 1) :=
  fun N =>
    match run_form (R := selfStep) (E := bothHold p) (u := occ l) (T := 0)
        (b := beginTest p) (e := fun x => !decide (p x.2 (x.1 + 1)))
        (fun t _ => distinct_occ (listed (t + 1)).1)
        (fun t _ x f mf c => by
          obtain ⟨h1, h2⟩ := mem_occ mf
          obtain ⟨⟨e1, e2⟩, hx, _⟩ := c
          obtain ⟨s, c₀⟩ := x
          obtain ⟨t', a⟩ := f
          dsimp only at h1 h2 e1 e2 hx
          subst h1
          have es : s = t := (Nat.succ.inj e1).symm
          subst es; subst e2
          exact occ_of_mem (((listed s).2 a).mp hx))
        fixed_selfStep
        (fun t _ y my => by
          obtain ⟨h1, h2⟩ := mem_occ my
          obtain ⟨t', a⟩ := y
          dsimp only at h1 h2
          subst h1
          have holds : p a (t + 1) := ((listed (t + 1)).2 a).mpr h2
          refine Iff.trans ?_ (begins_iff holds).symm
          show (!decide (p a t)) = true ↔ ¬ p a t
          exact bool_iff_not)
        (fun t _ x mx => by
          obtain ⟨h1, h2⟩ := mem_occ mx
          obtain ⟨t', a⟩ := x
          dsimp only at h1 h2
          subst h1
          have holds : p a t' := ((listed t').2 a).mpr h2
          exact bool_iff_not.trans (ends_iff holds).symm)
        (fun M => match ceasing M with
          | ⟨t, a, later, held, gone⟩ =>
            ⟨t, later, (t, a), occ_of_mem (((listed t).2 a).mp held), (ends_iff held).mpr gone⟩)
        N with
    | ⟨t, later, y, my, bg⟩ => by
        obtain ⟨h1, h2⟩ := mem_occ my
        obtain ⟨t', a⟩ := y
        dsimp only at h1 h2
        subst h1
        have holds : p a (t + 1) := ((listed (t + 1)).2 a).mpr h2
        exact ⟨t, a, later, (begins_iff holds).mp bg, holds⟩

end ListedCase

end U4cReview
end Becoming

#print axioms Becoming.U4cReview.step_form
#print axioms Becoming.U4cReview.step_needs_once
#print axioms Becoming.U4cReview.run_form
#print axioms Becoming.U4cReview.coming_of_ceasing'
#print axioms Becoming.U4cReview.mirror_step_form
#print axioms of_decide_eq_false
#print axioms Becoming.U4cReview.fixed_selfStep
#print axioms Becoming.U4cReview.begins_iff
#print axioms Becoming.U4cReview.ends_iff
#print axioms Becoming.U4cReview.bool_iff_not
#print axioms Becoming.U4cReview.mem_occ
#print axioms Becoming.U4cReview.distinct_occ
