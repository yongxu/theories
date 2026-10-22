import Becoming.Gated

/-!
# Copying: reproducing a sequence token by token from a shared pool

A copy reads a template in order and, for each token, attaches a matching component taken from
a pool, drawing support for the attachment. This module states, for every alphabet with
decidable equality and every law of draws, when such a copy completes, what a copy reading
through contacts reproduces, what inspection against a reference does to the product, and what
repeated doubling draws. The constructed copy machines of the periphery are instances
(`CopyingInstances`).

* **Exact copying.** A pool supplies a word where it holds every token at least as often as the
  word uses it (`Supplies`, a condition on each token's count). A copy of a word completes
  exactly when the pool supplies the word and the support covers what its attachments draw
  (`completes_iff`), and its product is then the word (`built_iff`); it then holds the word,
  the pool without it, and the support less what was drawn (`copies`). It leaves nothing in the
  pool exactly when the pool holds each token exactly as often as the word uses it and the support
  covers the draws (`empties_iff`). With `r` left over to
  release the product, exactly when the support covers the draws and `r` (`releases_iff`). A stalled copy stays where it stalled
  (`steps_fixed`).
* **Copies from one shared pool.** Copying words in turn from one pool and support, every copy
  is released exactly when the pool supplies all the words together and the support covers all
  their draws and releases (`batch_all_iff`); exchanging adjacent words, and so any
  reordering, leaves this as it was (`batch_all_swap`), though which copies are released can
  change. The pool supplies one word followed by another exactly when it supplies the first and
  its remainder the second (`supplies_append_iff`). A **lineage**, one word copied `n` times in
  turn, is released copy by copy exactly when the pool holds each token at least `n` times as
  often as the word uses it and the support covers `n` times the word's draws and release
  (`lineage_all_iff`).
* **Local draws.** Where the first attachment draws `first` and each further one `same` after
  a like token and `differ` after an unlike one (`pairDraw`), a word's use of support depends
  on the law only through its number of unlike adjacent pairs (`use_word`). So among words of
  one length, uses are in arithmetic progression where the unlike pairs are (`use_midpoint`),
  and the word with more unlike pairs draws less exactly when an unlike attachment draws less
  (`use_lt_iff`).
* **Reading through contacts.** A copy that attaches at each site what a reading `read` gives
  there reproduces a word exactly when every site reads the word's token, the pool supplies the
  word and the support covers what it draws (`reading_iff`). Its product only grows
  (`readSteps_extends`).
* **The product only grows.** For every process, an output extended by every step is extended
  along every course, and conversely (`extends_along_iff`).
* **Inspection against a reference.** Inspecting a site and exchanging its token for the
  reference's never increases the defects against a template, for every product, pool and
  support, exactly when the reference agrees with the template at that site (`inspect_le_iff`);
  every scan of such sites never increases them (`scan_le`). At a defective site, the
  inspection leaves the reference's token exactly when the pool holds it and the support covers
  both draws (`inspect_matches_iff`). A product of the template's length has no defect
  exactly when it is the template (`defects_zero_iff`). An exchange keeps the count of every
  token across product and pool (`exchange_keeps_counts`).
* **Doubling.** Where every unit draws `d` from one stock and becomes two, `n` rounds from `k`
  units run exactly when the stock covers `d * required n k`, and end with `k * 2 ^ n` units
  (`doubling_iff`), where `required n k + k = k * 2 ^ n` (`required_add`).

No premise is added; the module imports only the core and every declaration has an empty axiom
report.
-/

namespace Becoming.Copying

open Generative

universe u v w

/-! ## Arithmetic and lists -/

/-- What two draws need together is what the first needs and what the second needs from what
the first leaves. -/
theorem add_le_iff {a b n : Nat} : a + b ≤ n ↔ a ≤ n ∧ b ≤ n - a :=
  ⟨fun h => ⟨Nat.le_trans (Nat.le_add_right a b) h, Naturals.le_sub_of_add_le h⟩,
   fun ⟨le, h⟩ => Nat.le_trans (Nat.add_le_add_left h a) (Nat.le_of_eq (add_sub_of_le le))⟩

/-- What holds of both branches holds of the choice. -/
theorem ite_cases {β : Sort v} {c : Prop} [inst : Decidable c] {a b : β} (P : β → Prop)
    (pos : c → P a) (neg : ¬ c → P b) : P (if c then a else b) :=
  match inst with
  | isTrue h => pos h
  | isFalse h => neg h

section Lists

variable {β : Type u}

theorem append_cancel : ∀ (l : List β) {a b : List β}, l ++ a = l ++ b → a = b
  | [], _, _, h => h
  | _ :: xs, _, _, h => append_cancel xs (List.cons.inj h).2

theorem ne_append_cons (l : List β) (x : β) (xs : List β) : l ≠ l ++ x :: xs :=
  fun same => nomatch append_cancel l ((ListTests.append_nil l).trans same)

/-- The list with the token at site `i` replaced by `x`. -/
def setAt : List β → Nat → β → List β
  | [], _, _ => []
  | _ :: xs, 0, x => x :: xs
  | y :: xs, i + 1, x => y :: setAt xs i x

/-- The last token, if any. -/
def final : List β → Option β
  | [] => none
  | [x] => some x
  | _ :: y :: rest => final (y :: rest)

theorem nth_setAt_self : ∀ (b : List β) (i : Nat) {old : β} (x : β),
    nth b i = some old → nth (setAt b i x) i = some x
  | [], _, _, _, h => nomatch h
  | _ :: _, 0, _, _, _ => rfl
  | _ :: xs, i + 1, _, x, h => nth_setAt_self xs i x h

end Lists

/-! ## The product only grows -/

section Extends

variable {β : Type u} {S : Type v} {A : Type w}

/-- Every step extends the output: what stood stays as a prefix. -/
def Extends (P : Process S A) (out : S → List β) : Prop :=
  ∀ s a t, P.step s a t → ∃ tail, out t = out s ++ tail

theorem extends_along {P : Process S A} {out : S → List β} (ext : Extends P out) :
    ∀ {s t : S} {plan : List A}, Trace P s plan t → ∃ tail, out t = out s ++ tail
  | _, _, [], .nil s => ⟨[], (ListTests.append_nil (out s)).symm⟩
  | _, _, _ :: _, .cons step tail =>
    match ext _ _ _ step, extends_along ext tail with
    | ⟨first, h1⟩, ⟨rest, h2⟩ =>
      ⟨first ++ rest, h2.trans ((congrArg (· ++ rest) h1).trans (ListTests.append_assoc _ _ _))⟩

/-- **An output is extended along every course exactly when every step extends it.** -/
theorem extends_along_iff {P : Process S A} {out : S → List β} :
    (∀ s plan t, Trace P s plan t → ∃ tail, out t = out s ++ tail) ↔ Extends P out :=
  ⟨fun along s a t step => along s [a] t (.cons step (.nil t)),
   fun ext _ _ _ path => extends_along ext path⟩

end Extends

/-! ## Pools -/

section Pool

variable {α : Type u} [DecidableEq α]

/-- How many copies of `a` a list holds. -/
def countOf (a : α) : List α → Nat
  | [] => 0
  | x :: xs => if x = a then countOf a xs + 1 else countOf a xs

/-- The list with its first copy of `a` taken out, if it holds one. -/
def remove (a : α) : List α → List α
  | [] => []
  | x :: xs => if x = a then xs else x :: remove a xs

/-- The pool supplies the word: it holds every token at least as often as the word uses it. -/
def Supplies (word pool : List α) : Prop := ∀ a, countOf a word ≤ countOf a pool

theorem countOf_self (a : α) (xs : List α) : countOf a (a :: xs) = countOf a xs + 1 :=
  if_pos rfl

theorem countOf_other {a x : α} (ne : x ≠ a) (xs : List α) : countOf a (x :: xs) = countOf a xs :=
  if_neg ne

theorem countOf_append (a : α) : ∀ (l m : List α), countOf a (l ++ m) = countOf a l + countOf a m
  | [], m => (Nat.zero_add _).symm
  | x :: xs, m =>
    match decEq x a with
    | isTrue e => by
      show (if x = a then countOf a (xs ++ m) + 1 else countOf a (xs ++ m)) =
        (if x = a then countOf a xs + 1 else countOf a xs) + countOf a m
      rw [if_pos e, if_pos e, countOf_append a xs m, Nat.add_right_comm]
    | isFalse ne => by
      show (if x = a then countOf a (xs ++ m) + 1 else countOf a (xs ++ m)) =
        (if x = a then countOf a xs + 1 else countOf a xs) + countOf a m
      rw [if_neg ne, if_neg ne, countOf_append a xs m]

theorem countOf_remove_self (a : α) : ∀ pool : List α, 0 < countOf a pool →
    countOf a (remove a pool) + 1 = countOf a pool
  | [], pos => absurd pos (Nat.lt_irrefl 0)
  | x :: xs, pos =>
    match decEq x a with
    | isTrue e => by
      show countOf a (if x = a then xs else x :: remove a xs) + 1 =
        (if x = a then countOf a xs + 1 else countOf a xs)
      rw [if_pos e, if_pos e]
    | isFalse ne => by
      have pos' : 0 < countOf a xs := by rw [countOf_other ne] at pos; exact pos
      show countOf a (if x = a then xs else x :: remove a xs) + 1 =
        (if x = a then countOf a xs + 1 else countOf a xs)
      rw [if_neg ne, if_neg ne, countOf_other ne]
      exact countOf_remove_self a xs pos'

theorem countOf_remove_other {a b : α} (ne : a ≠ b) : ∀ pool : List α,
    countOf b (remove a pool) = countOf b pool
  | [] => rfl
  | x :: xs =>
    match decEq x a with
    | isTrue e => by
      have xb : x ≠ b := fun h => ne (e.symm.trans h)
      show countOf b (if x = a then xs else x :: remove a xs) = countOf b (x :: xs)
      rw [if_pos e, countOf_other xb]
    | isFalse nx => by
      show countOf b (if x = a then xs else x :: remove a xs) =
        (if x = b then countOf b xs + 1 else countOf b xs)
      rw [if_neg nx]
      show (if x = b then countOf b (remove a xs) + 1 else countOf b (remove a xs)) = _
      rw [countOf_remove_other ne xs]

theorem supplies_nil (pool : List α) : Supplies [] pool := fun _ => Nat.zero_le _

theorem pos_of_supplies {x : α} {xs pool : List α} (s : Supplies (x :: xs) pool) :
    0 < countOf x pool :=
  Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.succ_pos _) (Nat.le_of_eq (countOf_self x xs).symm))
    (s x)

