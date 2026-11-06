import Becoming.FinerTraces
import Becoming.TypicalRuns
import Becoming.Resolution

/-!
# Situation traces: the counts of situations are counts of the traces of one determined process

`Becoming.Situations` counts natural weights as situations: the law whose moves are situations
(`Situations.finerLaw`) is a determined process of the spine, and its counts are sums over the
list of finer courses (`Situations.finer`). `Becoming.FinerTraces` showed that a list of situations
is a finer course exactly where it is a trace of the finer law taking listed moves to listed
configurations, and left open whether each trace is listed once. This module closes that: with
the moves and configurations listed without repetition, the finer courses list each such trace
once (`finer_traces`), so every count of `Becoming.Situations` is a count of the traces of the
finer law, the same for every list holding each of them once (`TypicalRuns.sum_listed`).

* **Each trace once.** Joining lists without repetition whose members are tagged by where they
  come from repeats nothing (`distinct_joinMap`), so with the moves and configurations listed
  without repetition the finer courses of `n` steps hold each trace of the finer law of `n`
  steps through listed moves and configurations once (`finer_traces`; on two values,
  `finer_twoTraces`). A list in which nothing occurs more than once is without repetition
  (`distinct_of_occ`).
* **The law of large numbers counts traces.** On two values with `p` and `q` situations, for
  every list holding each trace of `n` steps of the finer law once: there are `(p + q) ^ n`
  (`traces_count`); those taking a course number its weight (`course_traces`); and those whose
  course deviates by at least `d` number, times `d`, at most `n·p·q·(p + q)^n`
  (`traces_typical`).
* **For every event.** With `wt v` situations for each value of a list without repetition, the
  traces of the finer law of `n` steps through those values number `(P + Q) ^ n`
  (`event_traces_count`); the law of large numbers (`event_traces_typical`) and exponential
  concentration (`event_traces_concentrated`) count them.
* **For every process.** Where every move and configuration is listed once, the traces of the
  finer law taking a course number its weight (`course_traces_listed`).
* **Signed weights count traces of two kinds.** The signed transfer is the pair of the counts of
  the finer law's traces composing to adding and to subtracting (`signed_traces`), and the
  balanced weighting of `Interference.cancels` is taken by two traces of one step
  (`cancels_traces`), one adding and one subtracting (`cancels_counts`).

What is not derived: which trace is the one taken; that the course which happens is typical. No
ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

namespace SituationTraces

open Situations

universe u v

/-! ## Lists without repetition -/

section Distinct

variable {α : Type u} {β : Type v}

