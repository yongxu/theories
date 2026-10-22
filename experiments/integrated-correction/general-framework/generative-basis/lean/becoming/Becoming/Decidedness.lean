import Becoming.Space
import Becoming.Recurrence

/-!
# Decidedness: what a count needs, and where

Ren, 11 October 2026: “i intuitively feel decidability is too dualist”, then “please” to the
suggestion that decidability be made local: no longer a commitment of the representation, each
law that counts or names a step stating decidedness where it counts, and every law that does not
need it stated without it (the zero-premise plan, (b2)).

A proposition is *decided* where it holds or fails (`Decided`). The core's logic does not assume
this of every proposition. A decision procedure (`Decidable`) gives it as data, and counting has
used one through `mark`. Here a count is a relation instead. A number *indicates* a proposition
where it is one and the proposition holds, or zero and it fails (`Indicates`). A number *counts*
the members of a list of which a determination holds where it sums their indicators (`Counts`),
and across a list of steps the counts at each step sum (`CountsAcross`).

* **A count exists exactly where what it counts is decided.** Something indicates a
  proposition exactly where the proposition is decided (`indicates_iff_decided`), and a count of
  a list exists exactly where each member is decided (`counts_iff_decided`). A count is one
  number (`Counts.unique`), and where a procedure decides, its marks are the count
  (`counts_total`, `counts_total`, `counts_total`). So the yes or no is needed only at what
  is counted, and only for the count to exist.
* **Counts obey the census with no premise.** Over a stretch, wherever the counts exist, the
  members holding at the end with those that ceased across it are those holding at the start
  with those that came to be (`Counts.over_stretch`). No decidedness is assumed, not even at the
  steps inside the stretch: decided there, the census holds (`Counts.over_stretch_decided`), that
  those finitely many states are decided cannot be refuted (`not_not_decided`), and an equation
  of numbers holds wherever its failure is refuted. Likewise, across one step
  (`Counts.across_step`), a count is at most the members (`Counts.le_length`), and comings and
  ceasings differ by at most the members (`CountsAcross.keep_pace`). Where what holds is listed at
  each step, each member once, the list at the end with what ceased is the list at the start with
  what came to be, across one step and over a stretch, again with no decidedness
  (`Counts.listed_across`, `Counts.listed_over_stretch`): a count is the length of a list of the
  members counted (`Counts.listing`), and two lists without repetition with the same members are
  equally long (`length_eq_of_same`).
* **Recurrence with no premise.** In a finite family, while nothing of it ceases each member
  comes to be at most once (`comes_once`), and while nothing comes to be each ceases at most
  once (`ceases_once_of`); so no more steps of a stretch see a member come to be, or cease, than
  the family has members (`coming_steps_within`, `ceasing_steps_within`). Hence, where coming to
  be recurs, from any step there is a stretch in which something ceasing cannot be refuted
  (`Recurs.ceasing_within`), and ceasing never stops for good (`Recurs.ceasing_not_stopping`);
  and conversely (`Recurs.coming_within`, `Recurs.coming_not_stopping`). No decidedness is used.
* **Decided where it is found.** With the states of that stretch decided, the step is found
  (`Recurs.ceasing_found`, `Recurs.coming_found`). Decided from some step on, coming to be
  recurs in a finite family exactly where ceasing does (`coming_recurs_iff_decided`), with no
  decision procedure; `coming_recurs_iff` in `Becoming.Change` asks a procedure at every step.
* **Finite worlds.** The same holds of a web with finitely many formations
  (`Web.unceasing_iff_decided`). In a finite world, where arising recurs, ceasing never stops
  for good, and conversely, with no decidedness (`World.ceasing_not_stopping`,
  `World.arising_not_stopping`); decided from some step on, arising recurs exactly when ceasing
  does (`World.arising_iff_ceasing_decided`), of which `World.arising_iff_ceasing` is the case
  decided by a procedure from the first step. With a
  list covering what is active from some step on, the same holds, decidedness asked only of the
  list's members (`World.ceasing_not_stopping_covered`, `World.arising_not_stopping_covered`,
  `World.arising_iff_ceasing_covered`).
* **Rest needs none.** The rest theorems of `Becoming.Space` and `Becoming.Openness`
  (`World.rests_unrefuted_covering`, `World.rests_unrefuted`, `World.comes_to_rest_unrefuted`,
  `World.rest_few`) use no decision procedure, and state
  that the world rests from some step on cannot be refuted (`World.RestsFrom`): that the falls of an
  amount that does not rise stop from some step on cannot be refuted, it not being the case that
  after every step from then on a later fall stays unrefuted (`falls_stop_unrefuted`,
  `stop_unrefuted_iff`), and that refutes the arising which ceasing recurring under a covering list
  leaves unrefuted after every step (`Covers.not_not_coming_from`).
* **Where decidedness is provably needed.** Asked of every finite world, the recurring form
  without decidedness is excluded middle (`World.law_iff_em`), and naming a last step is a
  principle of omniscience (`World.lpo_of_finite_ends`, `Listed.lpo_of_few`, `Web.lpo_of_ending`).
  The forms here that use no decidedness state that something is not refuted, or never stops
  for good, rather than at which step it happens.

* **Undominated members of a listed menu.** A nonempty listed menu under a relation that is
  irreflexive and transitive on it has a member no member betters, where whether one member
  betters another is weakly decided, its failure decided or refuted (`exists_undominated`). Every
  undominated member has a determination exactly where every member lacking it is bettered by some
  member (`undominated_has_iff`): one direction asks only that the relation be decided, the other
  only that the determination be, and without that gives it unrefuted (`Undominated.not_not_has`).
  Asked of every relation and determination, these are weak excluded middle and excluded middle
  (`exists_undominated_iff_weakly`, `undominated_has_iff_em`).

**AI reading, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D30).** The yes or
no of a state is not assumed of becoming. It is what an exact count needs, at the states counted,
and what finding a step needs, at the steps searched. Laws relating counts need none, and the laws
of recurrence hold with none, doubly negated.

Declarations moved here unchanged, with their names, from `Becoming.Likeness`, `Becoming.Joining`
and `Becoming.Coverage` (board item W): see the sections so headed.
* **Cases into a stable conclusion.** A conclusion following from a proposition and from its failure
  holds wherever it is stable, the proposition left undecided (`Decided.cases_stable`): every
  negation and every equation of numbers is stable.
-/

namespace Becoming

variable {α : Type}

/-! ## Decided, indicated, counted -/

/-- A proposition is decided: it holds or it fails. -/
def Decided (p : Prop) : Prop :=
  p ∨ ¬ p

/-- That a proposition is decided cannot be refuted. -/
theorem not_not_decided (p : Prop) : ¬ ¬ Decided p :=
  fun refuted => refuted (.inr fun holds => refuted (.inl holds))

/-- **Arguing by cases into a stable conclusion.** Where a conclusion follows from a proposition
and from its failure, it holds wherever it is stable, with the proposition left undecided: that
the proposition is decided cannot be refuted (`not_not_decided`). Every negation, and every
equation of numbers, is stable. -/
theorem Decided.cases_stable {p q : Prop} (stable : ¬ ¬ q → q) (yes : p → q) (no : ¬ p → q) : q :=
  stable fun fails => not_not_decided p fun decided => match decided with
    | .inl holds => fails (yes holds)
    | .inr refuted => fails (no refuted)

/-- A decided proposition holds wherever its failure is refuted. -/
theorem Decided.of_not_not {p : Prop} (decided : Decided p) (not_not : ¬ ¬ p) : p :=
  match decided with
  | .inl holds => holds
  | .inr fails => absurd fails not_not

/-- Two decided propositions decide their conjunction. -/
theorem Decided.and {p q : Prop} (first : Decided p) (second : Decided q) : Decided (p ∧ q) :=
  match first, second with
  | .inl holds, .inl holds' => .inl ⟨holds, holds'⟩
  | .inr fails, _ => .inr fun both => fails both.1
  | _, .inr fails => .inr fun both => fails both.2

/-- A decided proposition decides its negation. -/
theorem Decided.not {p : Prop} (decided : Decided p) : Decided (¬ p) :=
  match decided with
  | .inl holds => .inr fun fails => fails holds
  | .inr fails => .inl fails

