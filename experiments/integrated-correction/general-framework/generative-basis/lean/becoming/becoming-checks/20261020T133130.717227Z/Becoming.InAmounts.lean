import Becoming.LeastLoss
import Becoming.Space

/-!
# A world in amounts: the rest theorem over any amounts, read finitely

The rest theorem (`World.rests_unrefuted_enclosed`, its forms `World.rests_unrefuted_covering` and
`World.rests_unrefuted`) reads a world's standings and exchanges in whole numbers and takes its force
from them: every change of a standing lowers the total standing by at least one, and no total lies
beyond its own count of ones. `Becoming.LeastLoss` states the step on which it turns for any
amounts, with the two premises the whole numbers supplied (a least loss, and a stock within finitely
many of them), and the other route: an amount read off configurations a list holds comes to rest
with no least loss (`Amounts.rests_unrefuted_of_finite_reading`). This module carries that route up
to worlds.

* **Totals over any amounts.** `Amounts.totalOf` adds amounts over a list. It keeps the order
  (`Amounts.totalOf_le`), splits over addition (`Amounts.totalOf_add`), exchanges two lists
  (`Amounts.totalOf_swap`), holds each member's amount (`Amounts.le_totalOf`), and, where every
  member's amount is at least another's and the totals are the other way, holds each member's the
  other way too (`Amounts.le_of_totalOf_le`): no member can be strictly larger while the total is
  not. Over a family and a part of it holding every member not within nothing, the two totals are
  each within the other, as far as can be refuted (`Amounts.totalOf_support`). In whole numbers it
  is `total` (`Amounts.totalOf_whole`).
* **A world in amounts.** `World.InAmounts w A` reads a world's standings, takes and gives in
  amounts `A`; what takes part, what is active and what arises or ceases are the world's own
  records. A family balances across a step where each member's level after the step, with what is
  taken from it, is within its level before, with what is given to it (`BalancesOn`, one way: no
  amount is made); the flow dissipates on it where every relatum taking part gives the family no
  more than it takes from it, and whatever gives it back all it takes takes nothing (`DissipatesOn`:
  strictness with no least loss). A relatum stands where its level is not within nothing.
* **The law of one step.** Balanced and dissipated on, the family's total does not rise
  (`InAmounts.stock_still`), and where it does not fall strictly no member's level changes either
  way (`InAmounts.steady_of_stock_le`): a rise needs something given, and a relatum that took and
  gave back no less took nothing. So every change of a member's level lowers the total strictly
  (`InAmounts.change_lowers`), with no least loss.
* **The rest theorem, read finitely.** Where the family's total is read off configurations a list
  holds, from some step on, that its changes stop cannot be refuted
  (`InAmounts.change_stops_unrefuted`, from `Amounts.rests_unrefuted_of_finite_reading`). In a world
  in any amounts with a census of its active relata, all embodied, a balanced and dissipative flow,
  every step from some step on enclosed, and the census's total read off configurations a list
  holds, that the world rests from some step on cannot be refuted
  (`InAmounts.rests_unrefuted_enclosed`): each enclosing family is widened, as far as can be refuted,
  to hold what is active before and after the step (`InAmounts.Enclosed.around_not_not`), and its
  total is the census's each way (`InAmounts.stock_census`). Where one family holds what is active
  from some step on, balanced and dissipated on, and whatever arises is embodied, the same holds
  (`InAmounts.rests_unrefuted_covering`); it is enough that the family's levels are read off
  configurations a list holds (`InAmounts.rests_unrefuted_reading`), and in a finite world that its
  level functions are among those a list holds (`InAmounts.rests_unrefuted`).
* **Whole numbers are an instance.** Every world is a world in whole-number amounts
  (`World.wholeAmounts`), whose balance, dissipation, embodiment and enclosure are the world's own
  (`World.balanced_whole`, `World.dissipative_whole`, `World.embodied_whole`,
  `World.arisingEmbodied_whole`, `World.enclosed_whole`); so by the laws over any amounts a world
  meeting the premises of `World.rests_unrefuted_enclosed` whose census's total is read finitely
  rests, unrefuted (`World.rests_unrefuted_enclosed_read`), and so does a finite world whose level
  functions a list holds (`World.rests_unrefuted_listed`). In whole numbers the reading is not
  needed: the least loss of one carries the whole-number laws.
* **The premise is needed over dense amounts.** In `HalvingPass` one standing passes between two
  relata, halving at each pass, in dyadic amounts: the flow balances and dissipates on the pair,
  whatever arises is embodied, every active relatum is in the pair, and still at every step one
  relatum arises and the other ceases (`HalvingPass.never_rests`). The losses shrink without a
  floor, as in `Halving`, so the whole-number route fails, and no list holds its levels
  (`HalvingPass.levels_unlisted`), so the finite route does not apply. A world in dense amounts
  rests where its levels are read finitely or a least loss is given, and need not otherwise.

The representation commits to discrete steps and to Prop-valued activity; amounts are any
`Amounts`. The finite reading is the premise named where it is used. Every declaration has an
empty axiom report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace Amounts

variable {A : Type} {M : Amounts A} {X Y : Type}

/-- The total of amounts over a list. -/
def totalOf (M : Amounts A) : List X → (X → A) → A
  | [], _ => M.zero
  | x :: xs, a => M.add (a x) (totalOf M xs a)

theorem add_add_add_comm (a b c d : A) :
    M.add (M.add a b) (M.add c d) = M.add (M.add a c) (M.add b d) := by
  rw [M.add_assoc, ← M.add_assoc b c d, M.add_comm b c, M.add_assoc c b d,
    ← M.add_assoc a c (M.add b d)]

/-- Totals keep the order of their members. -/
theorem totalOf_le {a b : X → A} : ∀ {l : List X}, (∀ x, x ∈ l → M.le (a x) (b x)) →
    M.le (M.totalOf l a) (M.totalOf l b)
  | [], _ => M.le_refl _
  | x :: xs, le => M.le_trans (M.add_le_add_right (M.totalOf xs a) (le x (.head xs)))
      (add_le_add_left (b x) (totalOf_le fun y mem => le y (.tail x mem)))

