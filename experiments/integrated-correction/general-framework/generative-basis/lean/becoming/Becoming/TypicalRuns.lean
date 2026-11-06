import Becoming.Typicality
import Becoming.Parting
import Becoming.CrossSituational
import Becoming.FinerTraces

/-!
# Typical runs: what counting says of the prefixes of runs of free branching

`Becoming.Typicality` counts, with natural weights `p` and `q`, the courses of `n` steps on two
values (`Typicality.courses`), and states the exact spread, the counting form of Chebyshev's bound
and of Chernoff's bound over them. It reads every course as a run of free branching
(`Parting.free`, `Parting.freeRun`). This module states those counts of the runs: the courses of
`n` steps are exactly the prefixes of `n` steps a run of free branching on two values shows
(`Learning.prefixOf` of `Parting.course`), each listed once, so every count over them is a
count over the prefixes of runs, whatever list holds them.

* **The courses are the prefixes of runs.** A list of `n` values is a course of `n` steps exactly
  where some run of free branching shows it as its prefix of `n` steps (`mem_courses_iff`), and
  the courses list each prefix once (`courses_records`).
* **A count over the prefixes does not depend on how they are listed.** Two lists each holding
  every member of one kind once give every count the same sum (`sum_listing`, `total_listing`).
* **The counts of `Becoming.Typicality` are counts of prefixes.** For every list `l` holding each
  prefix of `n` steps of the runs of free branching on two values once: there are `2 ^ n` of
  them (`records_count`); they weigh `(p + q) ^ n` together (`records_weight`), which is the sum
  over histories of `Becoming.Weighted` (`histories_records`); their squared deviations add up to
  `n·p·q·(p + q)^n` (`records_spread`); those deviating by at least `d` weigh, times `d`, at most
  `n·p·q·(p + q)^n` (`records_typical`); and those with at least `k` ones weigh, times
  `u ^ k · v ^ n`, at most `(p·u + q·v) ^ n · v ^ k` for every `u ≥ v` (`records_concentrated`),
  with `p = q = 1`, `u = 3`, `v = 1` numbering, times `3 ^ k`, at most `4 ^ n`
  (`records_few_far_ahead`).

What is not derived, as in `Becoming.Typicality`: that the run which happens is typical. Counting
weighs the prefixes of runs; it does not choose one, and no prefix shows that a run of free
branching will not part (`Parting.free_parts_after`). No ethical predicate, ranking or axiom
occurs.
-/

namespace Becoming

open Generative

namespace TypicalRuns

universe u

/-! ## Lists holding every member of one kind once -/

section Listing

variable {α : Type u}

/-- `l` holds every `x` with `M x`, and nothing else, each once. -/
def Listing (M : α → Prop) (l : List α) : Prop :=
  Distinct l ∧ ∀ x, x ∈ l ↔ M x

/-- A member splits its list. -/
theorem split_of_mem {a : α} : ∀ {l : List α}, a ∈ l → ∃ l₁ l₂, l = l₁ ++ a :: l₂
  | _ :: l, .head _ => ⟨[], l, rfl⟩
  | b :: _, .tail _ mem => match split_of_mem mem with
    | ⟨l₁, l₂, same⟩ => ⟨b :: l₁, l₂, congrArg (b :: ·) same⟩

theorem mem_of_mem_drop {a x : α} {l₁ l₂ : List α} (mem : x ∈ l₁ ++ l₂) : x ∈ l₁ ++ a :: l₂ :=
  match ListTests.mem_append_iff.mp mem with
  | .inl inside => mem_appended_left _ inside
  | .inr outside => mem_appended_right (.tail a outside) l₁

theorem mem_drop_or {a x : α} {l₁ l₂ : List α} (mem : x ∈ l₁ ++ a :: l₂) :
    x = a ∨ x ∈ l₁ ++ l₂ :=
  match ListTests.mem_append_iff.mp mem with
  | .inl inside => .inr (mem_appended_left _ inside)
  | .inr (.head _) => .inl rfl
  | .inr (.tail _ outside) => .inr (mem_appended_right outside l₁)

