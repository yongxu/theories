import Becoming.Weighted

/-!
# Typicality: what counting says of the course that happens

`Becoming.Weighted` states what a weighting of steps adds to a law that is not determined: the
sum over histories is exact, possibility is its support, and its losses are theorems. Every
weighting there is a premise: the weights come with their laws and nothing is assumed of any
world. A record shows one course, never a weight. This module states, with no premise, what
weights counted over the courses say of the frequencies a record can show, and so where a
record fixes weights and where it cannot.

Two values, `true` and `false`, are counted with natural weights `p` and `q` (`weight`): a
course of `n` steps weighs the product of the weights of its steps, and the courses of `n`
steps (`courses`, each course of `n` steps a member, `mem_courses_iff`, `2 ^ n` of them,
`courses_length`) weigh `(p + q) ^ n` together (`total_weight`). A course with `a` ones and `b`
zeros is read by `x = q·a` and `y = p·b` (`ahead`, `behind`); its frequency of ones is the
ratio `p : q` exactly where `x = y`, and `(x - y)²`, stated without subtraction as
`x·x + y·y` against `2·x·y`, is its squared deviation.

* **The spread is exact.** Over the courses of `n` steps, each weighted, the squared
  deviations add up to `n·p·q·(p + q)^n` (`spread`): `x·x + y·y` summed is `2·x·y` summed plus
  `n·p·q·(p + q)^n`. Each step adds `p·q·(p + q)` times the weight, whatever came before.
* **Most courses show the weights.** The courses whose squared deviation is at least `d` weigh,
  times `d`, at most `n·p·q·(p + q)^n` (`typical`). Out of the whole weight `(p + q)^n`, those
  whose frequency of ones is off `p / (p + q)` by `ε` or more weigh at most
  `p·q / ((p + q)²·ε²·n)` of it, which falls as `n` grows: Chebyshev's variance bound and the
  counting form of the law of large numbers. With `p = q = 1` every course weighs one, and the count of courses of `n` steps
  whose ones and zeros differ by at least `δ`, times `δ²`, is at most `n·2^n`.
* **The deviation stays within the bound at every step.** Stop the pair `(x, y)` of a course at the
  first step at which its squared deviation reaches `d` (`stopped`, `stopStep`); up to that step it
  is the course's own pair, and from it the pair has reached `d` (`stopped_spec`, with `reachesBy`
  whether the course reaches `d` at some step). A step adds `p·q·(p + q)` times the weight of the
  courses whose pair still moves (`moving`), and nothing for the others (`stopped_square_step`,
  `stopped_cross_step`, through `weighted_square` and `weighted_cross`), so the stopped squares add
  up to at most the stopped cross terms plus `n·p·q·(p + q)^n` (`stopped_spread`). Hence the
  courses whose squared deviation reaches `d` at some step, their start included, weigh, times `d`,
  at most `n·p·q·(p + q)^n` (`typical_throughout`), the bound `typical` gives for the last step
  alone; `typical` is its case (`offBy_le_within`). Read with `d = ((p + q)·ε·n)²`, the courses
  whose count of ones strays from `k·p / (p + q)` by `ε·n` or more at some step `k ≤ n` weigh at
  most `p·q / ((p + q)²·ε²·n)` of the whole: the counts stay near their means throughout, while the
  frequencies show the weights at the horizon.
* **Concentration is exponential.** Weighting each one by `u` and each zero by `v` multiplies
  the weights step by step (`weight_mul`). So for every `u ≥ v`, the courses of `n` steps with at
  least `k` ones weigh, times `u ^ k · v ^ n`, at most `(p·u + q·v) ^ n · v ^ k`
  (`concentrated`): the counting form of Chernoff's bound. With `p = q = 1`, `u = 3` and `v = 1`,
  of the `2 ^ n` courses those with at least `k` ones number, times `3 ^ k`, at most `4 ^ n`
  (`few_far_ahead`). For `k ≥ 3n/4` their share is below `0.88 ^ n`, where the bound by the
  spread falls only as `1/n`.