/-- Totals of amounts that agree on the members agree. -/
theorem totalOf_congr {a b : X → A} : ∀ {l : List X}, (∀ x, x ∈ l → a x = b x) →
    M.totalOf l a = M.totalOf l b
  | [], _ => rfl
  | x :: xs, same => (congrArg (fun z => M.add z (M.totalOf xs a)) (same x (.head xs))).trans
      (congrArg (M.add (b x)) (totalOf_congr fun y mem => same y (.tail x mem)))

/-- The total of a sum is the sum of the totals. -/
theorem totalOf_add {a b : X → A} : ∀ l : List X,
    M.totalOf l (fun x => M.add (a x) (b x)) = M.add (M.totalOf l a) (M.totalOf l b)
  | [] => (M.zero_add M.zero).symm
  | x :: xs => (congrArg (M.add (M.add (a x) (b x))) (totalOf_add xs)).trans
      (add_add_add_comm _ _ _ _)

/-- Nothing, totalled, is nothing. -/
theorem totalOf_zero : ∀ l : List X, M.totalOf l (fun _ => M.zero) = M.zero
  | [] => rfl
  | _ :: xs => (M.zero_add _).trans (totalOf_zero xs)

/-- Totals over two lists may be taken in either order. -/
theorem totalOf_swap (k : X → Y → A) : ∀ (xs : List X) (ys : List Y),
    M.totalOf xs (fun x => M.totalOf ys (k x)) = M.totalOf ys (fun y => M.totalOf xs (fun x => k x y))
  | [], ys => (totalOf_zero ys).symm
  | x :: xs, ys => (congrArg (M.add (M.totalOf ys (k x))) (totalOf_swap k xs ys)).trans
      (totalOf_add (a := k x) (b := fun y => M.totalOf xs (fun x' => k x' y)) ys).symm

/-- A member's amount is within the total. -/
theorem le_totalOf {a : X → A} : ∀ {l : List X} {x : X}, x ∈ l → M.le (a x) (M.totalOf l a)
  | _ :: _, _, .head _ => le_add_right _ _
  | y :: _, _, .tail _ mem => M.le_trans (le_totalOf mem) (le_add_left _ (a y))

/-- Amounts each within nothing total within nothing. -/
theorem totalOf_le_zero {a : X → A} {l : List X} (none_ : ∀ x, x ∈ l → M.le (a x) M.zero) :
    M.le (M.totalOf l a) M.zero :=
  M.le_trans (totalOf_le none_) (le_of_eq (totalOf_zero l))

/-- **No member strictly larger while the total is not.** Where each member's `b` is within its
`a`, and the total of `a` is within the total of `b`, each member's `a` is within its `b`: by
cancellation, with no decision and no totality of the order. -/
theorem le_of_totalOf_le {a b : X → A} : ∀ {l : List X}, (∀ x, x ∈ l → M.le (b x) (a x)) →
    M.le (M.totalOf l a) (M.totalOf l b) → ∀ x, x ∈ l → M.le (a x) (b x)
  | [], _, _, _, mem => nomatch mem
  | y :: ys, below, le, _, .head _ =>
    M.le_of_add_le_add_right (M.totalOf ys a)
      (M.le_trans le (add_le_add_left (b y) (totalOf_le fun z mem => below z (.tail y mem))))
  | y :: ys, below, le, x, .tail _ mem =>
    le_of_totalOf_le (fun z m => below z (.tail y m))
      (M.le_of_add_le_add_right (a y)
        (M.le_trans (le_of_eq (M.add_comm _ _))
          (M.le_trans le (M.le_trans (M.add_le_add_right _ (below y (.head ys)))
            (le_of_eq (M.add_comm _ _)))))) x mem

/-- In whole numbers the total is `total`. -/
theorem totalOf_whole {a : X → Nat} : ∀ l : List X, Amounts.whole.totalOf l a = total l a
  | [] => rfl
  | x :: xs => congrArg (a x + ·) (totalOf_whole xs)

theorem add_left_comm (a b c : A) : M.add a (M.add b c) = M.add b (M.add a c) := by
  rw [← M.add_assoc, M.add_comm a b, M.add_assoc]

/-- A total over a list with one member inserted is that member's amount with the rest. -/
theorem totalOf_insert {a : X → A} (y : X) : ∀ (p q : List X),
    M.totalOf (p ++ y :: q) a = M.add (a y) (M.totalOf (p ++ q) a)
  | [], _ => rfl
  | b :: p, q => (congrArg (M.add (a b)) (totalOf_insert y p q)).trans (add_left_comm _ _ _)

/-- A member of a list with one member inserted is that member or a member of the rest. -/
theorem mem_insert_cases {y x : X} : ∀ {p q : List X}, x ∈ p ++ y :: q → x = y ∨ x ∈ p ++ q
  | [], _, mem => mem_cons_cases mem
  | _ :: _, _, .head _ => .inr (.head _)
  | b :: _, _, .tail _ mem => match mem_insert_cases mem with
    | .inl same => .inl same
    | .inr rest => .inr (.tail b rest)

/-- In a list without repetition, an inserted member is not among the rest. -/
theorem fresh_insert {y : X} : ∀ {p q : List X}, Distinct (p ++ y :: q) → ¬ y ∈ p ++ q
  | [], _, ⟨fresh, _⟩ => fresh
  | _ :: p, q, ⟨fresh, distinct⟩ => fun mem => match mem_cons_cases mem with
    | .inl same => fresh (Eq.subst (motive := fun x => x ∈ p ++ y :: q) same
        (mem_append_of_right p (.head q)))
    | .inr rest => fresh_insert distinct rest

