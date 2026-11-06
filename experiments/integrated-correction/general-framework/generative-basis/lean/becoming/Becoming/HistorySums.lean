import Becoming.Routes
import Becoming.FinerTraces

/-!
# History sums: support, splitting, exact orders and the steps between

`Becoming.Weighted` sums over histories for every weighting of steps, and `Becoming.Routes`
expands that sum by order: order `j` is what the courses of at most `j` responses carry. Four laws
of the sum were not stated there. The Routes header lists one of them as not derived (the exact
orders), and the exploratory repository reviewed in `SSBX-REPOSITORY-REVIEW` (its items W1–W4) had
candidates for the four. This module proves them, within the theory without axiom and with no
premise beyond what each statement names.

* **Support.** Where a weighting vanishes off the steps a possibility admits, and what is read
  vanishes where the possibility's reading does not hold, the sum over histories vanishes wherever
  possibility does not reach the reading (`Weights.transfer_zero_of_impossible`). No weighting of
  the steps that are there carries anything to where no course leads.
* **Splitting.** The transfer over `n + m` steps is `m` steps of the transfer that reads `n` steps
  on (`Weights.transfer_split`), and the weight along a joined course is the weight along its first
  part, read at its end by the weight along the second (`Weights.along_append`): for every
  weighting, with no condition.
* **Exact orders.** Split each step's weight into a ground part and a response part. The exact
  order `i` at horizon `n` (`Weights.exactly`) takes, across each step, order `i` through the ground
  part and order `i - 1` through the response part. For every weighting whose alternatives commute
  it is the sum over the courses whose steps are each taken through one part, exactly `i` of them
  through the response part (`Weights.exactly_eq_courses`, over the moves `HistorySums.labelled`,
  weighed by `HistorySums.part`, counted by `HistorySums.responses`); taking each step through
  one part loses nothing of the whole sum (`Weights.transfer_labelled`). The orders of
  `Becoming.Routes` are its partial sums (`Weights.within_eq_sum_exactly`), and the whole sum is
  the sum of all of them (`Weights.transfer_eq_sum_exactly`). For every weighting, above the
  horizon they vanish (`Weights.exactly_above`), order `0` is order `0` of `Becoming.Routes`
  (`Weights.within_zero_eq_exactly`), and a reading that keeps the laws of the weights can be
  taken order by order (`Weights.Hom.exactly`). For one configuration with ground weight one and
  response weight `M`, the exact order `i` is `Loops.binom n i * M ^ i`
  (`Routes.SelfLoop.exactly_eq`): the ways to place `i` responses among `n` steps.
* **Grouping by order needs alternatives that commute.** The weighting that keeps the cost of the
  first possible course in listed order (`HistorySums.firstListed`) has alternatives that do not
  commute (`HistorySums.firstListed_not_comm`), and there one step's sum over histories is not the
  sum of its exact orders (`HistorySums.grouping_needs_commuting`). The orders of
  `Becoming.Routes`, which do not regroup, need no such condition.
* **The steps between.** What the sum carries from a configuration to where a reading holds
  depends only on the weights of the steps that lie between them: two weightings that vanish off a
  possibility's steps, and agree on each step that a course of open steps reaches from the start
  and from which possibility reaches the reading in the steps left, have the same transfer
  (`Weights.transfer_between`, with `HistorySums.Leads` for the courses of open steps).
* **On the traces of a process.** Where possibility weights read the steps of a process and every
  move and configuration is listed, the four laws are laws of its traces. A weighting that
  vanishes off the steps sums to nothing wherever no trace reaches the reading
  (`Weights.transfer_zero_of_no_trace`); some trace of `n + m` moves reaches the reading exactly
  where some trace of `m` moves reaches a configuration from which some trace of `n` moves does
  (`HistorySums.trace_split_iff`); an exact order of counts that is not zero has a trace of as
  many moves (`HistorySums.exactly_trace`, `HistorySums.possibility_exactly_trace`), and a course
  of the process of the parts with exactly that many responses (`HistorySums.exactly_responses_trace`,
  over `HistorySums.partProcess`); the process of the parts has a trace exactly where the process
  has one (`HistorySums.labelled_trace_iff`); and two weightings agreeing on each step that lies on
  a trace from the start to the reading have the same transfer
  (`Weights.transfer_between_traces`).