* **Nothing derived says the course that happens is among them.** Every course is a run of
  free branching (`Becoming.Parting`'s `freeRun`), the all-ones course among them, and no
  record shows that a world will not part (`Parting.free_parts_after`). Counting weighs
  courses; it does not choose one. That the course which happens is typical, so that its
  frequencies show the weights, is not a theorem of the core. Where each step is taken in as
  many situations as its weight, each fixing it, the weights count situations and this count is
  of situations (`Becoming.Situations`): most situations of a kind give frequencies near the
  ratio, and which situation it is fixes the course. Ren, 16 October 2026: "the situation makes
  it true".

* **The weights are those of `Becoming.Weighted`.** Free branching on two values weighted by
  counting (`stepWeight`) composes along each history the weight of its values
  (`along_weight`), and the sum over its histories of `n` steps is the total weight here
  (`sum_courses_weight`, through `Weights.sum_courses`).

**Classical sources.** The exact spread is the variance of the binomial distribution; the bound by
the spread (`typical`) is Chebyshev's inequality (Bienaymé 1853, Chebyshev 1867) in counting form,
and with it the weak law of large numbers of Bernoulli (1713) for the frequency of ones. The bound
at every step (`typical_throughout`) is Kolmogorov's maximal inequality (1928), proved here as it
usually is, by stopping each course where it first reaches the deviation. The bound
by weighting each one (`concentrated`) is the exponential-moment method of Chernoff (1952). Here
they are stated over natural weights, with no real numbers and no probability measure: the counts
are of courses, or, in `Becoming.Situations`, of situations.

The AM–GM step `2·x·y ≤ x·x + y·y` is proved on the way (`Naturals.twice_le`), as the case at margin
zero of the margin square: where `x + m ≤ y`, `m·m + 2·x·y ≤ x·x + y·y` (`margin_square`, through
the identity `square_gap`). The arithmetic uses
the core's inductive forms of distributivity, associativity and powers in `Becoming.Prelude`
(`add_mul_split`, `mul_assoc_nat`, `mul_turn` and `Naturals.pow_add`), since Lean's prelude forms of
these laws use propositional extensionality. Ren took the reading of their words on 16 October 2026.
-/

namespace Becoming

namespace Typicality

/-! ## Courses and their weights -/

/-- The ones of a course, its `true` steps. -/
def ones : List Bool → Nat
  | [] => 0
  | true :: w => ones w + 1
  | false :: w => ones w

/-- The zeros of a course, its `false` steps. -/
def zeros : List Bool → Nat
  | [] => 0
  | true :: w => zeros w
  | false :: w => zeros w + 1

/-- The weight of a course: the product of `p` for each one and `q` for each zero. -/
def weight (p q : Nat) : List Bool → Nat
  | [] => 1
  | true :: w => p * weight p q w
  | false :: w => q * weight p q w

/-- Each course of a list, followed by one more step of each value. -/
def extend : List (List Bool) → List (List Bool)
  | [] => []
  | w :: ws => (true :: w) :: (false :: w) :: extend ws

/-- The courses of `n` steps, the latest step first. -/
def courses : Nat → List (List Bool)
  | 0 => [[]]
  | n + 1 => extend (courses n)

theorem mem_extend_true {w : List Bool} : ∀ {ws : List (List Bool)}, w ∈ ws →
    (true :: w) ∈ extend ws ∧ (false :: w) ∈ extend ws
  | _ :: _, .head _ => ⟨.head _, .tail _ (.head _)⟩
  | _ :: _, .tail _ mem => match mem_extend_true mem with
    | ⟨t, f⟩ => ⟨.tail _ (.tail _ t), .tail _ (.tail _ f)⟩

theorem of_mem_extend {v : List Bool} : ∀ {ws : List (List Bool)}, v ∈ extend ws →
    ∃ b w, v = b :: w ∧ w ∈ ws
  | [], mem => nomatch (mem : v ∈ ([] : List (List Bool)))
  | w :: ws, mem =>
    have listed : v ∈ (true :: w) :: (false :: w) :: extend ws := mem
    match mem_cons_cases listed with
    | .inl eq => ⟨true, w, eq, .head _⟩
    | .inr later => match mem_cons_cases later with
      | .inl eq => ⟨false, w, eq, .head _⟩
      | .inr inside => match of_mem_extend inside with
        | ⟨b, w', eq, inside'⟩ => ⟨b, w', eq, .tail _ inside'⟩

/-- **The courses of `n` steps are exactly the lists of `n` values.** -/
theorem mem_courses_iff : ∀ {n : Nat} {w : List Bool}, w ∈ courses n ↔ w.length = n
  | 0, [] => ⟨fun _ => rfl, fun _ => .head _⟩
  | 0, _ :: _ => ⟨fun mem => (match mem with | .tail _ inside => nomatch inside),
      fun same => nomatch same⟩
  | _ + 1, [] => ⟨fun mem => (match of_mem_extend mem with | ⟨_, _, eq, _⟩ => nomatch eq),
      fun same => nomatch same⟩
  | n + 1, b :: w =>
    ⟨fun mem => match of_mem_extend mem with
      | ⟨_, _, eq, inside⟩ =>
        congrArg (· + 1) ((congrArg List.length (List.cons.inj eq).2).trans
          (mem_courses_iff.mp inside)),
     fun same =>
      have inside : w ∈ courses n := mem_courses_iff.mpr (Nat.succ.inj same)
      match b with
      | true => (mem_extend_true inside).1
      | false => (mem_extend_true inside).2⟩

theorem extend_length : ∀ ws : List (List Bool), (extend ws).length = 2 * ws.length
  | [] => rfl
  | _ :: ws => congrArg (· + 2) (extend_length ws)

/-- There are `2 ^ n` courses of `n` steps. -/
theorem courses_length : ∀ n, (courses n).length = 2 ^ n
  | 0 => rfl
  | n + 1 => (extend_length (courses n)).trans
      ((congrArg (2 * ·) (courses_length n)).trans (Nat.mul_comm 2 (2 ^ n)))

/-! ## Sums over courses -/

theorem total_extend (f : List Bool → Nat) : ∀ ws : List (List Bool),
    total (extend ws) f = total ws (fun w => f (true :: w) + f (false :: w))
  | [] => rfl
  | w :: ws => by
    show f (true :: w) + (f (false :: w) + total (extend ws) f) =
      (f (true :: w) + f (false :: w)) + total ws (fun w => f (true :: w) + f (false :: w))
    rw [total_extend f ws, Nat.add_assoc]

theorem total_congr {f g : List Bool → Nat} (same : ∀ w, f w = g w) :
    ∀ ws : List (List Bool), total ws f = total ws g
  | [] => rfl
  | w :: ws => by
    show f w + total ws f = g w + total ws g
    rw [same w, total_congr same ws]

theorem total_add (f g : List Bool → Nat) : ∀ ws : List (List Bool),
    total ws (fun w => f w + g w) = total ws f + total ws g
  | [] => rfl
  | w :: ws => by
    show (f w + g w) + total ws (fun w => f w + g w) = (f w + total ws f) + (g w + total ws g)
    rw [total_add f g ws, Nat.add_add_add_comm]

theorem total_mul (c : Nat) (f : List Bool → Nat) : ∀ ws : List (List Bool),
    total ws (fun w => c * f w) = c * total ws f
  | [] => (Nat.mul_zero c).symm
  | w :: ws => by
    show c * f w + total ws (fun w => c * f w) = c * (f w + total ws f)
    rw [total_mul c f ws, Nat.mul_add]

theorem total_mul_right (c : Nat) (f : List Bool → Nat) : ∀ ws : List (List Bool),
    total ws (fun w => f w * c) = total ws f * c
  | [] => (Nat.zero_mul c).symm
  | w :: ws => by
    show f w * c + total ws (fun w => f w * c) = (f w + total ws f) * c
    rw [total_mul_right c f ws, add_mul_split]

theorem total_le {f g : List Bool → Nat} (le : ∀ w, f w ≤ g w) :
    ∀ ws : List (List Bool), total ws f ≤ total ws g
  | [] => Nat.le_refl 0
  | w :: ws => Nat.add_le_add (le w) (total_le le ws)

/-- **The courses of `n` steps weigh `(p + q) ^ n` together.** -/
theorem total_weight (p q : Nat) : ∀ n, total (courses n) (weight p q) = (p + q) ^ n
  | 0 => rfl
  | n + 1 => by
    show total (extend (courses n)) (weight p q) = (p + q) ^ n * (p + q)
    rw [total_extend]
    show total (courses n) (fun w => p * weight p q w + q * weight p q w) = _
    rw [total_congr (fun w => (add_mul_split p q (weight p q w)).symm),
      total_mul, total_weight p q n, Nat.mul_comm]

/-! ## The squared deviation -/

/-- `q` for each one: `q·a`. -/
def ahead (q : Nat) (w : List Bool) : Nat := q * ones w

/-- `p` for each zero: `p·b`. -/
def behind (p : Nat) (w : List Bool) : Nat := p * zeros w

/-- `x·x + y·y`, with `x = q·a` and `y = p·b`. -/
def square (p q : Nat) (w : List Bool) : Nat :=
  ahead q w * ahead q w + behind p w * behind p w

/-- `2·x·y`. -/
def cross (p q : Nat) (w : List Bool) : Nat := 2 * (ahead q w * behind p w)

theorem sq_add (x q : Nat) : (x + q) * (x + q) = x * x + q * (2 * x + q) := by
  rw [add_mul_split, Nat.mul_add, Nat.mul_add, Nat.mul_add, Nat.two_mul, Nat.mul_add,
    Nat.mul_comm x q, Nat.add_assoc, Nat.add_assoc]

theorem square_true (p q : Nat) (w : List Bool) :
    square p q (true :: w) = square p q w + q * (2 * ahead q w + q) := by
  show (ahead q w + q) * (ahead q w + q) + behind p w * behind p w = _
  rw [sq_add]
  exact Nat.add_right_comm _ _ _

theorem square_false (p q : Nat) (w : List Bool) :
    square p q (false :: w) = square p q w + p * (2 * behind p w + p) := by
  show ahead q w * ahead q w + (behind p w + p) * (behind p w + p) = _
  rw [sq_add]
  exact (Nat.add_assoc _ _ _).symm

theorem cross_true (p q : Nat) (w : List Bool) :
    cross p q (true :: w) = cross p q w + 2 * (q * behind p w) := by
  show 2 * ((ahead q w + q) * behind p w) = _
  rw [add_mul_split, Nat.mul_add]
  rfl

theorem cross_false (p q : Nat) (w : List Bool) :
    cross p q (false :: w) = cross p q w + 2 * (p * ahead q w) := by
  show 2 * (ahead q w * (behind p w + p)) = _
  rw [Nat.mul_add, Nat.mul_add, Nat.mul_comm (ahead q w) p]
  rfl

/-- One step of weight `p` on a weighted amount. -/
theorem split (p W A a : Nat) : (p * W) * (A + a) = p * (W * A) + W * (p * a) := by
  rw [Nat.mul_add, mul_assoc_nat, mul_assoc_nat, mul_turn p W a]

theorem regroup (p q u a b : Nat) : (p * u + a) + (q * u + b) = (p + q) * u + (a + b) := by
  rw [Nat.add_add_add_comm, add_mul_split]

/-- The cross terms of the two steps, against the squared terms, leave `p·q·(p + q)`. -/
theorem steps_leave (p q x y : Nat) :
    p * (q * (2 * x + q)) + q * (p * (2 * y + p)) =
      (p * (2 * (q * y)) + q * (2 * (p * x))) + p * q * (p + q) := by
  rw [← mul_assoc_nat p q, mul_turn q p, ← mul_assoc_nat p q,
    mul_turn p 2 (q * y), ← mul_assoc_nat p q y, mul_turn 2 (p * q) y,
    mul_turn q 2 (p * x), mul_turn q p x, ← mul_assoc_nat p q x,
    mul_turn 2 (p * q) x,
    Nat.mul_add (p * q) (2 * x), Nat.mul_add (p * q) (2 * y), Nat.mul_add (p * q) p q,
    Nat.add_add_add_comm, Nat.add_comm (p * q * (2 * x)) (p * q * (2 * y)),
    Nat.add_comm (p * q * q) (p * q * p)]

theorem weighted_square (p q : Nat) (w : List Bool) :
    weight p q (true :: w) * square p q (true :: w) +
        weight p q (false :: w) * square p q (false :: w) =
      (p + q) * (weight p q w * square p q w) +
        (weight p q w * (p * (2 * (q * behind p w)) + q * (2 * (p * ahead q w))) +
          weight p q w * (p * q * (p + q))) := by
  show (p * weight p q w) * square p q (true :: w) +
      (q * weight p q w) * square p q (false :: w) = _
  rw [square_true, square_false, split, split, regroup,
    ← Nat.mul_add (weight p q w) (p * (q * (2 * ahead q w + q)))
      (q * (p * (2 * behind p w + p))),
    steps_leave,
    Nat.mul_add (weight p q w) (p * (2 * (q * behind p w)) + q * (2 * (p * ahead q w)))
      (p * q * (p + q))]

theorem weighted_cross (p q : Nat) (w : List Bool) :
    weight p q (true :: w) * cross p q (true :: w) +
        weight p q (false :: w) * cross p q (false :: w) =
      (p + q) * (weight p q w * cross p q w) +
        weight p q w * (p * (2 * (q * behind p w)) + q * (2 * (p * ahead q w))) := by
  show (p * weight p q w) * cross p q (true :: w) +
      (q * weight p q w) * cross p q (false :: w) = _
  rw [cross_true, cross_false, split, split, regroup,
    ← Nat.mul_add (weight p q w) (p * (2 * (q * behind p w))) (q * (2 * (p * ahead q w)))]

theorem step_weight (p q n : Nat) :
    (p + q) * (n * (p * q * (p + q) ^ n)) + p * q * (p + q) * (p + q) ^ n =
      (n + 1) * (p * q * (p + q) ^ (n + 1)) := by
  show _ = (n + 1) * (p * q * ((p + q) ^ n * (p + q)))
  rw [Nat.mul_comm ((p + q) ^ n) (p + q), mul_assoc_nat (p * q) (p + q),
    mul_turn (p * q) (p + q), mul_turn (p + q) n, Nat.succ_mul]

/-- **The spread is exact.** Over the courses of `n` steps, each weighted, `x·x + y·y` adds up
to `2·x·y` plus `n·p·q·(p + q)^n`: the squared deviations add up to `n·p·q·(p + q)^n`. -/
theorem spread (p q : Nat) : ∀ n,
    total (courses n) (fun w => weight p q w * square p q w) =
      total (courses n) (fun w => weight p q w * cross p q w) + n * (p * q * (p + q) ^ n)
  | 0 => (Nat.add_zero 0).symm.trans (congrArg (0 + ·) (Nat.zero_mul _).symm)
  | n + 1 => by
    show total (extend (courses n)) (fun w => weight p q w * square p q w) =
      total (extend (courses n)) (fun w => weight p q w * cross p q w) + _
    rw [total_extend, total_extend, total_congr (weighted_square p q),
      total_congr (weighted_cross p q), total_add, total_add, total_add, total_mul, total_mul,
      spread p q n, total_congr (fun w => Nat.mul_comm (weight p q w) (p * q * (p + q))),
      total_mul, total_weight, ← step_weight, Nat.mul_add (p + q), Nat.add_add_add_comm]

/-! ## Most courses show the weights -/

/-- Four amounts regrouped: `a + ((a + b) + (b + c)) = ((a + b) + (a + b)) + c`. -/
theorem regroup_square (a b c : Nat) : a + ((a + b) + (b + c)) = ((a + b) + (a + b)) + c := by
  rw [Nat.add_assoc a b (b + c), Nat.add_assoc (a + b) (a + b) c, Nat.add_assoc a b (a + b + c),
    Nat.add_assoc a b c, Nat.add_left_comm b a (b + c)]

/-- `x·x + (x + k)·(x + k)` is `2·x·(x + k)` with `k·k` more. -/
theorem square_gap (x k : Nat) : x * x + (x + k) * (x + k) = 2 * (x * (x + k)) + k * k := by
  rw [add_mul_split x k (x + k), Nat.mul_add k x k, Nat.mul_comm k x, Naturals.two_mul,
    Nat.mul_add x x k]
  exact regroup_square (x * x) (x * k) (k * k)

/-- **A difference of at least `m` squares to at least `m·m`**: where `x + m ≤ y`,
`m·m + 2·x·y ≤ x·x + y·y`. -/
theorem margin_square {x y m : Nat} (le : x + m ≤ y) : m * m + 2 * (x * y) ≤ x * x + y * y :=
  match le_dest (Naturals.le_of_add_le_right le) with
  | ⟨k, at_y⟩ => by
    rw [at_y, square_gap x k, Nat.add_comm (m * m)]
    exact Nat.add_le_add_left
      (Nat.mul_self_le_mul_self (Naturals.le_of_add_le_add_left (at_y ▸ le))) _

/-- The weight of a course whose squared deviation is at least `d`, and nothing otherwise. -/
def offBy (p q d : Nat) (w : List Bool) : Nat :=
  if d + cross p q w ≤ square p q w then weight p q w else 0

/-! ## The deviation at every step -/

/-- `x·x + y·y` of a pair `(x, y)`. -/
def pairSquare (s : Nat × Nat) : Nat := s.1 * s.1 + s.2 * s.2

/-- `2·x·y` of a pair `(x, y)`. -/
def pairCross (s : Nat × Nat) : Nat := 2 * (s.1 * s.2)

/-- One step of a pair stopped once its squared deviation reaches `d`: where
`d + 2·x·y ≤ x·x + y·y` it stays; otherwise a one adds `q` to `x` and a zero adds `p` to `y`. -/
def stopStep (p q d : Nat) (b : Bool) (s : Nat × Nat) : Nat × Nat :=
  if d + pairCross s ≤ pairSquare s then s
  else match b with
    | true => (s.1 + q, s.2)
    | false => (s.1, s.2 + p)

/-- The pair `(x, y)` of a course stopped at the first step at which its squared deviation reaches
`d`: up to that step each one adds `q` to `x` and each zero adds `p` to `y`, the earliest step
first. -/
def stopped (p q d : Nat) : List Bool → Nat × Nat
  | [] => (0, 0)
  | b :: w => stopStep p q d b (stopped p q d w)

/-- Whether the squared deviation of a course reaches `d` at some step, its start included. -/
def reachesBy (p q d : Nat) : List Bool → Bool
  | [] => decide (d + cross p q [] ≤ square p q [])
  | b :: w => reachesBy p q d w || decide (d + cross p q (b :: w) ≤ square p q (b :: w))

/-- A course whose squared deviation reaches `d` at its end reaches it at some step. -/
theorem reachesBy_of_end {p q d : Nat} :
    ∀ {w : List Bool}, d + cross p q w ≤ square p q w → reachesBy p q d w = true
  | [], far => decide_eq_true far
  | _ :: w, far => ListTests.or_right (reachesBy p q d w) (decide_eq_true far)

/-- **Until it reaches `d`, the stopped pair is the course's own pair; once it has, it has reached
`d`.** -/
theorem stopped_spec (p q d : Nat) : ∀ w : List Bool,
    (reachesBy p q d w = false ∧ stopped p q d w = (ahead q w, behind p w) ∧
        ¬ d + cross p q w ≤ square p q w) ∨
      (reachesBy p q d w = true ∧
        d + pairCross (stopped p q d w) ≤ pairSquare (stopped p q d w))
  | [] => match h : decide (d + cross p q [] ≤ square p q []) with
    | true => .inr ⟨h, of_decide_eq_true h⟩
    | false => .inl ⟨h, rfl, of_decide_eq_false h⟩
  | b :: w => match stopped_spec p q d w with
    | .inr ⟨reached, hit⟩ =>
      have same : stopped p q d (b :: w) = stopped p q d w := if_pos hit
      .inr ⟨ListTests.or_left _ reached, same ▸ hit⟩
    | .inl ⟨unreached, actual, go⟩ =>
      have moved : stopped p q d (b :: w) = (ahead q (b :: w), behind p (b :: w)) := by
        show stopStep p q d b (stopped p q d w) = _
        rw [actual]
        show (if d + cross p q w ≤ square p q w then (ahead q w, behind p w)
          else match b with
            | true => (ahead q w + q, behind p w)
            | false => (ahead q w, behind p w + p)) = _
        rw [if_neg go]
        cases b <;> rfl
      have last : reachesBy p q d (b :: w) =
          decide (d + cross p q (b :: w) ≤ square p q (b :: w)) := by
        show (reachesBy p q d w || _) = _
        rw [unreached]
        rfl
      match h : decide (d + cross p q (b :: w) ≤ square p q (b :: w)) with
      | true => .inr ⟨last.trans h, moved ▸ of_decide_eq_true h⟩
      | false => .inl ⟨last.trans h, moved, of_decide_eq_false h⟩

/-- The weight of a course while its pair has not stopped, and nothing once it has. -/
def moving (p q d : Nat) (w : List Bool) : Nat :=
  if d + pairCross (stopped p q d w) ≤ pairSquare (stopped p q d w) then 0 else weight p q w

theorem moving_le (p q d : Nat) (w : List Bool) : moving p q d w ≤ weight p q w :=
  if hit : d + pairCross (stopped p q d w) ≤ pairSquare (stopped p q d w) then by
    show (if d + pairCross (stopped p q d w) ≤ pairSquare (stopped p q d w) then 0
      else weight p q w) ≤ _
    rw [if_pos hit]; exact Nat.zero_le _
  else by
    show (if d + pairCross (stopped p q d w) ≤ pairSquare (stopped p q d w) then 0
      else weight p q w) ≤ _
    rw [if_neg hit]; exact Nat.le_refl _

/-- The cross terms one step adds to a pair, `p·2·q·y + q·2·p·x`. -/
def stepCross (p q : Nat) (s : Nat × Nat) : Nat := p * (2 * (q * s.2)) + q * (2 * (p * s.1))

/-- A moving pair is the course's own, and so is the pair after one more step. -/
theorem stopped_go {p q d : Nat} {w : List Bool}
    (go : ¬ d + pairCross (stopped p q d w) ≤ pairSquare (stopped p q d w)) :
    stopped p q d w = (ahead q w, behind p w) ∧
      ∀ b, stopped p q d (b :: w) = (ahead q (b :: w), behind p (b :: w)) :=
  match stopped_spec p q d w with
  | .inr ⟨_, hit⟩ => absurd hit go
  | .inl ⟨_, actual, _⟩ => ⟨actual, fun b => by
      show stopStep p q d b (stopped p q d w) = _
      show (if d + pairCross (stopped p q d w) ≤ pairSquare (stopped p q d w)
        then stopped p q d w
        else match b with
          | true => ((stopped p q d w).1 + q, (stopped p q d w).2)
          | false => ((stopped p q d w).1, (stopped p q d w).2 + p)) = _
      rw [if_neg go, actual]
      cases b <;> rfl⟩

/-- **One step of the stopped squares.** A stopped pair adds nothing to `x·x + y·y` but the
weight; a moving one adds what the course's own pair adds (`weighted_square`). -/
theorem stopped_square_step (p q d : Nat) (w : List Bool) :
    weight p q (true :: w) * pairSquare (stopped p q d (true :: w)) +
        weight p q (false :: w) * pairSquare (stopped p q d (false :: w)) =
      (p + q) * (weight p q w * pairSquare (stopped p q d w)) +
        (moving p q d w * stepCross p q (stopped p q d w) + moving p q d w * (p * q * (p + q))) :=
  if hit : d + pairCross (stopped p q d w) ≤ pairSquare (stopped p q d w) then by
    have stays : ∀ b, stopped p q d (b :: w) = stopped p q d w := fun _ => if_pos hit
    have still : moving p q d w = 0 := if_pos hit
    show p * weight p q w * pairSquare (stopped p q d (true :: w)) +
        q * weight p q w * pairSquare (stopped p q d (false :: w)) = _
    rw [stays true, stays false, still, Nat.zero_mul, Nat.zero_mul, ← add_mul_split,
      ← add_mul_split, mul_assoc_nat]
    rfl
  else by
    have moves : moving p q d w = weight p q w := if_neg hit
    obtain ⟨actual, next⟩ := stopped_go hit
    rw [next true, next false, actual, moves]
    exact weighted_square p q w

/-- **One step of the stopped cross terms.** -/
theorem stopped_cross_step (p q d : Nat) (w : List Bool) :
    weight p q (true :: w) * pairCross (stopped p q d (true :: w)) +
        weight p q (false :: w) * pairCross (stopped p q d (false :: w)) =
      (p + q) * (weight p q w * pairCross (stopped p q d w)) +
        moving p q d w * stepCross p q (stopped p q d w) :=
  if hit : d + pairCross (stopped p q d w) ≤ pairSquare (stopped p q d w) then by
    have stays : ∀ b, stopped p q d (b :: w) = stopped p q d w := fun _ => if_pos hit
    have still : moving p q d w = 0 := if_pos hit
    show p * weight p q w * pairCross (stopped p q d (true :: w)) +
        q * weight p q w * pairCross (stopped p q d (false :: w)) = _
    rw [stays true, stays false, still, Nat.zero_mul, ← add_mul_split, ← add_mul_split,
      mul_assoc_nat]
    rfl
  else by
    have moves : moving p q d w = weight p q w := if_neg hit
    obtain ⟨actual, next⟩ := stopped_go hit
    rw [next true, next false, actual, moves]
    exact weighted_cross p q w

/-- **The stopped spread is at most the spread.** Over the courses of `n` steps, each weighted,
`x·x + y·y` of the stopped pair adds up to at most `2·x·y` of it plus `n·p·q·(p + q)^n`: each step
adds `p·q·(p + q)` times the weight of the courses still moving, and no more. -/
theorem stopped_spread (p q d : Nat) : ∀ n,
    total (courses n) (fun w => weight p q w * pairSquare (stopped p q d w)) ≤
      total (courses n) (fun w => weight p q w * pairCross (stopped p q d w)) +
        n * (p * q * (p + q) ^ n)
  | 0 => Nat.le_trans (Nat.le_refl _) (Nat.le_add_right _ _)
  | n + 1 => by
    have ih := stopped_spread p q d n
    have still : total (courses n) (moving p q d) ≤ (p + q) ^ n :=
      Nat.le_trans (total_le (moving_le p q d) (courses n)) (Nat.le_of_eq (total_weight p q n))
    show total (extend (courses n)) (fun w => weight p q w * pairSquare (stopped p q d w)) ≤
      total (extend (courses n)) (fun w => weight p q w * pairCross (stopped p q d w)) +
        (n + 1) * (p * q * (p + q) ^ (n + 1))
    rw [total_extend, total_extend, total_congr (stopped_square_step p q d),
      total_congr (stopped_cross_step p q d), total_add, total_add, total_add, total_mul,
      total_mul, total_mul_right, ← step_weight]
    exact Nat.le_trans
      (Nat.add_le_add
        (Nat.le_trans (Nat.mul_le_mul_left (p + q) ih) (Nat.le_of_eq (Nat.mul_add _ _ _)))
        (Nat.add_le_add_left
          (Nat.le_trans (Nat.mul_le_mul_right _ still) (Nat.le_of_eq (Nat.mul_comm _ _))) _))
      (Nat.le_of_eq (Nat.add_add_add_comm _ _ _ _))

/-- The weight of a course whose squared deviation reaches `d` at some step, and nothing
otherwise. -/
def offByWithin (p q d : Nat) (w : List Bool) : Nat :=
  if reachesBy p q d w = true then weight p q w else 0

theorem offByWithin_le (p q d : Nat) (w : List Bool) :
    offByWithin p q d w * d + weight p q w * pairCross (stopped p q d w) ≤
      weight p q w * pairSquare (stopped p q d w) :=
  match stopped_spec p q d w with
  | .inr ⟨reached, hit⟩ => by
    show (if reachesBy p q d w = true then weight p q w else 0) * d + _ ≤ _
    rw [reached, if_pos rfl, ← Nat.mul_add]
    exact Nat.mul_le_mul_left _ hit
  | .inl ⟨unreached, _, _⟩ => by
    show (if reachesBy p q d w = true then weight p q w else 0) * d + _ ≤ _
    rw [unreached, if_neg (fun same => Bool.noConfusion same), Nat.zero_mul, Nat.zero_add]
    exact Nat.mul_le_mul_left _ (Naturals.twice_le _ _)

/-- **The deviation stays within the bound at every step.** The courses of `n` steps whose squared
deviation reaches `d` at some step weigh, times `d`, at most `n·p·q·(p + q)^n`, the bound `typical`
gives for the last step alone: Kolmogorov's maximal inequality, in counting form. -/
theorem typical_throughout (p q n d : Nat) :
    total (courses n) (offByWithin p q d) * d ≤ n * (p * q * (p + q) ^ n) :=
  have bound := total_le (offByWithin_le p q d) (courses n)
  le_of_add_le_add_right (total (courses n) (fun w => weight p q w * pairCross (stopped p q d w)))
    (by
      rw [total_add, total_mul_right] at bound
      rw [Nat.add_comm (n * _)]
      exact Nat.le_trans bound (stopped_spread p q d n))

/-- A course whose squared deviation reaches `d` at its end reaches it at some step. -/
theorem offBy_le_within (p q d : Nat) (w : List Bool) : offBy p q d w ≤ offByWithin p q d w :=
  if far : d + cross p q w ≤ square p q w then by
    show (if d + cross p q w ≤ square p q w then weight p q w else 0) ≤
      (if reachesBy p q d w = true then weight p q w else 0)
    rw [if_pos far, if_pos (reachesBy_of_end far)]
    exact Nat.le_refl _
  else by
    show (if d + cross p q w ≤ square p q w then weight p q w else 0) ≤ _
    rw [if_neg far]
    exact Nat.zero_le _

/-- **Most courses show the weights.** The courses of `n` steps whose squared deviation is at
least `d` weigh, times `d`, at most `n·p·q·(p + q)^n`, out of `(p + q)^n` for all of them: the
variance bound of Chebyshev's inequality, in counting form, the last step of
`typical_throughout`. -/
theorem typical (p q n d : Nat) :
    total (courses n) (offBy p q d) * d ≤ n * (p * q * (p + q) ^ n) :=
  Nat.le_trans (Nat.mul_le_mul_right d (total_le (offBy_le_within p q d) (courses n)))
    (typical_throughout p q n d)

/-! ## Concentration is exponential -/

/-- A course has as many ones and zeros as steps. -/
theorem ones_add_zeros : ∀ w : List Bool, ones w + zeros w = w.length
  | [] => rfl
  | true :: w => (Nat.add_right_comm _ _ _).trans (congrArg (· + 1) (ones_add_zeros w))
  | false :: w => (Nat.add_assoc _ _ _).symm.trans (congrArg (· + 1) (ones_add_zeros w))

/-- The weight of a course is `p ^ a · q ^ b` for `a` ones and `b` zeros. -/
theorem weight_pow (p q : Nat) : ∀ w : List Bool, weight p q w = p ^ ones w * q ^ zeros w
  | [] => rfl
  | true :: w => by
    show p * weight p q w = p ^ ones w * p * q ^ zeros w
    rw [weight_pow p q w, Nat.mul_comm (p ^ ones w) p, mul_assoc_nat]
  | false :: w => by
    show q * weight p q w = p ^ ones w * (q ^ zeros w * q)
    rw [weight_pow p q w, Nat.mul_comm (q ^ zeros w) q, mul_turn]

/-- **Weights multiply step by step.** -/
theorem weight_mul (p q u v : Nat) : ∀ w : List Bool,
    weight p q w * weight u v w = weight (p * u) (q * v) w
  | [] => rfl
  | true :: w => by
    show (p * weight p q w) * (u * weight u v w) = (p * u) * weight (p * u) (q * v) w
    rw [← weight_mul p q u v w, Naturals.mul_mul_mul_comm]
  | false :: w => by
    show (q * weight p q w) * (v * weight u v w) = (q * v) * weight (p * u) (q * v) w
    rw [← weight_mul p q u v w, Naturals.mul_mul_mul_comm]

/-- Tilting toward ones: with `v ≤ u` and at least `k` of `a` ones, `u ^ k · v ^ (a + b)` is at
most `u ^ a · v ^ b · v ^ k`. -/
theorem tilt_le {u v : Nat} (le : v ≤ u) {k a : Nat} (enough : k ≤ a) (b : Nat) :
    u ^ k * v ^ (a + b) ≤ (u ^ a * v ^ b) * v ^ k :=
  match le_dest enough with
  | ⟨e, at_a⟩ => by
    rw [at_a, Naturals.pow_add u k e, Nat.add_assoc, Naturals.pow_add v k (e + b), Naturals.pow_add v e b,
      mul_assoc_nat (u ^ k) (u ^ e)]
    have left : v ^ k * (v ^ e * v ^ b) = v ^ e * (v ^ b * v ^ k) :=
      (Nat.mul_comm _ _).trans (mul_assoc_nat _ _ _)
    have right : (u ^ k * (u ^ e * v ^ b)) * v ^ k = u ^ k * (u ^ e * (v ^ b * v ^ k)) :=
      (mul_assoc_nat _ _ _).trans (congrArg (u ^ k * ·) (mul_assoc_nat _ _ _))
    rw [left, right]
    exact Nat.mul_le_mul_left _ (Nat.mul_le_mul_right _ (Nat.pow_le_pow_left le e))

/-- The weight of a course with at least `k` ones, and nothing otherwise. -/
def atLeast (p q k : Nat) (w : List Bool) : Nat :=
  if k ≤ ones w then weight p q w else 0

theorem atLeast_le (p q k : Nat) {u v : Nat} (le : v ≤ u) (w : List Bool) :
    atLeast p q k w * (u ^ k * v ^ w.length) ≤ weight (p * u) (q * v) w * v ^ k :=
  if enough : k ≤ ones w then by
    show (if k ≤ ones w then weight p q w else 0) * _ ≤ _
    rw [if_pos enough, ← weight_mul p q u v w, mul_assoc_nat, ← ones_add_zeros w,
      weight_pow u v w]
    exact Nat.mul_le_mul_left _ (tilt_le le enough _)
  else by
    show (if k ≤ ones w then weight p q w else 0) * _ ≤ _
    rw [if_neg enough, Nat.zero_mul]
    exact Nat.zero_le _

theorem total_le_mem {f g : List Bool → Nat} :
    ∀ ws : List (List Bool), (∀ w, w ∈ ws → f w ≤ g w) → total ws f ≤ total ws g
  | [], _ => Nat.le_refl 0
  | w :: ws, le => Nat.add_le_add (le w (.head _)) (total_le_mem ws fun v mem => le v (.tail _ mem))

theorem total_congr_mem {f g : List Bool → Nat} :
    ∀ ws : List (List Bool), (∀ w, w ∈ ws → f w = g w) → total ws f = total ws g
  | [], _ => rfl
  | w :: ws, same => by
    show f w + total ws f = g w + total ws g
    rw [same w (.head _), total_congr_mem ws fun v mem => same v (.tail _ mem)]

/-- **Concentration is exponential.** For every `u ≥ v`, the courses of `n` steps with at least
`k` ones weigh, times `u ^ k · v ^ n`, at most `(p·u + q·v) ^ n · v ^ k`. -/
theorem concentrated (p q k n : Nat) {u v : Nat} (le : v ≤ u) :
    total (courses n) (atLeast p q k) * (u ^ k * v ^ n) ≤ (p * u + q * v) ^ n * v ^ k := by
  rw [← total_mul_right, ← total_weight (p * u) (q * v) n, ← total_mul_right]
  exact total_le_mem _ fun w mem => by
    have len : w.length = n := mem_courses_iff.mp mem
    rw [← len]
    exact atLeast_le p q k le w

/-- **Exponentially few courses run far ahead.** Of the `2 ^ n` courses of `n` steps, those with
at least `k` ones number, times `3 ^ k`, at most `4 ^ n`. -/
theorem few_far_ahead (k n : Nat) : total (courses n) (atLeast 1 1 k) * 3 ^ k ≤ 4 ^ n := by
  have bound := concentrated 1 1 k n (by decide : 1 ≤ 3)
  rw [Nat.one_pow, Nat.one_pow, Nat.mul_one, Nat.mul_one] at bound
  exact bound

/-! ## The weights are counting weights of steps -/

/-- Free branching on two values weighted by counting: a step to `true` weighs `p`, a step to
`false` weighs `q`, whatever it comes from. -/
def stepWeight (p q : Nat) (_ : Bool) (_ : Unit) : Bool → Nat
  | true => p
  | false => q

/-- **A course weighs what `Becoming.Weighted` composes along it.** -/
theorem along_weight (p q : Nat) : ∀ (s : Bool) (h : List (Unit × Bool)),
    counting.along (stepWeight p q) (fun _ => 1) s h = weight p q (h.map Prod.snd)
  | _, [] => rfl
  | _, ((), true) :: h => congrArg (p * ·) (along_weight p q true h)
  | _, ((), false) :: h => congrArg (q * ·) (along_weight p q false h)

theorem transfer_weight (p q : Nat) : ∀ (n : Nat) (s : Bool),
    counting.transfer (stepWeight p q) [()] [true, false] (fun _ => 1) n s = (p + q) ^ n
  | 0, _ => rfl
  | n + 1, s => by
    show p * counting.transfer (stepWeight p q) [()] [true, false] (fun _ => 1) n true +
        (q * counting.transfer (stepWeight p q) [()] [true, false] (fun _ => 1) n false + 0) =
      (p + q) ^ n * (p + q)
    rw [transfer_weight p q n true, transfer_weight p q n false, Nat.add_zero,
      ← add_mul_split, Nat.mul_comm]

/-- **The weights are those of `Becoming.Weighted`.** The sum over histories of `n` steps of
free branching, weighted by counting, is the total weight of the courses of `n` steps here. -/
theorem sum_courses_weight (p q n : Nat) (s : Bool) :
    counting.sum (Becoming.courses [()] [true, false] n)
        (counting.along (stepWeight p q) (fun _ => 1) s) =
      total (Typicality.courses n) (weight p q) :=
  (Weights.sum_courses _ _ _ _ n s).trans
    ((transfer_weight p q n s).trans (total_weight p q n).symm)

end Typicality

end Becoming