/-- **Totals over a family and the part of it that counts.** Over two lists without repetition,
the first holding the second, where every member of the first outside the second is not refuted to
be within nothing, the two totals are, as far as can be refuted, each within the other. Whether
each member lies in the second list need only be not refuted. -/
theorem totalOf_support {a : X → A} : ∀ {U D : List X}, Distinct U → Distinct D →
    (∀ x, x ∈ D → x ∈ U) → (∀ x, x ∈ U → ¬ x ∈ D → ¬¬ M.le (a x) M.zero) →
    ¬¬ (M.le (M.totalOf U a) (M.totalOf D a) ∧ M.le (M.totalOf D a) (M.totalOf U a))
  | [], [], _, _, _, _ => fun no => no ⟨M.le_refl _, M.le_refl _⟩
  | [], _ :: _, _, _, sub, _ => nomatch sub _ (.head _)
  | y :: U, D, ⟨fresh, distinctU⟩, distinctD, sub, outside => fun no =>
    have decide : (y ∈ D ∨ ¬ y ∈ D) → False := fun
      | .inl inside => match List.append_of_mem inside with
        | ⟨p, q, split⟩ =>
          have distinctD' : Distinct (p ++ y :: q) := Eq.subst (motive := Distinct) split distinctD
          have whole : M.totalOf D a = M.add (a y) (M.totalOf (p ++ q) a) :=
            (congrArg (fun l => M.totalOf l a) split).trans (totalOf_insert y p q)
          totalOf_support distinctU (distinct_remove distinctD')
            (fun x mem => match mem_cons_cases (sub x (Eq.subst (motive := fun l => x ∈ l) split.symm
                (mem_insert mem))) with
              | .inl same => absurd (Eq.subst (motive := fun z => z ∈ p ++ q) same mem)
                  (fresh_insert distinctD')
              | .inr rest => rest)
            (fun x mem out => outside x (.tail y mem) fun inD =>
              match mem_insert_cases (Eq.subst (motive := fun l => x ∈ l) split inD) with
              | .inl same => fresh (Eq.subst (motive := fun z => z ∈ U) same mem)
              | .inr rest => out rest)
            fun ⟨up, down⟩ => no
              ⟨M.le_trans (add_le_add_left (a y) up) (le_of_eq whole.symm),
               M.le_trans (le_of_eq whole) (add_le_add_left (a y) down)⟩
      | .inr notD => outside y (.head U) notD fun nothing =>
          totalOf_support distinctU distinctD
            (fun x mem => match mem_cons_cases (sub x mem) with
              | .inl same => absurd (Eq.subst (motive := fun z => z ∈ D) same mem) notD
              | .inr rest => rest)
            (fun x mem out => outside x (.tail y mem) out)
            fun ⟨up, down⟩ => no
              ⟨M.le_trans (M.add_le_add_right _ nothing)
                 (M.le_trans (le_of_eq (M.zero_add _)) up),
               M.le_trans down (le_add_left _ (a y))⟩
    decide (.inr fun inside => decide (.inl inside))

end Amounts

namespace World

/-- **A world in amounts.** A world's standings, and what its relata take from and give to each
other across each step, read in amounts `A`. What takes part in a step, what is active, and what
arises or ceases are the world's own records; its whole-number levels are not read. -/
structure InAmounts (w : World) (A : Type) where
  level : Nat → w.Relatum → A
  take : Nat → w.Relatum → w.Relatum → A
  give : Nat → w.Relatum → w.Relatum → A

namespace InAmounts

variable {w : World} {A : Type} (M : Amounts A) (v : w.InAmounts A)

/-- What the relata taking part take from `c` across the step from `t`. -/
def taken (t : Nat) (c : w.Relatum) : A :=
  M.totalOf (w.flow.present t) fun f => v.take t f c

/-- What the relata taking part give to `c` across the step from `t`. -/
def given (t : Nat) (c : w.Relatum) : A :=
  M.totalOf (w.flow.present t) fun f => v.give t f c

/-- The total standing of a family at step `t`. -/
def stock (ds : List w.Relatum) (t : Nat) : A :=
  M.totalOf ds (v.level t)

/-- The family balances across the step from `t`: each member's level after the step, with what
is taken from it, is within its level before, with what is given to it. No amount is made. -/
def BalancesOn (ds : List w.Relatum) (t : Nat) : Prop :=
  ∀ c, c ∈ ds → M.le (M.add (v.level (t + 1) c) (v.taken M t c)) (M.add (v.level t c) (v.given M t c))

/-- Every family balances across every step. -/
def Balanced : Prop :=
  ∀ t c, M.le (M.add (v.level (t + 1) c) (v.taken M t c)) (M.add (v.level t c) (v.given M t c))

/-- The flow dissipates on the family across the step from `t`: every relatum taking part gives the
family no more than it takes from it, and whatever gives it back all it takes from it takes nothing
from it. Strictness is read with no least loss. -/
def DissipatesOn (ds : List w.Relatum) (t : Nat) : Prop :=
  ∀ f, f ∈ w.flow.present t →
    M.le (M.totalOf ds (v.give t f)) (M.totalOf ds (v.take t f)) ∧
      (M.le (M.totalOf ds (v.take t f)) (M.totalOf ds (v.give t f)) →
        M.le (M.totalOf ds (v.take t f)) M.zero)

/-- No relatum taking part in the step from `t` takes from or gives to a relatum outside the
family. -/
def ClosedAt (ds : List w.Relatum) (t : Nat) : Prop :=
  ∀ f, f ∈ w.flow.present t → ∀ c, ¬ c ∈ ds → M.le (v.take t f c) M.zero ∧ M.le (v.give t f c) M.zero

/-- Dissipation: across every step, every family without repetition closed across it is
dissipated on. -/
def Dissipative : Prop :=
  ∀ ds t, Distinct ds → v.ClosedAt M ds t → v.DissipatesOn M ds t

/-- A relatum's level rises across the step from `t`: after the step it is not within its level
before. -/
def Rises (t : Nat) (c : w.Relatum) : Prop :=
  ¬ M.le (v.level (t + 1) c) (v.level t c)

/-- A relatum's level falls across the step from `t`: before the step it is not within its level
after. -/
def Falls (t : Nat) (c : w.Relatum) : Prop :=
  ¬ M.le (v.level t c) (v.level (t + 1) c)

/-- Whatever arises is embodied: at every step it is active exactly where its level is not within
nothing. -/
def ArisingEmbodied : Prop :=
  ∀ t x, w.web.Arises t x → ∀ s, w.web.active s x ↔ ¬ M.le (v.level s x) M.zero

variable {M v}

/-- An embodied relatum arising rises. -/
theorem rises_of_arises (embodied : v.ArisingEmbodied M) {t : Nat} {x : w.Relatum}
    (arises : w.web.Arises t x) : v.Rises M t x := fun le =>
  arises.1 ((embodied t x arises t).mpr fun within =>
    (embodied t x arises (t + 1)).mp arises.2 (M.le_trans le within))

/-- What is taken from the family, totalled, is what each relatum taking part takes from it. -/
theorem taken_total (ds : List w.Relatum) (t : Nat) :
    M.totalOf ds (v.taken M t) =
      M.totalOf (w.flow.present t) (fun f => M.totalOf ds (v.take t f)) :=
  (Amounts.totalOf_swap (fun f c => v.take t f c) (w.flow.present t) ds).symm

/-- What is given to the family, totalled, is what each relatum taking part gives to it. -/
theorem given_total (ds : List w.Relatum) (t : Nat) :
    M.totalOf ds (v.given M t) =
      M.totalOf (w.flow.present t) (fun f => M.totalOf ds (v.give t f)) :=
  (Amounts.totalOf_swap (fun f c => v.give t f c) (w.flow.present t) ds).symm

/-- Balanced, the family's total after the step, with what is taken from it, is within its total
before, with what is given to it. -/
theorem balance_total {ds : List w.Relatum} {t : Nat} (balances : v.BalancesOn M ds t) :
    M.le (M.add (v.stock M ds (t + 1)) (M.totalOf ds (v.taken M t)))
      (M.add (v.stock M ds t) (M.totalOf ds (v.given M t))) :=
  M.le_trans (Amounts.le_of_eq (Amounts.totalOf_add (a := v.level (t + 1)) (b := v.taken M t) ds).symm)
    (M.le_trans
      (Amounts.totalOf_le (a := fun c => M.add (v.level (t + 1) c) (v.taken M t c))
        (b := fun c => M.add (v.level t c) (v.given M t c)) balances)
      (Amounts.le_of_eq (Amounts.totalOf_add (a := v.level t) (b := v.given M t) ds)))

/-- **The total standing does not rise** across a step at which the family balances and is
dissipated on. -/
theorem stock_still {ds : List w.Relatum} {t : Nat} (balances : v.BalancesOn M ds t)
    (dissipates : v.DissipatesOn M ds t) : M.le (v.stock M ds (t + 1)) (v.stock M ds t) :=
  M.le_of_add_le_add_right (M.totalOf ds (v.taken M t))
    (M.le_trans (balance_total balances)
      (Amounts.add_le_add_left (v.stock M ds t)
        (M.le_trans (Amounts.le_of_eq (given_total ds t))
          (M.le_trans
            (Amounts.totalOf_le (a := fun f => M.totalOf ds (v.give t f))
              (b := fun f => M.totalOf ds (v.take t f)) fun f mem => (dissipates f mem).1)
            (Amounts.le_of_eq (taken_total ds t).symm)))))

/-- **The law of one step, over any amounts.** Across a step at which the family balances and is
dissipated on, where its total does not fall strictly (its total before is within its total
after), no member's level changes either way: the relata taking part each took no more than they
gave back, so took nothing, so gave nothing, and with nothing given no level rises and none falls. -/
theorem steady_of_stock_le {ds : List w.Relatum} {t : Nat} (balances : v.BalancesOn M ds t)
    (dissipates : v.DissipatesOn M ds t) (le : M.le (v.stock M ds t) (v.stock M ds (t + 1))) :
    ∀ c, c ∈ ds → M.le (v.level (t + 1) c) (v.level t c) ∧ M.le (v.level t c) (v.level (t + 1) c) :=
  have within : M.le (M.totalOf ds (v.taken M t)) (M.totalOf ds (v.given M t)) :=
    M.le_of_add_le_add_right (v.stock M ds t)
      (M.le_trans (Amounts.le_of_eq (M.add_comm _ _))
        (M.le_trans (M.le_trans (M.add_le_add_right _ le) (balance_total balances))
          (Amounts.le_of_eq (M.add_comm _ _))))
  have each : ∀ f, f ∈ w.flow.present t →
      M.le (M.totalOf ds (v.take t f)) (M.totalOf ds (v.give t f)) :=
    Amounts.le_of_totalOf_le (a := fun f => M.totalOf ds (v.take t f))
      (b := fun f => M.totalOf ds (v.give t f)) (fun f mem => (dissipates f mem).1)
      (M.le_trans (Amounts.le_of_eq (taken_total ds t).symm)
        (M.le_trans within (Amounts.le_of_eq (given_total ds t))))
  have nothing : ∀ c, c ∈ ds → M.le (v.given M t c) M.zero := fun _ member =>
    Amounts.totalOf_le_zero fun f mem =>
      M.le_trans (Amounts.le_totalOf (a := v.give t f) member)
        (M.le_trans (dissipates f mem).1 ((dissipates f mem).2 (each f mem)))
  have still : ∀ c, c ∈ ds → M.le (v.level (t + 1) c) (v.level t c) := fun c member =>
    M.le_trans (Amounts.le_add_right _ (v.taken M t c))
      (M.le_trans (balances c member)
        (M.le_trans (Amounts.add_le_add_left _ (nothing c member))
          (Amounts.le_of_eq (Amounts.add_zero _))))
  fun c member => ⟨still c member,
    Amounts.le_of_totalOf_le (a := v.level t) (b := v.level (t + 1)) still le c member⟩

/-- So every change of a member's level, a rise or a fall, lowers the family's total strictly:
after the step it does not hold the total before. No least loss is asked. -/
theorem change_lowers {ds : List w.Relatum} {t : Nat} (balances : v.BalancesOn M ds t)
    (dissipates : v.DissipatesOn M ds t) {c : w.Relatum} (member : c ∈ ds)
    (changes : v.Rises M t c ∨ v.Falls M t c) : ¬ M.le (v.stock M ds t) (v.stock M ds (t + 1)) :=
  fun le => match changes with
  | .inl rises => rises (steady_of_stock_le balances dissipates le c member).1
  | .inr falls => falls (steady_of_stock_le balances dissipates le c member).2

/-- **Change stops, unrefuted, over any amounts, read finitely.** Where from `T` on the family
balances and is dissipated on, and its total is read off configurations a list holds, it is not the
case that after every step from `T` on a later change of a member's level stays unrefuted. No least
loss, no Archimedean property and no decision: `Amounts.rests_unrefuted_of_finite_reading`. -/
theorem change_stops_unrefuted {ds : List w.Relatum} {T : Nat} {S : Type} {g : Nat → S} {q : S → A}
    {l : List S} (balances : ∀ t, T ≤ t → v.BalancesOn M ds t)
    (dissipates : ∀ t, T ≤ t → v.DissipatesOn M ds t) (held : ∀ t, T ≤ t → g t ∈ l)
    (reads : ∀ t, T ≤ t → v.stock M ds t = q (g t)) :
    ¬ ∀ N, T ≤ N → ¬¬ ∃ t c, N ≤ t ∧ c ∈ ds ∧ (v.Rises M t c ∨ v.Falls M t c) :=
  fun changing => Amounts.rests_unrefuted_of_finite_reading (M := M) (q := q) held
    (fun t later no => no (Eq.subst (motive := fun x => M.le x (q (g t)))
      (reads (t + 1) (Nat.le_succ_of_le later))
      (Eq.subst (motive := fun x => M.le (v.stock M ds (t + 1)) x) (reads t later)
        (stock_still (balances t later) (dissipates t later)))))
    fun N from_ none_ => changing N from_ fun ⟨t, _, after, member, changes⟩ =>
      have later : T ≤ t := Nat.le_trans from_ after
      none_ ⟨t, after, fun le => change_lowers (balances t later) (dissipates t later) member changes
        (Eq.subst (motive := fun x => M.le x (v.stock M ds (t + 1))) (reads t later).symm
          (Eq.subst (motive := fun x => M.le (q (g t)) x) (reads (t + 1) (Nat.le_succ_of_le later)).symm
            le))⟩

/-- **The rest theorem over any amounts, read finitely.** In a world whose active relata lie, from
`T` on, in one family, balanced and dissipated on at each of those steps, whose arising is embodied,
and whose family total is read off configurations a list holds, that the world rests from some step
on cannot be refuted. Over any amounts: no least loss, no Archimedean property, no decision. Ceasing
left unrefuted after every step leaves arising unrefuted after every step
(`World.arising_unrefuted_covering`), and an embodied arising is a rise. -/
theorem rests_unrefuted_covering {ds : List w.Relatum} {T : Nat} {S : Type} {g : Nat → S}
    {q : S → A} {l : List S} (covers : ∀ t, T ≤ t → ∀ x, w.web.active t x → x ∈ ds)
    (balances : ∀ t, T ≤ t → v.BalancesOn M ds t) (dissipates : ∀ t, T ≤ t → v.DissipatesOn M ds t)
    (embodied : v.ArisingEmbodied M) (held : ∀ t, T ≤ t → g t ∈ l)
    (reads : ∀ t, T ≤ t → v.stock M ds t = q (g t)) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  have unrefuted := change_stops_unrefuted balances dissipates held reads
  World.rests_unrefuted_iff.mpr
  ⟨fun arising => unrefuted fun N from_ none_ => arising N fun ⟨t, x, later, arises⟩ =>
      none_ ⟨t, x, later,
        covers (t + 1) (Nat.le_succ_of_le (Nat.le_trans from_ later)) x arises.2,
        .inl (rises_of_arises embodied arises)⟩,
   fun ceasing => unrefuted fun N from_ none_ =>
      World.arising_unrefuted_covering covers ceasing N from_ fun ⟨t, x, later, member, arises⟩ =>
        none_ ⟨t, x, later, member, .inl (rises_of_arises embodied arises)⟩⟩

/-- It is enough that the family's levels are read off configurations a list holds: the total is
then read off them too. -/
theorem rests_unrefuted_reading {ds : List w.Relatum} {T : Nat} {S : Type} {g : Nat → S}
    {read : S → w.Relatum → A} {l : List S} (covers : ∀ t, T ≤ t → ∀ x, w.web.active t x → x ∈ ds)
    (balances : ∀ t, T ≤ t → v.BalancesOn M ds t) (dissipates : ∀ t, T ≤ t → v.DissipatesOn M ds t)
    (embodied : v.ArisingEmbodied M) (held : ∀ t, T ≤ t → g t ∈ l)
    (reads : ∀ t, T ≤ t → ∀ c, c ∈ ds → v.level t c = read (g t) c) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  rests_unrefuted_covering (q := fun s => M.totalOf ds (read s)) covers balances dissipates embodied
    held fun t later => Amounts.totalOf_congr (reads t later)

/-- **A finite world in amounts rests, read finitely.** In a finite world in any amounts whose flow
balances and dissipates and whose arising is embodied, where a list holds every level function the
world takes, that the world rests from some step on cannot be refuted. -/
theorem rests_unrefuted (finite : w.Finite) (balanced : v.Balanced M) (dissipative : v.Dissipative M)
    (embodied : v.ArisingEmbodied M) {ls : List (w.Relatum → A)} (held : ∀ t, v.level t ∈ ls) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  match finite with
  | ⟨all, distinct, every⟩ =>
    rests_unrefuted_reading (T := 0) (ds := all) (g := v.level) (read := fun lv => lv)
      (fun _ _ x _ => every x) (fun t _ c _ => balanced t c)
      (fun t _ => dissipative all t distinct fun _ _ c outside => absurd (every c) outside)
      embodied (fun t _ => held t) fun _ _ _ _ => rfl

variable (M v)

/-- Every relatum is embodied: at every step it is active exactly where its level is not within
nothing. -/
def Embodied : Prop :=
  ∀ t x, w.web.active t x ↔ ¬ M.le (v.level t x) M.zero

/-- Across the step from `t`, some family without repetition is closed. -/
def Enclosed (t : Nat) : Prop :=
  ∃ es, Distinct es ∧ v.ClosedAt M es t

variable {M v}

/-- Without decided equality, a step enclosed by some family is not not enclosed around every
family: some family without repetition holding it is closed across the step. -/
theorem Enclosed.around_not_not {t : Nat} (enclosed : v.Enclosed M t) :
    ∀ ds : List w.Relatum, ¬¬ ∃ es, Distinct es ∧ (∀ c, c ∈ ds → c ∈ es) ∧ v.ClosedAt M es t
  | [] => fun no => match enclosed with
    | ⟨es, distinct, closed⟩ => no ⟨es, distinct, fun _ mem => (nomatch mem), closed⟩
  | a :: ds => fun no => enclosed.around_not_not ds fun ⟨es, distinct, sub, closed⟩ =>
    have widen : (a ∈ es ∨ ¬ a ∈ es) → False := fun
      | .inl inside => no ⟨es, distinct, fun c mem => match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun d => d ∈ es) same.symm inside
          | .inr mem => sub c mem, closed⟩
      | .inr outside => no ⟨a :: es, ⟨outside, distinct⟩, fun c mem =>
          match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun d => d ∈ a :: es) same.symm (.head es)
          | .inr mem => .tail a (sub c mem),
        fun f present c out => closed f present c fun inside => out (.tail a inside)⟩
    widen (.inr fun inside => widen (.inl inside))