theorem distinct_map {g : α → β} (inj : ∀ a b, g a = g b → a = b) :
    ∀ {l : List α}, Distinct l → Distinct (l.map g)
  | [], _ => trivial
  | a :: l, ⟨out, rest⟩ =>
    show ¬ g a ∈ l.map g ∧ Distinct (l.map g) from
    ⟨fun mem => match ListTests.mem_map_iff.mp mem with
      | ⟨a', inside, same⟩ =>
        out (Eq.subst (motive := fun x => x ∈ l) (inj a' a same) inside),
     distinct_map inj rest⟩

/-- **Joining lists without repetition whose members are tagged by where they come from repeats
nothing.** -/
theorem distinct_joinMap {g : α → List β} :
    ∀ {l : List α}, Distinct l → (∀ a, a ∈ l → Distinct (g a)) →
      (∀ a b x, x ∈ g a → x ∈ g b → a = b) → Distinct (joinMap g l)
  | [], _, _, _ => trivial
  | a :: l, ⟨out, rest⟩, each, tags =>
    show Distinct (g a ++ joinMap g l) from
    distinct_append (each a (.head l))
      (distinct_joinMap rest (fun b mem => each b (.tail a mem)) tags)
      (fun x inside other => match FinerTraces.of_mem_joinMap other with
        | ⟨b, mem, inner⟩ =>
          out (Eq.subst (motive := fun y => y ∈ l) (tags b a x inner inside) mem))

theorem distinct_upto : ∀ k, Distinct (Undecided.upto k)
  | 0 => trivial
  | k + 1 => show ¬ k ∈ Undecided.upto k ∧ Distinct (Undecided.upto k) from
    ⟨fun mem => Nat.lt_irrefl k (FinerTraces.lt_of_mem_upto mem), distinct_upto k⟩

theorem occ_pos [DecidableEq α] {x : α} : ∀ {k : List α}, x ∈ k → 1 ≤ occ k x
  | _ :: _, .head _ => Nat.le_trans (Nat.le_of_eq (if_pos rfl).symm) (Nat.le_add_right _ _)
  | _ :: _, .tail _ mem => Nat.le_trans (occ_pos mem) (Nat.le_add_left _ _)

/-- **Nothing occurring more than once, a list is without repetition.** -/
theorem distinct_of_occ [DecidableEq α] : ∀ {l : List α}, (∀ a, occ l a ≤ 1) →
    Distinct l
  | [], _ => trivial
  | x :: l, le =>
    show ¬ x ∈ l ∧ Distinct l from
    ⟨fun mem =>
      have here : occ (x :: l) x = 1 + occ l x := congrArg (· + occ l x) (if_pos rfl)
      Nat.not_succ_le_self 1
        (Nat.le_trans (Nat.add_le_add_left (occ_pos mem) 1)
          (Eq.subst (motive := fun y => y ≤ 1) here (le x))),
     distinct_of_occ fun a => Nat.le_trans (Nat.le_add_left _ _) (le a)⟩

end Distinct

/-! ## Each trace of the finer law once -/

section Finer

variable {S : Type u} {A : Type v}

theorem distinct_openSteps {moves : List A} {all : List S} (dm : Distinct moves)
    (da : Distinct all) : Distinct (openSteps moves all) :=
  distinct_joinMap dm (fun _ _ => distinct_map (fun _ _ same => congrArg Prod.snd same) da)
    (fun _ _ _ ina inb => match ListTests.mem_map_iff.mp ina, ListTests.mem_map_iff.mp inb with
      | ⟨_, _, ea⟩, ⟨_, _, eb⟩ => (congrArg Prod.fst ea).trans (congrArg Prod.fst eb).symm)

theorem distinct_finerSteps (weight : S → A → S → Nat) {moves : List A} {all : List S}
    (dm : Distinct moves) (da : Distinct all) (s : S) :
    Distinct (finerSteps weight moves all s) :=
  distinct_joinMap (distinct_openSteps dm da)
    (fun _ _ => distinct_map (fun _ _ same => congrArg (fun y : A × S × Nat => y.2.2) same)
      (distinct_upto _))
    (fun _ _ _ ina inb => match ListTests.mem_map_iff.mp ina, ListTests.mem_map_iff.mp inb with
      | ⟨_, _, ea⟩, ⟨_, _, eb⟩ =>
        (congrArg (fun y : A × S × Nat => (y.1, y.2.1)) ea).trans
          (congrArg (fun y : A × S × Nat => (y.1, y.2.1)) eb).symm)

/-- The finer courses of `n` steps repeat nothing where the moves and configurations are listed
without repetition. -/
theorem distinct_finer (weight : S → A → S → Nat) {moves : List A} {all : List S}
    (dm : Distinct moves) (da : Distinct all) :
    ∀ n s, Distinct (finer weight moves all n s)
  | 0, _ => show ¬ ([] : List (A × S × Nat)) ∈ ([] : List (List (A × S × Nat))) ∧ True from
      ⟨fun mem => (nomatch mem), trivial⟩
  | n + 1, s =>
    distinct_joinMap (distinct_finerSteps weight dm da s)
      (fun x _ => distinct_map (fun _ _ same => (List.cons.inj same).2)
        (distinct_finer weight dm da n x.2.1))
      (fun _ _ _ inx iny => match ListTests.mem_map_iff.mp inx, ListTests.mem_map_iff.mp iny with
        | ⟨_, _, ex⟩, ⟨_, _, ey⟩ => (List.cons.inj (ex.trans ey.symm)).1)

/-- A trace of `n` steps of the finer law from `s`, taking listed moves to listed
configurations. -/
def FinerTrace (weight : S → A → S → Nat) (moves : List A) (all : List S) (n : Nat) (s : S)
    (h : List (A × S × Nat)) : Prop :=
  h.length = n ∧ (∃ t, Trace (finerLaw weight) s h t) ∧ ∀ x, x ∈ h → x.1 ∈ moves ∧ x.2.1 ∈ all

/-- `l` holds every trace of `n` steps of the finer law from `s` through listed moves and
configurations once. -/
def Traces (weight : S → A → S → Nat) (moves : List A) (all : List S) (n : Nat) (s : S)
    (l : List (List (A × S × Nat))) : Prop :=
  TypicalRuns.Listing (FinerTrace weight moves all n s) l

/-- **The finer courses hold each trace of the finer law once**, where the moves and
configurations are listed without repetition. -/
theorem finer_traces (weight : S → A → S → Nat) {moves : List A} {all : List S}
    (dm : Distinct moves) (da : Distinct all) (n : Nat) (s : S) :
    Traces weight moves all n s (finer weight moves all n s) :=
  ⟨distinct_finer weight dm da n s, FinerTraces.mem_finer_iff weight moves all n s⟩

end Finer

/-! ## Two values -/

/-- `l` holds every trace of `n` steps from `s` of the finer law of two values with `p` and `q`
situations once. -/
def TwoTraces (p q n : Nat) (s : Bool) (l : List (List (Unit × Bool × Nat))) : Prop :=
  TypicalRuns.Listing
    (fun h => h.length = n ∧ ∃ t, Trace (finerLaw (Typicality.stepWeight p q)) s h t) l

theorem finer_twoTraces (p q n : Nat) (s : Bool) :
    TwoTraces p q n s (finer (Typicality.stepWeight p q) [()] [true, false] n s) :=
  ⟨distinct_finer _ Asymptote.distinct Shuttle.distinct n s, FinerTraces.two_values_mem_iff p q n s⟩

section Two

variable {p q n : Nat} {s : Bool} {l : List (List (Unit × Bool × Nat))}

/-- **There are `(p + q) ^ n` traces of `n` steps of the finer law.** -/
theorem traces_count (listed : TwoTraces p q n s l) : l.length = (p + q) ^ n :=
  (TypicalRuns.length_listed listed (finer_twoTraces p q n s)).trans (situations_count p q n s)

/-- **The weight of a course is the number of traces of the finer law that take it.** -/
theorem course_traces {w : List Bool} (listed : TwoTraces p q w.length s l) :
    counting.sum l (fun h => if (coarse h).map Prod.snd = w then 1 else 0) =
      Typicality.weight p q w :=
  (TypicalRuns.sum_listed listed (finer_twoTraces p q w.length s) _).trans
    (situations_of_course p q s w)

/-- **The law of large numbers counts the traces of the finer law.** Of the `(p + q) ^ n`
traces of `n` steps, those whose course deviates by at least `d` number, times `d`, at most
`n·p·q·(p + q)^n`. -/
theorem traces_typical (listed : TwoTraces p q n s l) (d : Nat) :
    counting.sum l (fun h => far p q d ((coarse h).map Prod.snd)) * d ≤
      n * (p * q * (p + q) ^ n) :=
  Eq.subst (motive := fun x => x * d ≤ n * (p * q * (p + q) ^ n))
    (TypicalRuns.sum_listed (finer_twoTraces p q n s) listed _) (situations_typical p q n d s)

end Two

/-! ## Any number of values: an event -/

section Event

variable {V : Type u} {vals : List V} {n : Nat} {s : V} {l : List (List (Unit × V × Nat))}

/-- **The traces of the finer law number the weight of all values to the `n`.** -/
theorem event_traces_count (wt : V → Nat) (distinct : Distinct vals)
    (listed : Traces (valueWeight wt) [()] vals n s l) : l.length = (counting.sum vals wt) ^ n :=
  (TypicalRuns.length_listed listed (finer_traces _ Asymptote.distinct distinct n s)).trans
    (event_count vals wt n s)

/-- **The law of large numbers counts the traces of the finer law for every event.** -/
theorem event_traces_typical (wt : V → Nat) (event : V → Bool) (d : Nat)
    (distinct : Distinct vals) (listed : Traces (valueWeight wt) [()] vals n s l) :
    counting.sum l
        (fun h => far (inside vals wt event) (outside vals wt event) d (seen event (coarse h))) * d ≤
      n * (inside vals wt event * outside vals wt event *
        (inside vals wt event + outside vals wt event) ^ n) :=
  Eq.subst (motive := fun x => x * d ≤ _)
    (TypicalRuns.sum_listed (finer_traces _ Asymptote.distinct distinct n s) listed _)
    (event_typical vals wt event n d s)

/-- **Exponentially few traces of the finer law run far ahead for every event.** -/
theorem event_traces_concentrated (wt : V → Nat) (event : V → Bool) (k : Nat) {u v : Nat}
    (le : v ≤ u) (distinct : Distinct vals)
    (listed : Traces (valueWeight wt) [()] vals n s l) :
    counting.sum l (fun h => if k ≤ Typicality.ones (seen event (coarse h)) then 1 else 0) *
        (u ^ k * v ^ n) ≤
      (inside vals wt event * u + outside vals wt event * v) ^ n * v ^ k :=
  Eq.subst (motive := fun x => x * (u ^ k * v ^ n) ≤ _)
    (TypicalRuns.sum_listed (finer_traces _ Asymptote.distinct distinct n s) listed _)
    (event_concentrated vals wt event k n s le)

end Event

/-! ## Every process -/

section Course

variable {S : Type u} {A : Type v} [DecidableEq A] [DecidableEq S]

/-- **The traces of the finer law taking a course number its weight, for every process** where
every move and configuration is listed once. -/
theorem course_traces_listed (weight : S → A → S → Nat) {moves : List A} {all : List S}
    (once_moves : ∀ a, occ moves a = 1) (once_all : ∀ m, occ all m = 1) (s : S)
    (c : List (A × S)) {l : List (List (A × S × Nat))}
    (listed : Traces weight moves all c.length s l) :
    counting.sum l (fun h => if coarse h = c then 1 else 0) =
      counting.along weight (fun _ => 1) s c :=
  (TypicalRuns.sum_listed listed
      (finer_traces weight (distinct_of_occ fun a => Nat.le_of_eq (once_moves a))
        (distinct_of_occ fun m => Nat.le_of_eq (once_all m)) c.length s) _).trans
    (situations_of_course_listed weight once_moves once_all s c)

end Course

/-! ## Signed weights -/

section Signed

variable {S : Type u} {A : Type v}

/-- **A signed weight is a pair of counts of traces.** With the moves and configurations listed
without repetition, the signed transfer counts, among the traces of the finer law through the
`P + N` situations of each step, those composing to adding and those composing to
subtracting. -/
theorem signed_traces (weight : S → A → S → Nat × Nat) {moves : List A} {all : List S}
    (dm : Distinct moves) (da : Distinct all) (n : Nat) (s : S)
    {l : List (List (A × S × Nat))} (listed : Traces (both weight) moves all n s l) :
    signed.transfer weight moves all (fun _ => signed.one) n s =
      (counting.sum l (fun h => if signs signed (Situations.sign weight) s h = (1, 0) then 1 else 0),
        counting.sum l (fun h => if signs signed (Situations.sign weight) s h = (0, 1) then 1 else 0)) :=
  have finer := finer_traces (both weight) dm da n s
  (signed_counts weight moves all n s).trans
    (congr (congrArg Prod.mk (TypicalRuns.sum_listed finer listed _))
      (TypicalRuns.sum_listed finer listed _))

/-- **Where signed weights cancel, the traces do not.** The balanced weighting of
`Interference.cancels` is taken by two traces of one step of the finer law. -/
theorem cancels_traces {l : List (List (Bool × Unit × Nat))}
    (listed : Traces (both Interference.weight) [true, false] [()] 1 () l) : l.length = 2 :=
  (TypicalRuns.length_listed listed (finer_traces _ Shuttle.distinct Asymptote.distinct 1 ())).trans
    cancels_situations.2

/-- **Of the two traces of the balanced weighting, one adds and one subtracts.** Counted among the
one-step traces of the finer law, those composing to adding and those composing to subtracting
are one each: the cancellation of `Interference.cancels` is a balance between them. -/
theorem cancels_counts {l : List (List (Bool × Unit × Nat))}
    (listed : Traces (both Interference.weight) [true, false] [()] 1 () l) :
    (counting.sum l (fun h =>
        if signs signed (Situations.sign Interference.weight) () h = (1, 0) then 1 else 0),
      counting.sum l (fun h =>
        if signs signed (Situations.sign Interference.weight) () h = (0, 1) then 1 else 0)) =
      (1, 1) :=
  (signed_traces Interference.weight Shuttle.distinct Asymptote.distinct 1 () listed).symm.trans
    Interference.cancels.2

end Signed

end SituationTraces

end Becoming