/-- Taking a member out of a list without repetition leaves a list without repetition that does
not hold it. -/
theorem distinct_drop {a : α} :
    ∀ {l₁ l₂ : List α}, Distinct (l₁ ++ a :: l₂) →
      ¬ a ∈ l₁ ++ l₂ ∧ Distinct (l₁ ++ l₂)
  | [], _, ⟨out, rest⟩ => ⟨out, rest⟩
  | b :: l₁, l₂, ⟨out, rest⟩ =>
    match distinct_drop (l₁ := l₁) (l₂ := l₂) rest with
    | ⟨out', rest'⟩ =>
      ⟨fun mem => match mem with
        | .head _ => out (mem_appended_right (.head l₂) l₁)
        | .tail _ inside => out' inside,
       ⟨fun mem => out (mem_of_mem_drop mem), rest'⟩⟩

/-- **A count does not depend on how the members are listed.** Two lists without repetition
holding the same members give every reading the same sum. -/
theorem sum_listing (f : α → Nat) : ∀ {l m : List α}, Distinct l →
    Distinct m → (∀ x, x ∈ l ↔ x ∈ m) → counting.sum l f = counting.sum m f
  | [], [], _, _, _ => rfl
  | [], b :: _, _, _, same => nomatch (same b).mpr (.head _)
  | a :: l, _, ⟨out, rest⟩, dm, same =>
    match split_of_mem ((same a).mp (.head l)) with
    | ⟨m₁, m₂, split⟩ =>
      have dm' : Distinct (m₁ ++ a :: m₂) :=
        Eq.subst (motive := fun k => Distinct k) split dm
      match distinct_drop dm' with
      | ⟨out', rest'⟩ =>
        have members : ∀ x, x ∈ l ↔ x ∈ m₁ ++ m₂ := fun x =>
          ⟨fun mem =>
            match mem_drop_or (Eq.subst (motive := fun k => x ∈ k) split ((same x).mp (.tail a mem)))
              with
            | .inl at_a => absurd (Eq.subst (motive := fun y => y ∈ l) at_a mem) out
            | .inr inside => inside,
           fun mem =>
            match (same x).mpr (Eq.subst (motive := fun k => x ∈ k) split.symm (mem_of_mem_drop mem))
              with
            | .head _ => absurd mem out'
            | .tail _ inside => inside⟩
        have whole : counting.sum (m₁ ++ a :: m₂) f = f a + counting.sum (m₁ ++ m₂) f :=
          (Weights.sum_append (W := counting) f m₁ (a :: m₂)).trans
            ((Nat.add_left_comm _ _ _).trans
              (congrArg (f a + ·) (Weights.sum_append (W := counting) f m₁ m₂).symm))
        (congrArg (f a + ·) (sum_listing f rest rest' members)).trans
          (whole.symm.trans (congrArg (fun k => counting.sum k f) split.symm))

/-- Two lists each holding every member of one kind once give every reading the same sum. -/
theorem sum_listed {M : α → Prop} {l m : List α} (listed : Listing M l) (listed' : Listing M m)
    (f : α → Nat) : counting.sum l f = counting.sum m f :=
  sum_listing f listed.1 listed'.1 fun x => (listed.2 x).trans (listed'.2 x).symm

/-- Two lists each holding every member of one kind once have one length. -/
theorem length_listed {M : α → Prop} {l m : List α} (listed : Listing M l)
    (listed' : Listing M m) : l.length = m.length :=
  (Situations.sum_one l).symm.trans ((sum_listed listed listed' _).trans (Situations.sum_one m))

end Listing

/-! ## The courses are the prefixes of runs -/

/-- Typicality's sum is the sum of counting. -/
theorem total_eq_sum (f : List Bool → Nat) : ∀ ws : List (List Bool),
    total ws f = counting.sum ws f
  | [] => rfl
  | w :: ws => congrArg (f w + ·) (total_eq_sum f ws)

/-- Two lists each holding every member of one kind once give every reading the same total. -/
theorem total_listing {M : List Bool → Prop} {l m : List (List Bool)} (listed : Listing M l)
    (listed' : Listing M m) (f : List Bool → Nat) : total l f = total m f :=
  (total_eq_sum f l).trans ((sum_listed listed listed' f).trans (total_eq_sum f m).symm)

/-- The sequence whose prefix of `w.length` steps is `w`, `false` after it. -/
def ofRecord : List Bool → Nat → Bool
  | [], _ => false
  | b :: w, k => if k = w.length then b else ofRecord w k

theorem record_ofRecord : ∀ w : List Bool, Learning.prefixOf (ofRecord w) w.length = w
  | [] => rfl
  | b :: w =>
    show ofRecord (b :: w) w.length :: Learning.prefixOf (ofRecord (b :: w)) w.length = b :: w from
    congr (congrArg List.cons (if_pos rfl))
      ((Learning.prefix_congr fun _ before => if_neg (Nat.ne_of_lt before)).trans
        (record_ofRecord w))

/-- The prefix of `n` steps of a run of free branching on two values. -/
abbrev record (r : Run (Parting.free Bool)) (n : Nat) : List Bool :=
  Learning.prefixOf (Parting.course id r) n

/-- **The courses of `n` steps are exactly the prefixes of `n` steps of runs of free branching on
two values.** -/
theorem mem_courses_iff {n : Nat} {w : List Bool} :
    w ∈ Typicality.courses n ↔ ∃ r : Run (Parting.free Bool), record r n = w :=
  ⟨fun mem =>
    have len : w.length = n := Typicality.mem_courses_iff.mp mem
    ⟨Parting.freeRun (ofRecord w),
      Eq.subst (motive := fun k => Learning.prefixOf (ofRecord w) k = w) len (record_ofRecord w)⟩,
   fun ⟨_, same⟩ => Typicality.mem_courses_iff.mpr
    (Eq.subst (motive := fun k => k.length = n) same (Learning.prefix_length _ n))⟩

theorem distinct_extend : ∀ {ws : List (List Bool)}, Distinct ws →
    Distinct (Typicality.extend ws)
  | [], _ => trivial
  | w :: ws, ⟨out, rest⟩ =>
    have fresh : ∀ b, ¬ (b :: w) ∈ Typicality.extend ws := fun _ mem =>
      match Typicality.of_mem_extend mem with
      | ⟨_, _, same, inside⟩ =>
        out (Eq.subst (motive := fun x => x ∈ ws) (List.cons.inj same).2.symm inside)
    show ¬ (true :: w) ∈ (false :: w) :: Typicality.extend ws ∧
        (¬ (false :: w) ∈ Typicality.extend ws ∧
          Distinct (Typicality.extend ws)) from
    ⟨fun mem => match mem_cons_cases mem with
      | .inl same => Bool.noConfusion (List.cons.inj same).1
      | .inr inside => fresh true inside,
     ⟨fresh false, distinct_extend rest⟩⟩

theorem distinct_courses : ∀ n, Distinct (Typicality.courses n)
  | 0 => show ¬ ([] : List Bool) ∈ ([] : List (List Bool)) ∧ True from
      ⟨fun mem => (nomatch mem), trivial⟩
  | n + 1 => distinct_extend (distinct_courses n)

/-- `l` holds every prefix of `n` steps of the runs of free branching on two values once. -/
def Records (n : Nat) (l : List (List Bool)) : Prop :=
  Listing (fun w => ∃ r : Run (Parting.free Bool), record r n = w) l

/-- **The courses of `n` steps hold every prefix of `n` steps of the runs once.** -/
theorem courses_records (n : Nat) : Records n (Typicality.courses n) :=
  ⟨distinct_courses n, fun _ => mem_courses_iff⟩

/-! ## The counts of Typicality are counts of prefixes -/

section Counts

variable {n : Nat} {l : List (List Bool)}

/-- **There are `2 ^ n` prefixes of `n` steps of the runs of free branching on two values.** -/
theorem records_count (listed : Records n l) : l.length = 2 ^ n :=
  (length_listed listed (courses_records n)).trans (Typicality.courses_length n)

/-- **The prefixes of `n` steps weigh `(p + q) ^ n` together.** -/
theorem records_weight (listed : Records n l) (p q : Nat) :
    total l (Typicality.weight p q) = (p + q) ^ n :=
  (total_listing listed (courses_records n) _).trans (Typicality.total_weight p q n)

/-- **The sum over histories of `Becoming.Weighted` is the weight of the prefixes.** The sum over
the histories of `n` steps of free branching on two values, weighted by counting, is the total
weight of the prefixes of `n` steps of its runs. -/
theorem histories_records (listed : Records n l) (p q : Nat) (s : Bool) :
    counting.sum (Becoming.courses [()] [true, false] n)
        (counting.along (Typicality.stepWeight p q) (fun _ => 1) s) =
      total l (Typicality.weight p q) :=
  (Typicality.sum_courses_weight p q n s).trans (total_listing (courses_records n) listed _)

/-- **The spread over the prefixes of runs is exact.** Over the prefixes of `n` steps, each
weighted, `x·x + y·y` adds up to `2·x·y` plus `n·p·q·(p + q)^n`. -/
theorem records_spread (listed : Records n l) (p q : Nat) :
    total l (fun w => Typicality.weight p q w * Typicality.square p q w) =
      total l (fun w => Typicality.weight p q w * Typicality.cross p q w) +
        n * (p * q * (p + q) ^ n) :=
  (total_listing listed (courses_records n) _).trans
    ((Typicality.spread p q n).trans
      (congrArg (· + n * (p * q * (p + q) ^ n)) (total_listing (courses_records n) listed _)))

/-- **Most prefixes of runs show the weights.** The prefixes of `n` steps whose squared deviation
is at least `d` weigh, times `d`, at most `n·p·q·(p + q)^n`, out of `(p + q)^n` for all. -/
theorem records_typical (listed : Records n l) (p q d : Nat) :
    total l (Typicality.offBy p q d) * d ≤ n * (p * q * (p + q) ^ n) :=
  Eq.subst (motive := fun x => x * d ≤ n * (p * q * (p + q) ^ n))
    (total_listing (courses_records n) listed _) (Typicality.typical p q n d)

/-- **Concentration over the prefixes of runs is exponential.** For every `u ≥ v`, the prefixes of
`n` steps with at least `k` ones weigh, times `u ^ k · v ^ n`, at most `(p·u + q·v) ^ n · v ^ k`. -/
theorem records_concentrated (listed : Records n l) (p q k : Nat) {u v : Nat} (le : v ≤ u) :
    total l (Typicality.atLeast p q k) * (u ^ k * v ^ n) ≤ (p * u + q * v) ^ n * v ^ k :=
  Eq.subst (motive := fun x => x * (u ^ k * v ^ n) ≤ (p * u + q * v) ^ n * v ^ k)
    (total_listing (courses_records n) listed _) (Typicality.concentrated p q k n le)

/-- **Exponentially few runs run far ahead.** Of the `2 ^ n` prefixes of `n` steps, those with at
least `k` ones number, times `3 ^ k`, at most `4 ^ n`. -/
theorem records_few_far_ahead (listed : Records n l) (k : Nat) :
    total l (Typicality.atLeast 1 1 k) * 3 ^ k ≤ 4 ^ n :=
  Eq.subst (motive := fun x => x * 3 ^ k ≤ 4 ^ n)
    (total_listing (courses_records n) listed _) (Typicality.few_far_ahead k n)

end Counts

end TypicalRuns

end Becoming