/-- An embodied relatum ceasing falls. -/
theorem falls_of_ceases (embodied : v.Embodied M) {t : Nat} {x : w.Relatum}
    (ceases : w.web.Ceases t x) : v.Falls M t x := fun le =>
  ceases.2 ((embodied (t + 1) x).mpr fun within =>
    (embodied t x).mp ceases.1 (M.le_trans le within))

/-- With a census of the active relata, all embodied, the total over a family without repetition
holding what is active is, as far as can be refuted, the total over the census, each way. -/
theorem stock_census {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : v.Embodied M) {es : List w.Relatum} (distinct : Distinct es) {t : Nat}
    (holds : ∀ c, c ∈ alive t → c ∈ es) :
    ¬¬ (M.le (v.stock M es t) (v.stock M (alive t) t) ∧
      M.le (v.stock M (alive t) t) (v.stock M es t)) :=
  Amounts.totalOf_support distinct (census t).1 holds fun x _ out stands =>
    out (((census t).2 x).mp ((embodied t x).mpr stands))

/-- **The rest theorem over any amounts, read finitely, enclosed.** In a world in any amounts with
a census of its active relata, every relatum embodied, a balanced and dissipative flow, every step
from `T` on enclosed, and the census's total read off configurations a list holds from `T` on, that
the world rests from some step on cannot be refuted. No least loss, no Archimedean property and no
decision: at each step the enclosing family is widened, as far as can be refuted, to hold what is
active before and after it, its total does not rise and falls strictly at each arising or ceasing
(`InAmounts.change_lowers`), and it is the census's total each way (`InAmounts.stock_census`); so
the census's total, read finitely, comes to rest (`Amounts.rests_unrefuted_of_finite_reading`). -/
theorem rests_unrefuted_enclosed {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : v.Embodied M) (balanced : v.Balanced M) (dissipative : v.Dissipative M) {T : Nat}
    (enclosed : ∀ t, T ≤ t → v.Enclosed M t) {S : Type} {g : Nat → S} {q : S → A} {l : List S}
    (held : ∀ t, T ≤ t → g t ∈ l) (reads : ∀ t, T ≤ t → v.stock M (alive t) t = q (g t)) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  have around : ∀ t, T ≤ t → ¬¬ ∃ es, Distinct es ∧ (∀ c, c ∈ alive t → c ∈ es) ∧
      (∀ c, c ∈ alive (t + 1) → c ∈ es) ∧ v.BalancesOn M es t ∧ v.DissipatesOn M es t :=
    fun t later no => (enclosed t later).around_not_not (alive t ++ alive (t + 1))
      fun ⟨es, distinct, sub, closed⟩ => no ⟨es, distinct,
        fun c mem => sub c (mem_append_of_left _ mem), fun c mem => sub c (mem_append_of_right _ mem),
        fun c _ => balanced t c, dissipative es t distinct closed⟩
  have still : ∀ t, T ≤ t → ¬¬ M.le (q (g (t + 1))) (q (g t)) := fun t later no =>
    around t later fun ⟨_, distinct, before, after, balances, dissipates⟩ =>
      stock_census census embodied distinct before fun ⟨down, _⟩ =>
        stock_census census embodied distinct after fun ⟨_, up⟩ =>
          no (Eq.subst (motive := fun x => M.le x (q (g t))) (reads (t + 1) (Nat.le_succ_of_le later))
            (Eq.subst (motive := fun x => M.le (v.stock M (alive (t + 1)) (t + 1)) x) (reads t later)
              (M.le_trans up (M.le_trans (stock_still balances dissipates) down))))
  have strict : ∀ t, T ≤ t → ∀ x, (x ∈ alive t ∨ x ∈ alive (t + 1)) →
      (v.Rises M t x ∨ v.Falls M t x) → ¬ M.le (q (g t)) (q (g (t + 1))) :=
    fun t later x member changes le => around t later
      fun ⟨_, distinct, before, after, balances, dissipates⟩ =>
        stock_census census embodied distinct before fun ⟨up, _⟩ =>
          stock_census census embodied distinct after fun ⟨_, down⟩ =>
            change_lowers balances dissipates
              (match member with
                | .inl now => before x now
                | .inr next => after x next) changes
              (M.le_trans up (M.le_trans
                (Eq.subst (motive := fun x => M.le x (v.stock M (alive (t + 1)) (t + 1)))
                  (reads t later).symm
                  (Eq.subst (motive := fun x => M.le (q (g t)) x)
                    (reads (t + 1) (Nat.le_succ_of_le later)).symm le)) down))
  have unrefuted := Amounts.rests_unrefuted_of_finite_reading (M := M) held still
  World.rests_unrefuted_iff.mpr
  ⟨fun arising => unrefuted fun N from_ none_ => arising N fun ⟨t, x, after, arises⟩ =>
      none_ ⟨t, after, strict t (Nat.le_trans from_ after) x
        (.inr (((census (t + 1)).2 x).mp arises.2)) (.inl (rises_of_arises
          (fun _ y _ s => embodied s y) arises))⟩,
   fun ceasing => unrefuted fun N from_ none_ => ceasing N fun ⟨t, x, after, ceases⟩ =>
      none_ ⟨t, after, strict t (Nat.le_trans from_ after) x
        (.inl (((census t).2 x).mp ceases.1)) (.inr (falls_of_ceases embodied ceases))⟩⟩

