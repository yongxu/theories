import Becoming.Assurance
import Becoming.Witnesses

/-!
# Plans under assurance: endpoints, responses and the readings they need

`Becoming.Assurance` states when a plan completes (`InquirySufficiency.Completes`): every step
possible and safe from every configuration the earlier steps can reach, every endpoint in the
goal. This module states what the older wisdom line (`CorePredication`, `ContextualWisdom`,
`WisdomResponseStructure`, 8 October) proved on its own predicates, on the core's process,
traces and completion (board item F3R, 18 October 2026). It adds no premise.

* **Endpoints of one plan.** For a determined process (`Becoming.Determined`) two traces of one
  plan from one configuration end alike (`Trace.determined_end`), so some endpoint in the goal
  makes every endpoint be in it (`every_end_of_some_end`). Without determinacy that fails: in
  `Open`, where every move goes anywhere, one move from `false` may end at `true` and need not
  (`Open.some_not_every`). Where no move is possible (`Shut`) the plan has no trace, every
  endpoint condition holds vacuously, and no endpoint meets any goal (`Shut.no_trace`,
  `Shut.every_end_vacuous`, `Shut.no_end`).
* **Completion depends on the goal only pointwise** (`completes_congr`).
* **A response read from the configuration.** For a law of change `f` and a response
  `respond : S → A`, the plan the response makes, one move after another from where the law has
  taken the configuration (`itinerary`), completes into every set the response keeps, for every
  length (`completes_itinerary`). In `Regulation`, a count moved up or down by one and kept
  within the band from one to two: the band needs opposite moves at its two ends
  (`Regulation.opposite_moves`), so no move chosen through a reading that merges the two ends
  keeps both (`Regulation.no_merged_move`); the response that adds at one and removes above
  keeps the band (`Regulation.respond_keeps`) along its itinerary of every length
  (`Regulation.kept_along`), and the move that succeeds once does not succeed twice
  (`Regulation.next_move_changes`).
* **Readings adequate for a response have no coarsest.** In `Routes` a mode names the one route
  that does not arrive (`Routes.completes_iff`). A reading of the mode is adequate when some
  response to it arrives from every mode. Two adequate readings (`leftReading`, `rightReading`)
  each merge modes whose outcomes under one route differ (`Routes.adequate_merges_outcomes`);
  every two modes share an arriving route (`Routes.pairwise_common`) but no route arrives from
  all three (`Routes.no_common`). A reading that both adequate readings refine is constant
  (`Routes.common_coarsening_constant`), hence not adequate
  (`Routes.common_coarsening_inadequate`), so no adequate reading is refined by every adequate
  reading (`Routes.no_coarsest_adequate`).

The regulation band and the three routes are supplied examples, not models of dispositions,
of wisdom or of ethical evaluation. Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative Generative.InquirySufficiency Assurance

universe u v w

namespace AssurancePlans

variable {S : Type u} {A : Type v}

/-! ## Endpoints of one plan -/