/-- **Taking a supplied token.** The pool supplies `x :: xs` exactly when it holds `x` and what
is left once `x` is taken supplies `xs`. -/
theorem supplies_cons_iff {x : α} {xs pool : List α} :
    Supplies (x :: xs) pool ↔ 0 < countOf x pool ∧ Supplies xs (remove x pool) :=
  ⟨fun s => ⟨pos_of_supplies s, fun a =>
    match decEq x a with
    | isTrue e => by
      cases e
      have h := s x
      rw [countOf_self, ← countOf_remove_self x pool (pos_of_supplies s)] at h
      exact Nat.le_of_succ_le_succ h
    | isFalse ne => by
      have h := s a
      rw [countOf_other ne, ← countOf_remove_other ne pool] at h
      exact h⟩,
   fun ⟨pos, s⟩ a =>
    match decEq x a with
    | isTrue e => by
      cases e
      rw [countOf_self, ← countOf_remove_self x pool pos]
      exact Nat.succ_le_succ (s x)
    | isFalse ne => by
      rw [countOf_other ne, ← countOf_remove_other ne pool]
      exact s a⟩

/-! ## Exact copying -/

/-- A copy in progress: the token last attached, the tokens still to attach, the product, the
pool, and the support free and used. -/
structure Scan (α : Type u) where
  previous : Option α
  pending : List α
  built : List α
  pool : List α
  free : Nat
  used : Nat

variable (draw : Option α → α → Nat)

/-- One move of the copy: the next pending token is attached where the pool holds it and the
free support covers what it draws after the token last attached; otherwise nothing changes. -/
def tick (s : Scan α) : Scan α :=
  match s.pending with
  | [] => s
  | x :: xs =>
    if 0 < countOf x s.pool ∧ draw s.previous x ≤ s.free then
      ⟨some x, xs, s.built ++ [x], remove x s.pool, s.free - draw s.previous x,
        s.used + draw s.previous x⟩
    else s

/-- `n` moves of the copy. -/
def steps : Nat → Scan α → Scan α
  | 0, s => s
  | n + 1, s => steps n (tick draw s)

/-- What a word's attachments draw in all, after the token `previous`. -/
def use : Option α → List α → Nat
  | _, [] => 0
  | p, x :: xs => draw p x + use (some x) xs

/-- The token last attached after attaching a word. -/
def lastOr : Option α → List α → Option α
  | p, [] => p
  | _, x :: xs => lastOr (some x) xs

/-- The pool once each token of a word is taken in turn. -/
def removeAll : List α → List α → List α
  | [], pool => pool
  | x :: xs, pool => removeAll xs (remove x pool)

theorem tick_cons (prev : Option α) (x : α) (xs built pool : List α) (free used : Nat) :
    tick draw ⟨prev, x :: xs, built, pool, free, used⟩ =
      if 0 < countOf x pool ∧ draw prev x ≤ free then
        ⟨some x, xs, built ++ [x], remove x pool, free - draw prev x, used + draw prev x⟩
      else ⟨prev, x :: xs, built, pool, free, used⟩ := rfl

/-- **A stalled copy stays where it stalled.** -/
theorem steps_fixed {s : Scan α} (fixed : tick draw s = s) : ∀ n, steps draw n s = s
  | 0 => rfl
  | n + 1 => (congrArg (steps draw n) fixed).trans (steps_fixed fixed n)

/-- **A supplied and covered copy completes**: it holds the word, the pool without it, and the
support less what was drawn. -/
theorem copies : ∀ (prev : Option α) (built word pool : List α) (free used : Nat),
    Supplies word pool → use draw prev word ≤ free →
      steps draw word.length ⟨prev, word, built, pool, free, used⟩ =
        ⟨lastOr prev word, [], built ++ word, removeAll word pool,
          free - use draw prev word, used + use draw prev word⟩
  | prev, built, [], pool, free, used, _, _ => by
    exact congrArg (fun l => (⟨prev, [], l, pool, free, used⟩ : Scan α)) (ListTests.append_nil built).symm
  | prev, built, x :: xs, pool, free, used, supplies, covered => by
    have ⟨pos, rest⟩ := supplies_cons_iff.mp supplies
    have ⟨first, more⟩ := add_le_iff.mp
      (show draw prev x + use draw (some x) xs ≤ free from covered)
    show steps draw xs.length (tick draw ⟨prev, x :: xs, built, pool, free, used⟩) = _
    rw [tick_cons, if_pos ⟨pos, first⟩,
      copies (some x) (built ++ [x]) xs (remove x pool) _ _ rest more,
      ListTests.append_assoc, Naturals.sub_sub, Nat.add_assoc]
    all_goals rfl

/-- A completed copy was supplied and covered. -/
theorem supplied_of_completes : ∀ (prev : Option α) (built word pool : List α) (free used : Nat),
    (steps draw word.length ⟨prev, word, built, pool, free, used⟩).pending = [] →
      Supplies word pool ∧ use draw prev word ≤ free
  | _, _, [], pool, free, _, _ => ⟨supplies_nil pool, Nat.zero_le free⟩
  | prev, built, x :: xs, pool, free, used, done => by
    have done' : (steps draw xs.length
        (tick draw ⟨prev, x :: xs, built, pool, free, used⟩)).pending = [] := done
    match Nat.decLt 0 (countOf x pool), Nat.decLe (draw prev x) free with
    | isTrue pos, isTrue first =>
      rw [tick_cons, if_pos ⟨pos, first⟩] at done'
      have ⟨rest, more⟩ := supplied_of_completes (some x) (built ++ [x]) xs _ _ _ done'
      exact ⟨supplies_cons_iff.mpr ⟨pos, rest⟩, add_le_iff.mpr ⟨first, more⟩⟩
    | isFalse absent, _ =>
      have fixed : tick draw ⟨prev, x :: xs, built, pool, free, used⟩ =
          ⟨prev, x :: xs, built, pool, free, used⟩ :=
        (tick_cons draw prev x xs built pool free used).trans (if_neg fun h => absent h.1)
      rw [fixed, steps_fixed draw fixed] at done'
      exact nomatch done'
    | isTrue _, isFalse over =>
      have fixed : tick draw ⟨prev, x :: xs, built, pool, free, used⟩ =
          ⟨prev, x :: xs, built, pool, free, used⟩ :=
        (tick_cons draw prev x xs built pool free used).trans (if_neg fun h => over h.2)
      rw [fixed, steps_fixed draw fixed] at done'
      exact nomatch done'

/-- **Exact copying.** A copy of a word completes exactly when the pool supplies the word and
the support covers what its attachments draw. -/
theorem completes_iff (prev : Option α) (built word pool : List α) (free used : Nat) :
    (steps draw word.length ⟨prev, word, built, pool, free, used⟩).pending = [] ↔
      Supplies word pool ∧ use draw prev word ≤ free :=
  ⟨supplied_of_completes draw prev built word pool free used,
   fun ⟨supplies, covered⟩ =>
    (congrArg Scan.pending (copies draw prev built word pool free used supplies covered)).trans rfl⟩