end InAmounts

/-! ## Whole numbers are an instance -/

/-- A world read in whole-number amounts: its own levels, takes and gives. -/
def wholeAmounts (w : World) : w.InAmounts Nat :=
  ⟨w.web.level, w.flow.take, w.flow.give⟩

variable {w : World}

/-- A world's balance is its balance in whole-number amounts. -/
theorem balanced_whole (balanced : w.Balanced) : w.wholeAmounts.Balanced Amounts.whole :=
  fun t c => Nat.le_of_eq ((congrArg (w.web.level (t + 1) c + ·) (Amounts.totalOf_whole _)).trans
    ((balanced t c).trans (congrArg (w.web.level t c + ·) (Amounts.totalOf_whole _)).symm))

/-- In whole numbers, a total that with its sign is within another and holds the other is
nothing. -/
theorem nothing_of_sign {G T : Nat} (within : G + sign T ≤ T) (back : T ≤ G) : T ≤ 0 :=
  match T, within, back with
  | 0, _, _ => Nat.le_refl 0
  | _ + 1, within, back => absurd (Nat.le_trans within back) (Nat.not_succ_le_self G)

/-- A world's dissipation is its dissipation in whole-number amounts: what gives back all it takes
takes nothing, since a whole number that takes something loses at least one. -/
theorem dissipative_whole (dissipative : w.Dissipative) :
    w.wholeAmounts.Dissipative Amounts.whole := fun ds t distinct closed f mem =>
  have closedAt : w.flow.ClosedAt ds t := fun f mem c outside =>
    ⟨Nat.le_antisymm (closed f mem c outside).1 (Nat.zero_le _),
     Nat.le_antisymm (closed f mem c outside).2 (Nat.zero_le _)⟩
  have within := dissipative ds t distinct closedAt f mem
  have takes := Amounts.totalOf_whole (a := w.flow.take t f) ds
  have gives := Amounts.totalOf_whole (a := w.flow.give t f) ds
  ⟨Eq.subst (motive := fun x => x ≤ Amounts.whole.totalOf ds (w.flow.take t f)) gives.symm
      (Eq.subst (motive := fun x => total ds (w.flow.give t f) ≤ x) takes.symm
        (Nat.le_trans (Nat.le_add_right _ _) within)),
   fun back => Eq.subst (motive := fun x => x ≤ 0) takes.symm
      (nothing_of_sign within
        (Eq.subst (motive := fun x => total ds (w.flow.take t f) ≤ x) gives
          (Eq.subst (motive := fun x => x ≤ Amounts.whole.totalOf ds (w.flow.give t f)) takes back)))⟩