/-- Decided at each member of a list, a determination decides whether it holds of some member. -/
theorem Decided.exists_mem {β : Type} {P : β → Prop} :
    ∀ {l : List β}, (∀ b, b ∈ l → Decided (P b)) → Decided (∃ b, b ∈ l ∧ P b)
  | [], _ => .inr fun ⟨_, mem, _⟩ => nomatch mem
  | b :: l, decided => match decided b (.head l) with
    | .inl holds => .inl ⟨b, .head l, holds⟩
    | .inr fails => match Decided.exists_mem (l := l) fun c mem => decided c (.tail b mem) with
      | .inl ⟨c, mem, holds⟩ => .inl ⟨c, .tail b mem, holds⟩
      | .inr absent => .inr fun ⟨c, mem, holds⟩ => match mem_cons_cases mem with
        | .inl same => fails (Eq.subst (motive := P) same holds)
        | .inr mem => absent ⟨c, mem, holds⟩

/-- Decided at each step from `M` up to `U`, a determination decides whether it holds at one. -/
theorem Decided.exists_below {P : Nat → Prop} {M : Nat} :
    ∀ {U : Nat}, (∀ t, M ≤ t → t < U → Decided (P t)) → Decided (∃ t, M ≤ t ∧ t < U ∧ P t)
  | 0, _ => .inr fun ⟨t, _, below, _⟩ => Nat.not_lt_zero t below
  | U + 1, decided =>
    match Decided.exists_below (U := U) fun t from_ below => decided t from_ (Nat.lt_succ_of_lt below) with
    | .inl ⟨t, from_, below, holds⟩ => .inl ⟨t, from_, Nat.lt_succ_of_lt below, holds⟩
    | .inr absent => match Nat.decLe M U with
      | isFalse late => .inr fun ⟨t, from_, below, holds⟩ => match Nat.lt_or_ge t U with
        | .inl early => absent ⟨t, from_, early, holds⟩
        | .inr _ => late (Nat.le_trans from_ (Nat.le_of_lt_succ below))
      | isTrue from_ => match decided U from_ (Nat.lt_succ_self U) with
        | .inl holds => .inl ⟨U, from_, Nat.lt_succ_self U, holds⟩
        | .inr fails => .inr fun ⟨t, from', below, holds⟩ => match Nat.lt_or_ge t U with
          | .inl early => absent ⟨t, from', early, holds⟩
          | .inr after =>
            fails (Eq.subst (motive := P) (Nat.le_antisymm (Nat.le_of_lt_succ below) after) holds)

/-- `k` indicates `p`: it is one where `p` holds and zero where `p` fails. -/
def Indicates (p : Prop) (k : Nat) : Prop :=
  (p ∧ k = 1) ∨ (¬ p ∧ k = 0)

/-- Something indicates a proposition exactly where the proposition is decided. -/
theorem indicates_iff_decided {p : Prop} : (∃ k, Indicates p k) ↔ Decided p :=
  ⟨fun ⟨_, indicates⟩ => match indicates with
    | .inl ⟨holds, _⟩ => .inl holds
    | .inr ⟨fails, _⟩ => .inr fails,
   fun decided => match decided with
    | .inl holds => ⟨1, .inl ⟨holds, rfl⟩⟩
    | .inr fails => ⟨0, .inr ⟨fails, rfl⟩⟩⟩

namespace Indicates

variable {p : Prop} {k : Nat}

theorem eq_one (indicates : Indicates p k) (holds : p) : k = 1 :=
  match indicates with
  | .inl ⟨_, one⟩ => one
  | .inr ⟨fails, _⟩ => absurd holds fails

theorem eq_zero (indicates : Indicates p k) (fails : ¬ p) : k = 0 :=
  match indicates with
  | .inl ⟨holds, _⟩ => absurd holds fails
  | .inr ⟨_, zero⟩ => zero

/-- What indicates a proposition is one number. -/
theorem unique {k' : Nat} (indicates : Indicates p k) (indicates' : Indicates p k') : k = k' :=
  match indicates with
  | .inl ⟨holds, one⟩ => one.trans (indicates'.eq_one holds).symm
  | .inr ⟨fails, zero⟩ => zero.trans (indicates'.eq_zero fails).symm

theorem le_one (indicates : Indicates p k) : k ≤ 1 :=
  match indicates with
  | .inl ⟨_, one⟩ => Nat.le_of_eq one
  | .inr ⟨_, zero⟩ => Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le 1)

theorem holds_of_pos (indicates : Indicates p k) (pos : 0 < k) : p :=
  match indicates with
  | .inl ⟨holds, _⟩ => holds
  | .inr ⟨_, zero⟩ => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq zero)) (Nat.lt_irrefl 0)

theorem decided (indicates : Indicates p k) : Decided p :=
  indicates_iff_decided.mp ⟨k, indicates⟩

end Indicates

/-- A decision procedure's mark indicates what it decides. -/
theorem indicates_mark (p : Prop) [Decidable p] : Indicates p (mark p) :=
  mark_cases (q := Indicates p) (fun holds => .inl ⟨holds, rfl⟩) fun fails => .inr ⟨fails, rfl⟩

/-- `n` counts the members of a list of which `q` holds: it sums their indicators. A count as a
relation; no decision procedure is used. -/
def Counts : List α → (α → Prop) → Nat → Prop
  | [], _, n => n = 0
  | a :: as, q, n => ∃ k m, Indicates (q a) k ∧ Counts as q m ∧ n = k + m

/-- A count of a list exists exactly where each member is decided. -/
theorem counts_iff_decided {q : α → Prop} : ∀ {as : List α},
    (∃ n, Counts as q n) ↔ ∀ a, a ∈ as → Decided (q a)
  | [] => ⟨(fun _ _ mem => nomatch mem), fun _ => ⟨0, rfl⟩⟩
  | a :: as => ⟨fun ⟨_, _, m, indicates, rest, _⟩ b mem => match mem_cons_cases mem with
      | .inl same => Eq.subst (motive := fun x => Decided (q x)) same.symm indicates.decided
      | .inr mem => (counts_iff_decided (as := as)).mp ⟨m, rest⟩ b mem,
     fun decided => match indicates_iff_decided.mpr (decided a (.head as)),
         (counts_iff_decided (as := as)).mpr fun b mem => decided b (.tail a mem) with
       | ⟨k, indicates⟩, ⟨m, rest⟩ => ⟨k + m, k, m, indicates, rest, rfl⟩⟩

namespace Counts

variable {q : α → Prop}

/-- A count is one number. -/
theorem unique : ∀ {as : List α} {n n' : Nat}, Counts as q n → Counts as q n' → n = n'
  | [], _, _, zero, zero' => zero.trans zero'.symm
  | _ :: _, _, _, ⟨_, m, indicates, rest, sum⟩, ⟨k', _, indicates', rest', sum'⟩ =>
    sum.trans (((congrArg (· + m) (indicates.unique indicates')).trans
      (congrArg (k' + ·) (unique rest rest'))).trans sum'.symm)

/-- A count is at most the members. -/
theorem le_length : ∀ {as : List α} {n : Nat}, Counts as q n → n ≤ as.length
  | [], _, zero => Nat.le_of_eq zero
  | _ :: _, _, ⟨_, _, indicates, rest, sum⟩ =>
    Nat.le_trans (Nat.le_of_eq sum) (Nat.le_trans (Nat.add_le_add indicates.le_one rest.le_length)
      (Nat.le_of_eq (Nat.add_comm 1 _)))

/-- A positive count has a member of which `q` holds. -/
theorem exists_of_pos : ∀ {as : List α} {n : Nat}, Counts as q n → 0 < n → ∃ a, a ∈ as ∧ q a
  | [], _, zero, pos => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq zero)) (Nat.lt_irrefl 0)
  | a :: _, _, ⟨k, m, indicates, rest, sum⟩, pos => match Nat.eq_zero_or_pos k with
    | .inr positive => ⟨a, .head _, indicates.holds_of_pos positive⟩
    | .inl zero => match exists_of_pos rest (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        (sum.trans ((congrArg (· + m) zero).trans (Nat.zero_add m))))) with
      | ⟨b, mem, holds⟩ => ⟨b, .tail a mem, holds⟩

/-- A member of which `q` holds makes a count positive. -/
theorem pos_of_mem : ∀ {as : List α} {n : Nat}, Counts as q n → ∀ {a : α}, a ∈ as → q a → 0 < n
  | [], _, _, _, mem, _ => nomatch mem
  | _ :: _, _, ⟨k, m, indicates, rest, sum⟩, _, mem, holds => match mem_cons_cases mem with
    | .inl same => Nat.lt_of_lt_of_le
        (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq
          (indicates.eq_one (Eq.subst (motive := q) same holds)).symm))
        (Nat.le_trans (Nat.le_add_right k m) (Nat.le_of_eq sum.symm))
    | .inr mem => Nat.lt_of_lt_of_le (pos_of_mem rest mem holds)
        (Nat.le_trans (Nat.le_add_left m k) (Nat.le_of_eq sum.symm))