/-- **The product is the word exactly when the copy is supplied and covered.** -/
theorem built_iff : ∀ (prev : Option α) (built word pool : List α) (free used : Nat),
    (steps draw word.length ⟨prev, word, built, pool, free, used⟩).built = built ++ word ↔
      Supplies word pool ∧ use draw prev word ≤ free
  | _, _, [], pool, free, _ =>
    ⟨fun _ => ⟨supplies_nil pool, Nat.zero_le free⟩, fun _ => (ListTests.append_nil _).symm⟩
  | prev, built, x :: xs, pool, free, used =>
    ⟨fun done => by
      have done' : (steps draw xs.length
          (tick draw ⟨prev, x :: xs, built, pool, free, used⟩)).built = built ++ x :: xs := done
      match Nat.decLt 0 (countOf x pool), Nat.decLe (draw prev x) free with
      | isTrue pos, isTrue first =>
        rw [tick_cons, if_pos ⟨pos, first⟩] at done'
        have ⟨rest, more⟩ := (built_iff (some x) (built ++ [x]) xs _ _ _).mp
          (done'.trans (ListTests.append_assoc built [x] xs).symm)
        exact ⟨supplies_cons_iff.mpr ⟨pos, rest⟩, add_le_iff.mpr ⟨first, more⟩⟩
      | isFalse absent, _ =>
        have fixed : tick draw ⟨prev, x :: xs, built, pool, free, used⟩ =
            ⟨prev, x :: xs, built, pool, free, used⟩ :=
          (tick_cons draw prev x xs built pool free used).trans (if_neg fun h => absent h.1)
        rw [fixed, steps_fixed draw fixed] at done'
        exact absurd done' (ne_append_cons built x xs)
      | isTrue _, isFalse over =>
        have fixed : tick draw ⟨prev, x :: xs, built, pool, free, used⟩ =
            ⟨prev, x :: xs, built, pool, free, used⟩ :=
          (tick_cons draw prev x xs built pool free used).trans (if_neg fun h => over h.2)
        rw [fixed, steps_fixed draw fixed] at done'
        exact absurd done' (ne_append_cons built x xs),
     fun ⟨supplies, covered⟩ =>
      congrArg Scan.built (copies draw prev built (x :: xs) pool free used supplies covered)⟩

/-- **Exact copying with release.** A copy completes with `r` free to release it exactly when
the pool supplies the word and the support covers its draws and `r`. -/
theorem releases_iff (r : Nat) (prev : Option α) (built word pool : List α) (free used : Nat) :
    ((steps draw word.length ⟨prev, word, built, pool, free, used⟩).pending = [] ∧
        r ≤ (steps draw word.length ⟨prev, word, built, pool, free, used⟩).free) ↔
      Supplies word pool ∧ use draw prev word + r ≤ free :=
  ⟨fun ⟨done, left⟩ =>
    have ⟨supplies, covered⟩ := supplied_of_completes draw prev built word pool free used done
    have left' : r ≤ free - use draw prev word := by
      rw [copies draw prev built word pool free used supplies covered] at left
      exact left
    ⟨supplies, add_le_iff.mpr ⟨covered, left'⟩⟩,
   fun ⟨supplies, covered⟩ =>
    have ⟨within, left⟩ := add_le_iff.mp covered
    by
      rw [copies draw prev built word pool free used supplies within]
      exact ⟨rfl, left⟩⟩

/-- What the pool holds of each token once a supplied word is taken, with what the word used. -/
theorem countOf_removeAll : ∀ (word pool : List α), Supplies word pool →
    ∀ a, countOf a (removeAll word pool) + countOf a word = countOf a pool
  | [], _, _, _ => rfl
  | x :: xs, pool, supplies, a => by
    have ⟨pos, rest⟩ := supplies_cons_iff.mp supplies
    have taken := countOf_removeAll xs (remove x pool) rest a
    show countOf a (removeAll xs (remove x pool)) + countOf a (x :: xs) = countOf a pool
    match decEq x a with
    | isTrue e =>
      cases e
      rw [countOf_self, ← Nat.add_assoc, taken, countOf_remove_self x pool pos]
    | isFalse ne =>
      rw [countOf_other ne, taken, countOf_remove_other ne pool]

/-- A list is empty exactly when it holds no token. -/
theorem nil_iff_countOf_zero : ∀ l : List α, l = [] ↔ ∀ a, countOf a l = 0
  | [] => ⟨fun _ _ => rfl, fun _ => rfl⟩
  | x :: xs => ⟨fun empty => (nomatch empty),
      fun none => Nat.noConfusion ((countOf_self x xs).symm.trans (none x))⟩

/-- **Exact copying that empties the pool.** A copy of a word completes with nothing left in the
pool exactly when the pool holds each token exactly as often as the word uses it and the support
covers what its attachments draw. -/
theorem empties_iff (prev : Option α) (built word pool : List α) (free used : Nat) :
    ((steps draw word.length ⟨prev, word, built, pool, free, used⟩).pending = [] ∧
        (steps draw word.length ⟨prev, word, built, pool, free, used⟩).pool = []) ↔
      (∀ a, countOf a word = countOf a pool) ∧ use draw prev word ≤ free :=
  ⟨fun ⟨done, empty⟩ =>
    have ⟨supplies, covered⟩ := supplied_of_completes draw prev built word pool free used done
    have left : removeAll word pool = [] :=
      (congrArg Scan.pool (copies draw prev built word pool free used supplies covered)).symm.trans empty
    ⟨fun a => (Nat.zero_add _).symm.trans
        (Eq.subst (motive := fun c => c + countOf a word = countOf a pool)
          ((nil_iff_countOf_zero _).mp left a) (countOf_removeAll word pool supplies a)),
      covered⟩,
   fun ⟨same, covered⟩ =>
    have supplies : Supplies word pool := fun a => Nat.le_of_eq (same a)
    have done := copies draw prev built word pool free used supplies covered
    ⟨congrArg Scan.pending done,
     (congrArg Scan.pool done).trans ((nil_iff_countOf_zero _).mpr fun a =>
        add_right_cancel (countOf a word)
          ((countOf_removeAll word pool supplies a).trans ((same a).symm.trans (Nat.zero_add _).symm)))⟩⟩

/-! ## Copies from one shared pool -/

/-- The words joined in order. -/
def joinAll : List (List α) → List α
  | [] => []
  | w :: ws => w ++ joinAll ws

/-- What the words need in all. -/
def totalOf (f : List α → Nat) : List (List α) → Nat
  | [] => 0
  | w :: ws => f w + totalOf f ws

/-- Every flag is raised. -/
def Every : List Bool → Prop
  | [] => True
  | b :: bs => b = true ∧ Every bs

/-- **What a word followed by another needs.** The pool supplies `w ++ v` exactly when it supplies
`w` and what is left once `w` is taken supplies `v`. -/
theorem supplies_append_iff : ∀ (w v pool : List α),
    Supplies (w ++ v) pool ↔ Supplies w pool ∧ Supplies v (removeAll w pool)
  | [], _, pool => ⟨fun s => ⟨supplies_nil pool, s⟩, fun ⟨_, s⟩ => s⟩
  | x :: w, v, pool =>
    supplies_cons_iff.trans
      ⟨fun ⟨pos, s⟩ =>
        have ⟨s1, s2⟩ := (supplies_append_iff w v (remove x pool)).mp s
        ⟨supplies_cons_iff.mpr ⟨pos, s1⟩, s2⟩,
       fun ⟨s1, s2⟩ =>
        have ⟨pos, s1'⟩ := supplies_cons_iff.mp s1
        ⟨pos, (supplies_append_iff w v (remove x pool)).mpr ⟨s1', s2⟩⟩⟩

/-- The copy `t` is complete with `r` free to release it. -/
def released (r : Nat) (t : Scan α) : Bool :=
  match t.pending with
  | [] => decide (r ≤ t.free)
  | _ :: _ => false

omit [DecidableEq α] in
theorem released_iff (r : Nat) : ∀ t : Scan α, released r t = true ↔ t.pending = [] ∧ r ≤ t.free
  | ⟨_, [], _, _, _, _⟩ => ⟨fun h => ⟨rfl, of_decide_eq_true h⟩, fun ⟨_, le⟩ => decide_eq_true le⟩
  | ⟨_, _ :: _, _, _, _, _⟩ => ⟨fun h => (nomatch h), fun ⟨h, _⟩ => (nomatch h)⟩

/-- Copy the words in turn from one shared pool and support, each from no previous token onto an
empty product. A copy complete with `r` free is released, drawing `r`; one that is not keeps what
it drew. The flags say which copies were released. -/
def batch (r : Nat) : List (List α) → List α → Nat → Nat → List Bool × List α × Nat × Nat
  | [], pool, free, used => ([], pool, free, used)
  | w :: ws, pool, free, used =>
    let t := steps draw w.length ⟨none, w, [], pool, free, used⟩
    let ok := released r t
    let rest := batch r ws t.pool (cond ok (t.free - r) t.free) (cond ok (t.used + r) t.used)
    (ok :: rest.1, rest.2)

/-- **Copies from one shared pool.** Every copy of the batch is released exactly when the pool
supplies all the words together and the support covers all their draws and releases. The
order of the words does not matter for this. -/
theorem batch_all_iff (r : Nat) : ∀ (words : List (List α)) (pool : List α) (free used : Nat),
    Every (batch draw r words pool free used).1 ↔
      Supplies (joinAll words) pool ∧ totalOf (fun w => use draw none w + r) words ≤ free
  | [], pool, free, _ => ⟨fun _ => ⟨supplies_nil pool, Nat.zero_le free⟩, fun _ => trivial⟩
  | w :: ws, pool, free, used => by
    show (released r (steps draw w.length ⟨none, w, [], pool, free, used⟩) = true ∧
        Every (batch draw r ws (steps draw w.length ⟨none, w, [], pool, free, used⟩).pool
          (cond (released r (steps draw w.length ⟨none, w, [], pool, free, used⟩))
            ((steps draw w.length ⟨none, w, [], pool, free, used⟩).free - r)
            (steps draw w.length ⟨none, w, [], pool, free, used⟩).free)
          (cond (released r (steps draw w.length ⟨none, w, [], pool, free, used⟩))
            ((steps draw w.length ⟨none, w, [], pool, free, used⟩).used + r)
            (steps draw w.length ⟨none, w, [], pool, free, used⟩).used)).1) ↔
      Supplies (w ++ joinAll ws) pool ∧
        (use draw none w + r) + totalOf (fun w => use draw none w + r) ws ≤ free
    match h : released r (steps draw w.length ⟨none, w, [], pool, free, used⟩) with
    | true =>
      have ⟨supplies, covered⟩ := (releases_iff draw r none [] w pool free used).mp
        ((released_iff r _).mp h)
      have within := (add_le_iff.mp covered).1
      rw [copies draw none [] w pool free used supplies within]
      have ih := batch_all_iff r ws (removeAll w pool) (free - use draw none w - r)
        (used + use draw none w + r)
      exact ⟨fun ⟨_, every⟩ =>
          have ⟨s2, t2⟩ := ih.mp every
          ⟨(supplies_append_iff w (joinAll ws) pool).mpr ⟨supplies, s2⟩,
            add_le_iff.mpr ⟨covered, Nat.le_trans t2 (Nat.le_of_eq (Naturals.sub_sub _ _ _))⟩⟩,
        fun ⟨s, total⟩ =>
          have s2 := ((supplies_append_iff w (joinAll ws) pool).mp s).2
          have t2 := (add_le_iff.mp total).2
          ⟨rfl, ih.mpr ⟨s2, Nat.le_trans t2 (Nat.le_of_eq (Naturals.sub_sub _ _ _).symm)⟩⟩⟩
    | false =>
      exact ⟨fun ⟨ok, _⟩ => (nomatch ok), fun ⟨s, total⟩ =>
        have s1 := ((supplies_append_iff w (joinAll ws) pool).mp s).1
        have covered := (add_le_iff.mp total).1
        have done := (released_iff r _).mpr
          ((releases_iff draw r none [] w pool free used).mpr ⟨s1, covered⟩)
        nomatch h.symm.trans done⟩

theorem countOf_joinAll_swap (a : α) (u v : List α) (post : List (List α)) :
    ∀ pre : List (List α),
      countOf a (joinAll (pre ++ u :: v :: post)) = countOf a (joinAll (pre ++ v :: u :: post))
  | [] => by
    show countOf a (u ++ (v ++ joinAll post)) = countOf a (v ++ (u ++ joinAll post))
    rw [countOf_append, countOf_append, countOf_append, countOf_append, Nat.add_left_comm]
  | w :: pre => by
    show countOf a (w ++ joinAll (pre ++ u :: v :: post)) =
      countOf a (w ++ joinAll (pre ++ v :: u :: post))
    rw [countOf_append, countOf_append, countOf_joinAll_swap a u v post pre]

omit [DecidableEq α] in
theorem totalOf_swap (f : List α → Nat) (u v : List α) (post : List (List α)) :
    ∀ pre : List (List α), totalOf f (pre ++ u :: v :: post) = totalOf f (pre ++ v :: u :: post)
  | [] => Nat.add_left_comm (f u) (f v) (totalOf f post)
  | w :: pre => congrArg (f w + ·) (totalOf_swap f u v post pre)

/-- **The order does not decide whether all are released.** Exchanging two adjacent words of a
batch, which generates every reordering, leaves whether every copy is released as it was. -/
theorem batch_all_swap (r : Nat) (pre post : List (List α)) (u v pool : List α) (free used : Nat) :
    Every (batch draw r (pre ++ u :: v :: post) pool free used).1 ↔
      Every (batch draw r (pre ++ v :: u :: post) pool free used).1 :=
  (batch_all_iff draw r _ pool free used).trans
    (Iff.trans
      ⟨fun ⟨s, t⟩ => ⟨fun a => Nat.le_trans (Nat.le_of_eq (countOf_joinAll_swap a u v post pre).symm)
          (s a), Nat.le_trans (Nat.le_of_eq (totalOf_swap _ u v post pre).symm) t⟩,
       fun ⟨s, t⟩ => ⟨fun a => Nat.le_trans (Nat.le_of_eq (countOf_joinAll_swap a u v post pre))
          (s a), Nat.le_trans (Nat.le_of_eq (totalOf_swap _ u v post pre)) t⟩⟩
      (batch_all_iff draw r _ pool free used).symm)

/-! ## A lineage: one word copied again and again -/

/-- `n` copies of a word joined hold each token `n` times as often as the word. -/
theorem countOf_joinAll_replicate (a : α) (w : List α) :
    ∀ n : Nat, countOf a (joinAll (List.replicate n w)) = n * countOf a w
  | 0 => (Nat.zero_mul _).symm
  | n + 1 => (countOf_append a w (joinAll (List.replicate n w))).trans
      ((congrArg (countOf a w + ·) (countOf_joinAll_replicate a w n)).trans
        ((Nat.add_comm _ _).trans (Nat.succ_mul n (countOf a w)).symm))

omit [DecidableEq α] in
/-- `n` copies of a word need `n` times what one needs. -/
theorem totalOf_replicate (f : List α → Nat) (w : List α) :
    ∀ n : Nat, totalOf f (List.replicate n w) = n * f w
  | 0 => (Nat.zero_mul _).symm
  | n + 1 => (congrArg (f w + ·) (totalOf_replicate f w n)).trans
      ((Nat.add_comm _ _).trans (Nat.succ_mul n (f w)).symm)

/-- **A lineage.** Copying one word `n` times in turn from one shared pool and support, every
copy is released exactly when the pool holds each token at least `n` times as often as the word
uses it and the support covers `n` times the word's draws and release. -/
theorem lineage_all_iff (r : Nat) (word pool : List α) (free used n : Nat) :
    Every (batch draw r (List.replicate n word) pool free used).1 ↔
      (∀ a, n * countOf a word ≤ countOf a pool) ∧ n * (use draw none word + r) ≤ free :=
  (batch_all_iff draw r _ pool free used).trans
    ⟨fun ⟨s, t⟩ => ⟨fun a => Nat.le_trans (Nat.le_of_eq (countOf_joinAll_replicate a word n).symm)
        (s a), Nat.le_trans (Nat.le_of_eq (totalOf_replicate (fun w => use draw none w + r) word n).symm) t⟩,
     fun ⟨s, t⟩ => ⟨fun a => Nat.le_trans (Nat.le_of_eq (countOf_joinAll_replicate a word n))
        (s a), Nat.le_trans (Nat.le_of_eq (totalOf_replicate (fun w => use draw none w + r) word n)) t⟩⟩

/-! ## Local draws -/

/-- The first attachment draws `first`; each further one draws `same` after a like token and
`differ` after an unlike one. -/
def pairDraw (first same differ : Nat) : Option α → α → Nat
  | none, _ => first
  | some y, x => if y = x then same else differ

/-- Unlike adjacent pairs of the word `x :: l`. -/
def unlikeFrom : α → List α → Nat
  | _, [] => 0
  | x, y :: rest => (if x = y then 0 else 1) + unlikeFrom y rest

theorem use_pair (first same differ : Nat) : ∀ (x : α) (l : List α),
    use (pairDraw first same differ) (some x) l + same * unlikeFrom x l =
      same * l.length + differ * unlikeFrom x l
  | _, [] => rfl
  | x, y :: rest => by
    have ih := use_pair first same differ y rest
    show ((if x = y then same else differ) + use (pairDraw first same differ) (some y) rest) +
        same * ((if x = y then 0 else 1) + unlikeFrom y rest) =
      same * rest.length + same + differ * ((if x = y then 0 else 1) + unlikeFrom y rest)
    match decEq x y with
    | isTrue e =>
      rw [if_pos e, if_pos e, Nat.zero_add, Nat.add_assoc, ih, ← Nat.add_assoc,
        Nat.add_comm same (same * rest.length)]
    | isFalse ne =>
      rw [if_neg ne, if_neg ne, Nat.left_distrib, Nat.left_distrib, Nat.mul_one, Nat.mul_one,
        Nat.add_add_add_comm, ih, Nat.add_comm (same * rest.length) same,
        Nat.add_add_add_comm same (same * rest.length) differ, Nat.add_comm same differ]

/-- **A word's use of support depends on the law only through its unlike adjacent pairs.** -/
theorem use_word (first same differ : Nat) (x : α) (l : List α) :
    use (pairDraw first same differ) none (x :: l) + same * unlikeFrom x l =
      first + same * l.length + differ * unlikeFrom x l :=
  (Nat.add_assoc _ _ _).trans ((congrArg (first + ·) (use_pair first same differ x l)).trans
    (Nat.add_assoc _ _ _).symm)

theorem midpoint_arith {A B C F e u U1 U2 U3 : Nat} (h1 : A + e * U1 = F + u * U1)
    (h3 : B + e * U3 = F + u * U3) (h2 : C + e * U2 = F + u * U2) (mid : U1 + U3 = 2 * U2) :
    A + B = 2 * C :=
  add_right_cancel (e * (U1 + U3)) (calc
    A + B + e * (U1 + U3) = (A + e * U1) + (B + e * U3) :=
        (congrArg (A + B + ·) (Nat.left_distrib e U1 U3)).trans
          (Nat.add_add_add_comm A B (e * U1) (e * U3))
    _ = (F + u * U1) + (F + u * U3) := by rw [h1, h3]
    _ = (F + F) + u * (U1 + U3) :=
        (Nat.add_add_add_comm F (u * U1) F (u * U3)).trans
          (congrArg (F + F + ·) (Nat.left_distrib u U1 U3).symm)
    _ = (F + F) + u * (U2 + U2) := by rw [mid, Nat.two_mul]
    _ = (F + u * U2) + (F + u * U2) :=
        (congrArg (F + F + ·) (Nat.left_distrib u U2 U2)).trans
          (Nat.add_add_add_comm F F (u * U2) (u * U2))
    _ = (C + e * U2) + (C + e * U2) := by rw [h2]
    _ = (C + C) + e * (U2 + U2) :=
        (Nat.add_add_add_comm C (e * U2) C (e * U2)).trans
          (congrArg (C + C + ·) (Nat.left_distrib e U2 U2).symm)
    _ = 2 * C + e * (U1 + U3) := by rw [mid, Nat.two_mul, Nat.two_mul])

/-- **Uses in arithmetic progression.** Among words of one length whose unlike pairs are in
arithmetic progression, their uses of support are too, for every law of local draws. -/
theorem use_midpoint (first same differ : Nat) {x y z : α} {l m k : List α}
    (lm : l.length = m.length) (km : k.length = m.length)
    (mid : unlikeFrom x l + unlikeFrom z k = 2 * unlikeFrom y m) :
    use (pairDraw first same differ) none (x :: l) +
        use (pairDraw first same differ) none (z :: k) =
      2 * use (pairDraw first same differ) none (y :: m) := by
  have h1 := use_word first same differ x l
  have h3 := use_word first same differ z k
  have h2 := use_word first same differ y m
  rw [lm] at h1
  rw [km] at h3
  exact midpoint_arith h1 h3 h2 mid

/-- **Ranking by local draws.** Among words of one length, the word with more unlike pairs
draws less exactly when an unlike attachment draws less than a like one. -/
theorem use_lt_iff (first same differ : Nat) {x y : α} {l m : List α}
    (lm : l.length = m.length) {d : Nat} (more : unlikeFrom y m = unlikeFrom x l + d)
    (pos : 0 < d) :
    use (pairDraw first same differ) none (y :: m) <
        use (pairDraw first same differ) none (x :: l) ↔ differ < same := by
  have h1 := use_word first same differ x l
  have h2 := use_word first same differ y m
  rw [lm] at h1
  rw [more, Nat.left_distrib, Nat.left_distrib, ← Nat.add_assoc, ← Nat.add_assoc] at h2
  rw [← h1, Nat.add_right_comm (use (pairDraw first same differ) none (x :: l))] at h2
  -- h2 : C' + same * U + same * d = C + same * U + differ * d
  rw [Nat.add_right_comm (use (pairDraw first same differ) none (y :: m))] at h2
  have turn := add_right_cancel (same * unlikeFrom x l) h2
  -- turn : C' + same * d = C + differ * d
  constructor
  · intro less
    have h : use (pairDraw first same differ) none (x :: l) + differ * d <
        use (pairDraw first same differ) none (x :: l) + same * d := by
      rw [← turn]
      exact Nat.add_lt_add_right less _
    have h' := Nat.lt_of_add_lt_add_left h
    match Nat.decLt differ same with
    | isTrue lt => exact lt
    | isFalse ge =>
      exact absurd h' (Nat.not_lt_of_le (Nat.mul_le_mul_right d (Nat.le_of_not_lt ge)))
  · intro lt
    have h : use (pairDraw first same differ) none (y :: m) + same * d <
        use (pairDraw first same differ) none (x :: l) + same * d := by
      rw [turn]
      exact Nat.add_lt_add_left (Nat.mul_lt_mul_of_lt_of_le lt (Nat.le_refl d) pos) _
    exact Nat.lt_of_add_lt_add_right h

/-! ## Reading through contacts -/

/-- The site `i` of a word read through `read`: each site reads the word's token. -/
def Reads (read : Nat → Option α) : Nat → List α → Prop
  | _, [] => True
  | i, x :: xs => read i = some x ∧ Reads read (i + 1) xs

/-- One move of a copy attaching what the reading gives at the next site, given that
reading. -/
def readStep (s : Scan α) : Option α → Scan α
  | none => s
  | some x =>
    match s.pending with
    | [] => s
    | _ :: xs =>
      if 0 < countOf x s.pool ∧ draw s.previous x ≤ s.free then
        ⟨some x, xs, s.built ++ [x], remove x s.pool, s.free - draw s.previous x,
          s.used + draw s.previous x⟩
      else s

/-- One move of a copy reading through `read`: the token attached at site `i`
is what `read` reads at `i`. -/
def readTick (read : Nat → Option α) (s : Scan α) : Scan α := readStep draw s (read s.built.length)

/-- `n` moves of a copy reading through `read`. -/
def readSteps (read : Nat → Option α) : Nat → Scan α → Scan α
  | 0, s => s
  | n + 1, s => readSteps read n (readTick draw read s)

theorem readSteps_fixed (read : Nat → Option α) {s : Scan α} (fixed : readTick draw read s = s) :
    ∀ n, readSteps draw read n s = s
  | 0 => rfl
  | n + 1 => (congrArg (readSteps draw read n) fixed).trans (readSteps_fixed read fixed n)

theorem readStep_extends : ∀ (s : Scan α) (o : Option α),
    ∃ tail, (readStep draw s o).built = s.built ++ tail
  | _, none => ⟨[], (ListTests.append_nil _).symm⟩
  | s, some x =>
    match s with
    | ⟨_, [], _, _, _, _⟩ => ⟨[], (ListTests.append_nil _).symm⟩
    | ⟨prev, p :: xs, built, pool, free, used⟩ => by
      show ∃ tail, (if 0 < countOf x pool ∧ draw prev x ≤ free then
        (⟨some x, xs, built ++ [x], remove x pool, free - draw prev x, used + draw prev x⟩ :
          Scan α) else ⟨prev, p :: xs, built, pool, free, used⟩).built = built ++ tail
      exact ite_cases (fun r : Scan α => ∃ tail, r.built = built ++ tail)
        (fun _ => ⟨[x], rfl⟩) (fun _ => ⟨[], (ListTests.append_nil built).symm⟩)

/-- **The product of a reading copy only grows.** -/
theorem readSteps_extends (read : Nat → Option α) :
    ∀ (n : Nat) (s : Scan α), ∃ tail, (readSteps draw read n s).built = s.built ++ tail
  | 0, _ => ⟨[], (ListTests.append_nil _).symm⟩
  | n + 1, s =>
    match readStep_extends draw s (read s.built.length),
      readSteps_extends read n (readTick draw read s) with
    | ⟨first, h1⟩, ⟨rest, h2⟩ =>
      ⟨first ++ rest, h2.trans ((congrArg (· ++ rest) h1).trans (ListTests.append_assoc _ _ _))⟩

/-- **A copy reading through `read` reproduces a word exactly when every site reads
the word's token there, the pool supplies the word and the support covers what it draws.** -/
theorem reading_iff (read : Nat → Option α) : ∀ (word pending : List α) (prev : Option α)
    (built pool : List α) (free used : Nat), pending.length = word.length →
    ((readSteps draw read word.length ⟨prev, pending, built, pool, free, used⟩).built =
        built ++ word ↔
      Reads read built.length word ∧ Supplies word pool ∧ use draw prev word ≤ free)
  | [], _, prev, built, pool, free, used, _ =>
    ⟨fun _ => ⟨trivial, supplies_nil pool, Nat.zero_le free⟩,
     fun _ => (ListTests.append_nil built).symm⟩
  | _ :: _, [], _, _, _, _, _, lengths => nomatch lengths
  | x :: xs, p :: ps, prev, built, pool, free, used, lengths => by
    have lengths' : ps.length = xs.length := Nat.succ.inj lengths
    show (readSteps draw read xs.length
        (readStep draw ⟨prev, p :: ps, built, pool, free, used⟩ (read built.length))).built =
          built ++ x :: xs ↔ _
    match hr : read built.length with
    | none =>
      have fixed : readTick draw read ⟨prev, p :: ps, built, pool, free, used⟩ =
          ⟨prev, p :: ps, built, pool, free, used⟩ :=
        congrArg (readStep draw ⟨prev, p :: ps, built, pool, free, used⟩) hr
      have fixed' : readStep draw ⟨prev, p :: ps, built, pool, free, used⟩ none =
          ⟨prev, p :: ps, built, pool, free, used⟩ := rfl
      rw [fixed', readSteps_fixed draw read fixed]
      exact ⟨fun same => absurd same (ne_append_cons built x xs),
        fun ⟨reads, _⟩ => nomatch hr.symm.trans reads.1⟩
    | some y =>
      match Nat.decLt 0 (countOf y pool), Nat.decLe (draw prev y) free with
      | isTrue pos, isTrue first =>
        have moved : readStep draw ⟨prev, p :: ps, built, pool, free, used⟩ (some y) =
            ⟨some y, ps, built ++ [y], remove y pool, free - draw prev y, used + draw prev y⟩ :=
          if_pos ⟨pos, first⟩
        rw [moved]
        match decEq y x with
        | isTrue e =>
          subst e
          have ih := reading_iff read xs ps (some y) (built ++ [y]) (remove y pool)
            (free - draw prev y) (used + draw prev y) lengths'
          rw [ListTests.append_assoc, ListTests.length_append] at ih
          exact ih.trans ⟨fun ⟨reads, rest, more⟩ =>
              ⟨⟨hr, reads⟩, supplies_cons_iff.mpr ⟨pos, rest⟩, add_le_iff.mpr ⟨first, more⟩⟩,
            fun ⟨⟨_, reads⟩, supplies, covered⟩ =>
              ⟨reads, (supplies_cons_iff.mp supplies).2,
                (add_le_iff.mp (show draw prev y + use draw (some y) xs ≤ free from covered)).2⟩⟩
        | isFalse ne =>
          have ⟨tail, grown⟩ := readSteps_extends draw read xs.length
            ⟨some y, ps, built ++ [y], remove y pool, free - draw prev y, used + draw prev y⟩
          exact ⟨fun same => by
              have h := grown.symm.trans same
              rw [ListTests.append_assoc] at h
              exact absurd (List.cons.inj (append_cancel built h)).1 ne,
            fun ⟨reads, _⟩ => absurd (Option.some.inj (hr.symm.trans reads.1)) ne⟩
      | isFalse absent, _ =>
        have fixed : readTick draw read ⟨prev, p :: ps, built, pool, free, used⟩ =
            ⟨prev, p :: ps, built, pool, free, used⟩ :=
          (congrArg (readStep draw ⟨prev, p :: ps, built, pool, free, used⟩) hr).trans
            (if_neg fun h => absent h.1)
        have fixed' : readStep draw ⟨prev, p :: ps, built, pool, free, used⟩ (some y) =
            ⟨prev, p :: ps, built, pool, free, used⟩ := if_neg fun h => absent h.1
        rw [fixed', readSteps_fixed draw read fixed]
        exact ⟨fun same => absurd same (ne_append_cons built x xs),
          fun ⟨reads, supplies, _⟩ => by
            have e : y = x := Option.some.inj (hr.symm.trans reads.1)
            subst e
            exact absurd (pos_of_supplies supplies) absent⟩
      | isTrue _, isFalse over =>
        have fixed : readTick draw read ⟨prev, p :: ps, built, pool, free, used⟩ =
            ⟨prev, p :: ps, built, pool, free, used⟩ :=
          (congrArg (readStep draw ⟨prev, p :: ps, built, pool, free, used⟩) hr).trans
            (if_neg fun h => over h.2)
        have fixed' : readStep draw ⟨prev, p :: ps, built, pool, free, used⟩ (some y) =
            ⟨prev, p :: ps, built, pool, free, used⟩ := if_neg fun h => over h.2
        rw [fixed', readSteps_fixed draw read fixed]
        exact ⟨fun same => absurd same (ne_append_cons built x xs),
          fun ⟨reads, _, covered⟩ => by
            have e : y = x := Option.some.inj (hr.symm.trans reads.1)
            subst e
            exact absurd (add_le_iff.mp
              (show draw prev y + use draw (some y) xs ≤ free from covered)).1 over⟩

/-! ## Inspection against a reference -/

/-- Sites at which the product differs from the reference sequence, over their common length. -/
def defects : List α → List α → Nat
  | [], _ => 0
  | _ :: _, [] => 0
  | a :: as, b :: bs => (if a = b then 0 else 1) + defects as bs

/-- The reference reading `ref` agrees with the template `t` at site `i`, where both have a
token there. -/
def FaithfulAt (ref : Nat → Option α) (t : List α) (i : Nat) : Prop :=
  ∀ x y, ref i = some x → nth t i = some y → x = y

/-- Draw `c` from the free support. -/
def drawSupport (c : Nat) (s : Scan α) : Scan α :=
  ⟨s.previous, s.pending, s.built, s.pool, s.free - c, s.used + c⟩

/-- Exchange the token `old` found at site `i` for `x`, drawing `ce`, where the two differ, the
pool holds `x` and the support covers `ce`; the displaced token returns to the pool. -/
def exchangeAt (ce i : Nat) (x : α) (s : Scan α) : Option α → Scan α
  | none => s
  | some old =>
    if ¬ old = x ∧ 0 < countOf x s.pool ∧ ce ≤ s.free then
      ⟨final (setAt s.built i x), s.pending, setAt s.built i x, remove x s.pool ++ [old],
        s.free - ce, s.used + ce⟩
    else s

/-- Exchange the token at site `i` for `x`. -/
def exchange (ce i : Nat) (x : α) (s : Scan α) : Scan α := exchangeAt ce i x s (nth s.built i)

/-- Inspect site `i` against the reference token, drawing `ci`, then exchange. -/
def inspectAt (ci ce i : Nat) (s : Scan α) : Option α → Option α → Scan α
  | none, _ => s
  | some _, none => s
  | some x, some _ => if ci ≤ s.free then exchange ce i x (drawSupport ci s) else s

/-- Inspect site `i` against the reference reading `ref`. -/
def inspect (ci ce : Nat) (ref : Nat → Option α) (i : Nat) (s : Scan α) : Scan α :=
  inspectAt ci ce i s (ref i) (nth s.built i)

/-- Inspect the sites in turn. -/
def scanSites (ci ce : Nat) (ref : Nat → Option α) : List Nat → Scan α → Scan α
  | [], s => s
  | i :: is, s => scanSites ci ce ref is (inspect ci ce ref i s)

theorem defects_self : ∀ t : List α, defects t t = 0
  | [] => rfl
  | a :: as => by
    show (if a = a then 0 else 1) + defects as as = 0
    rw [if_pos rfl, defects_self as]

/-- Setting a defective site to the template's token removes one defect. -/
theorem defects_fix : ∀ (t b : List α) (i : Nat) {x old : α}, nth t i = some x →
    nth b i = some old → old ≠ x → defects t (setAt b i x) + 1 = defects t b
  | [], _, _, _, _, ht, _, _ => nomatch ht
  | _ :: _, [], _, _, _, _, hb, _ => nomatch hb
  | a :: as, c :: cs, 0, x, old, ht, hb, ne => by
    have ax : a = x := Option.some.inj ht
    have co : c = old := Option.some.inj hb
    subst ax
    subst co
    show (if a = a then 0 else 1) + defects as cs + 1 = (if a = c then 0 else 1) + defects as cs
    rw [if_pos rfl, if_neg (fun h => ne h.symm), Nat.zero_add, Nat.add_comm]
  | a :: as, c :: cs, i + 1, _, _, ht, hb, ne => by
    show (if a = c then 0 else 1) + defects as (setAt cs i _) + 1 =
      (if a = c then 0 else 1) + defects as cs
    rw [Nat.add_assoc, defects_fix as cs i ht hb ne]

/-- Setting a correct site to another token adds one defect. -/
theorem defects_break : ∀ (t b : List α) (i : Nat) {x y : α}, nth t i = some y →
    nth b i = some y → x ≠ y → defects t (setAt b i x) = defects t b + 1
  | [], _, _, _, _, ht, _, _ => nomatch ht
  | _ :: _, [], _, _, _, _, hb, _ => nomatch hb
  | a :: as, c :: cs, 0, x, y, ht, hb, ne => by
    have ay : a = y := Option.some.inj ht
    have cy : c = y := Option.some.inj hb
    subst ay
    subst cy
    show (if c = x then 0 else 1) + defects as cs = (if c = c then 0 else 1) + defects as cs + 1
    rw [if_neg (fun h => ne h.symm), if_pos rfl, Nat.zero_add, Nat.add_comm]
  | a :: as, c :: cs, i + 1, _, _, ht, hb, ne => by
    show (if a = c then 0 else 1) + defects as (setAt cs i _) =
      (if a = c then 0 else 1) + defects as cs + 1
    rw [Nat.add_assoc, defects_break as cs i ht hb ne]

/-- Setting a site beyond the template leaves the defects as they were. -/
theorem defects_beyond : ∀ (t b : List α) (i : Nat) (x : α), nth t i = none →
    defects t (setAt b i x) = defects t b
  | [], [], _, _, _ => rfl
  | [], _ :: _, 0, _, _ => rfl
  | [], _ :: _, _ + 1, _, _ => rfl
  | _ :: _, [], _, _, _ => rfl
  | _ :: _, _ :: _, 0, _, ht => nomatch ht
  | a :: as, c :: cs, i + 1, x, ht => by
    show (if a = c then 0 else 1) + defects as (setAt cs i x) =
      (if a = c then 0 else 1) + defects as cs
    rw [defects_beyond as cs i x ht]

/-- An exchange towards a token the template holds at the site, or a site beyond it, never
increases the defects. -/
theorem exchange_le (t : List α) (ce i : Nat) (x : α) (s : Scan α)
    (faithful : ∀ y, nth t i = some y → x = y) :
    defects t (exchange ce i x s).built ≤ defects t s.built := by
  show defects t (exchangeAt ce i x s (nth s.built i)).built ≤ defects t s.built
  match hb : nth s.built i with
  | none => exact Nat.le_refl _
  | some old =>
    refine ite_cases (fun r : Scan α => defects t r.built ≤ defects t s.built) (fun ⟨ne, _, _⟩ => ?_)
      (fun _ => Nat.le_refl _)
    show defects t (setAt s.built i x) ≤ defects t s.built
    match ht : nth t i with
    | none => exact Nat.le_of_eq (defects_beyond t s.built i x ht)
    | some y =>
      have e : x = y := faithful y ht
      subst e
      exact Nat.le_trans (Nat.le_succ _) (Nat.le_of_eq (defects_fix t s.built i ht hb ne))

/-- An inspection against a faithful reference never increases the defects. -/
theorem inspect_le {t : List α} {ref : Nat → Option α} {i : Nat} (faithful : FaithfulAt ref t i)
    (ci ce : Nat) (s : Scan α) : defects t (inspect ci ce ref i s).built ≤ defects t s.built := by
  show defects t (inspectAt ci ce i s (ref i) (nth s.built i)).built ≤ defects t s.built
  match hr : ref i, hb : nth s.built i with
  | none, _ => exact Nat.le_refl _
  | some _, none => exact Nat.le_refl _
  | some x, some _ =>
    exact ite_cases (fun r : Scan α => defects t r.built ≤ defects t s.built)
      (fun _ => exchange_le t ce i x (drawSupport ci s) fun y ht => faithful x y hr ht)
      (fun _ => Nat.le_refl _)

/-- **Inspection never increases the defects exactly where the reference is faithful.** For
every product, pool and support, inspecting site `i` and exchanging towards the reference never
increases the defects against `t` exactly when the reference agrees with `t` at `i`. -/
theorem inspect_le_iff (ci ce : Nat) (t : List α) (ref : Nat → Option α) (i : Nat) :
    (∀ s : Scan α, defects t (inspect ci ce ref i s).built ≤ defects t s.built) ↔
      FaithfulAt ref t i :=
  ⟨fun never x y hr ht =>
    match decEq x y with
    | isTrue e => e
    | isFalse ne => by
      have h := never ⟨none, [], t, [x], ci + ce, 0⟩
      have broken : (inspect ci ce ref i (⟨none, [], t, [x], ci + ce, 0⟩ : Scan α)).built =
          setAt t i x := by
        show (inspectAt ci ce i ⟨none, [], t, [x], ci + ce, 0⟩ (ref i) (nth t i)).built = _
        rw [hr, ht]
        show (if ci ≤ ci + ce then exchange ce i x (drawSupport ci ⟨none, [], t, [x], ci + ce, 0⟩)
          else _).built = _
        rw [if_pos (Nat.le_add_right ci ce)]
        show (exchangeAt ce i x (drawSupport ci ⟨none, [], t, [x], ci + ce, 0⟩) (nth t i)).built = _
        rw [ht]
        have avail : 0 < countOf x [x] := by
          rw [countOf_self]
          exact Nat.succ_pos 0
        have left : ce ≤ ci + ce - ci := Nat.le_of_eq (Naturals.add_sub_cancel_left ci ce).symm
        exact congrArg Scan.built (if_pos ⟨fun h => ne h.symm, avail, left⟩)
      rw [broken, defects_break t t i ht ht ne, defects_self] at h
      exact absurd h (Nat.not_succ_le_zero 0),
   fun faithful s => inspect_le faithful ci ce s⟩

/-- **A scan of faithful sites never increases the defects.** -/
theorem scan_le {t : List α} {ref : Nat → Option α} (ci ce : Nat) :
    ∀ (sites : List Nat) (s : Scan α), (∀ i, i ∈ sites → FaithfulAt ref t i) →
      defects t (scanSites ci ce ref sites s).built ≤ defects t s.built
  | [], _, _ => Nat.le_refl _
  | i :: is, s, faithful =>
    Nat.le_trans (scan_le ci ce is _ fun j mem => faithful j (.tail i mem))
      (inspect_le (faithful i (.head is)) ci ce s)

/-- **The single-site criterion.** At a site holding `old`, where the reference reads `x ≠ old`,
inspection leaves `x` there exactly when the pool holds `x` and the support covers the draws of
inspection and exchange. -/
theorem inspect_matches_iff (ci ce : Nat) {ref : Nat → Option α} {i : Nat} {x old : α}
    (s : Scan α) (hr : ref i = some x) (hb : nth s.built i = some old) (ne : old ≠ x) :
    nth (inspect ci ce ref i s).built i = some x ↔ ci + ce ≤ s.free ∧ 0 < countOf x s.pool := by
  show nth (inspectAt ci ce i s (ref i) (nth s.built i)).built i = some x ↔ _
  rw [hr, hb]
  show nth (if ci ≤ s.free then exchange ce i x (drawSupport ci s) else s).built i = some x ↔ _
  match Nat.decLe ci s.free with
  | isFalse nle =>
    rw [if_neg nle]
    exact ⟨fun h => absurd (Option.some.inj (hb.symm.trans h)) ne,
      fun ⟨cover, _⟩ => absurd (Nat.le_trans (Nat.le_add_right ci ce) cover) nle⟩
  | isTrue le =>
    rw [if_pos le]
    show nth (exchangeAt ce i x (drawSupport ci s) (nth s.built i)).built i = some x ↔ _
    rw [hb]
    match Nat.decLt 0 (countOf x s.pool), Nat.decLe ce (s.free - ci) with
    | isTrue pos, isTrue left =>
      rw [show exchangeAt ce i x (drawSupport ci s) (some old) = _ from if_pos ⟨ne, pos, left⟩]
      exact ⟨fun _ => ⟨add_le_iff.mpr ⟨le, left⟩, pos⟩, fun _ => nth_setAt_self s.built i x hb⟩
    | isFalse absent, _ =>
      rw [show exchangeAt ce i x (drawSupport ci s) (some old) = drawSupport ci s from
        if_neg (fun h => absent h.2.1)]
      exact ⟨fun h => absurd (Option.some.inj (hb.symm.trans h)) ne,
        fun ⟨_, pos⟩ => absurd pos absent⟩
    | isTrue _, isFalse over =>
      rw [show exchangeAt ce i x (drawSupport ci s) (some old) = drawSupport ci s from
        if_neg (fun h => over h.2.2)]
      exact ⟨fun h => absurd (Option.some.inj (hb.symm.trans h)) ne,
        fun ⟨cover, _⟩ => absurd (add_le_iff.mp cover).2 over⟩

/-- **No defect exactly at the template.** A product of the template's length has no defect
against it exactly when it is the template. -/
theorem defects_zero_iff : ∀ (t b : List α), b.length = t.length → (defects t b = 0 ↔ b = t)
  | [], [], _ => ⟨fun _ => rfl, fun _ => rfl⟩
  | [], _ :: _, h => nomatch h
  | _ :: _, [], h => nomatch h
  | a :: as, c :: cs, h =>
    match decEq a c with
    | isTrue e => by
      subst e
      show (if a = a then 0 else 1) + defects as cs = 0 ↔ a :: cs = a :: as
      rw [if_pos rfl, Nat.zero_add]
      exact (defects_zero_iff as cs (Nat.succ.inj h)).trans
        ⟨fun same => congrArg (a :: ·) same, fun same => (List.cons.inj same).2⟩
    | isFalse ne => by
      show (if a = c then 0 else 1) + defects as cs = 0 ↔ c :: cs = a :: as
      rw [if_neg ne]
      exact ⟨fun h0 => absurd (Nat.le_trans (Nat.le_add_right 1 (defects as cs)) (Nat.le_of_eq h0))
          (Nat.not_succ_le_zero 0),
        fun same => absurd (List.cons.inj same).1.symm ne⟩

theorem countOf_setAt (a : α) : ∀ (b : List α) (i : Nat) {old : α} (x : α), nth b i = some old →
    countOf a (setAt b i x) + countOf a [old] = countOf a b + countOf a [x]
  | [], _, _, _, h => nomatch h
  | c :: cs, 0, old, x, h => by
    have e : c = old := Option.some.inj h
    subst e
    show countOf a ([x] ++ cs) + countOf a [c] = countOf a ([c] ++ cs) + countOf a [x]
    rw [countOf_append, countOf_append]
    exact (Nat.add_comm _ _).trans ((congrArg (countOf a [c] + ·) (Nat.add_comm _ _)).trans
      (Nat.add_assoc _ _ _).symm)
  | c :: cs, i + 1, _, x, h => by
    show countOf a ([c] ++ setAt cs i x) + _ = countOf a ([c] ++ cs) + _
    rw [countOf_append, countOf_append, Nat.add_assoc, countOf_setAt a cs i x h, Nat.add_assoc]

theorem countOf_remove (a x : α) (pool : List α) (pos : 0 < countOf x pool) :
    countOf a (remove x pool) + countOf a [x] = countOf a pool :=
  match decEq x a with
  | isTrue e => by
    subst e
    rw [countOf_self]
    exact countOf_remove_self x pool pos
  | isFalse ne => by
    rw [countOf_other ne, countOf_remove_other ne]
    rfl

/-- **An exchange keeps every token's count across product and pool.** -/
theorem exchange_keeps_counts (ce i : Nat) (x : α) (s : Scan α) (a : α) :
    countOf a ((exchange ce i x s).built ++ (exchange ce i x s).pool) =
      countOf a (s.built ++ s.pool) := by
  show countOf a ((exchangeAt ce i x s (nth s.built i)).built ++
    (exchangeAt ce i x s (nth s.built i)).pool) = _
  match hb : nth s.built i with
  | none => rfl
  | some old =>
    refine ite_cases (fun r : Scan α => countOf a (r.built ++ r.pool) = countOf a (s.built ++ s.pool))
      (fun ⟨_, pos, _⟩ => ?_) (fun _ => rfl)
    show countOf a (setAt s.built i x ++ (remove x s.pool ++ [old])) = countOf a (s.built ++ s.pool)
    rw [countOf_append, countOf_append, countOf_append, ← Nat.add_assoc,
      Nat.add_right_comm (countOf a (setAt s.built i x)), countOf_setAt a s.built i x hb,
      Nat.add_assoc, Nat.add_comm (countOf a [x]), countOf_remove a x s.pool pos]

/-- An inspection keeps every token's count across product and pool. -/
theorem inspect_keeps_counts (ci ce : Nat) (ref : Nat → Option α) (i : Nat) (s : Scan α) (a : α) :
    countOf a ((inspect ci ce ref i s).built ++ (inspect ci ce ref i s).pool) =
      countOf a (s.built ++ s.pool) := by
  show countOf a ((inspectAt ci ce i s (ref i) (nth s.built i)).built ++
    (inspectAt ci ce i s (ref i) (nth s.built i)).pool) = _
  match ref i, nth s.built i with
  | none, _ => rfl
  | some _, none => rfl
  | some x, some _ =>
    exact ite_cases (fun r : Scan α => countOf a (r.built ++ r.pool) = countOf a (s.built ++ s.pool))
      (fun _ => exchange_keeps_counts ce i x (drawSupport ci s) a) (fun _ => rfl)

end Pool

/-! ## Copying, and doubling its case -/

/-- Units drawn for beyond the start in `n` rounds of copying `b`-fold from `k` units. -/
def requiredBy (b : Nat) : Nat → Nat → Nat
  | 0, _ => 0
  | n + 1, k => k + requiredBy b n (b * k)

theorem mul_pow_succ (b k n : Nat) : b * k * b ^ n = k * b ^ (n + 1) :=
  calc b * k * b ^ n = k * b * b ^ n := congrArg (· * b ^ n) (Nat.mul_comm b k)
    _ = k * (b * b ^ n) := mul_assoc_nat k b (b ^ n)
    _ = k * (b ^ n * b) := congrArg (k * ·) (Nat.mul_comm b (b ^ n))

/-- **What copying draws.** Copying `c + 1`-fold, `c` times what `n` rounds draw for, with the `k`
units of the start, make `k * (c + 1) ^ n`. -/
theorem requiredBy_add (c : Nat) : ∀ n k : Nat, c * requiredBy (c + 1) n k + k = k * (c + 1) ^ n
  | 0, k => (congrArg (· + k) (Nat.mul_zero c)).trans ((Nat.zero_add k).trans (Nat.mul_one k).symm)
  | n + 1, k =>
    calc c * (k + requiredBy (c + 1) n ((c + 1) * k)) + k
        = c * requiredBy (c + 1) n ((c + 1) * k) + (c * k + k) :=
          (congrArg (· + k) ((Nat.left_distrib c k _).trans (Nat.add_comm _ _))).trans
            (Nat.add_assoc _ _ _)
      _ = c * requiredBy (c + 1) n ((c + 1) * k) + (c + 1) * k :=
          congrArg (_ + ·) ((Nat.mul_comm (c + 1) k).trans ((Nat.left_distrib k c 1).trans
            (congr (congrArg (· + ·) (Nat.mul_comm k c)) (Nat.mul_one k)))).symm
      _ = (c + 1) * k * (c + 1) ^ n := requiredBy_add c n ((c + 1) * k)
      _ = k * (c + 1) ^ (n + 1) := mul_pow_succ (c + 1) k n

/-- Units drawn for beyond the start in `n` rounds of doubling from `k` units: `k * (2 ^ n - 1)`. -/
def required : Nat → Nat → Nat := requiredBy 2

theorem two_mul_pow (k n : Nat) : 2 * k * 2 ^ n = k * 2 ^ (n + 1) := mul_pow_succ 2 k n

/-- **What doubling draws.** `required n k` and the `k` units of the start make `k * 2 ^ n`. -/
theorem required_add (n k : Nat) : required n k + k = k * 2 ^ n :=
  (congrArg (· + k) (Nat.one_mul (required n k)).symm).trans (requiredBy_add 1 n k)

/-- One round of copying `b`-fold: every unit draws `d` from the stock and becomes `b`. -/
def copying (b d : Nat) : Process (Nat × Nat) Unit :=
  ⟨fun s _ t => d * s.1 ≤ s.2 ∧ t = (b * s.1, s.2 - d * s.1)⟩

/-- One round of doubling: every unit draws `d` from the stock and becomes two. -/
def doubling (d : Nat) : Process (Nat × Nat) Unit := copying 2 d

/-- `n` rounds. -/
def rounds (n : Nat) : List Unit := List.replicate n ()

/-- **Copying.** Where every unit draws `d` from one stock and becomes `b`, `n` rounds from `k`
units with stock `m` run exactly when `d * requiredBy b n k ≤ m`, and end with `k * b ^ n` units
and what the stock has left. -/
theorem copying_iff (b d : Nat) : ∀ (n k m : Nat) (t : Nat × Nat),
    Trace (copying b d) (k, m) (rounds n) t ↔
      d * requiredBy b n k ≤ m ∧ t = (k * b ^ n, m - d * requiredBy b n k)
  | 0, k, m, t =>
    ⟨fun path => match path with
      | .nil _ => ⟨Nat.zero_le m, congrArg (·, m) (Nat.mul_one k).symm⟩,
     fun ⟨_, ended⟩ => by
      have e : t = (k, m) := ended.trans (congrArg (·, m) (Nat.mul_one k))
      subst e
      exact .nil _⟩
  | n + 1, k, m, t =>
    have split : d * requiredBy b (n + 1) k = d * k + d * requiredBy b n (b * k) :=
      Nat.left_distrib _ _ _
    ⟨fun path => match path with
      | .cons ⟨first, moved⟩ rest => by
        subst moved
        have ⟨more, ended⟩ := (copying_iff b d n (b * k) (m - d * k) t).mp rest
        refine ⟨?_, ?_⟩
        · rw [split]
          exact add_le_iff.mpr ⟨first, more⟩
        · rw [ended, mul_pow_succ, Naturals.sub_sub, split],
     fun ⟨covered, ended⟩ => by
      rw [split] at covered ended
      have ⟨first, more⟩ := add_le_iff.mp covered
      refine .cons ⟨first, rfl⟩ ((copying_iff b d n (b * k) (m - d * k) t).mpr ⟨more, ?_⟩)
      rw [ended, mul_pow_succ, Naturals.sub_sub]⟩

/-- Copying runs every number of rounds where the stock covers what they draw. -/
theorem copying_runs (b d n k m : Nat) (covered : d * requiredBy b n k ≤ m) :
    Trace (copying b d) (k, m) (rounds n) (k * b ^ n, m - d * requiredBy b n k) :=
  (copying_iff b d n k m _).mpr ⟨covered, rfl⟩

/-- **Doubling.** Where every unit draws `d` from one stock and becomes two, `n` rounds from `k`
units with stock `m` run exactly when `d * required n k ≤ m`, and end with `k * 2 ^ n` units and
what the stock has left. -/
theorem doubling_iff (d : Nat) (n k m : Nat) (t : Nat × Nat) :
    Trace (doubling d) (k, m) (rounds n) t ↔
      d * required n k ≤ m ∧ t = (k * 2 ^ n, m - d * required n k) :=
  copying_iff 2 d n k m t

/-- Doubling runs every number of rounds where the stock covers what they draw. -/
theorem doubling_runs (d n k m : Nat) (covered : d * required n k ≤ m) :
    Trace (doubling d) (k, m) (rounds n) (k * 2 ^ n, m - d * required n k) :=
  copying_runs 2 d n k m covered

/-- **Ten from one, five rounds.** Copying tenfold, each unit drawing one, five rounds from one unit
run from a stock of 11,111 and end with 100,000 units and none left: one teaches ten, ten a
hundred, and so to a hundred thousand. -/
theorem tenfold : Trace (copying 10 1) (1, 11111) (rounds 5) (100000, 0) :=
  copying_runs 10 1 5 1 11111 (Nat.le_refl _)

end Becoming.Copying