/-- A world whose arising is embodied has it embodied in whole-number amounts. -/
theorem arisingEmbodied_whole (embodied : w.ArisingEmbodied) :
    w.wholeAmounts.ArisingEmbodied Amounts.whole := fun t x arises s =>
  (embodied t x arises s).trans ⟨fun pos le => Nat.not_le_of_gt pos le, Nat.gt_of_not_le⟩

/-- **The whole-number instance.** A finite world whose flow balances and dissipates, whose arising
is embodied, and whose level functions a list holds, rests from some step on, unrefuted, by the law
over any amounts (`InAmounts.rests_unrefuted`). In whole numbers the list is not needed: the least
loss of one carries `World.rests_unrefuted`. -/
theorem rests_unrefuted_listed (finite : w.Finite) (balanced : w.Balanced)
    (dissipative : w.Dissipative) (embodied : w.ArisingEmbodied) {ls : List (w.Relatum → Nat)}
    (held : ∀ t, w.web.level t ∈ ls) : ¬ ¬ ∃ N, w.RestsFrom N :=
  InAmounts.rests_unrefuted (v := w.wholeAmounts) (M := Amounts.whole) finite
    (balanced_whole balanced) (dissipative_whole dissipative) (arisingEmbodied_whole embodied) held

/-- A world whose relata are embodied has them embodied in whole-number amounts. -/
theorem embodied_whole (embodied : w.Embodied) : w.wholeAmounts.Embodied Amounts.whole :=
  fun t x => (embodied x t).trans ⟨fun pos le => Nat.not_le_of_gt pos le, Nat.gt_of_not_le⟩