/-- Where `q` holds of no member, a count is zero. -/
theorem eq_zero {as : List α} {n : Nat} (counts : Counts as q n) (fails : ∀ a, a ∈ as → ¬ q a) :
    n = 0 :=
  match Nat.eq_zero_or_pos n with
  | .inl zero => zero
  | .inr pos => match counts.exists_of_pos pos with
    | ⟨a, mem, holds⟩ => absurd holds (fails a mem)

end Counts

/-- Where a procedure decides each member, the total of its marks is the count. -/
theorem counts_total {q : α → Prop} [∀ a, Decidable (q a)] :
    ∀ as : List α, Counts as q (total as fun a => mark (q a))
  | [] => rfl
  | a :: as => ⟨mark (q a), total as (fun a => mark (q a)), indicates_mark (q a), counts_total as,
      rfl⟩

/-- `n` totals, across a list of steps, the counts of `q t` on the members `fam t` listed at each
step `t`. -/
def CountsAcross (fam : Nat → List α) (q : Nat → α → Prop) : List Nat → Nat → Prop
  | [], n => n = 0
  | t :: ts, n => ∃ k m, Counts (fam t) (q t) k ∧ CountsAcross fam q ts m ∧ n = k + m

/-! ## The census with no premise -/

section Census

variable {p : α → Nat → Prop}