**Readings (the AI's).**
- Support and `Interference.unseen` bound each other from either side. A weighting of the steps
  that are there adds nothing where possibility has nothing; possibility, read from a weighting
  that cancels, can see something where the weighting has nothing. Where weights cannot cancel,
  as with counting, the two agree exactly (`counting_transfer_iff` in `Becoming.Weighted`).
- Splitting is what makes a horizon a step of the unfolding and not a fixed frame: what is read
  after `n + m` steps is what is read after `m` steps of what is read after `n`.
- An exact order is a regrouping of the alternatives by how many responses a course takes, so it
  needs the alternatives to commute; the cumulative orders of `Becoming.Routes` keep the listed
  order and need nothing. Where only the first possible course counts, regrouping changes which
  course is first.
- The steps between are the coupling that carries: a difference at a step no course from the
  start reaches, or from which nothing reaches the reading in the steps left, changes nothing that
  is carried. This is locality of the sum over histories in its own terms, read off the courses,
  with no prior order of cause and effect.

What is not derived: the converse of each law. That every step between can change what is carried
is not stated; that a weighting is not zero wherever possibility holds fails where weights cancel
(`Interference.cancels`). The labelled courses list each move's ground part before its response
part, so the grouping theorem needs commuting alternatives even where a different listing would
not; the first-listed weighting is one witness that some condition is needed. Sums over infinitely
many configurations or an unbounded horizon are not stated. The representation commits to discrete
steps and listed moves and configurations. No ethical predicate, ranking or axiom occurs.

**Classical sources.** Support, splitting and locality are properties of path sums over a
semiring: the support of a weighted automaton's behaviour lies in its underlying automaton, the
transfer is a semigroup in the horizon (the Chapman–Kolmogorov equation), and only the states that
are accessible and co-accessible (the trim part) contribute. Grouping by exact order is the
expansion of `(G + K) ^ n` by the number of factors `K`, which in a semiring needs commutative
addition; with commuting `G` and `K` it is the binomial theorem. The first-listed weighting is a
semiring with left-biased, non-commutative addition.
-/

namespace Becoming

open Generative

universe u v w x

/-! ## Sums -/

section Sums

variable {R : Type w} {W : Weights R}

/-- A sum of nothing is nothing. -/
theorem Weights.sum_eq_zero {α : Type u} {f : α → R} :
    ∀ l : List α, (∀ a, a ∈ l → f a = W.zero) → W.sum l f = W.zero
  | [], _ => rfl
  | a :: l, zero =>
    (congrArg (fun y => W.add y (W.sum l f)) (zero a (.head _))).trans
      ((W.zero_add _).trans (Weights.sum_eq_zero l fun b mem => zero b (.tail _ mem)))

/-- Where alternatives commute, four of them regroup. -/
theorem Weights.add_add_add_comm (comm : ∀ a b, W.add a b = W.add b a) (a b c d : R) :
    W.add (W.add a b) (W.add c d) = W.add (W.add a c) (W.add b d) :=
  (W.add_assoc a b (W.add c d)).trans
    ((congrArg (W.add a) ((W.add_assoc b c d).symm.trans
      ((congrArg (fun y => W.add y d) (comm b c)).trans (W.add_assoc c b d)))).trans
      (W.add_assoc a c (W.add b d)).symm)

/-- Where alternatives commute, the sum of two contributions is the two sums added. -/
theorem Weights.sum_add (comm : ∀ a b, W.add a b = W.add b a) {α : Type u} (f g : α → R) :
    ∀ l : List α, W.sum l (fun a => W.add (f a) (g a)) = W.add (W.sum l f) (W.sum l g)
  | [] => (W.zero_add W.zero).symm
  | a :: l => (congrArg (W.add (W.add (f a) (g a))) (Weights.sum_add comm f g l)).trans
      (Weights.add_add_add_comm comm _ _ _ _)

/-- Where alternatives commute, two sums exchange. -/
theorem Weights.sum_comm (comm : ∀ a b, W.add a b = W.add b a) {α : Type u} {β : Type v}
    (F : α → β → R) (l' : List β) :
    ∀ l : List α, W.sum l (fun a => W.sum l' (F a)) = W.sum l' fun b => W.sum l fun a => F a b
  | [] => (Weights.sum_eq_zero (f := fun b => W.sum ([] : List α) fun a => F a b) l'
      fun _ _ => rfl).symm
  | a :: l => (congrArg (W.add (W.sum l' (F a))) (Weights.sum_comm comm F l' l)).trans
      (Weights.sum_add comm (F a) (fun b => W.sum l fun a => F a b) l').symm

/-- A contribution kept or dropped, after a step's weight or before. -/
theorem Weights.cond_mul (b : Bool) (c y : R) :
    cond b (W.mul c y) W.zero = W.mul c (cond b y W.zero) := by
  cases b
  · exact (W.mul_zero c).symm
  · rfl

/-- The sum over the open steps, move by move. -/
theorem Weights.sum_openSteps {S : Type u} {A : Type v} (moves : List A) (all : List S)
    (H : A × S → R) :
    W.sum (openSteps moves all) H = W.sum moves fun a => W.sum all fun m => H (a, m) :=
  (Weights.sum_joinMap _ H moves).trans (Weights.sum_congr _ fun _ _ => Weights.sum_map _ H all)

end Sums

namespace HistorySums

/-- The steps from `T + 1` are those from `T`, each one later. -/
theorem steps_shift : ∀ T N, steps (T + 1) N = (steps T N).map Nat.succ
  | _, 0 => rfl
  | T, N + 1 => congrArg (List.cons (T + 1)) (steps_shift (T + 1) N)

end HistorySums

/-- The orders `0` to `j + 1`: order `0`, then the orders `0` to `j`, each one higher. -/
theorem Weights.sum_steps_succ {R : Type w} {W : Weights R} (F : Nat → R) (j : Nat) :
    W.sum (steps 0 (j + 1)) F = W.add (F 0) (W.sum (steps 0 j) fun i => F (i + 1)) :=
  congrArg (W.add (F 0)) ((congrArg (fun l => W.sum l F) (HistorySums.steps_shift 0 j)).trans
    (Weights.sum_map Nat.succ F (steps 0 j)))

/-! ## Support -/

namespace HistorySums

/-- Where possibility's sum fails, each alternative fails. -/
theorem possibility_sum_false {α : Type u} {g : α → Bool} {l : List α}
    (fails : possibility.sum l g = false) (a : α) (mem : a ∈ l) : g a = false := by
  cases here : g a with
  | false => rfl
  | true => exact Bool.noConfusion ((possibility_sum_of_mem here mem).symm.trans fails)

end HistorySums

section Support

variable {R : Type w} {W : Weights R} {S : Type u} {A : Type v}

/-- **Support.** Where a weighting vanishes off the steps a possibility admits, and what is read
vanishes where the possibility's reading does not hold, the sum over histories vanishes wherever
possibility does not reach the reading after `n` steps. -/
theorem Weights.transfer_zero_of_impossible (weight : S → A → S → R) (step : S → A → S → Bool)
    (off : ∀ s a t, step s a t = false → weight s a t = W.zero) (g : S → Bool) (f : S → R)
    (offRead : ∀ s, g s = false → f s = W.zero) (moves : List A) (all : List S) :
    ∀ n s, possibility.transfer step moves all g n s = false →
      W.transfer weight moves all f n s = W.zero
  | 0, s, fails => offRead s fails
  | n + 1, s, fails => Weights.sum_eq_zero _ fun p mem => by
    have term := HistorySums.possibility_sum_false fails p mem
    cases here : step s p.1 p.2 with
    | false =>
      exact (congrArg (fun y => W.mul y _) (off s p.1 p.2 here)).trans (W.zero_mul _)
    | true =>
      exact (congrArg (W.mul _) (Weights.transfer_zero_of_impossible weight step off g f offRead
        moves all n p.2 (Hexagram.and_false_of_true term here))).trans (W.mul_zero _)

end Support

/-! ## Splitting -/

section Splitting

variable {R : Type w} {W : Weights R} {S : Type u} {A : Type v}

/-- **The transfer splits at every intermediate horizon.** What is read after `n + m` steps is
what is read after `m` steps of what is read after `n`. -/
theorem Weights.transfer_split (weight : S → A → S → R) (moves : List A) (all : List S)
    (f : S → R) (n : Nat) :
    ∀ m s, W.transfer weight moves all f (n + m) s =
      W.transfer weight moves all (W.transfer weight moves all f n) m s
  | 0, _ => rfl
  | m + 1, _ => Weights.sum_congr _ fun p _ =>
      congrArg (W.mul _) (Weights.transfer_split weight moves all f n m p.2)

/-- **The weight along a joined course** is the weight along its first part, read at its end by
the weight along the second. -/
theorem Weights.along_append (weight : S → A → S → R) (f : S → R) :
    ∀ (s : S) (h h' : List (A × S)), W.along weight f s (h ++ h') =
      W.along weight (fun t => W.along weight f t h') s h
  | _, [], _ => rfl
  | _, p :: h, h' => congrArg (W.mul _) (Weights.along_append weight f p.2 h h')

end Splitting

/-! ## Exact orders -/

section Exact

variable {R : Type w} {W : Weights R} {S : Type u} {A : Type v}

/-- **The exact orders of a sum over histories.** Each step's weight split into a ground part and
a response part: order `i` reads, across each step, order `i` through the ground part and order
`i - 1` through the response part; at the end of the horizon only order `0` is read. -/
def Weights.exactly (W : Weights R) (ground response : S → A → S → R) (moves : List A)
    (all : List S) (f : S → R) : Nat → Nat → S → R
  | 0, 0, s => f s
  | _ + 1, 0, _ => W.zero
  | 0, n + 1, s => W.sum (openSteps moves all) fun p =>
      W.mul (ground s p.1 p.2) (Weights.exactly W ground response moves all f 0 n p.2)
  | i + 1, n + 1, s => W.sum (openSteps moves all) fun p =>
      W.add (W.mul (ground s p.1 p.2) (Weights.exactly W ground response moves all f (i + 1) n p.2))
        (W.mul (response s p.1 p.2) (Weights.exactly W ground response moves all f i n p.2))

/-- **Above the horizon an exact order vanishes:** a course of `n` steps takes at most `n`
responses. For every weighting. -/
theorem Weights.exactly_above (ground response : S → A → S → R) (moves : List A) (all : List S)
    (f : S → R) : ∀ i n, n < i → ∀ s, W.exactly ground response moves all f i n s = W.zero
  | 0, _, lt, _ => absurd lt (Nat.not_lt_zero _)
  | _ + 1, 0, _, _ => rfl
  | i + 1, n + 1, lt, _ => Weights.sum_eq_zero _ fun p _ =>
    (congrArg (fun y => W.add y _) ((congrArg (W.mul _) (Weights.exactly_above ground response
        moves all f (i + 1) n (Nat.lt_of_succ_lt lt) p.2)).trans (W.mul_zero _))).trans
      ((congrArg (W.add W.zero) ((congrArg (W.mul _) (Weights.exactly_above ground response moves
        all f i n (Nat.lt_of_succ_lt_succ lt) p.2)).trans (W.mul_zero _))).trans (W.zero_add _))

/-- **Order `0` is the same in both expansions**, for every weighting. -/
theorem Weights.within_zero_eq_exactly (ground response : S → A → S → R) (moves : List A)
    (all : List S) (f : S → R) :
    ∀ n s, W.within ground response moves all f 0 n s = W.exactly ground response moves all f 0 n s
  | 0, _ => rfl
  | n + 1, _ => Weights.sum_congr _ fun p _ =>
      congrArg (W.mul _) (Weights.within_zero_eq_exactly ground response moves all f n p.2)

/-- One step of the regrouping by order, where alternatives commute. -/
theorem Weights.regroup (comm : ∀ a b, W.add a b = W.add b a) (c r : R) (E : Nat → R)
    (l : List Nat) :
    W.add (W.mul c (W.add (E 0) (W.sum l fun i => E (i + 1)))) (W.mul r (W.sum l E)) =
      W.add (W.mul c (E 0)) (W.sum l fun i => W.add (W.mul c (E (i + 1))) (W.mul r (E i))) :=
  (congrArg (fun y => W.add y (W.mul r (W.sum l E))) (W.left_distrib c (E 0) _)).trans
    ((W.add_assoc _ _ _).trans (congrArg (W.add (W.mul c (E 0)))
      (((congrArg (fun y => W.add y (W.mul r (W.sum l E))) (Weights.mul_sum c _ l)).trans
        (congrArg (W.add _) (Weights.mul_sum r E l))).trans
        (Weights.sum_add comm (fun i => W.mul c (E (i + 1))) (fun i => W.mul r (E i)) l).symm)))

/-- **The orders of `Becoming.Routes` are partial sums of the exact orders,** for every weighting
whose alternatives commute: order `j` is the sum of the exact orders `0` to `j`. -/
theorem Weights.within_eq_sum_exactly (comm : ∀ a b, W.add a b = W.add b a)
    (ground response : S → A → S → R) (moves : List A) (all : List S) (f : S → R) :
    ∀ j n s, W.within ground response moves all f j n s =
      W.sum (steps 0 (j + 1)) fun i => W.exactly ground response moves all f i n s
  | j, 0, s => (W.add_zero (f s)).symm.trans (congrArg (W.add (f s))
      ((congrArg (fun l => W.sum l fun i => W.exactly ground response moves all f i 0 s)
        (HistorySums.steps_shift 0 j)).trans ((Weights.sum_map Nat.succ _ _).trans
          (Weights.sum_eq_zero _ fun _ _ => rfl))).symm)
  | 0, n + 1, s => (Weights.within_zero_eq_exactly ground response moves all f (n + 1) s).trans
      (W.add_zero _).symm
  | j + 1, n + 1, s =>
    (Weights.sum_congr _ fun p _ =>
      (congrArg (fun y => W.add (W.mul (ground s p.1 p.2) y)
          (W.mul (response s p.1 p.2) (W.within ground response moves all f j n p.2)))
        ((Weights.within_eq_sum_exactly comm ground response moves all f (j + 1) n p.2).trans
          (Weights.sum_steps_succ _ (j + 1)))).trans
      ((congrArg (fun y => W.add (W.mul (ground s p.1 p.2)
          (W.add (W.exactly ground response moves all f 0 n p.2)
            (W.sum (steps 0 (j + 1)) fun i => W.exactly ground response moves all f (i + 1) n p.2)))
          (W.mul (response s p.1 p.2) y))
        (Weights.within_eq_sum_exactly comm ground response moves all f j n p.2)).trans
        (Weights.regroup comm _ _ (fun i => W.exactly ground response moves all f i n p.2)
          (steps 0 (j + 1))))).trans
    ((Weights.sum_add comm _ _ _).trans
      ((congrArg (W.add _) (Weights.sum_comm comm (fun p i =>
          W.add (W.mul (ground s p.1 p.2) (W.exactly ground response moves all f (i + 1) n p.2))
            (W.mul (response s p.1 p.2) (W.exactly ground response moves all f i n p.2)))
          (steps 0 (j + 1)) (openSteps moves all))).trans
        (Weights.sum_steps_succ (fun i => W.exactly ground response moves all f i (n + 1) s)
          (j + 1)).symm))

/-- **The whole sum is the sum of its exact orders,** for every weighting whose alternatives
commute: the transfer of the ground and response parts together over `n` steps is the sum of the
exact orders `0` to `n`. -/
theorem Weights.transfer_eq_sum_exactly (comm : ∀ a b, W.add a b = W.add b a)
    (ground response : S → A → S → R) (moves : List A) (all : List S) (f : S → R) (n : Nat)
    (s : S) :
    W.transfer (fun s a t => W.add (ground s a t) (response s a t)) moves all f n s =
      W.sum (steps 0 (n + 1)) fun i => W.exactly ground response moves all f i n s :=
  (Weights.within_exact ground response moves all f n n (Nat.le_refl n) s).symm.trans
    (Weights.within_eq_sum_exactly comm ground response moves all f n n s)

variable {T : Type x} {V : Weights T}

/-- **A reading that keeps the laws can be taken exact order by exact order.** -/
theorem Weights.Hom.exactly (h : Weights.Hom W V) (ground response : S → A → S → R)
    (moves : List A) (all : List S) (f : S → R) :
    ∀ i n s, h.map (W.exactly ground response moves all f i n s) =
      V.exactly (fun s a t => h.map (ground s a t)) (fun s a t => h.map (response s a t)) moves
        all (fun s => h.map (f s)) i n s
  | 0, 0, _ => rfl
  | _ + 1, 0, _ => h.map_zero
  | 0, n + 1, _ => (Weights.Hom.sum h _ _).trans (Weights.sum_congr _ fun p _ =>
      (h.map_mul _ _).trans (congrArg (V.mul _)
        (Weights.Hom.exactly h ground response moves all f 0 n p.2)))
  | i + 1, n + 1, _ => (Weights.Hom.sum h _ _).trans (Weights.sum_congr _ fun p _ =>
      (h.map_add _ _).trans
        ((congrArg (fun y => V.add y _) ((h.map_mul _ _).trans (congrArg (V.mul _)
            (Weights.Hom.exactly h ground response moves all f (i + 1) n p.2)))).trans
          (congrArg (V.add _) ((h.map_mul _ _).trans (congrArg (V.mul _)
            (Weights.Hom.exactly h ground response moves all f i n p.2))))))

end Exact

/-! ## The exact orders are sums over courses -/

namespace HistorySums

/-- Each move taken through its ground part (`false`) and through its response part (`true`). -/
def labelled {A : Type v} (moves : List A) : List (A × Bool) :=
  moves.map (fun a => (a, false)) ++ moves.map fun a => (a, true)

/-- The weight of a step taken through one part. -/
def part {R : Type w} {S : Type u} {A : Type v} (ground response : S → A → S → R) :
    S → A × Bool → S → R :=
  fun s ab t => cond ab.2 (response s ab.1 t) (ground s ab.1 t)

/-- How many steps of a course are taken through the response part. -/
def responses {S : Type u} {A : Type v} : List ((A × Bool) × S) → Nat
  | [] => 0
  | p :: h => cond p.1.2 (responses h + 1) (responses h)

end HistorySums

section Courses

variable {R : Type w} {W : Weights R} {S : Type u} {A : Type v}

/-- The sum over the courses of `n + 1` labelled steps, by the part of the first step. -/
theorem Weights.sum_courses_labelled (moves : List A) (all : List S) (n : Nat)
    (F : List ((A × Bool) × S) → R) :
    W.sum (courses (HistorySums.labelled moves) all (n + 1)) F =
      W.add (W.sum moves fun a => W.sum all fun m =>
          W.sum (courses (HistorySums.labelled moves) all n) fun h => F (((a, false), m) :: h))
        (W.sum moves fun a => W.sum all fun m =>
          W.sum (courses (HistorySums.labelled moves) all n) fun h => F (((a, true), m) :: h)) :=
  (Weights.sum_joinMap _ F _).trans
    ((Weights.sum_congr _ fun _ _ => Weights.sum_map _ F _).trans
      ((Weights.sum_openSteps _ all _).trans
        ((Weights.sum_append _ _ _).trans
          ((congrArg (fun y => W.add y _) (Weights.sum_map _ _ _)).trans
            (congrArg (W.add _) (Weights.sum_map _ _ _))))))

/-- **Taking each step through one part loses nothing,** for every weighting whose alternatives
commute: the sum over the courses whose steps are each taken through the ground part or the
response part is the sum over histories of the two parts together. -/
theorem Weights.transfer_labelled (comm : ∀ a b, W.add a b = W.add b a)
    (ground response : S → A → S → R) (moves : List A) (all : List S) (f : S → R) :
    ∀ n s, W.transfer (HistorySums.part ground response) (HistorySums.labelled moves) all f n s =
      W.transfer (fun s a t => W.add (ground s a t) (response s a t)) moves all f n s
  | 0, _ => rfl
  | n + 1, s =>
    (Weights.sum_openSteps (HistorySums.labelled moves) all fun p =>
        W.mul (HistorySums.part ground response s p.1 p.2) (W.transfer (HistorySums.part ground
          response) (HistorySums.labelled moves) all f n p.2)).trans
      ((Weights.sum_append (fun ab => W.sum all fun m => W.mul (HistorySums.part ground response s
          ab m) (W.transfer (HistorySums.part ground response) (HistorySums.labelled moves) all f n
            m)) _ _).trans
        ((congrArg (fun y => W.add y _) (Weights.sum_map _ _ _)).trans
          ((congrArg (W.add _) (Weights.sum_map _ _ _)).trans
            ((Weights.sum_add comm (fun a => W.sum all fun m => W.mul (ground s a m)
                (W.transfer (HistorySums.part ground response) (HistorySums.labelled moves) all f n
                  m)) (fun a => W.sum all fun m => W.mul (response s a m)
                (W.transfer (HistorySums.part ground response) (HistorySums.labelled moves) all f n
                  m)) moves).symm.trans
              ((Weights.sum_congr _ fun a _ => (Weights.sum_add comm _ _ all).symm.trans
                (Weights.sum_congr _ fun m _ =>
                  (congrArg (fun y => W.add (W.mul (ground s a m) y) (W.mul (response s a m) y))
                      (Weights.transfer_labelled comm ground response moves all f n m)).trans
                    (W.right_distrib _ _ _).symm)).trans
                (Weights.sum_openSteps moves all fun p =>
                  W.mul (W.add (ground s p.1 p.2) (response s p.1 p.2))
                    (W.transfer (fun s a t => W.add (ground s a t) (response s a t)) moves all f n
                      p.2)).symm)))))

/-- **The exact order `i` is the sum over the courses with exactly `i` responses,** for every
weighting whose alternatives commute: each step of a course is taken through its ground part or
its response part, and the courses that take exactly `i` responses are summed with the composed
weights of their parts. -/
theorem Weights.exactly_eq_courses (comm : ∀ a b, W.add a b = W.add b a)
    (ground response : S → A → S → R) (moves : List A) (all : List S) (f : S → R) :
    ∀ n i s, W.exactly ground response moves all f i n s =
      W.sum (courses (HistorySums.labelled moves) all n) fun h =>
        cond (Nat.beq (HistorySums.responses h) i)
          (W.along (HistorySums.part ground response) f s h) W.zero
  | 0, 0, s => (W.add_zero (f s)).symm
  | 0, _ + 1, _ => (W.zero_add W.zero).symm
  | n + 1, 0, s => by
    have grounded : ∀ a m, (W.sum (courses (HistorySums.labelled moves) all n) fun h =>
        cond (Nat.beq (HistorySums.responses (((a, false), m) :: h)) 0)
          (W.along (HistorySums.part ground response) f s (((a, false), m) :: h)) W.zero) =
        W.mul (ground s a m) (W.exactly ground response moves all f 0 n m) := fun a m =>
      (Weights.sum_congr _ fun h _ => Weights.cond_mul _ _ _).trans
        ((Weights.mul_sum _ _ _).symm.trans
          (congrArg (W.mul _) (Weights.exactly_eq_courses comm ground response moves all f n 0 m).symm))
    have none : ∀ a m, (W.sum (courses (HistorySums.labelled moves) all n) fun h =>
        cond (Nat.beq (HistorySums.responses (((a, true), m) :: h)) 0)
          (W.along (HistorySums.part ground response) f s (((a, true), m) :: h)) W.zero) =
        W.zero := fun _ _ => Weights.sum_eq_zero _ fun _ _ => rfl
    exact (Weights.sum_openSteps moves all _).trans ((W.add_zero _).symm.trans
      ((congrArg (fun y => W.add y W.zero) (Weights.sum_congr _ fun a _ =>
          Weights.sum_congr _ fun m _ => (grounded a m).symm)).trans
        ((congrArg (W.add _) (Weights.sum_eq_zero moves fun a _ =>
            Weights.sum_eq_zero all fun m _ => none a m).symm).trans
          (Weights.sum_courses_labelled moves all n fun h =>
            cond (Nat.beq (HistorySums.responses h) 0)
              (W.along (HistorySums.part ground response) f s h) W.zero).symm)))
  | n + 1, i + 1, s => by
    have grounded : ∀ a m, (W.sum (courses (HistorySums.labelled moves) all n) fun h =>
        cond (Nat.beq (HistorySums.responses (((a, false), m) :: h)) (i + 1))
          (W.along (HistorySums.part ground response) f s (((a, false), m) :: h)) W.zero) =
        W.mul (ground s a m) (W.exactly ground response moves all f (i + 1) n m) := fun a m =>
      (Weights.sum_congr _ fun h _ => Weights.cond_mul _ _ _).trans
        ((Weights.mul_sum _ _ _).symm.trans
          (congrArg (W.mul _)
            (Weights.exactly_eq_courses comm ground response moves all f n (i + 1) m).symm))
    have responded : ∀ a m, (W.sum (courses (HistorySums.labelled moves) all n) fun h =>
        cond (Nat.beq (HistorySums.responses (((a, true), m) :: h)) (i + 1))
          (W.along (HistorySums.part ground response) f s (((a, true), m) :: h)) W.zero) =
        W.mul (response s a m) (W.exactly ground response moves all f i n m) := fun a m =>
      (Weights.sum_congr _ fun h _ => Weights.cond_mul _ _ _).trans
        ((Weights.mul_sum _ _ _).symm.trans
          (congrArg (W.mul _)
            (Weights.exactly_eq_courses comm ground response moves all f n i m).symm))
    exact (Weights.sum_openSteps moves all _).trans
      ((Weights.sum_congr _ fun a _ => Weights.sum_add comm _ _ all).trans
        ((Weights.sum_add comm _ _ moves).trans
          ((congrArg (fun y => W.add y _) (Weights.sum_congr _ fun a _ =>
              Weights.sum_congr _ fun m _ => (grounded a m).symm)).trans
            ((congrArg (W.add _) (Weights.sum_congr _ fun a _ =>
                Weights.sum_congr _ fun m _ => (responded a m).symm)).trans
              (Weights.sum_courses_labelled moves all n fun h =>
                cond (Nat.beq (HistorySums.responses h) (i + 1))
                  (W.along (HistorySums.part ground response) f s h) W.zero).symm))))

end Courses

/-! ## The binomial orders of one configuration -/

namespace Routes.SelfLoop

/-- **The exact order `i` of one configuration** with ground weight one and response weight `M`
is the ways to place `i` responses among `n` steps times `M ^ i`. -/
theorem exactly_eq (M : Nat) : ∀ i n,
    counting.exactly (fun _ _ _ => 1) (fun _ _ _ => M) [()] [()] (fun _ => 1) i n () =
      Loops.binom n i * M ^ i
  | 0, 0 => rfl
  | _ + 1, 0 => (Nat.zero_mul _).symm
  | 0, n + 1 => (Nat.add_zero _).trans ((Nat.one_mul _).trans ((exactly_eq M 0 n).trans
      (congrArg (· * M ^ 0) ((Loops.binom_zero n).trans (Loops.binom_zero (n + 1)).symm))))
  | i + 1, n + 1 =>
    (Nat.add_zero _).trans
      ((Naturals.add_congr ((Nat.one_mul _).trans (exactly_eq M (i + 1) n))
          (congrArg (M * ·) (exactly_eq M i n))).trans
        ((Nat.add_comm _ _).trans
          ((congrArg (· + Loops.binom n (i + 1) * M ^ (i + 1))
              (Loops.pow_step (Loops.binom n i) M i).symm).trans
            (add_mul_split _ _ _).symm)))

end Routes.SelfLoop

/-! ## Grouping by order needs alternatives that commute -/

namespace HistorySums

/-- Alternatives keep the first that is possible. -/
def firstAdd : Option Nat → Option Nat → Option Nat
  | some c, _ => some c
  | none, b => b

/-- Successive steps add their costs; a step that is not possible ends the course. -/
def firstMul : Option Nat → Option Nat → Option Nat
  | some c, some d => some (c + d)
  | some _, none => none
  | none, _ => none

/-- **The first possible course in listed order, with its cost.** Alternatives keep the first that
is possible (`none` where none is), and successive steps add their costs. -/
def firstListed : Weights (Option Nat) where
  zero := none
  one := some 0
  add := firstAdd
  mul := firstMul
  add_assoc := fun a _ _ => by cases a <;> rfl
  zero_add := fun _ => rfl
  add_zero := fun a => by cases a <;> rfl
  mul_assoc := fun a b c => by
    cases a <;> cases b <;> cases c
    all_goals first
      | rfl
      | exact congrArg some (Nat.add_assoc _ _ _)
  one_mul := fun a => by
    cases a with
    | none => rfl
    | some c => exact congrArg some (Nat.zero_add c)
  mul_one := fun a => by cases a <;> rfl
  zero_mul := fun _ => rfl
  mul_zero := fun a => by cases a <;> rfl
  left_distrib := fun a b _ => by cases a <;> cases b <;> rfl
  right_distrib := fun a b c => by cases a <;> cases b <;> cases c <;> rfl

/-- The alternatives of the first-listed weighting do not commute. -/
theorem firstListed_not_comm : ¬ ∀ a b, firstListed.add a b = firstListed.add b a :=
  fun comm => Nat.noConfusion (Option.some.inj (comm (some 1) (some 0)))

/-- The ground part: only the second move, at no cost. -/
def firstGround : Unit → Bool → Unit → Option Nat
  | _, false, _ => none
  | _, true, _ => some 0

/-- The response part: only the first move, at cost one. -/
def firstResponse : Unit → Bool → Unit → Option Nat
  | _, false, _ => some 1
  | _, true, _ => none

/-- **Grouping by order needs alternatives that commute.** With the first-listed weighting, one
step's sum over histories finds the first move's response, at cost one; the sum of its exact
orders finds order `0` first, the second move's ground part, at cost zero. -/
theorem grouping_needs_commuting :
    firstListed.transfer (fun s a t => firstListed.add (firstGround s a t) (firstResponse s a t))
        [false, true] [()] (fun _ => some 0) 1 () ≠
      firstListed.sum (steps 0 2) fun i =>
        firstListed.exactly firstGround firstResponse [false, true] [()] (fun _ => some 0) i 1 () :=
  fun same => Nat.noConfusion (Option.some.inj (same : some 1 = some 0))

end HistorySums

/-! ## The steps between -/

namespace HistorySums

/-- **Leading in `d` open steps.** From `a`, a course of `d` steps, each a listed move to a listed
configuration that `step` admits, ends at `x`. -/
inductive Leads {S : Type u} {A : Type v} (step : S → A → S → Bool) (moves : List A)
    (all : List S) : S → Nat → S → Prop
  | here (a : S) : Leads step moves all a 0 a
  | next {a : S} {b : A} {y : S} {d : Nat} {x : S} : b ∈ moves → y ∈ all → step a b y = true →
      Leads step moves all y d x → Leads step moves all a (d + 1) x

end HistorySums

section Between

variable {R : Type w} {W : Weights R} {S : Type u} {A : Type v}

/-- **What is carried depends only on the steps between.** Two weightings that vanish off the
steps a possibility admits have the same transfer from `a` over `n` steps, read where the
possibility's reading holds, wherever they agree on each step that lies between: a step from a
configuration that a course of `d` open steps reaches from `a`, to one from which possibility
reaches the reading in the `e` steps left. -/
theorem Weights.transfer_between (weight weight' : S → A → S → R) (step : S → A → S → Bool)
    (off : ∀ s a t, step s a t = false → weight s a t = W.zero)
    (off' : ∀ s a t, step s a t = false → weight' s a t = W.zero) (g : S → Bool) (f : S → R)
    (offRead : ∀ s, g s = false → f s = W.zero) (moves : List A) (all : List S) :
    ∀ n a, (∀ d e x b y, d + 1 + e = n → HistorySums.Leads step moves all a d x → b ∈ moves →
        y ∈ all → step x b y = true → possibility.transfer step moves all g e y = true →
          weight x b y = weight' x b y) →
      W.transfer weight moves all f n a = W.transfer weight' moves all f n a
  | 0, _, _ => rfl
  | n + 1, a, agree => Weights.sum_congr _ fun p mem => by
    have listed := FinerTraces.of_mem_openSteps mem
    cases here : step a p.1 p.2 with
    | false =>
      exact (congrArg (fun y => W.mul y _) (off a p.1 p.2 here)).trans ((W.zero_mul _).trans
        ((W.zero_mul _).symm.trans (congrArg (fun y => W.mul y _) (off' a p.1 p.2 here).symm)))
    | true =>
      cases reaches : possibility.transfer step moves all g n p.2 with
      | false =>
        exact (congrArg (W.mul _) (Weights.transfer_zero_of_impossible weight step off g f offRead
          moves all n p.2 reaches)).trans ((W.mul_zero _).trans ((W.mul_zero _).symm.trans
            (congrArg (W.mul _) (Weights.transfer_zero_of_impossible weight' step off' g f offRead
              moves all n p.2 reaches).symm)))
      | true =>
        exact (congrArg (fun y => W.mul y _) (agree 0 n a p.1 p.2
            ((Nat.succ_add 0 n).trans (congrArg Nat.succ (Nat.zero_add n)))
            (.here a) listed.1 listed.2 here reaches)).trans
          (congrArg (W.mul _) (Weights.transfer_between weight weight' step off off' g f offRead
            moves all n p.2 fun d e x b y same leads move reached admits ends =>
              agree (d + 1) e x b y ((Nat.succ_add (d + 1) e).trans (congrArg Nat.succ same))
                (.next listed.1 listed.2 here leads) move reached admits ends))

end Between

/-! ## On the traces of a process -/

namespace HistorySums

/-- A count of one alternative is at most the count of all. -/
theorem le_sum_of_mem {α : Type u} {F : α → Nat} {x : α} :
    ∀ {l : List α}, x ∈ l → F x ≤ counting.sum l F
  | _ :: _, .head _ => Nat.le_add_right _ _
  | _ :: _, .tail _ mem => Nat.le_trans (le_sum_of_mem mem) (Nat.le_add_left _ _)

/-- The steps `T` to `T + N - 1` hold every step in between. -/
theorem mem_steps : ∀ (N T i : Nat), T ≤ i → i < T + N → i ∈ steps T N
  | 0, T, _, le, lt => absurd (Nat.lt_of_le_of_lt le lt) (Nat.lt_irrefl T)
  | N + 1, T, i, le, lt => match Nat.decEq i T with
    | isTrue same =>
      Eq.subst (motive := fun x => x ∈ steps T (N + 1)) same.symm (.head (steps (T + 1) N))
    | isFalse other => .tail T (mem_steps N (T + 1) i (Nat.lt_of_le_of_ne le fun h => other h.symm)
        (Nat.lt_of_lt_of_eq lt (Nat.succ_add T N).symm))

/-- A count kept by a test is not zero only where the test passes. -/
theorem cond_nonzero {b : Bool} {x : Nat} (pos : nonzero (cond b x 0) = true) :
    b = true ∧ nonzero x = true := by
  cases b
  · exact Bool.noConfusion pos
  · exact ⟨rfl, pos⟩

/-- The configuration a course ends at. -/
def last {S : Type u} {A : Type v} : S → List (A × S) → S
  | s, [] => s
  | _, p :: h => last p.2 h

/-- The process whose moves are the moves taken through one part: a step where that part's count
is not zero. -/
def partProcess {S : Type u} {A : Type v} (ground response : S → A → S → Nat) :
    Process S (A × Bool) :=
  ⟨fun s ab t => nonzero (part ground response s ab t) = true⟩

section Traces

variable {S : Type u} {A : Type v}

/-- **A course whose count is not zero is a trace** of the process of the steps whose counts are
not zero, ending where what is read is not zero. -/
theorem along_trace (weight : S → A → S → Nat) (f : S → Nat) :
    ∀ (s : S) (h : List (A × S)), nonzero (counting.along weight f s h) = true →
      Trace ⟨fun s a t => nonzero (weight s a t) = true⟩ s (h.map Prod.fst) (last s h) ∧
        nonzero (f (last s h)) = true
  | _, [], pos => ⟨.nil _, pos⟩
  | s, p :: h, pos =>
    have both := bool_of_and_true ((support.map_mul (weight s p.1 p.2)
      (counting.along weight f p.2 h)).symm.trans pos)
    match along_trace weight f p.2 h both.2 with
    | ⟨tr, ends⟩ => ⟨.cons both.1 tr, ends⟩

/-- A course of open steps from `a` is a trace of the process the steps read. -/
theorem Leads.trace (P : Process S A) {step : S → A → S → Bool}
    (reads : ∀ s a t, step s a t = true ↔ P.step s a t) {moves : List A} {all : List S} :
    ∀ {a : S} {d : Nat} {x : S}, Leads step moves all a d x → ∃ as, as.length = d ∧ Trace P a as x
  | _, _, _, .here a => ⟨[], rfl, .nil a⟩
  | _, _, _, .next (b := b) _ _ admits leads =>
    match Leads.trace P reads leads with
    | ⟨as, len, tr⟩ => ⟨b :: as, congrArg (· + 1) len, .cons ((reads _ _ _).mp admits) tr⟩

/-- **Splitting, on a process.** Where possibility weights read the steps of `P` and every move
and configuration is listed, some trace of `n + m` moves from `s` reaches where `g` holds exactly
where some trace of `m` moves reaches a configuration from which some trace of `n` moves does. -/
theorem trace_split_iff (P : Process S A) (step : S → A → S → Bool)
    (reads : ∀ s a t, step s a t = true ↔ P.step s a t) (moves : List A) (all : List S)
    (every_move : ∀ a, a ∈ moves) (every : ∀ s, s ∈ all) (g : S → Bool) (n m : Nat) (s : S) :
    (∃ as t, as.length = n + m ∧ Trace P s as t ∧ g t = true) ↔
      ∃ bs u, bs.length = m ∧ Trace P s bs u ∧
        ∃ cs t, cs.length = n ∧ Trace P u cs t ∧ g t = true :=
  have inner := fun u => possibility_transfer_iff P step reads moves all every_move every g n u
  (possibility_transfer_iff P step reads moves all every_move every g (n + m) s).symm.trans
    ((Eq.to_iff (congrArg (· = true)
        (Weights.transfer_split (W := possibility) step moves all g n m s))).trans
      ((possibility_transfer_iff P step reads moves all every_move every _ m s).trans
        ⟨fun ⟨bs, u, len, tr, holds⟩ => ⟨bs, u, len, tr, (inner u).mp holds⟩,
         fun ⟨bs, u, len, tr, holds⟩ => ⟨bs, u, len, tr, (inner u).mpr holds⟩⟩))

/-- An exact order of counts is at most the whole count. -/
theorem exactly_le_transfer (ground response : S → A → S → Nat) (moves : List A) (all : List S)
    (f : S → Nat) (i n : Nat) (s : S) :
    counting.exactly ground response moves all f i n s ≤
      counting.transfer (fun s a t => ground s a t + response s a t) moves all f n s :=
  match Nat.decLt n i with
  | isTrue above => Nat.le_trans (Nat.le_of_eq (Weights.exactly_above (W := counting) ground
      response moves all f i n above s)) (Nat.zero_le _)
  | isFalse within => Nat.le_trans
      (le_sum_of_mem (F := fun k => counting.exactly ground response moves all f k n s)
        (mem_steps (n + 1) 0 i (Nat.zero_le i)
          (Nat.lt_of_lt_of_eq (Nat.lt_succ_of_le (Nat.ge_of_not_lt within))
            (Nat.zero_add (n + 1)).symm)))
      (Nat.le_of_eq (Weights.transfer_eq_sum_exactly (W := counting) Nat.add_comm ground response
        moves all f n s).symm)

/-- **Each exact order counts only courses the process has.** Where the counts of the ground and
response parts together are not zero exactly at the steps of `P`, with every move and
configuration listed, an exact order not zero at `s` after `n` steps has a trace of `P` of `n`
moves from `s` to a configuration where `f` is not zero. -/
theorem exactly_trace (P : Process S A) (ground response : S → A → S → Nat)
    (reads : ∀ s a t, nonzero (ground s a t + response s a t) = true ↔ P.step s a t)
    (moves : List A) (all : List S) (every_move : ∀ a, a ∈ moves) (every : ∀ s, s ∈ all)
    (f : S → Nat) (i n : Nat) (s : S)
    (pos : nonzero (counting.exactly ground response moves all f i n s) = true) :
    ∃ as t, as.length = n ∧ Trace P s as t ∧ nonzero (f t) = true :=
  (counting_transfer_iff P (fun s a t => ground s a t + response s a t) reads moves all every_move
      every f n s).mp
    (RouteTraces.nonzero_of_le (exactly_le_transfer ground response moves all f i n s) pos)

/-- **Read as possibility, each exact order holds only along courses the process has.** -/
theorem possibility_exactly_trace (P : Process S A) (ground response : S → A → S → Nat)
    (reads : ∀ s a t, nonzero (ground s a t + response s a t) = true ↔ P.step s a t)
    (moves : List A) (all : List S) (every_move : ∀ a, a ∈ moves) (every : ∀ s, s ∈ all)
    (f : S → Nat) (i n : Nat) (s : S)
    (holds : possibility.exactly (fun s a t => nonzero (ground s a t))
      (fun s a t => nonzero (response s a t)) moves all (fun s => nonzero (f s)) i n s = true) :
    ∃ as t, as.length = n ∧ Trace P s as t ∧ nonzero (f t) = true :=
  exactly_trace P ground response reads moves all every_move every f i n s
    ((Weights.Hom.exactly support ground response moves all f i n s).trans holds)

/-- **An exact order not zero has a course with exactly that many responses:** a trace of the
process of the parts, each step taken through its ground or its response part, with `i` responses,
ending where `f` is not zero. -/
theorem exactly_responses_trace (ground response : S → A → S → Nat) (moves : List A)
    (all : List S) (f : S → Nat) (i n : Nat) (s : S)
    (pos : nonzero (counting.exactly ground response moves all f i n s) = true) :
    ∃ h, h ∈ courses (labelled moves) all n ∧ responses h = i ∧
      Trace (partProcess ground response) s (h.map Prod.fst) (last s h) ∧
        nonzero (f (last s h)) = true :=
  have counted := (congrArg nonzero (Weights.exactly_eq_courses (W := counting) Nat.add_comm
    ground response moves all f n i s)).symm.trans pos
  match possibility_sum_true ((Weights.Hom.sum support _ _).symm.trans counted) with
  | ⟨h, mem, kept⟩ => match cond_nonzero kept with
    | ⟨same, along⟩ =>
      ⟨h, mem, Nat.eq_of_beq_eq_true same, along_trace (part ground response) f s h along⟩

/-- Every labelled move is listed where every move is. -/
theorem mem_labelled {moves : List A} (every_move : ∀ a, a ∈ moves) :
    ∀ ab : A × Bool, ab ∈ labelled moves
  | (a, false) => mem_appended_left _ (ListTests.mem_map_of (f := fun a => (a, false)) (every_move a))
  | (a, true) => mem_appended_right (ListTests.mem_map_of (f := fun a => (a, true)) (every_move a)) _

/-- **Taking each step through one part loses no trace.** Where the counts of the two parts
together are not zero exactly at the steps of `P`, with every move and configuration listed, the
process of the parts has a trace of `n` moves from `s` to where `f` is not zero exactly where `P`
has one. -/
theorem labelled_trace_iff (P : Process S A) (ground response : S → A → S → Nat)
    (reads : ∀ s a t, nonzero (ground s a t + response s a t) = true ↔ P.step s a t)
    (moves : List A) (all : List S) (every_move : ∀ a, a ∈ moves) (every : ∀ s, s ∈ all)
    (f : S → Nat) (n : Nat) (s : S) :
    (∃ as t, as.length = n ∧ Trace (partProcess ground response) s as t ∧ nonzero (f t) = true) ↔
      ∃ as t, as.length = n ∧ Trace P s as t ∧ nonzero (f t) = true :=
  (counting_transfer_iff (partProcess ground response) (part ground response)
      (fun _ _ _ => Iff.rfl) (labelled moves) all (mem_labelled every_move) every f n s).symm.trans
    ((Eq.to_iff (congrArg (fun x => nonzero x = true)
        (Weights.transfer_labelled (W := counting) Nat.add_comm ground response moves all f n s))).trans
      (counting_transfer_iff P (fun s a t => ground s a t + response s a t) reads moves all
        every_move every f n s))

end Traces

end HistorySums

section TraceReadings

variable {R : Type w} {W : Weights R} {S : Type u} {A : Type v}

/-- **Support, on a process.** Where possibility weights read the steps of `P` and every move and
configuration is listed, a weighting that vanishes off the steps, reading what vanishes where `g`
fails, sums to nothing from `s` over `n` steps wherever no trace of `n` moves from `s` reaches
where `g` holds. -/
theorem Weights.transfer_zero_of_no_trace (P : Process S A) (step : S → A → S → Bool)
    (reads : ∀ s a t, step s a t = true ↔ P.step s a t) (moves : List A) (all : List S)
    (every_move : ∀ a, a ∈ moves) (every : ∀ s, s ∈ all) (weight : S → A → S → R)
    (off : ∀ s a t, step s a t = false → weight s a t = W.zero) (g : S → Bool) (f : S → R)
    (offRead : ∀ s, g s = false → f s = W.zero) (n : Nat) (s : S)
    (none : ¬ ∃ as t, as.length = n ∧ Trace P s as t ∧ g t = true) :
    W.transfer weight moves all f n s = W.zero :=
  Weights.transfer_zero_of_impossible weight step off g f offRead moves all n s (by
    cases holds : possibility.transfer step moves all g n s with
    | false => rfl
    | true => exact absurd ((possibility_transfer_iff P step reads moves all every_move every g n
        s).mp holds) none)

/-- **The steps between, on a process.** Where possibility weights read the steps of `P` and every
move and configuration is listed, two weightings that vanish off the steps, reading what vanishes
where `g` fails, have the same transfer from `a` over `n` steps wherever they agree on each step
that lies on a trace of `n` moves from `a` to where `g` holds. -/
theorem Weights.transfer_between_traces (P : Process S A) (step : S → A → S → Bool)
    (reads : ∀ s a t, step s a t = true ↔ P.step s a t) (moves : List A) (all : List S)
    (every_move : ∀ a, a ∈ moves) (every : ∀ s, s ∈ all) (weight weight' : S → A → S → R)
    (off : ∀ s a t, step s a t = false → weight s a t = W.zero)
    (off' : ∀ s a t, step s a t = false → weight' s a t = W.zero) (g : S → Bool) (f : S → R)
    (offRead : ∀ s, g s = false → f s = W.zero) (n : Nat) (a : S)
    (agree : ∀ d e x b y, d + 1 + e = n → (∃ as, as.length = d ∧ Trace P a as x) → P.step x b y →
      (∃ cs t, cs.length = e ∧ Trace P y cs t ∧ g t = true) → weight x b y = weight' x b y) :
    W.transfer weight moves all f n a = W.transfer weight' moves all f n a :=
  Weights.transfer_between weight weight' step off off' g f offRead moves all n a
    fun d e x b y same leads _ _ admits ends =>
      agree d e x b y same (HistorySums.Leads.trace P reads leads) ((reads x b y).mp admits)
        ((possibility_transfer_iff P step reads moves all every_move every g e y).mp ends)

end TraceReadings

end Becoming