/-- A step a world's flow encloses is enclosed in whole-number amounts. -/
theorem enclosed_whole {t : Nat} (enclosed : w.flow.Enclosed t) :
    w.wholeAmounts.Enclosed Amounts.whole t :=
  match enclosed with
  | ⟨es, distinct, closed⟩ => ⟨es, distinct, fun f mem c outside =>
      ⟨Nat.le_of_eq (closed f mem c outside).1, Nat.le_of_eq (closed f mem c outside).2⟩⟩

/-- **The whole-number instance of the enclosed form.** A world with a census of its active
relata, all embodied, a balanced and dissipative flow, every step from `T` on enclosed, and the
census's total standing read off configurations a list holds, rests from some step on, unrefuted,
by the law over any amounts (`InAmounts.rests_unrefuted_enclosed`). In whole numbers the reading is
not needed (`World.rests_unrefuted_enclosed`). -/
theorem rests_unrefuted_enclosed_read {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : w.Embodied) (balanced : w.Balanced) (dissipative : w.Dissipative) {T : Nat}
    (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) {S : Type} {g : Nat → S} {q : S → Nat}
    {l : List S} (held : ∀ t, T ≤ t → g t ∈ l)
    (reads : ∀ t, T ≤ t → total (alive t) (w.web.level t) = q (g t)) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  InAmounts.rests_unrefuted_enclosed (v := w.wholeAmounts) (M := Amounts.whole) census
    (embodied_whole embodied) (balanced_whole balanced) (dissipative_whole dissipative)
    (fun t later => enclosed_whole (enclosed t later)) held
    fun t later => (Amounts.totalOf_whole _).trans (reads t later)

end World

/-! ## A standing that halves as it passes: the premise is needed over dense amounts -/

namespace HalvingPass

/-- Which relatum holds the standing at step `t`: `true` at even steps. -/
def even : Nat → Bool
  | 0 => true
  | t + 1 => !even t

/-- The amount `s` where the relatum is the holder `h`, nothing elsewhere. -/
def at_ : Bool → Bool → Dyadic → Dyadic
  | true, true, s => s
  | true, false, _ => Dyadic.zero
  | false, true, _ => Dyadic.zero
  | false, false, s => s

/-- Active is holding. -/
def web : Web Bool Bool :=
  ⟨fun _ _ => 0, fun t x => x = even t, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

/-- The holder takes part in each step. -/
def flow : Flow Bool Bool :=
  ⟨fun t => [even t], fun _ _ _ => 0, fun _ _ _ => 0⟩

/-- The world of two relata passing one standing. -/
def world : World :=
  World.of Bool flow web

/-- In dyadic amounts: the holder stands at `1 / 2 ^ t`, takes it all from itself, and gives half of
it to the other. -/
def amounts : world.InAmounts Dyadic :=
  ⟨fun t x => at_ (even t) x (Halving.stock t),
   fun t f c => at_ (even t) f (at_ (even t) c (Halving.stock t)),
   fun t f c => at_ (even t) f (at_ (!even t) c (Halving.stock (t + 1)))⟩