/-- Across a step, wherever the four counts exist, the members holding after it with those that
ceased are those holding before it with those that came to be. No premise. -/
theorem Counts.across_step {t : Nat} : ∀ {as : List α} {h h' c d : Nat},
    Counts as (fun a => p a t) h → Counts as (fun a => p a (t + 1)) h' →
    Counts as (fun a => ComesToBe (p a) t) c → Counts as (fun a => CeasesToBe (p a) t) d →
    h' + d = h + c
  | [], h, _, _, d, now, next, came, ceased =>
    (congrArg (· + d) (next.trans now.symm)).trans (congrArg (h + ·) (ceased.trans came.symm))
  | _ :: _, _, _, c, d, ⟨k, m, held, now, sum⟩, ⟨k', m', holds, next, sum'⟩,
      ⟨kc, mc, comes, came, sumc⟩, ⟨kd, md, ceases, ceased, sumd⟩ =>
    have head : k' + kd = k + kc := match held, holds with
      | .inl ⟨was, one⟩, .inl ⟨is, one'⟩ =>
        (congrArg (· + kd) (one'.trans one.symm)).trans (congrArg (k + ·)
          ((ceases.eq_zero fun ceased => ceased.2 is).trans
            (comes.eq_zero fun came => came.1 was).symm))
      | .inl ⟨was, one⟩, .inr ⟨isNot, zero'⟩ =>
        ((congrArg (· + kd) zero').trans (congrArg (0 + ·) (ceases.eq_one ⟨was, isNot⟩))).trans
          ((congrArg (· + kc) one).trans (congrArg (1 + ·)
            (comes.eq_zero fun came => came.1 was))).symm
      | .inr ⟨wasNot, zero⟩, .inl ⟨is, one'⟩ =>
        ((congrArg (· + kd) one').trans (congrArg (1 + ·)
          (ceases.eq_zero fun ceased => wasNot ceased.1))).trans
          ((congrArg (· + kc) zero).trans (congrArg (0 + ·) (comes.eq_one ⟨wasNot, is⟩))).symm
      | .inr ⟨wasNot, zero⟩, .inr ⟨isNot, zero'⟩ =>
        (congrArg (· + kd) (zero'.trans zero.symm)).trans (congrArg (k + ·)
          ((ceases.eq_zero fun ceased => wasNot ceased.1).trans
            (comes.eq_zero fun came => isNot came.2).symm))
    have tail : m' + md = m + mc := Counts.across_step now next came ceased
    calc _ = (k' + m') + (kd + md) := (congrArg (· + d) sum').trans (congrArg (k' + m' + ·) sumd)
      _ = (k' + kd) + (m' + md) := Nat.add_add_add_comm k' m' kd md
      _ = (k + kc) + (m + mc) := (congrArg (· + (m' + md)) head).trans (congrArg (k + kc + ·) tail)
      _ = (k + m) + (kc + mc) := Nat.add_add_add_comm k kc m mc
      _ = _ := ((congrArg (· + c) sum).trans (congrArg (k + m + ·) sumc)).symm

/-- The step after `S` and `n` more is the step after `S + 1` and `n`. -/
theorem shift_succ (S n : Nat) : S + (n + 1) = S + 1 + n :=
  (congrArg (S + ·) (Nat.add_comm n 1)).trans (Nat.add_assoc S 1 n).symm

/-- Over a stretch whose states are decided at each of its steps, wherever the counts exist, the
members holding at the end with those that ceased across it are those holding at the start with
those that came to be. -/
theorem Counts.over_stretch_decided {as : List α} : ∀ {S : Nat} (n : Nat) {h h' A D : Nat},
    (∀ a, a ∈ as → ∀ t, t ∈ steps S (n + 1) → Decided (p a t)) →
    Counts as (fun a => p a S) h → Counts as (fun a => p a (S + n)) h' →
    CountsAcross (fun _ => as) (fun t a => ComesToBe (p a) t) (steps S n) A →
    CountsAcross (fun _ => as) (fun t a => CeasesToBe (p a) t) (steps S n) D →
    h' + D = h + A
  | _, 0, h, _, _, D, _, start, finish, came, ceased =>
    (congrArg (· + D) (finish.unique start)).trans (congrArg (h + ·) (ceased.trans came.symm))
  | S, n + 1, h, h', A, D, decided, start, finish, ⟨c, A', comes, came, sumA⟩,
      ⟨d, D', ceases, ceased, sumD⟩ =>
    match (counts_iff_decided (q := fun a => p a (S + 1))).mpr
        fun a mem => decided a mem (S + 1) (.tail _ (.head _)) with
    | ⟨h₁, next⟩ =>
      have step : h₁ + d = h + c := Counts.across_step start next comes ceases
      have rest : h' + D' = h₁ + A' := Counts.over_stretch_decided (S := S + 1) n
        (fun a mem t member => decided a mem t (.tail _ member)) next
        (Eq.subst (motive := fun x => Counts as (fun a => p a x) h') (shift_succ S n) finish)
        came ceased
      calc h' + D = h' + (d + D') := congrArg (h' + ·) sumD
        _ = d + (h' + D') := Nat.add_left_comm h' d D'
        _ = d + (h₁ + A') := congrArg (d + ·) rest
        _ = (h₁ + d) + A' := (Nat.add_assoc d h₁ A').symm.trans (congrArg (· + A') (Nat.add_comm d h₁))
        _ = (h + c) + A' := congrArg (· + A') step
        _ = h + (c + A') := Nat.add_assoc h c A'
        _ = h + A := congrArg (h + ·) sumA.symm

/-- The census with no premise. Over a stretch, wherever the counts exist, the members holding at
the end with those that ceased across it are those holding at the start with those that came to
be. No decidedness is assumed of the steps inside the stretch: decided there, the census holds,
and that they are decided cannot be refuted. -/
theorem Counts.over_stretch {as : List α} {S n h h' A D : Nat}
    (start : Counts as (fun a => p a S) h) (finish : Counts as (fun a => p a (S + n)) h')
    (came : CountsAcross (fun _ => as) (fun t a => ComesToBe (p a) t) (steps S n) A)
    (ceased : CountsAcross (fun _ => as) (fun t a => CeasesToBe (p a) t) (steps S n) D) :
    h' + D = h + A :=
  Decidable.of_not_not fun differs =>
    not_not_all (E := as) (P := fun a => ∀ t, t ∈ steps S (n + 1) → Decided (p a t))
      (fun a _ => not_not_all (E := steps S (n + 1)) (P := fun t => Decided (p a t))
        fun t _ => not_not_decided (p a t))
      fun decided => differs (Counts.over_stretch_decided n decided start finish came ceased)

/-- Over any stretch, wherever comings and ceasings are counted, they differ by at most the
members. No premise. -/
theorem CountsAcross.keep_pace {as : List α} {S n A D : Nat}
    (came : CountsAcross (fun _ => as) (fun t a => ComesToBe (p a) t) (steps S n) A)
    (ceased : CountsAcross (fun _ => as) (fun t a => CeasesToBe (p a) t) (steps S n) D) :
    A ≤ as.length + D ∧ D ≤ as.length + A :=
  Decidable.of_not_not fun beyond =>
    not_not_all (E := as) (P := fun a => Decided (p a S)) (fun _ _ => not_not_decided _)
      fun first =>
    not_not_all (E := as) (P := fun a => Decided (p a (S + n))) (fun _ _ => not_not_decided _)
      fun last =>
      match (counts_iff_decided (q := fun a => p a S)).mpr first,
          (counts_iff_decided (q := fun a => p a (S + n))).mpr last with
      | ⟨h, start⟩, ⟨h', finish⟩ =>
        have balance : h' + D = h + A := Counts.over_stretch start finish came ceased
        beyond ⟨Nat.le_trans (Nat.le_add_left A h) (Nat.le_trans (Nat.le_of_eq balance.symm)
            (Nat.add_le_add_right finish.le_length D)),
          Nat.le_trans (Nat.le_add_left D h') (Nat.le_trans (Nat.le_of_eq balance)
            (Nat.add_le_add_right start.le_length A))⟩

end Census

/-! ## Listed determinations -/

section Listed

/-- Where `q` holds of every member, the count is the number of members. -/
theorem Counts.of_all {q : α → Prop} : ∀ {as : List α}, (∀ a, a ∈ as → q a) → Counts as q as.length
  | [], _ => rfl
  | a :: as, all => ⟨1, as.length, .inl ⟨all a (.head as), rfl⟩,
      Counts.of_all fun b mem => all b (.tail a mem), Nat.add_comm _ _⟩

/-- Where `q` holds of no member, the count is zero. -/
theorem Counts.of_none {q : α → Prop} : ∀ {as : List α}, (∀ a, a ∈ as → ¬ q a) → Counts as q 0
  | [], _ => rfl
  | a :: as, fails => ⟨0, 0, .inr ⟨fails a (.head as), rfl⟩,
      Counts.of_none fun b mem => fails b (.tail a mem), rfl⟩

/-- A count is the length of a list of exactly the members counted, without repetition where the
members have none. -/
theorem Counts.listing {q : α → Prop} : ∀ {as : List α} {n : Nat}, Counts as q n →
    ∃ s : List α, s.length = n ∧ (∀ a, a ∈ s ↔ a ∈ as ∧ q a) ∧ (Distinct as → Distinct s)
  | [], _, zero => ⟨[], zero.symm, fun _ => ⟨(fun mem => nomatch mem), fun ⟨mem, _⟩ => nomatch mem⟩,
      fun _ => trivial⟩
  | a :: _, _, ⟨_, m, indicates, rest, sum⟩ => match Counts.listing rest with
    | ⟨s, length, members, distinct⟩ => match indicates with
      | .inl ⟨holds, one⟩ =>
        ⟨a :: s, (congrArg (· + 1) length).trans ((Nat.add_comm m 1).trans
            ((congrArg (· + m) one).symm.trans sum.symm)),
         fun b => ⟨fun mem => match mem_cons_cases mem with
            | .inl same => ⟨Eq.subst (motive := fun x => x ∈ a :: _) same.symm (.head _),
                Eq.subst (motive := q) same.symm holds⟩
            | .inr mem => match (members b).mp mem with
              | ⟨inRest, qb⟩ => ⟨.tail a inRest, qb⟩,
           fun ⟨mem, qb⟩ => match mem_cons_cases mem with
            | .inl same => Eq.subst (motive := fun x => x ∈ a :: s) same.symm (.head s)
            | .inr mem => .tail a ((members b).mpr ⟨mem, qb⟩)⟩,
         fun ⟨fresh, tail⟩ => ⟨fun mem => fresh ((members a).mp mem).1, distinct tail⟩⟩
      | .inr ⟨fails, zero⟩ =>
        ⟨s, length.trans ((Nat.zero_add m).symm.trans ((congrArg (· + m) zero).symm.trans sum.symm)),
         fun b => ⟨fun mem => match (members b).mp mem with
            | ⟨inRest, qb⟩ => ⟨.tail a inRest, qb⟩,
           fun ⟨mem, qb⟩ => match mem_cons_cases mem with
            | .inl same => absurd (Eq.subst (motive := q) same qb) fails
            | .inr mem => (members b).mpr ⟨mem, qb⟩⟩,
         fun ⟨_, tail⟩ => distinct tail⟩

/-- Two lists without repetition with the same members are equally long. -/
theorem length_eq_of_same {s s' : List α} (distinct : Distinct s) (distinct' : Distinct s')
    (same : ∀ a, a ∈ s ↔ a ∈ s') : s.length = s'.length :=
  Nat.le_antisymm (length_le_of_sub distinct fun a mem => (same a).mp mem)
    (length_le_of_sub distinct' fun a mem => (same a).mpr mem)

variable {p : α → Nat → Prop} {l : Nat → List α}

/-- The census across a step, where what holds is listed at the step's two ends, each member
once: wherever ceasings and comings are counted, the list after the step with what ceased is the
list before it with what came to be. No decidedness is assumed. -/
theorem Counts.listed_across {t c d : Nat} (now : Distinct (l t) ∧ ∀ a, p a t ↔ a ∈ l t)
    (next : Distinct (l (t + 1)) ∧ ∀ a, p a (t + 1) ↔ a ∈ l (t + 1))
    (ceased : Counts (l t) (fun a => CeasesToBe (p a) t) d)
    (came : Counts (l (t + 1)) (fun a => ComesToBe (p a) t) c) :
    (l (t + 1)).length + d = (l t).length + c :=
  Decidable.of_not_not fun differs =>
    not_not_all (E := l t) (P := fun a => Decided (p a (t + 1))) (fun _ _ => not_not_decided _)
      fun after =>
    not_not_all (E := l (t + 1)) (P := fun a => Decided (p a t)) (fun _ _ => not_not_decided _)
      fun before =>
    match (counts_iff_decided (q := fun a => p a (t + 1))).mpr after,
        (counts_iff_decided (q := fun a => p a t)).mpr before with
    | ⟨kept, keptAfter⟩, ⟨kept', keptBefore⟩ =>
      have first : kept + d = (l t).length + 0 :=
        Counts.across_step (p := p) (Counts.of_all fun a mem => (now.2 a).mpr mem) keptAfter
          (Counts.of_none fun a mem comes => comes.1 ((now.2 a).mpr mem)) ceased
      have second : (l (t + 1)).length + 0 = kept' + c :=
        Counts.across_step (p := p) keptBefore (Counts.of_all fun a mem => (next.2 a).mpr mem) came
          (Counts.of_none fun a mem ceases => ceases.2 ((next.2 a).mpr mem))
      have same : kept = kept' := match keptAfter.listing, keptBefore.listing with
        | ⟨_, length, members, distinct⟩, ⟨_, length', members', distinct'⟩ =>
          length.symm.trans ((length_eq_of_same (distinct now.1) (distinct' next.1) fun a =>
            ⟨fun mem => match (members a).mp mem with
              | ⟨inNow, holdsNext⟩ => (members' a).mpr ⟨(next.2 a).mp holdsNext, (now.2 a).mpr inNow⟩,
             fun mem => match (members' a).mp mem with
              | ⟨inNext, holdsNow⟩ => (members a).mpr ⟨(now.2 a).mp holdsNow, (next.2 a).mpr inNext⟩⟩).trans
            length')
      differs (calc (l (t + 1)).length + d = (kept' + c) + d := congrArg (· + d) second
        _ = (kept + c) + d := congrArg (· + c + d) same.symm
        _ = (kept + d) + c := Nat.add_right_comm kept c d
        _ = (l t).length + c := congrArg (· + c) first)

/-- The census over a stretch, where what holds is listed at each of its steps, each member once:
wherever ceasings and comings are counted across it, the list at the end with what ceased is the
list at the start with what came to be. No decidedness is assumed. -/
theorem Counts.listed_over_stretch : ∀ {S : Nat} (n : Nat) {A D : Nat},
    (∀ s, S ≤ s → s ≤ S + n → Distinct (l s) ∧ ∀ a, p a s ↔ a ∈ l s) →
    CountsAcross l (fun t a => CeasesToBe (p a) t) (steps S n) D →
    CountsAcross (fun t => l (t + 1)) (fun t a => ComesToBe (p a) t) (steps S n) A →
    (l (S + n)).length + D = (l S).length + A
  | _, 0, _, _, _, ceased, came =>
    congrArg ((l _).length + ·) (ceased.trans came.symm)
  | S, n + 1, A, D, listing, ⟨d, D', ceases, ceased, sumD⟩, ⟨c, A', comes, came, sumA⟩ =>
    have step : (l (S + 1)).length + d = (l S).length + c :=
      Counts.listed_across (listing S (Nat.le_refl S) (Nat.le_add_right S (n + 1)))
        (listing (S + 1) (Nat.le_succ S) (Nat.succ_le_succ (Nat.le_add_right S n))) ceases comes
    have rest : (l (S + 1 + n)).length + D' = (l (S + 1)).length + A' :=
      Counts.listed_over_stretch (S := S + 1) n
        (fun s lo hi => listing s (Nat.le_trans (Nat.le_succ S) lo)
          (Nat.le_trans hi (Nat.le_of_eq (shift_succ S n).symm))) ceased came
    calc (l (S + (n + 1))).length + D = (l (S + 1 + n)).length + (d + D') :=
        (congrArg (fun x => (l x).length + D) (shift_succ S n)).trans (congrArg (_ + ·) sumD)
      _ = d + ((l (S + 1 + n)).length + D') := Nat.add_left_comm _ d D'
      _ = d + ((l (S + 1)).length + A') := congrArg (d + ·) rest
      _ = ((l (S + 1)).length + d) + A' :=
        (Nat.add_assoc d _ A').symm.trans (congrArg (· + A') (Nat.add_comm d _))
      _ = ((l S).length + c) + A' := congrArg (· + A') step
      _ = (l S).length + A := (Nat.add_assoc _ c A').trans (congrArg (_ + ·) sumA.symm)

end Listed

/-! ## Recurrence with no premise -/

section Recurrence

/-- What holds at `S` and ceases at none of the `n` steps from `S` is not refuted to hold at
`S + n`. No decidedness is needed. -/
theorem holds_on {q : Nat → Prop} {S : Nat} (holds : q S) :
    ∀ n, (∀ k, k < n → ¬ CeasesToBe q (S + k)) → ¬ ¬ q (S + n)
  | 0, _ => fun fails => fails holds
  | n + 1, still => fun fails => holds_on holds n (fun k below => still k (Nat.lt_succ_of_lt below))
      fun held => still n (Nat.lt_succ_self n) ⟨held, fails⟩

/-- While a determination does not cease, what came to be does not come to be again. No
decidedness is needed. -/
theorem comes_once {q : Nat → Prop} {t t' : Nat} (before : t < t') (comes : ComesToBe q t)
    (still : ∀ s, t < s → s < t' → ¬ CeasesToBe q s) : ¬ ComesToBe q t' :=
  fun again => match le_dest before with
  | ⟨k, same⟩ => holds_on comes.2 k
      (fun j below => still (t + 1 + j)
        (Nat.lt_of_lt_of_le (Nat.lt_succ_self t) (Nat.le_add_right (t + 1) j))
        (Eq.subst (motive := fun x => t + 1 + j < x) same.symm (Nat.add_lt_add_left below (t + 1))))
      (Eq.subst (motive := fun x => ¬ q x) same again.1)

/-- While a determination does not come to be, what ceased does not cease again. No decidedness
is needed. -/
theorem ceases_once_of {q : Nat → Prop} {t t' : Nat} (before : t < t') (ceases : CeasesToBe q t)
    (still : ∀ s, t < s → s < t' → ¬ ComesToBe q s) : ¬ CeasesToBe q t' :=
  fun again => match le_dest before with
  | ⟨k, same⟩ => stays_failing_within (S := t + 1) ceases.2 (n := k)
      (fun j below => still (t + 1 + j)
        (Nat.lt_of_lt_of_le (Nat.lt_succ_self t) (Nat.le_add_right (t + 1) j))
        (Eq.subst (motive := fun x => t + 1 + j < x) same.symm (Nat.add_lt_add_left below (t + 1))))
      k (Nat.le_refl k) (Eq.subst (motive := q) same again.1)

variable {as : List α} {p : α → Nat → Prop}

/-- In a finite family, while nothing of it ceases across a stretch, no more steps of the stretch
see a member come to be than the family has members. No decidedness is needed. -/
theorem coming_steps_within {M U : Nat}
    (still : ∀ s a, M ≤ s → s < U → a ∈ as → ¬ CeasesToBe (p a) s) {E : List Nat}
    (distinct : Distinct E)
    (coming : ∀ t, t ∈ E → M ≤ t ∧ t < U ∧ ∃ a, a ∈ as ∧ ComesToBe (p a) t) :
    E.length ≤ as.length :=
  length_le_of_matched (S := fun t a => a ∈ as ∧ ComesToBe (p a) t) distinct
    (fun t mem => match (coming t mem).2.2 with
      | ⟨a, member, comes⟩ => ⟨a, member, member, comes⟩)
    fun t t' a mem mem' ⟨member, comes⟩ ⟨_, comes'⟩ => match Nat.lt_or_ge t t' with
      | .inl before => absurd comes' (comes_once before comes fun s after below =>
          still s a (Nat.le_trans (coming t mem).1 (Nat.le_of_lt after))
            (Nat.lt_trans below (coming t' mem').2.1) member)
      | .inr after => match Nat.lt_or_ge t' t with
        | .inl before => absurd comes (comes_once before comes' fun s after' below =>
            still s a (Nat.le_trans (coming t' mem').1 (Nat.le_of_lt after'))
              (Nat.lt_trans below (coming t mem).2.1) member)
        | .inr after' => Nat.le_antisymm after' after

/-- In a finite family, while nothing of it comes to be across a stretch, no more steps of the
stretch see a member cease than the family has members. No decidedness is needed. -/
theorem ceasing_steps_within {M U : Nat}
    (still : ∀ s a, M ≤ s → s < U → a ∈ as → ¬ ComesToBe (p a) s) {E : List Nat}
    (distinct : Distinct E)
    (ceasing : ∀ t, t ∈ E → M ≤ t ∧ t < U ∧ ∃ a, a ∈ as ∧ CeasesToBe (p a) t) :
    E.length ≤ as.length :=
  length_le_of_matched (S := fun t a => a ∈ as ∧ CeasesToBe (p a) t) distinct
    (fun t mem => match (ceasing t mem).2.2 with
      | ⟨a, member, ceases⟩ => ⟨a, member, member, ceases⟩)
    fun t t' a mem mem' ⟨member, ceases⟩ ⟨_, ceases'⟩ => match Nat.lt_or_ge t t' with
      | .inl before => absurd ceases' (ceases_once_of before ceases fun s after below =>
          still s a (Nat.le_trans (ceasing t mem).1 (Nat.le_of_lt after))
            (Nat.lt_trans below (ceasing t' mem').2.1) member)
      | .inr after => match Nat.lt_or_ge t' t with
        | .inl before => absurd ceases (ceases_once_of before ceases' fun s after' below =>
            still s a (Nat.le_trans (ceasing t' mem').1 (Nat.le_of_lt after'))
              (Nat.lt_trans below (ceasing t mem).2.1) member)
        | .inr after' => Nat.le_antisymm after' after

/-- Where an event of a finite family recurs, any number of distinct steps from `M` see it, all
before some step. -/
theorem Recurs.steps_found {e : α → Nat → Prop} (recurs : Recurs as e) (M : Nat) :
    ∀ k, ∃ E U, Distinct E ∧ E.length = k ∧ M ≤ U ∧
      ∀ t, t ∈ E → M ≤ t ∧ t < U ∧ ∃ a, a ∈ as ∧ e a t
  | 0 => ⟨[], M, trivial, rfl, Nat.le_refl M, fun _ mem => nomatch mem⟩
  | k + 1 => match Recurs.steps_found recurs M k with
    | ⟨E, U, distinct, length, from_, all⟩ => match recurs U with
      | ⟨t, a, later, member, happens⟩ =>
        ⟨t :: E, t + 1,
         ⟨fun mem => Nat.lt_irrefl t (Nat.lt_of_lt_of_le (all t mem).2.1 later), distinct⟩,
         congrArg Nat.succ length,
         Nat.le_trans from_ (Nat.le_trans later (Nat.le_succ t)),
         fun s mem => match mem_cons_cases mem with
           | .inl same => Eq.subst (motive := fun x => M ≤ x ∧ x < t + 1 ∧ ∃ a, a ∈ as ∧ e a x)
               same.symm ⟨Nat.le_trans from_ later, Nat.lt_succ_self t, a, member, happens⟩
           | .inr mem => ⟨(all s mem).1,
               Nat.lt_of_lt_of_le (all s mem).2.1 (Nat.le_trans later (Nat.le_succ t)),
               (all s mem).2.2⟩⟩

/-- Where coming to be recurs in a finite family, from any step there is a stretch in which
something of the family ceasing cannot be refuted. No decidedness is needed. -/
theorem Recurs.ceasing_within (coming : Recurs as fun a => ComesToBe (p a)) (M : Nat) :
    ∃ U, M ≤ U ∧ ¬ ¬ ∃ t, M ≤ t ∧ t < U ∧ ∃ a, a ∈ as ∧ CeasesToBe (p a) t :=
  match coming.steps_found M (as.length + 1) with
  | ⟨_, U, distinct, length, from_, all⟩ =>
    ⟨U, from_, fun nothing => Nat.not_succ_le_self as.length (Nat.le_trans (Nat.le_of_eq length.symm)
      (coming_steps_within (U := U)
        (fun s a lo hi mem ceases => nothing ⟨s, lo, hi, a, mem, ceases⟩) distinct all))⟩

/-- Where ceasing recurs in a finite family, from any step there is a stretch in which something
of the family coming to be cannot be refuted. No decidedness is needed. -/
theorem Recurs.coming_within (ceasing : Recurs as fun a => CeasesToBe (p a)) (M : Nat) :
    ∃ U, M ≤ U ∧ ¬ ¬ ∃ t, M ≤ t ∧ t < U ∧ ∃ a, a ∈ as ∧ ComesToBe (p a) t :=
  match ceasing.steps_found M (as.length + 1) with
  | ⟨_, U, distinct, length, from_, all⟩ =>
    ⟨U, from_, fun nothing => Nat.not_succ_le_self as.length (Nat.le_trans (Nat.le_of_eq length.symm)
      (ceasing_steps_within (U := U)
        (fun s a lo hi mem comes => nothing ⟨s, lo, hi, a, mem, comes⟩) distinct all))⟩

/-- Where coming to be recurs in a finite family, ceasing never stops for good: no step has
nothing of the family cease after it. No decidedness is needed. -/
theorem Recurs.ceasing_not_stopping (coming : Recurs as fun a => ComesToBe (p a)) :
    ¬ ∃ M, ∀ t a, M ≤ t → a ∈ as → ¬ CeasesToBe (p a) t :=
  fun ⟨M, quiet⟩ => match coming.ceasing_within M with
  | ⟨_, _, found⟩ => found fun ⟨t, from_, _, a, mem, ceases⟩ => quiet t a from_ mem ceases

/-- Where ceasing recurs in a finite family, coming to be never stops for good. No decidedness
is needed. -/
theorem Recurs.coming_not_stopping (ceasing : Recurs as fun a => CeasesToBe (p a)) :
    ¬ ∃ M, ∀ t a, M ≤ t → a ∈ as → ¬ ComesToBe (p a) t :=
  fun ⟨M, quiet⟩ => match ceasing.coming_within M with
  | ⟨_, _, found⟩ => found fun ⟨t, from_, _, a, mem, comes⟩ => quiet t a from_ mem comes

/-- Where coming to be recurs in a finite family, from any step there is a stretch which, with
its states decided, has something of the family cease in it. -/
theorem Recurs.ceasing_found (coming : Recurs as fun a => ComesToBe (p a)) (M : Nat) :
    ∃ U, M ≤ U ∧ ((∀ a t, a ∈ as → M ≤ t → t ≤ U → Decided (p a t)) →
      ∃ t, M ≤ t ∧ t < U ∧ ∃ a, a ∈ as ∧ CeasesToBe (p a) t) :=
  match coming.ceasing_within M with
  | ⟨U, from_, found⟩ => ⟨U, from_, fun decided =>
      (Decided.exists_below fun t lo hi => Decided.exists_mem fun a mem =>
        (decided a t mem lo (Nat.le_of_lt hi)).and
          (decided a (t + 1) mem (Nat.le_trans lo (Nat.le_succ t)) hi).not).of_not_not found⟩

/-- Where ceasing recurs in a finite family, from any step there is a stretch which, with its
states decided, has something of the family come to be in it. -/
theorem Recurs.coming_found (ceasing : Recurs as fun a => CeasesToBe (p a)) (M : Nat) :
    ∃ U, M ≤ U ∧ ((∀ a t, a ∈ as → M ≤ t → t ≤ U → Decided (p a t)) →
      ∃ t, M ≤ t ∧ t < U ∧ ∃ a, a ∈ as ∧ ComesToBe (p a) t) :=
  match ceasing.coming_within M with
  | ⟨U, from_, found⟩ => ⟨U, from_, fun decided =>
      (Decided.exists_below fun t lo hi => Decided.exists_mem fun a mem =>
        (decided a t mem lo (Nat.le_of_lt hi)).not.and
          (decided a (t + 1) mem (Nat.le_trans lo (Nat.le_succ t)) hi)).of_not_not found⟩

/-- Decided from some step on, coming to be recurs in a finite family exactly where ceasing does.
No decision procedure is used. -/
theorem coming_recurs_iff_decided (decided : ∃ N, ∀ a t, a ∈ as → N ≤ t → Decided (p a t)) :
    Recurs as (fun a => ComesToBe (p a)) ↔ Recurs as (fun a => CeasesToBe (p a)) :=
  match decided with
  | ⟨N, decided⟩ =>
    ⟨fun coming M => match coming.ceasing_found (M + N) with
      | ⟨_, _, found⟩ => match found fun a t mem lo _ =>
            decided a t mem (Nat.le_trans (Nat.le_add_left N M) lo) with
        | ⟨t, from_, _, a, mem, ceases⟩ =>
          ⟨t, a, Nat.le_trans (Nat.le_add_right M N) from_, mem, ceases⟩,
     fun ceasing M => match ceasing.coming_found (M + N) with
      | ⟨_, _, found⟩ => match found fun a t mem lo _ =>
            decided a t mem (Nat.le_trans (Nat.le_add_left N M) lo) with
        | ⟨t, from_, _, a, mem, comes⟩ =>
          ⟨t, a, Nat.le_trans (Nat.le_add_right M N) from_, mem, comes⟩⟩

/-- Where the formations of a web are finitely many and their activity is decided from some step
on, some formation arises at arbitrarily late steps exactly when some formation ceases at
arbitrarily late steps. No decision procedure is used; `Web.unceasing_iff` asks one at every step. -/
theorem Web.unceasing_iff_decided {F C : Type} {W : Web F C} {fs : List F} (all : ∀ f, f ∈ fs)
    (decided : ∃ N, ∀ t f, N ≤ t → Decided (W.active t f)) :
    W.Unceasing ↔ ∀ N, ∃ t f, N ≤ t ∧ W.Ceases t f :=
  match decided with
  | ⟨N, decided⟩ =>
    have law := coming_recurs_iff_decided (as := fs) (p := fun f t => W.active t f)
      ⟨N, fun f t _ later => decided t f later⟩
    ⟨fun arising M => match law.mp (fun N => match arising N with
        | ⟨t, f, later, arises⟩ => ⟨t, f, later, all f, arises⟩) M with
      | ⟨t, f, later, _, ceases⟩ => ⟨t, f, later, ceases⟩,
     fun ceasing M => match law.mpr (fun N => match ceasing N with
        | ⟨t, f, later, ceases⟩ => ⟨t, f, later, all f, ceases⟩) M with
      | ⟨t, f, later, _, arises⟩ => ⟨t, f, later, arises⟩⟩

end Recurrence

/-! ## Finite worlds -/

namespace World

variable {w : World}

/-- In a finite world, where arising recurs, ceasing never stops for good: no step has nothing
cease after it. No decidedness is needed. -/
theorem ceasing_not_stopping (finite : w.Finite) (arising : w.ArisingRecurs) :
    ¬ ∃ M, ∀ t x, M ≤ t → ¬ w.web.Ceases t x :=
  match finite with
  | ⟨all, _, every⟩ => fun ⟨M, quiet⟩ =>
    Recurs.ceasing_not_stopping (as := all) (p := fun x t => w.web.active t x)
      (fun N => match arising N with
        | ⟨t, x, later, arises⟩ => ⟨t, x, later, every x, arises⟩)
      ⟨M, fun t x later _ ceases => quiet t x later ceases⟩

/-- In a finite world, where ceasing recurs, arising never stops for good. No decidedness is
needed. -/
theorem arising_not_stopping (finite : w.Finite) (ceasing : w.CeasingRecurs) :
    ¬ ∃ M, ∀ t x, M ≤ t → ¬ w.web.Arises t x :=
  match finite with
  | ⟨all, _, every⟩ => fun ⟨M, quiet⟩ =>
    Recurs.coming_not_stopping (as := all) (p := fun x t => w.web.active t x)
      (fun N => match ceasing N with
        | ⟨t, x, later, ceases⟩ => ⟨t, x, later, every x, ceases⟩)
      ⟨M, fun t x later _ arises => quiet t x later arises⟩

/-- In a finite world whose activity is decided from some step on, arising recurs exactly when
ceasing does. No decision procedure is used; asked of every finite world with no decidedness,
the law is excluded middle (`law_iff_em`). -/
theorem arising_iff_ceasing_decided (finite : w.Finite)
    (decided : ∃ N, ∀ t x, N ≤ t → Decided (w.web.active t x)) :
    w.ArisingRecurs ↔ w.CeasingRecurs :=
  match finite, decided with
  | ⟨all, _, every⟩, ⟨N, decided⟩ =>
    have law := coming_recurs_iff_decided (as := all) (p := fun x t => w.web.active t x)
      ⟨N, fun x t _ later => decided t x later⟩
    ⟨fun arising M => match law.mp (fun N => match arising N with
        | ⟨t, x, later, arises⟩ => ⟨t, x, later, every x, arises⟩) M with
      | ⟨t, x, later, _, ceases⟩ => ⟨t, x, later, ceases⟩,
     fun ceasing M => match law.mpr (fun N => match ceasing N with
        | ⟨t, x, later, ceases⟩ => ⟨t, x, later, every x, ceases⟩) M with
      | ⟨t, x, later, _, arises⟩ => ⟨t, x, later, arises⟩⟩

/-- With a list covering what is active from step `T` on, where arising recurs, ceasing never
stops for good. No decidedness is needed. -/
theorem ceasing_not_stopping_covered {ds : List w.Relatum} {T : Nat}
    (covers : ∀ t, T ≤ t → ∀ x, w.web.active t x → x ∈ ds) (arising : w.ArisingRecurs) :
    ¬ ∃ M, ∀ t x, M ≤ t → ¬ w.web.Ceases t x :=
  fun ⟨M, quiet⟩ =>
    Recurs.ceasing_not_stopping (as := ds) (p := fun x t => w.web.active t x)
      (fun K => match arising (K + T) with
        | ⟨t, x, later, arises⟩ => ⟨t, x, Nat.le_trans (Nat.le_add_right K T) later,
            covers (t + 1) (Nat.le_succ_of_le (Nat.le_trans (Nat.le_add_left T K) later)) x arises.2,
            arises⟩)
      ⟨M, fun t x later _ ceases => quiet t x later ceases⟩

/-- With a list covering what is active from step `T` on, where ceasing recurs, arising never
stops for good. No decidedness is needed. -/
theorem arising_not_stopping_covered {ds : List w.Relatum} {T : Nat}
    (covers : ∀ t, T ≤ t → ∀ x, w.web.active t x → x ∈ ds) (ceasing : w.CeasingRecurs) :
    ¬ ∃ M, ∀ t x, M ≤ t → ¬ w.web.Arises t x :=
  fun ⟨M, quiet⟩ =>
    Recurs.coming_not_stopping (as := ds) (p := fun x t => w.web.active t x)
      (fun K => match ceasing (K + T) with
        | ⟨t, x, later, ceases⟩ => ⟨t, x, Nat.le_trans (Nat.le_add_right K T) later,
            covers t (Nat.le_trans (Nat.le_add_left T K) later) x ceases.1, ceases⟩)
      ⟨M, fun t x later _ arises => quiet t x later arises⟩

/-- With a list covering what is active from step `T` on, and the activity of its members decided
from some step on, arising recurs exactly when ceasing does. No decision procedure is used, and
nothing is asked of the relata off the list. -/
theorem arising_iff_ceasing_covered {ds : List w.Relatum} {T : Nat}
    (covers : ∀ t, T ≤ t → ∀ x, w.web.active t x → x ∈ ds)
    (decided : ∃ N, ∀ t x, N ≤ t → x ∈ ds → Decided (w.web.active t x)) :
    w.ArisingRecurs ↔ w.CeasingRecurs :=
  match decided with
  | ⟨N, decided⟩ =>
    have law := coming_recurs_iff_decided (as := ds) (p := fun x t => w.web.active t x)
      ⟨N, fun x t mem later => decided t x later mem⟩
    ⟨fun arising M => match law.mp (fun K => match arising (K + T) with
        | ⟨t, x, later, arises⟩ => ⟨t, x, Nat.le_trans (Nat.le_add_right K T) later,
            covers (t + 1) (Nat.le_succ_of_le (Nat.le_trans (Nat.le_add_left T K) later)) x arises.2,
            arises⟩) M with
      | ⟨t, x, later, _, ceases⟩ => ⟨t, x, later, ceases⟩,
     fun ceasing M => match law.mpr (fun K => match ceasing (K + T) with
        | ⟨t, x, later, ceases⟩ => ⟨t, x, Nat.le_trans (Nat.le_add_right K T) later,
            covers t (Nat.le_trans (Nat.le_add_left T K) later) x ceases.1, ceases⟩) M with
      | ⟨t, x, later, _, arises⟩ => ⟨t, x, later, arises⟩⟩

end World

/-! ## Undominated members of a listed menu -/

section Undominated

variable {β : Type} {better : β → β → Prop}

/-- Whether a proposition fails is decided: it fails, or its failure is refuted. -/
def WeaklyDecided (p : Prop) : Prop :=
  ¬ p ∨ ¬ ¬ p

/-- A decided proposition is weakly decided. -/
theorem Decided.weakly {p : Prop} (decided : Decided p) : WeaklyDecided p :=
  match decided with
  | .inl holds => .inr fun fails => fails holds
  | .inr fails => .inl fails

/-- `a` is a member of `menu` that no member betters. -/
def Undominated (menu : List β) (better : β → β → Prop) (a : β) : Prop :=
  a ∈ menu ∧ ∀ b, b ∈ menu → ¬ better b a

/-- **A nonempty listed menu has an undominated member** where the relation is irreflexive and
transitive on it and whether one member betters another is weakly decided. The member is found
by one pass along the list, keeping the member no later one is known to better. -/
theorem exists_undominated : ∀ (x : β) (rest : List β),
    (∀ a b, a ∈ x :: rest → b ∈ x :: rest → WeaklyDecided (better a b)) →
    (∀ a, a ∈ x :: rest → ¬ better a a) →
    (∀ a b c, a ∈ x :: rest → b ∈ x :: rest → c ∈ x :: rest → better a b → better b c → better a c) →
    ∃ a, Undominated (x :: rest) better a
  | x, [], _, irreflexive, _ =>
    ⟨x, .head [], fun _ mem => match mem_cons_cases mem with
      | .inl same => Eq.subst (motive := fun c => ¬ better c x) same.symm (irreflexive x (.head []))
      | .inr never => nomatch never⟩
  | x, y :: rest, weakly, irreflexive, transitive =>
    match exists_undominated y rest (fun a b ma mb => weakly a b (.tail x ma) (.tail x mb))
        (fun a ma => irreflexive a (.tail x ma))
        (fun a b c ma mb mc => transitive a b c (.tail x ma) (.tail x mb) (.tail x mc)) with
    | ⟨u, mem, unbeaten⟩ => match weakly x u (.head _) (.tail x mem) with
      | .inl loses => ⟨u, .tail x mem, fun b mb => match mem_cons_cases mb with
        | .inl same => Eq.subst (motive := fun c => ¬ better c u) same.symm loses
        | .inr later => unbeaten b later⟩
      | .inr unrefuted => ⟨x, .head _, fun b mb => match mem_cons_cases mb with
        | .inl same => Eq.subst (motive := fun c => ¬ better c x) same.symm (irreflexive x (.head _))
        | .inr later => fun beats => unrefuted fun wins =>
            unbeaten b later (transitive b x u (.tail x later) (.head _) (.tail x mem) beats wins)⟩

/-- An undominated member has `P` unrefuted wherever every member lacking `P` is bettered by
some member. No decidedness is used. -/
theorem Undominated.not_not_has {P : β → Prop} {menu : List β}
    (bettered : ∀ a, a ∈ menu → ¬ P a → ∃ b, b ∈ menu ∧ better b a) {a : β}
    (undominated : Undominated menu better a) : ¬ ¬ P a :=
  fun fails => match bettered a undominated.1 fails with
    | ⟨b, mb, beats⟩ => undominated.2 b mb beats

/-- **Every undominated member has `P` wherever every member lacking `P` is bettered**, with `P`
decided on the menu. -/
theorem undominated_has {P : β → Prop} {menu : List β} (decided : ∀ a, a ∈ menu → Decided (P a))
    (bettered : ∀ a, a ∈ menu → ¬ P a → ∃ b, b ∈ menu ∧ better b a) :
    ∀ a, Undominated menu better a → P a :=
  fun a undominated => (decided a undominated.1).of_not_not (undominated.not_not_has bettered)

/-- Where every undominated member has `P`, every member lacking `P` is bettered by some member,
with the relation decided on the menu. -/
theorem bettered_of_undominated_has {P : β → Prop} {menu : List β}
    (decided : ∀ a b, a ∈ menu → b ∈ menu → Decided (better a b))
    (has : ∀ a, Undominated menu better a → P a) :
    ∀ a, a ∈ menu → ¬ P a → ∃ b, b ∈ menu ∧ better b a :=
  fun a mem fails =>
    match Decided.exists_mem (l := menu) (P := fun b => better b a) fun b mb => decided b a mb mem with
    | .inl found => found
    | .inr absent => absurd (has a ⟨mem, fun b mb beats => absent ⟨b, mb, beats⟩⟩) fails

/-- **Every undominated member of a listed menu has `P` exactly where every member lacking `P` is
bettered by some member**, with the relation and `P` decided on the menu. -/
theorem undominated_has_iff {P : β → Prop} {menu : List β}
    (decidedBetter : ∀ a b, a ∈ menu → b ∈ menu → Decided (better a b))
    (decidedHas : ∀ a, a ∈ menu → Decided (P a)) :
    (∀ a, Undominated menu better a → P a) ↔ ∀ a, a ∈ menu → ¬ P a → ∃ b, b ∈ menu ∧ better b a :=
  ⟨bettered_of_undominated_has decidedBetter, undominated_has decidedHas⟩

/-- Two members, each bettering the other exactly where `p` holds or fails. -/
def Opposed (p : Prop) : Bool → Bool → Prop
  | true, true => False
  | true, false => p
  | false, true => ¬ p
  | false, false => False

theorem Opposed.irreflexive (p : Prop) : ∀ a, ¬ Opposed p a a
  | true => fun never => never
  | false => fun never => never

theorem Opposed.transitive (p : Prop) : ∀ a b c, Opposed p a b → Opposed p b c → Opposed p a c
  | true, true, _ => fun never _ => False.elim never
  | false, false, _ => fun never _ => False.elim never
  | true, false, true => fun holds fails => fails holds
  | true, false, false => fun _ never => False.elim never
  | false, true, false => fun fails holds => fails holds
  | false, true, true => fun _ never => False.elim never

/-- **Asked of every relation, the weak decidedness is exactly weak excluded middle.** That every
nonempty listed menu under an irreflexive transitive relation has an undominated member holds
exactly where whether every proposition fails is decided: in `Opposed p`, `false` is undominated
exactly where `p` fails and `true` exactly where its failure is refuted. -/
theorem exists_undominated_iff_weakly :
    (∀ (β : Type) (better : β → β → Prop) (x : β) (rest : List β),
        (∀ a, a ∈ x :: rest → ¬ better a a) →
        (∀ a b c, a ∈ x :: rest → b ∈ x :: rest → c ∈ x :: rest → better a b → better b c →
          better a c) →
        ∃ a, Undominated (x :: rest) better a) ↔ ∀ p : Prop, WeaklyDecided p :=
  ⟨fun exists_ p =>
    match exists_ Bool (Opposed p) false [true] (fun a _ => Opposed.irreflexive p a)
        (fun a b c _ _ _ => Opposed.transitive p a b c) with
    | ⟨false, _, unbeaten⟩ => .inl (unbeaten true (.tail false (.head [])))
    | ⟨true, _, unbeaten⟩ => .inr (unbeaten false (.head [true])),
   fun weakly _ _ x rest irreflexive transitive =>
    exists_undominated x rest (fun _ _ _ _ => weakly _) irreflexive transitive⟩

/-- **Asked of every determination, the decidedness of `P` is exactly excluded middle.** That every
undominated member has `P` wherever every member lacking `P` is bettered holds for every menu,
relation and `P` exactly where every proposition is decided: on a menu of one member with no
relation, it is `p` wherever its failure is refuted. -/
theorem undominated_has_iff_em :
    (∀ (β : Type) (better : β → β → Prop) (P : β → Prop) (menu : List β),
        (∀ a, a ∈ menu → ¬ P a → ∃ b, b ∈ menu ∧ better b a) →
        ∀ a, Undominated menu better a → P a) ↔ ∀ p : Prop, Decided p :=
  ⟨fun has p => has Unit (fun _ _ => False) (fun _ => Decided p) [()]
      (fun _ _ fails => absurd fails (not_not_decided p)) () ⟨.head [], fun _ _ never => never⟩,
   fun em _ _ _ _ bettered => undominated_has (fun _ _ => em _) bettered⟩

end Undominated

end Becoming

/-! ## Decided over a list (moved from `Becoming.Likeness`) -/

namespace Becoming

universe u v w u' w'

section BranchingTests

variable {S : Type u} {S' : Type u'} {A : Type v} {C : Type w}

/-- Searching a list for a member where a determination holds is decided where the determination
is decided at each member (`Decided.exists_mem` for types of every universe). -/
theorem Decided.exists_listed {β : Type u} {P : β → Prop} :
    ∀ {l : List β}, (∀ b, b ∈ l → Decided (P b)) → Decided (∃ b, b ∈ l ∧ P b)
  | [], _ => .inr fun ⟨_, mem, _⟩ => nomatch mem
  | b :: l, decided => match decided b (.head l) with
    | .inl holds => .inl ⟨b, .head l, holds⟩
    | .inr fails => match Decided.exists_listed (l := l) fun c mem => decided c (.tail b mem) with
      | .inl ⟨c, mem, holds⟩ => .inl ⟨c, .tail b mem, holds⟩
      | .inr absent => .inr fun ⟨c, mem, holds⟩ => match mem_cons_split mem with
        | .inl same => fails (Eq.subst (motive := P) same holds)
        | .inr mem => absent ⟨c, mem, holds⟩

end BranchingTests

section Outcomes

variable {S : Type u} {S' : Type u'} {A : Type v} {C : Type w}

/-- A decided determination that does not hold of every member of a list fails of some member. -/
theorem Decided.exists_not_in {β : Type u} {P : β → Prop} {l : List β}
    (decided : ∀ b, b ∈ l → Decided (P b)) (fails : ¬ ∀ b, b ∈ l → P b) : ∃ b, b ∈ l ∧ ¬ P b :=
  match Decided.exists_listed (l := l) fun b mem => (decided b mem).not with
  | .inl found => found
  | .inr absent =>
    absurd (fun b mem => (decided b mem).of_not_not fun fails' => absent ⟨b, mem, fails'⟩) fails

end Outcomes

end Becoming

/-! ## Lists joined in either grouping (moved from `Becoming.Joining`) -/

namespace Becoming

universe u v w u' v'

namespace Joining

variable {F : Type u} {G : Type v} {K : Type u'} {K' : Type v'}

end Joining

end Becoming

/-! ## Membership kept under reordering (moved from `Becoming.Coverage`) -/

namespace Becoming

universe u

namespace Coverage

variable {C : Type u}

theorem Perm.mem {l l' : List C} (h : l.Perm l') {a : C} (mem : a ∈ l') : a ∈ l := by
  induction h with
  | nil => exact mem
  | cons x _ ih =>
    cases mem with
    | head => exact .head _
    | tail _ mem => exact .tail _ (ih mem)
  | swap x y _ =>
    cases mem with
    | head => exact .tail _ (.head _)
    | tail _ mem =>
      cases mem with
      | head => exact .head _
      | tail _ mem => exact .tail _ (.tail _ mem)
  | trans _ _ ih ih' => exact ih (ih' mem)

end Coverage

end Becoming