/-- **Under a determined process, one endpoint of a plan in the goal puts every endpoint in it.** -/
theorem every_end_of_some_end {P : Process S A} (determined : Determined P) {s : S}
    {plan : List A} {goal : S → Prop} (some_end : ∃ t, Trace P s plan t ∧ goal t) :
    ∀ t, Trace P s plan t → goal t :=
  match some_end with
  | ⟨_, path, held⟩ => fun _ path' =>
    Eq.subst (motive := goal) (Trace.determined_end determined path path') held

namespace Open

/-- Every move goes anywhere. -/
def process : Process Bool Unit := everyStep Bool Unit

/-- **Without determinacy, one endpoint in the goal does not put every endpoint there:** one move
from `false` may end at `true`, and may not. -/
theorem some_not_every :
    (∃ t, Trace process false [()] t ∧ t = true) ∧ ¬ ∀ t, Trace process false [()] t → t = true :=
  ⟨⟨true, .cons trivial (.nil _), rfl⟩,
   fun every => Bool.noConfusion (every false (.cons trivial (.nil _)))⟩

end Open

namespace Shut

/-- No move is possible. -/
def process : Process Bool Unit := Witnesses.halted Bool Unit

/-- **Where no move is possible, a plan of one move has no trace.** -/
theorem no_trace : ¬ Feasible process false [()]
  | ⟨_, .cons step _⟩ => step

/-- **Every endpoint condition holds vacuously,** even the impossible one. -/
theorem every_end_vacuous : ∀ t, Trace process false [()] t → False
  | _, .cons step _ => step

/-- **No endpoint meets any goal.** -/
theorem no_end : ¬ ∃ t, Trace process false [()] t ∧ True
  | ⟨t, path, _⟩ => no_trace ⟨t, path⟩

end Shut

/-! ## Completion depends on the goal pointwise -/

/-- **Completion depends on the goal only pointwise.** -/
theorem completes_congr {P : Process S A} {safe : S → A → S → Prop} {goal goal' : S → Prop}
    (same : ∀ s, goal s ↔ goal' s) :
    ∀ (plan : List A) (s : S), Completes P safe goal s plan ↔ Completes P safe goal' s plan
  | [], s => same s
  | _ :: rest, _ =>
    ⟨fun ⟨enabled, every⟩ => ⟨enabled, fun t step =>
        ⟨(every t step).1, (completes_congr same rest t).mp (every t step).2⟩⟩,
     fun ⟨enabled, every⟩ => ⟨enabled, fun t step =>
        ⟨(every t step).1, (completes_congr same rest t).mpr (every t step).2⟩⟩⟩

/-! ## A response read from the configuration -/

/-- The plan a response makes under a law of change: from each configuration, the move the
response reads off it, then on from where the law takes it. -/
def itinerary (f : S → A → S) (respond : S → A) : Nat → S → List A
  | 0, _ => []
  | k + 1, s => respond s :: itinerary f respond k (f s (respond s))

/-- **A response that keeps a set keeps it along its itinerary of every length:** the plan
completes into the set under the law. -/
theorem completes_itinerary {f : S → A → S} {respond : S → A} {K : S → Prop}
    (keeps : ∀ x, K x → K (f x (respond x))) :
    ∀ (k : Nat) (s : S), K s → Completes (ofMap f) free K s (itinerary f respond k s)
  | 0, _, held => held
  | k + 1, s, held =>
    ⟨⟨f s (respond s), rfl⟩, fun t step =>
      ⟨trivial, Eq.subst (motive := fun x => Completes (ofMap f) free K x
          (itinerary f respond k (f s (respond s))))
        (show f s (respond s) = t from step.symm)
        (completes_itinerary keeps k (f s (respond s)) (keeps s held))⟩⟩

namespace Regulation

/-- Add one or remove one. -/
inductive Move where
  | add
  | remove
  deriving DecidableEq

/-- The law of change of the count. -/
def update (n : Nat) : Move → Nat
  | .add => n + 1
  | .remove => n - 1

/-- The count under its law. -/
def process : Process Nat Move := ofMap update

/-- A supplied operating band. -/
def Band (n : Nat) : Prop := 1 ≤ n ∧ n ≤ 2

instance decidableBand (n : Nat) : Decidable (Band n) := inferInstanceAs (Decidable (1 ≤ n ∧ n ≤ 2))

/-- Add at or below one, remove above. -/
def respond (n : Nat) : Move := if n ≤ 1 then .add else .remove

/-- **The band needs opposite moves at its two ends.** -/
theorem opposite_moves :
    Completes process free Band 1 [.add] ∧ ¬ Completes process free Band 1 [.remove] ∧
      Completes process free Band 2 [.remove] ∧ ¬ Completes process free Band 2 [.add] :=
  ⟨(completes_ofMap_single update 1 .add).mpr (by decide),
   fun done => absurd ((completes_ofMap_single update 1 .remove).mp done) (by decide),
   (completes_ofMap_single update 2 .remove).mpr (by decide),
   fun done => absurd ((completes_ofMap_single update 2 .add).mp done) (by decide)⟩

/-- **No move chosen through a reading that merges the two ends keeps both.** -/
theorem no_merged_move {O : Type w} (reading : Nat → O) (merged : reading 1 = reading 2)
    (choose : O → Move) :
    ¬ (Completes process free Band 1 [choose (reading 1)] ∧
        Completes process free Band 2 [choose (reading 2)]) := by
  intro ⟨low, high⟩
  have low := (completes_ofMap_single update 1 (choose (reading 1))).mp low
  have high := (completes_ofMap_single update 2 (choose (reading 2))).mp high
  rw [← merged] at high
  cases choice : choose (reading 1) with
  | add => rw [choice] at high; exact absurd high (by decide)
  | remove => rw [choice] at low; exact absurd low (by decide)

/-- **The response keeps the band.** -/
theorem respond_keeps : ∀ n, Band n → Band (update n (respond n))
  | 0, held => absurd held.1 (by decide)
  | 1, _ => by decide
  | 2, _ => by decide
  | n + 3, held => absurd held.2 (fun le =>
      Nat.not_succ_le_zero n (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ le)))

/-- **Along the response's itinerary of every length the band is kept.** -/
theorem kept_along (k n : Nat) (held : Band n) :
    Completes process free Band n (itinerary update respond k n) :=
  completes_itinerary respond_keeps k n held

/-- **The move that succeeds once does not succeed twice; the response changes it.** -/
theorem next_move_changes :
    process.step 1 .add 2 ∧ Completes process free Band 1 [.add] ∧
      ¬ Completes process free Band 1 [.add, .add] ∧
      Completes process free Band 1 [.add, .remove] :=
  ⟨rfl, opposite_moves.1,
   fun done => absurd ((completes_ofMap_iff update 1 [.add, .add]).mp done) (by decide),
   (completes_ofMap_iff update 1 [.add, .remove]).mpr (by decide)⟩

end Regulation

/-! ## Readings adequate for a response -/

namespace Routes

/-- Three modes, three routes; a configuration is a mode and whether it has arrived. -/
abbrev Mode := Fin 3

/-- The three modes and routes, named without the numeral instance of `Fin`. -/
def zero : Fin 3 := ⟨0, by decide⟩
def one : Fin 3 := ⟨1, by decide⟩
def two : Fin 3 := ⟨2, by decide⟩

/-- A route arrives exactly when it differs from the mode. -/
def advance (s : Fin 3 × Bool) (a : Fin 3) : Fin 3 × Bool := (s.1, decide (a ≠ s.1))

/-- The routes under their law. -/
def process : Process (Fin 3 × Bool) (Fin 3) := ofMap advance

/-- Arrived. -/
def Reached (s : Fin 3 × Bool) : Prop := s.2 = true

/-- A reading of the mode is adequate for a response when the response to it arrives from
every mode. -/
def Adequate {O : Type w} (reading : Mode → O) (respond : O → Fin 3) : Prop :=
  ∀ m, Completes process free Reached (m, false) [respond (reading m)]

/-- Whether the mode is `zero`. -/
def leftReading (m : Mode) : Bool := decide (m = zero)
/-- Whether the mode is `two`. -/
def rightReading (m : Mode) : Bool := decide (m = two)
/-- Route `one` on `zero`, else route `zero`. -/
def leftRespond (o : Bool) : Fin 3 := if o then one else zero
/-- Route `zero` on `two`, else route `two`. -/
def rightRespond (o : Bool) : Fin 3 := if o then zero else two

/-- Every mode is `zero`, `one` or `two`. -/
theorem cases3 : ∀ m : Fin 3, m = zero ∨ m = one ∨ m = two
  | ⟨0, _⟩ => .inl rfl
  | ⟨1, _⟩ => .inr (.inl rfl)
  | ⟨2, _⟩ => .inr (.inr rfl)
  | ⟨n + 3, bound⟩ => absurd bound (fun lt =>
      Nat.not_succ_le_zero n (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ
        (Nat.le_of_succ_le_succ lt))))

/-- **One route arrives from an unreached mode exactly when it differs from the mode.** -/
theorem completes_iff (m a : Mode) :
    Completes process free Reached (m, false) [a] ↔ a ≠ m :=
  (completes_ofMap_single advance (m, false) a).trans
    ⟨fun reached => of_decide_eq_true reached, fun differs => decide_eq_true differs⟩

theorem left_adequate : Adequate leftReading leftRespond := fun m =>
  (completes_iff m _).mpr (match m, cases3 m with
    | _, .inl rfl => by decide
    | _, .inr (.inl rfl) => by decide
    | _, .inr (.inr rfl) => by decide)

theorem right_adequate : Adequate rightReading rightRespond := fun m =>
  (completes_iff m _).mpr (match m, cases3 m with
    | _, .inl rfl => by decide
    | _, .inr (.inl rfl) => by decide
    | _, .inr (.inr rfl) => by decide)

/-- **An adequate reading may merge modes whose outcomes under one route differ.** -/
theorem adequate_merges_outcomes :
    Adequate leftReading leftRespond ∧ leftReading one = leftReading two ∧
      ¬ Completes process free Reached (one, false) [one] ∧
      Completes process free Reached (two, false) [one] :=
  ⟨left_adequate, rfl, fun done => (completes_iff one one).mp done rfl,
   (completes_iff two one).mpr (by decide)⟩

/-- **Every two modes share an arriving route.** -/
theorem pairwise_common (m n : Mode) :
    ∃ a, Completes process free Reached (m, false) [a] ∧
      Completes process free Reached (n, false) [a] :=
  have pick : ∃ a : Fin 3, a ≠ m ∧ a ≠ n := match m, n, cases3 m, cases3 n with
    | _, _, .inl rfl, .inl rfl => ⟨one, by decide, by decide⟩
    | _, _, .inl rfl, .inr (.inl rfl) => ⟨two, by decide, by decide⟩
    | _, _, .inl rfl, .inr (.inr rfl) => ⟨one, by decide, by decide⟩
    | _, _, .inr (.inl rfl), .inl rfl => ⟨two, by decide, by decide⟩
    | _, _, .inr (.inl rfl), .inr (.inl rfl) => ⟨zero, by decide, by decide⟩
    | _, _, .inr (.inl rfl), .inr (.inr rfl) => ⟨zero, by decide, by decide⟩
    | _, _, .inr (.inr rfl), .inl rfl => ⟨one, by decide, by decide⟩
    | _, _, .inr (.inr rfl), .inr (.inl rfl) => ⟨zero, by decide, by decide⟩
    | _, _, .inr (.inr rfl), .inr (.inr rfl) => ⟨zero, by decide, by decide⟩
  match pick with
  | ⟨a, ne_m, ne_n⟩ => ⟨a, (completes_iff m a).mpr ne_m, (completes_iff n a).mpr ne_n⟩

/-- **No route arrives from every mode.** -/
theorem no_common : ¬ ∃ a, ∀ m, Completes process free Reached (m, false) [a]
  | ⟨a, every⟩ => (completes_iff a a).mp (every a) rfl

/-- **A reading that both adequate readings refine is constant.** -/
theorem common_coarsening_constant {O : Type w} (q : Mode → O) (fromLeft fromRight : Bool → O)
    (left : ∀ m, q m = fromLeft (leftReading m)) (right : ∀ m, q m = fromRight (rightReading m)) :
    ∀ m, q m = q zero :=
  have h01 : q zero = q one := (right zero).trans (right one).symm
  have h12 : q one = q two := (left one).trans (left two).symm
  fun m => match m, cases3 m with
    | _, .inl rfl => rfl
    | _, .inr (.inl rfl) => h01.symm
    | _, .inr (.inr rfl) => (h01.trans h12).symm

/-- **Hence it is not adequate for any response.** -/
theorem common_coarsening_inadequate {O : Type w} (q : Mode → O) (fromLeft fromRight : Bool → O)
    (left : ∀ m, q m = fromLeft (leftReading m)) (right : ∀ m, q m = fromRight (rightReading m))
    (respond : O → Fin 3) : ¬ Adequate q respond := fun adequate =>
  have same := common_coarsening_constant q fromLeft fromRight left right
  have fails := (completes_iff (respond (q zero)) (respond (q (respond (q zero))))).mp
    (adequate (respond (q zero)))
  fails (congrArg respond (same (respond (q zero))))

/-- **No adequate reading is refined by every adequate reading.** -/
theorem no_coarsest_adequate {O : Type w} :
    ¬ ∃ q : Mode → O, (∃ respond, Adequate q respond) ∧
      ∀ p : Mode → Bool, (∃ respond, Adequate p respond) →
        ∃ forget : Bool → O, ∀ m, q m = forget (p m)
  | ⟨q, ⟨respond, adequate⟩, coarsest⟩ =>
    match coarsest leftReading ⟨leftRespond, left_adequate⟩,
        coarsest rightReading ⟨rightRespond, right_adequate⟩ with
    | ⟨fromLeft, left⟩, ⟨fromRight, right⟩ =>
      common_coarsening_inadequate q fromLeft fromRight left right respond adequate

end Routes

end AssurancePlans

end Becoming