theorem at_self (h : Bool) (s : Dyadic) : at_ h h s = s := by
  cases h <;> rfl

theorem total_at (h : Bool) (s : Dyadic) :
    Dyadic.amounts.totalOf [true, false] (fun c => at_ h c s) = s := by
  cases h
  · exact (Dyadic.amounts.zero_add _).trans (Amounts.add_zero s)
  · exact (congrArg (Dyadic.amounts.add s) (Dyadic.amounts.zero_add _)).trans (Amounts.add_zero s)

theorem not_self (h : Bool) : ¬ (!h) = h := by
  cases h <;> exact fun same => nomatch same

theorem stock_positive : ∀ t, ¬ Dyadic.amounts.le (Halving.stock t) Dyadic.amounts.zero
  | 0 => fun le => Nat.not_succ_le_zero 0 le
  | t + 1 => Halving.loss_positive t

theorem stands_iff (h x : Bool) {s : Dyadic} (positive : ¬ Dyadic.amounts.le s Dyadic.amounts.zero) :
    x = h ↔ ¬ Dyadic.amounts.le (at_ h x s) Dyadic.amounts.zero := by
  cases h <;> cases x
  · exact ⟨fun _ => positive, fun _ => rfl⟩
  · exact ⟨(fun same => nomatch same), fun no => absurd (Dyadic.amounts.le_refl _) no⟩
  · exact ⟨(fun same => nomatch same), fun no => absurd (Dyadic.amounts.le_refl _) no⟩
  · exact ⟨fun _ => positive, fun _ => rfl⟩

/-- Every relatum is in the pair. -/
theorem covers (t : Nat) (x : Bool) (_ : world.web.active t x) : x ∈ [true, false] :=
  match x with
  | true => .head _
  | false => .tail _ (.head _)

/-- The pair balances at every step: what one relatum loses the other gains, with the loss. -/
theorem balances (t : Nat) : amounts.BalancesOn Dyadic.amounts [true, false] t := fun c _ =>
  Amounts.le_of_eq (by
    show Dyadic.amounts.add (at_ (!even t) c (Halving.stock (t + 1)))
        (Dyadic.amounts.add (at_ (even t) (even t) (at_ (even t) c (Halving.stock t)))
          Dyadic.amounts.zero) =
      Dyadic.amounts.add (at_ (even t) c (Halving.stock t))
        (Dyadic.amounts.add (at_ (even t) (even t) (at_ (!even t) c (Halving.stock (t + 1))))
          Dyadic.amounts.zero)
    rw [at_self, at_self, Amounts.add_zero, Amounts.add_zero, Dyadic.amounts.add_comm])

/-- The holder is the one taking part. -/
theorem present_holder {t : Nat} {f : Bool} (mem : f ∈ world.flow.present t) : f = even t :=
  have held : f ∈ [even t] := mem
  match held with
  | .head _ => rfl

/-- The pair is dissipated on at every step: the holder takes `1 / 2 ^ t` and gives back half. -/
theorem dissipates (t : Nat) : amounts.DissipatesOn Dyadic.amounts [true, false] t := fun f mem =>
  have takes : Dyadic.amounts.totalOf [true, false] (amounts.take t f) = Halving.stock t :=
    (Amounts.totalOf_congr fun _ _ => (present_holder mem).symm ▸ at_self (even t) _).trans
      (total_at (even t) _)
  have gives : Dyadic.amounts.totalOf [true, false] (amounts.give t f) = Halving.stock (t + 1) :=
    (Amounts.totalOf_congr fun _ _ => (present_holder mem).symm ▸ at_self (even t) _).trans
      (total_at (!even t) _)
  ⟨Eq.subst (motive := fun x => Dyadic.amounts.le x
      (Dyadic.amounts.totalOf [true, false] (amounts.take t f))) gives.symm
      (Eq.subst (motive := fun x => Dyadic.amounts.le (Halving.stock (t + 1)) x) takes.symm
        (Halving.never_rests.2.1 t)),
   fun back => absurd
      (Eq.subst (motive := fun x => Dyadic.amounts.le x (Halving.stock (t + 1))) takes
        (Eq.subst (motive := fun x => Dyadic.amounts.le
          (Dyadic.amounts.totalOf [true, false] (amounts.take t f)) x) gives back))
      (Halving.falls_strictly t)⟩

/-- Whatever arises is embodied: a relatum is active exactly where its dyadic level is not within
nothing. -/
theorem embodied : amounts.ArisingEmbodied Dyadic.amounts := fun _ x _ s =>
  stands_iff (even s) x (stock_positive s)

/-- At every step one relatum arises and the other ceases. -/
theorem arises (t : Nat) : world.web.Arises t (!even t) :=
  ⟨not_self (even t), rfl⟩

theorem ceases (t : Nat) : world.web.Ceases t (even t) :=
  ⟨rfl, fun same => not_self (even t) same.symm⟩

/-- **Arising and ceasing recur over dense amounts.** In the shuttle the flow balances and dissipates
on the pair, whatever arises is embodied and every active relatum is in the pair, the premises of
`InAmounts.rests_unrefuted_covering` but the finite reading, and still the world rests from no step
on: one relatum arises and the other ceases at every step. -/
theorem never_rests : ∀ N, ¬ world.RestsFrom N :=
  fun N quiet => (quiet N (Nat.le_refl N) (!even N)).1 (arises N)

/-- **No list holds the shuttle's levels**, by the rest theorem over any amounts: a list holding
them would bring the world to rest. Its shrinking losses and the unbounded count of its level
functions are one fact read twice, as for the halving stock (`Halving.stock_unlisted`). -/
theorem levels_unlisted : ¬ ∃ ls : List (Bool → Dyadic), ∀ t, amounts.level t ∈ ls :=
  fun ⟨_, held⟩ =>
    World.InAmounts.rests_unrefuted_reading (M := Dyadic.amounts) (v := amounts) (T := 0)
      (ds := [true, false]) (g := amounts.level) (read := fun lv => lv)
      (fun t _ => covers t) (fun t _ => balances t) (fun t _ => dissipates t) embodied
      (fun t _ => held t) (fun _ _ _ _ => rfl)
      fun ⟨N, quiet⟩ => never_rests N quiet

end HalvingPass

end Becoming
