import Becoming.Typicality

/-!
# Conditional weights: records, shares and the exit from a margin

`Becoming.Weighted` sums over histories for every weighting of steps and weighs an event on a listed
domain by its mass (`mass`), with natural weights; every weighting there is a premise.
`Becoming.Typicality` counts the courses of `n` steps on two values with natural weights `p` and `q`,
with Chebyshev's bound at the horizon (`Typicality.typical`) and Kolmogorov's bound at every step
(`Typicality.typical_throughout`). Neither says what a record does to a natural weighting, what share
of the courses an event takes, or how much weight the courses leaving a margin carry. This module
states these on the two layers, with no premise beyond the weighting each statement names, and with
no division, real number or logarithm.

* **Conditional weights** (near-definitional: identities of counting). The weighting restricted to a
  record keeps the weight of each course agreeing with the record and gives every other course
  nothing (`restrict`). Under it an event weighs what the courses meeting the event and the record
  weigh (`mass_restrict`), and its whole is the weight of the courses agreeing with the record
  (`whole_restrict`). An event weighs what its courses agreeing with a record weigh with what its
  courses disagreeing with it weigh (`mass_split`, the law of total weight). A record raises no
  weight and no mass (`restrict_le`, `mass_restrict_le`); two records in turn are their conjunction,
  in either order (`restrict_restrict`, `restrict_comm`).
* **Bayes's rule in counting form** (near-definitional: identities of counting). A share is a part
  of a whole, two naturals compared by cross-multiplication (`Share`, `Share.le`, `Share.Same`); the
  share of an event is its mass out of the whole mass (`share`). A share with nothing in its whole
  compares either way with every share and is the same ratio as any (`Share.zero_whole`), and an
  event's share with a zero whole is `⟨0, 0⟩` (`share_zero_whole`); so the laws given a record
  (`restrict_two_ways`, `restrict_independent`, `record_share`, `record_bound`) say nothing where the
  record weighs nothing. A hypothesis's share under the weighting restricted to a record, taken with
  the record's share, is the record's share under the weighting restricted to the hypothesis, taken
  with the hypothesis's share, as ratios (`restrict_two_ways`): both count the courses meeting the
  hypothesis and the record. In a generative model, each listed hypothesis with each listed record
  (`openSteps`), a course weighs the hypothesis's prior weight times the record's weight under it
  (`pairWeight`). The pair weight factors (`mass_pairWeight`); the weight of the courses agreeing
  with a record is the sum over the hypotheses of each one's prior weight times the record's weight
  under it (`evidence`); a hypothesis listed once has, given the record, the share whose part is its
  prior weight times the record's weight under it and whose whole is that sum (`posterior_single`).
  So two hypotheses, or two classes of them, compare after the record as prior weights times
  likelihood weights (`posterior_le_iff_single`, `posterior_le_iff`), and a record can turn their
  order (`Witness.record_reverses`). A prior weight is the hypothesis's share before any record where
  every listed hypothesis's likelihood weights have one total (`prior_share`), and in general not
  otherwise: a hypothesis's share is its prior weight times its own likelihood total, over the whole
  (`mass_pairWeight`), and equal prior weights with totals 1 and 3 weigh 1 and 3
  (`Witness.prior_not_share`).
* **Shares and surprise.** Less share is more surprise (near-definitional): one share is at most
  another exactly where the other's reciprocal, the whole over the part, is at most its own
  (`Share.le_iff_reciprocal`). The order is reflexive (`Share.le_refl`) and transitive through a
  share with a positive whole (`Share.le_trans`), a preorder on shares with a positive whole; through
  `⟨0, 0⟩` it is not transitive (`Witness.le_not_transitive`). A wider event has no smaller share
  (`share_le_of_included`). Over the pairs of two listed domains weighted by products, two
  independent events weigh the product of their masses (`mass_product`) and take the product of
  their shares, as pairs of naturals (`share_product`). Both are at least as surprising as either
  (`share_product_le`, `share_product_le_right`), and a record of one part leaves the share of an
  event of the other the same ratio (`restrict_independent`). Over the courses of independent steps
  (`independentWeight`, the composition of `Becoming.Weighted` along a course, each step weighed by
  what it is alone), the share of a conjunction of step events, one at each step (`meetsEach`), is
  the product of their shares (`share_meetsEach`, from `mass_meetsEach` and `whole_courses`). By the
  definitions, the reciprocal of a product of shares is the product of their reciprocals; read
  through a logarithm, which the core does not take, this is pointwise surprisal adding over
  independent events.
* **The exit from a margin.** On the courses of `Becoming.Typicality`, read a level standing `m`
  above a need, raised `q` by each one and lowered `p` by each zero. Weighed by `p` and `q`, its rises
  add up to what its falls add up to, by the binomial means of `Becoming.Drift`
  (`Drift.expected_ones`, `Drift.expected_zeros`), so no drift wears the margin down. The courses of
  `n` steps whose deviation at the horizon reaches `m` either way weigh, times `m·m`, at most
  `n·p·q·(p + q)^n`, the weighted squared spread (`deviates_bound`, from `Typicality.typical`). The
  level reaches the need or falls below it where the fall `y` reaches the rise `x` with `m` more
  (`fallsTo` at the horizon, `fallsWithin` at some step within it). The courses in which it does so
  within the horizon weigh, times `m·m`, at most the same (`fallsWithin_bound`, from
  `Typicality.typical_throughout`, through `Typicality.margin_square`), and those in which it does so
  at the horizon are among them (`fallsTo_bound`). As shares: they take at most `n·p·q` over `m·m`
  of the weight (`fallsWithin_share`), so the reciprocal of their share is at least `m·m` over
  `n·p·q` (`fallsWithin_reciprocal`). Standing at the need is not a break, since the core counts a
  need within the level as supported; a break, the level below the need, is reaching it from `m + 1`
  (`fallsTo_succ`), so its share within the horizon is at most `n·p·q` over `(m + 1)·(m + 1)`. The
  count at some step can exceed the count at the horizon: a course can fall and recover
  (`Witness.within_exceeds_end`).
* **What a record of the course so far says of the exit.** A course of `k + n` steps is a course of
  `n` later steps after a course of `k` earlier ones (`courses_add`; a course lists its latest step
  first). Take a record of the earliest `k` steps every course of `k` steps agreeing with which
  leaves the level `m'` above the need without having reached it. The courses agreeing with the
  record in which the level reaches the need within the horizon weigh what the record weighs times
  what the courses of the `n` steps left reaching it from `m'` weigh (`record_fallsWithin`, through
  `mass_record`, `fallsTo_append` and `fallsWithin_append`). Given the record, their share is that
  share (`record_share`), at most `n·p·q` over `m'·m'` (`record_bound`). Given the weighting, a
  record bears on the exit only through the margin it shows and the steps it leaves.

**Correspondence (an AI reading).** Read a share as a probability: a chance is a number of
situations of a kind (`Becoming.Situations`). Then restriction is conditioning (`mass_restrict`),
`restrict_two_ways` is Bayes's theorem in the form `P(h | o) P(o) = P(o | h) P(h)`, the share of
`evidence` in the whole is the marginal likelihood of a generative model, and `posterior_single` is
its posterior, `P(h | o) = P(h) P(o | h) / Σ P(h') P(o | h')`. This reads `prior h` as `P(h)` and
the record's weight under `h` as `P(o | h)`, which holds where every listed hypothesis's likelihood
weights have one total (`prior_share`). Otherwise `P(h)` is `prior h · Σₒ lik h o` over the whole,
and `evidence` over the whole is the marginal likelihood. Surprisal is `log (1 / P)`. No logarithm
is taken here; the reciprocal share orders as pointwise surprisal does (`Share.le_iff_reciprocal`),
and its products are surprisal's sums. Averages of surprisal, such as entropy and free energy, have
no reciprocal-share form, since an average of logarithms is not the logarithm of an average; free
energy and its bound are stated only in the periphery, over the reals
(`development/ue2-conditional-weights/periphery`). The free-energy principle bounds the surprisal of
a system's states by a variational free energy and reads persisting as keeping that surprisal low.
The exit bound is the case that reading is measured against: a balanced level that nothing reads
leaves a margin `m` within `n` steps on at most `n·p·q` over `m·m` of the weight, so leaving has
surprisal at least `log (m·m / (n·p·q))` where `m·m` exceeds `n·p·q`. The bound is void from
`n = m·m / (p·q)`, and such a level leaves every margin in time (a balanced walk recurs; not proved
here); persisting longer needs a giving that reads the level. The bound reads the weighting, the
counting form of a generative density, only through its spread; no belief (recognition density)
enters, as one does in free energy. `record_share` is the counting form of the half of 03's thesis T6
that is seen: where a record holds the level and the need, the exit reads off the margin the record
shows, the steps it leaves and the spread of the weighting, which the record does not show. The
weighting is the independently warranted model T6 allows; given it, nothing else in the record
matters, the steps being independent. That a record not holding the level bounds nothing, T6's
invisible half, is not touched here.

What is not derived: which weighting an actual unfolding has, or that the course which happens is
typical (as in `Becoming.Typicality`); real weights, densities, logarithms, surprisal as a number,
entropy, free energy or its bound. Conditioning is stated for natural weightings only: for
possibility, restriction is conditioning without shares; signed counts cancel, so a restricted signed
weighting has no share. Records are Boolean; graded evidence, a likelihood weighting multiplying a
weighting course by course, is the generative model's case only. The exit is stated for one level on
two values whose rises and falls balance under the weights (each one raising it `q`, each zero
lowering it `p`, with weights `p` and `q`); a level with a drift, several values or steps that are not
independent are not treated. The representation commits to discrete steps and natural weights. No
ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace ConditionalWeights

universe u v

/-! ## Entries of a mass -/

section Entries

/-- An entry kept by two tests in turn is kept by their conjunction. -/
theorem entry_and (a b : Bool) (n : Nat) :
    (if a = true then (if b = true then n else 0) else 0) = (if (a && b) = true then n else 0) := by
  cases a <;> cases b <;> rfl

/-- Two tests taken in either order keep the same entry. -/
theorem entry_swap (a b : Bool) (n : Nat) :
    (if b = true then (if a = true then n else 0) else 0) =
      (if a = true then (if b = true then n else 0) else 0) := by
  cases a <;> cases b <;> rfl

/-- An entry splits by a second test. -/
theorem entry_split (a b : Bool) (n : Nat) :
    (if (a && b) = true then n else 0) + (if (a && !b) = true then n else 0) =
      (if a = true then n else 0) := by
  cases a
  · rfl
  · cases b
    · exact Nat.zero_add n
    · rfl

/-- A test keeps an entry or drops it; it never raises it. -/
theorem entry_test_le (a : Bool) (n : Nat) : (if a = true then n else 0) ≤ n := by
  cases a
  · exact Nat.zero_le n
  · exact Nat.le_refl n

theorem entry_mul_left (a : Bool) (c n : Nat) :
    (if a = true then c * n else 0) = c * (if a = true then n else 0) := by
  cases a
  · exact (Nat.mul_zero c).symm
  · rfl

theorem entry_and_true (a : Bool) (n : Nat) :
    (if (a && true) = true then n else 0) = (if a = true then n else 0) := by
  cases a <;> rfl

theorem entry_and_comm (a b : Bool) (n : Nat) :
    (if (a && b) = true then n else 0) = (if (b && a) = true then n else 0) := by
  cases a <;> cases b <;> rfl

/-- A record keeps an entry an event keeps, or drops it. -/
theorem entry_restrict_le (a b : Bool) (n : Nat) :
    (if a = true then (if b = true then n else 0) else 0) ≤ (if a = true then n else 0) := by
  cases a
  · exact Nat.le_refl 0
  · exact entry_test_le b n

end Entries

/-! ## The mass of an event, entry by entry

`mass` is the sum of counting (`Weights.sum` of `counting`) over its entries (`mass_eq_sum`), so its
laws over joined, mapped and nested listings and under scaling are the laws of that sum, read
through the entries. -/

section Mass

variable {Ω : Type u}

/-- **A mass is the sum of counting over its entries.** -/
theorem mass_eq_sum (w : Ω → Nat) (e : Ω → Bool) :
    ∀ l : List Ω, mass l w e = counting.sum l (fun x => if e x = true then w x else 0)
  | [] => rfl
  | _ :: l => congrArg (_ + ·) (mass_eq_sum w e l)

/-- Masses whose entries agree on the listed members agree (`Weights.sum_congr`). -/
theorem mass_congr_mem {w w' : Ω → Nat} {e e' : Ω → Bool} {l : List Ω}
    (same : ∀ x, x ∈ l → (if e x = true then w x else 0) = (if e' x = true then w' x else 0)) :
    mass l w e = mass l w' e' :=
  (mass_eq_sum w e l).trans
    ((Weights.sum_congr (W := counting) l same).trans (mass_eq_sum w' e' l).symm)

/-- Masses whose entries agree agree. -/
theorem mass_congr {w w' : Ω → Nat} {e e' : Ω → Bool}
    (same : ∀ x, (if e x = true then w x else 0) = (if e' x = true then w' x else 0))
    (l : List Ω) : mass l w e = mass l w' e' :=
  mass_congr_mem fun x _ => same x

/-- Masses whose entries are each at most another's are at most the other's. -/
theorem mass_le_of_entries {w w' : Ω → Nat} {e e' : Ω → Bool}
    (le : ∀ x, (if e x = true then w x else 0) ≤ (if e' x = true then w' x else 0)) :
    ∀ l : List Ω, mass l w e ≤ mass l w' e'
  | [] => Nat.le_refl 0
  | x :: l => Nat.add_le_add (le x) (mass_le_of_entries le l)

/-- The event holding nowhere weighs nothing. -/
theorem mass_none (w : Ω → Nat) : ∀ l : List Ω, mass l w (fun _ => false) = 0
  | [] => rfl
  | _ :: l => (Nat.zero_add _).trans (mass_none w l)

/-- The mass on two lists joined is the two masses added (`Weights.sum_append`). -/
theorem mass_append (w : Ω → Nat) (e : Ω → Bool) (l l' : List Ω) :
    mass (l ++ l') w e = mass l w e + mass l' w e :=
  (mass_eq_sum w e (l ++ l')).trans
    ((Weights.sum_append (W := counting) (fun x => if e x = true then w x else 0) l l').trans
      (Naturals.add_congr (mass_eq_sum w e l).symm (mass_eq_sum w e l').symm))

/-- The mass on a mapped list reads the map (`Weights.sum_map`). -/
theorem mass_map {β : Type v} (g : β → Ω) (w : Ω → Nat) (e : Ω → Bool) (l : List β) :
    mass (l.map g) w e = mass l (fun b => w (g b)) (fun b => e (g b)) :=
  (mass_eq_sum w e (l.map g)).trans
    ((Weights.sum_map (W := counting) g (fun x => if e x = true then w x else 0) l).trans
      (mass_eq_sum (fun b => w (g b)) (fun b => e (g b)) l).symm)

/-- The mass over a joined listing is the sum of the masses over its parts (`Weights.sum_joinMap`). -/
theorem mass_joinMap {α : Type u} {β : Type v} (g : α → List β) (w : β → Nat) (e : β → Bool)
    (l : List α) : mass (joinMap g l) w e = mass l (fun a => mass (g a) w e) (fun _ => true) :=
  (mass_eq_sum w e (joinMap g l)).trans
    ((Weights.sum_joinMap (W := counting) g (fun x => if e x = true then w x else 0) l).trans
      ((Weights.sum_congr (W := counting) l fun a _ => (mass_eq_sum w e (g a)).symm).trans
        (mass_eq_sum (fun a => mass (g a) w e) (fun _ => true) l).symm))

/-- A weighting scaled at every entry scales the mass (`Weights.mul_sum`). -/
theorem mass_mul_left (c : Nat) (w : Ω → Nat) (e : Ω → Bool) (l : List Ω) :
    mass l (fun x => c * w x) e = c * mass l w e :=
  (mass_eq_sum (fun x => c * w x) e l).trans
    ((Weights.sum_congr (W := counting) l fun x _ => entry_mul_left (e x) c (w x)).trans
      ((Weights.mul_sum (W := counting) c (fun x => if e x = true then w x else 0) l).symm.trans
        (congrArg (c * ·) (mass_eq_sum w e l).symm)))

theorem mass_mul_right (c : Nat) (w : Ω → Nat) (e : Ω → Bool) (l : List Ω) :
    mass l (fun x => w x * c) e = mass l w e * c :=
  (mass_congr (w' := fun x => c * w x) (e' := e)
      (fun x => congrArg (fun y => if e x = true then y else 0) (Nat.mul_comm (w x) c)) l).trans
    ((mass_mul_left c w e l).trans (Nat.mul_comm _ _))

/-- The whole of a weighting with its entries tested is the mass of the test. -/
theorem whole_of_entries (v : Ω → Nat) (e : Ω → Bool) :
    ∀ l : List Ω, mass l (fun x => if e x = true then v x else 0) (fun _ => true) = mass l v e
  | [] => rfl
  | _ :: l => congrArg (_ + ·) (whole_of_entries v e l)

/-- A mass is a total of its entries. -/
theorem mass_eq_total {Ω : Type} (w : Ω → Nat) (e : Ω → Bool) :
    ∀ l : List Ω, mass l w e = total l (fun x => if e x = true then w x else 0)
  | [] => rfl
  | _ :: l => congrArg (_ + ·) (mass_eq_total w e l)

/-- The conjunction weighs the same in either order. -/
theorem mass_and_comm (l : List Ω) (w : Ω → Nat) (a b : Ω → Bool) :
    mass l w (fun x => a x && b x) = mass l w (fun x => b x && a x) :=
  mass_congr (fun x => entry_and_comm (a x) (b x) (w x)) l

/-- An event and `true` weigh as the event. -/
theorem mass_and_true (l : List Ω) (w : Ω → Nat) (a : Ω → Bool) :
    mass l w (fun x => a x && true) = mass l w a :=
  mass_congr (fun x => entry_and_true (a x) (w x)) l

end Mass

/-! ## Conditional weights -/

section Restrict

variable {Ω : Type u}

/-- **The weighting restricted to a record**: a course agreeing with the record keeps its weight,
every other course weighs nothing. -/
def restrict (record : Ω → Bool) (weight : Ω → Nat) (x : Ω) : Nat :=
  if record x = true then weight x else 0

/-- **Restriction is conditioning** (near-definitional). Under the weighting restricted to a record,
an event weighs what the courses meeting both the event and the record weigh. -/
theorem mass_restrict (r : Ω → Bool) (w : Ω → Nat) (e : Ω → Bool) (l : List Ω) :
    mass l (restrict r w) e = mass l w (fun x => e x && r x) :=
  mass_congr (fun x => entry_and (e x) (r x) (w x)) l

/-- **The weight of the courses agreeing with a record** is the whole of the weighting restricted to
it. -/
theorem whole_restrict (r : Ω → Bool) (w : Ω → Nat) (l : List Ω) :
    mass l (restrict r w) (fun _ => true) = mass l w r :=
  mass_restrict r w (fun _ => true) l

/-- **The law of total weight.** An event weighs what its courses agreeing with a record weigh with
what its courses disagreeing with it weigh. -/
theorem mass_split (r : Ω → Bool) (w : Ω → Nat) (e : Ω → Bool) :
    ∀ l : List Ω, mass l w e = mass l w (fun x => e x && r x) + mass l w (fun x => e x && !r x)
  | [] => rfl
  | x :: l => (congrArg (_ + ·) (mass_split r w e l)).trans
      ((congrArg (· + _) (entry_split (e x) (r x) (w x)).symm).trans
        (Nat.add_add_add_comm _ _ _ _))

/-- **A record raises no course's weight.** -/
theorem restrict_le (r : Ω → Bool) (w : Ω → Nat) (x : Ω) : restrict r w x ≤ w x :=
  entry_test_le (r x) (w x)

/-- **A record raises no mass.** -/
theorem mass_restrict_le (r : Ω → Bool) (w : Ω → Nat) (e : Ω → Bool) (l : List Ω) :
    mass l (restrict r w) e ≤ mass l w e :=
  mass_le_of_entries (fun x => entry_restrict_le (e x) (r x) (w x)) l

/-- **Two records in turn are their conjunction.** -/
theorem restrict_restrict (r₁ r₂ : Ω → Bool) (w : Ω → Nat) (x : Ω) :
    restrict r₂ (restrict r₁ w) x = restrict (fun y => r₁ y && r₂ y) w x :=
  (entry_swap (r₁ x) (r₂ x) (w x)).trans (entry_and (r₁ x) (r₂ x) (w x))

/-- **Records commute**: taken in either order they give one weighting. -/
theorem restrict_comm (r₁ r₂ : Ω → Bool) (w : Ω → Nat) (x : Ω) :
    restrict r₂ (restrict r₁ w) x = restrict r₁ (restrict r₂ w) x :=
  entry_swap (r₁ x) (r₂ x) (w x)

end Restrict

/-! ## Shares -/

/-- **A share**: a part of a whole, kept as two naturals and never divided. -/
structure Share where
  part : Nat
  whole : Nat

namespace Share

/-- `a` is at most `b` as a ratio, by cross-multiplication. -/
def le (a b : Share) : Prop := a.part * b.whole ≤ b.part * a.whole

/-- `a` and `b` are the same ratio, by cross-multiplication. -/
def Same (a b : Share) : Prop := a.part * b.whole = b.part * a.whole

/-- Two shares taken together: parts multiply and wholes multiply. -/
def mul (a b : Share) : Share := ⟨a.part * b.part, a.whole * b.whole⟩

/-- The share of a whole in itself. -/
def one : Share := ⟨1, 1⟩

/-- The whole over the part. Read through a logarithm, it is the share's surprisal. By the
definitions, the reciprocal of `a.mul b` is `a.reciprocal.mul b.reciprocal`. -/
def reciprocal (a : Share) : Share := ⟨a.whole, a.part⟩

theorem le_refl (a : Share) : a.le a := Nat.le_refl _

/-- The order of shares is transitive through a share with a positive whole: a preorder on shares
with a positive whole (the cross-multiplication order of `RuleCapture.CarrierCounts.order`). -/
theorem le_trans {a b c : Share} (pos : 0 < b.whole) (ab : a.le b) (bc : b.le c) : a.le c :=
  Nat.le_of_mul_le_mul_right
    (calc a.part * c.whole * b.whole
        = a.part * b.whole * c.whole := Naturals.mul_right_comm _ _ _
      _ ≤ b.part * a.whole * c.whole := Nat.mul_le_mul_right _ ab
      _ = b.part * c.whole * a.whole := Naturals.mul_right_comm _ _ _
      _ ≤ c.part * b.whole * a.whole := Nat.mul_le_mul_right _ bc
      _ = c.part * a.whole * b.whole := Naturals.mul_right_comm _ _ _) pos

/-- **A share with nothing in its whole compares either way with every share.** `⟨0, 0⟩` is at
most and at least every share, and the same ratio as any. -/
theorem zero_whole (a : Share) : (⟨0, 0⟩ : Share).le a ∧ a.le ⟨0, 0⟩ ∧ (⟨0, 0⟩ : Share).Same a :=
  ⟨show 0 * a.whole ≤ a.part * 0 by rw [Nat.zero_mul]; exact Nat.zero_le _,
   show a.part * 0 ≤ 0 * a.whole from Nat.zero_le _,
   show 0 * a.whole = a.part * 0 by rw [Nat.zero_mul]; rfl⟩

/-- **Less share is more surprise** (near-definitional). One share is at most another exactly where
the other's reciprocal is at most its reciprocal. -/
theorem le_iff_reciprocal (a b : Share) : a.le b ↔ b.reciprocal.le a.reciprocal :=
  ⟨fun le => show b.whole * a.part ≤ a.whole * b.part by
      rw [Nat.mul_comm b.whole, Nat.mul_comm a.whole]; exact le,
   fun le => show a.part * b.whole ≤ b.part * a.whole by
      rw [Nat.mul_comm a.part, Nat.mul_comm b.part]; exact le⟩

/-- Taking shares together keeps their order. -/
theorem mul_le_mul {a a' b b' : Share} (ha : a.le a') (hb : b.le b') : (a.mul b).le (a'.mul b') :=
  show a.part * b.part * (a'.whole * b'.whole) ≤ a'.part * b'.part * (a.whole * b.whole) from
  Nat.le_trans (Nat.le_of_eq (Naturals.mul_mul_mul_comm _ _ _ _).symm)
    (Nat.le_trans (Nat.mul_le_mul ha hb) (Nat.le_of_eq (Naturals.mul_mul_mul_comm _ _ _ _)))

/-- **Both of two events are at least as surprising as the first**: a share taken together with a
share whose part is within its whole is at most the first. -/
theorem mul_le_left (a : Share) {b : Share} (within : b.part ≤ b.whole) : (a.mul b).le a :=
  show a.part * b.part * a.whole ≤ a.part * (a.whole * b.whole) from
  Nat.le_trans (Nat.le_of_eq (mul_assoc_nat _ _ _)) (Nat.mul_le_mul_left a.part
    (Nat.le_trans (Nat.le_of_eq (Nat.mul_comm b.part a.whole)) (Nat.mul_le_mul_left a.whole within)))

end Share

section Shares

variable {Ω : Type u}

/-- **The share of an event** on a listed domain under a weighting: its mass out of the whole
mass. -/
def share (l : List Ω) (w : Ω → Nat) (e : Ω → Bool) : Share :=
  ⟨mass l w e, mass l w (fun _ => true)⟩

/-- **A wider event has no smaller share.** -/
theorem share_le_of_included {l : List Ω} (w : Ω → Nat) {e e' : Ω → Bool}
    (included : IncludedOn l e e') : (share l w e).le (share l w e') :=
  Nat.mul_le_mul_right _ (mass_mono w included)

/-- An event's share has its part within its whole. -/
theorem share_within (l : List Ω) (w : Ω → Nat) (e : Ω → Bool) :
    (share l w e).part ≤ (share l w e).whole :=
  mass_mono w fun _ _ _ => rfl

/-- **An event's share with nothing in its whole is `⟨0, 0⟩`**, which compares either way with
every share (`Share.zero_whole`). -/
theorem share_zero_whole (l : List Ω) (w : Ω → Nat) (e : Ω → Bool)
    (zero : (share l w e).whole = 0) : share l w e = ⟨0, 0⟩ :=
  congr (congrArg Share.mk (Nat.eq_zero_of_le_zero (zero ▸ share_within l w e))) zero

/-- **Bayes's rule in counting form** (near-definitional). A hypothesis's share under the weighting
restricted to a record, taken with the record's share, is the record's share under the weighting
restricted to the hypothesis, taken with the hypothesis's share, as ratios: both count the courses
meeting the hypothesis and the record. Where the record or the hypothesis weighs nothing, a share
given it is `⟨0, 0⟩` (`share_zero_whole`) and the statement says nothing. -/
theorem restrict_two_ways (l : List Ω) (w : Ω → Nat) (h r : Ω → Bool) :
    ((share l (restrict r w) h).mul (share l w r)).Same
      ((share l (restrict h w) r).mul (share l w h)) := by
  show mass l (restrict r w) h * mass l w r * (mass l (restrict h w) (fun _ => true) *
      mass l w (fun _ => true)) =
    mass l (restrict h w) r * mass l w h * (mass l (restrict r w) (fun _ => true) *
      mass l w (fun _ => true))
  rw [mass_restrict r w h l, mass_restrict h w r l, whole_restrict h w l, whole_restrict r w l,
    mass_and_comm l w r h]
  exact Naturals.mul_mul_mul_comm _ _ _ _

end Shares

/-! ## Pairs: a generative model and independent parts -/

section Pairs

variable {α : Type u} {β : Type v}

/-- An event tested at a first part scales the mass of the second. -/
theorem mass_scaled_event (k : Bool) (c : Nat) (v : β → Nat) (e : β → Bool) (bs : List β) :
    mass bs (fun m => c * v m) (fun m => k && e m) = if k = true then c * mass bs v e else 0 := by
  cases k
  · exact mass_none _ bs
  · exact mass_mul_left c v e bs

/-- **The mass over the pairs of two listed domains** (`openSteps`), the weight of a pair the
first's weight times the second's weight given the first: the pairs meeting `e₁` at the first and
`e₂` at the second weigh, for each first meeting `e₁`, its weight times what the seconds meeting
`e₂` weigh given it. -/
theorem mass_pairs (w₁ : α → Nat) (w₂ : α → β → Nat) (e₁ : α → Bool) (e₂ : β → Bool)
    (bs : List β) : ∀ as : List α,
    mass (openSteps as bs) (fun c => w₁ c.1 * w₂ c.1 c.2) (fun c => e₁ c.1 && e₂ c.2) =
      mass as (fun a => w₁ a * mass bs (w₂ a) e₂) e₁
  | [] => rfl
  | a :: as =>
    show mass ((bs.map fun m => (a, m)) ++ openSteps as bs) (fun c : α × β => w₁ c.1 * w₂ c.1 c.2)
        (fun c : α × β => e₁ c.1 && e₂ c.2) = _ from
    (mass_append (fun c : α × β => w₁ c.1 * w₂ c.1 c.2) (fun c : α × β => e₁ c.1 && e₂ c.2)
        (bs.map fun m => (a, m)) (openSteps as bs)).trans
      (Naturals.add_congr
        ((mass_map (fun m => (a, m)) (fun c : α × β => w₁ c.1 * w₂ c.1 c.2)
            (fun c : α × β => e₁ c.1 && e₂ c.2) bs).trans
          (mass_scaled_event (e₁ a) (w₁ a) (w₂ a) e₂ bs))
        (mass_pairs w₁ w₂ e₁ e₂ bs as))

/-- **Independent parts multiply.** With the weight of a pair the product of a weight of each part,
the pairs meeting `e₁` at the first and `e₂` at the second weigh the product of what each part's
event weighs. -/
theorem mass_product (w₁ : α → Nat) (w₂ : β → Nat) (e₁ : α → Bool) (e₂ : β → Bool) (as : List α)
    (bs : List β) :
    mass (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1 && e₂ c.2) =
      mass as w₁ e₁ * mass bs w₂ e₂ :=
  (mass_pairs w₁ (fun _ => w₂) e₁ e₂ bs as).trans (mass_mul_right _ w₁ e₁ as)

/-- **The share of both of two independent events is the product of their shares**, as pairs of
naturals, not only as ratios. -/
theorem share_product (w₁ : α → Nat) (w₂ : β → Nat) (e₁ : α → Bool) (e₂ : β → Bool) (as : List α)
    (bs : List β) :
    share (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1 && e₂ c.2) =
      (share as w₁ e₁).mul (share bs w₂ e₂) :=
  congr (congrArg Share.mk (mass_product w₁ w₂ e₁ e₂ as bs))
    (mass_product w₁ w₂ (fun _ => true) (fun _ => true) as bs)

/-- **Both of two independent events are at least as surprising as the first**: their share is at
most the first's. -/
theorem share_product_le (w₁ : α → Nat) (w₂ : β → Nat) (e₁ : α → Bool) (e₂ : β → Bool)
    (as : List α) (bs : List β) :
    (share (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1 && e₂ c.2)).le
      (share as w₁ e₁) :=
  (share_product w₁ w₂ e₁ e₂ as bs) ▸ Share.mul_le_left _ (share_within bs w₂ e₂)

/-- **Both of two independent events are at least as surprising as the second.** -/
theorem share_product_le_right (w₁ : α → Nat) (w₂ : β → Nat) (e₁ : α → Bool) (e₂ : β → Bool)
    (as : List α) (bs : List β) :
    (share (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1 && e₂ c.2)).le
      (share bs w₂ e₂) := by
  rw [share_product w₁ w₂ e₁ e₂ as bs]
  show mass as w₁ e₁ * mass bs w₂ e₂ * mass bs w₂ (fun _ => true) ≤
    mass bs w₂ e₂ * (mass as w₁ (fun _ => true) * mass bs w₂ (fun _ => true))
  have turned : (share as w₁ e₁).whole * mass bs w₂ e₂ * mass bs w₂ (fun _ => true) =
      mass bs w₂ e₂ * ((share as w₁ e₁).whole * mass bs w₂ (fun _ => true)) := by
    rw [Nat.mul_comm (share as w₁ e₁).whole (mass bs w₂ e₂), mul_assoc_nat]
  exact Nat.le_trans
    (Nat.mul_le_mul_right _ (Nat.mul_le_mul_right _ (share_within as w₁ e₁)))
    (Nat.le_of_eq turned)

/-- What an event of the first part weighs on the pairs. -/
theorem mass_first (w₁ : α → Nat) (w₂ : β → Nat) (e₁ : α → Bool) (as : List α) (bs : List β) :
    mass (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1) =
      mass as w₁ e₁ * mass bs w₂ (fun _ => true) :=
  (mass_and_true (openSteps as bs) (fun c : α × β => w₁ c.1 * w₂ c.2)
      (fun c : α × β => e₁ c.1)).symm.trans
    (mass_product w₁ w₂ e₁ (fun _ => true) as bs)

/-- **A record of one independent part leaves the other's share as it was**: the share of an event
of the first part, under the weighting restricted to a record of the second, is its share, as
ratios. Where the record weighs nothing this says nothing (`Share.zero_whole`). -/
theorem restrict_independent (w₁ : α → Nat) (w₂ : β → Nat) (e₁ : α → Bool) (r : β → Bool)
    (as : List α) (bs : List β) :
    (share (openSteps as bs) (restrict (fun c => r c.2) fun c => w₁ c.1 * w₂ c.2)
        (fun c => e₁ c.1)).Same
      (share (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1)) := by
  have meets : mass (openSteps as bs) (restrict (fun c : α × β => r c.2) fun c => w₁ c.1 * w₂ c.2)
      (fun c => e₁ c.1) = mass as w₁ e₁ * mass bs w₂ r :=
    (mass_restrict _ _ _ _).trans (mass_product w₁ w₂ e₁ r as bs)
  have agrees : mass (openSteps as bs) (restrict (fun c : α × β => r c.2) fun c => w₁ c.1 * w₂ c.2)
      (fun _ => true) = mass as w₁ (fun _ => true) * mass bs w₂ r :=
    (whole_restrict _ _ _).trans (mass_product w₁ w₂ (fun _ => true) r as bs)
  have whole : mass (openSteps as bs) (fun c : α × β => w₁ c.1 * w₂ c.2) (fun _ => true) =
      mass as w₁ (fun _ => true) * mass bs w₂ (fun _ => true) :=
    mass_product w₁ w₂ (fun _ => true) (fun _ => true) as bs
  show mass (openSteps as bs) (restrict (fun c => r c.2) fun c => w₁ c.1 * w₂ c.2)
      (fun c => e₁ c.1) * mass (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun _ => true) =
    mass (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1) *
      mass (openSteps as bs) (restrict (fun c => r c.2) fun c => w₁ c.1 * w₂ c.2) (fun _ => true)
  rw [meets, agrees, whole, mass_first]
  exact (Naturals.mul_mul_mul_comm _ _ _ _).trans
    ((congrArg (mass as w₁ e₁ * mass as w₁ (fun _ => true) * ·)
      (Nat.mul_comm (mass bs w₂ r) (mass bs w₂ (fun _ => true)))).trans
      (Naturals.mul_mul_mul_comm _ _ _ _).symm)

/-- The courses of a generative model are its pairs of a listed hypothesis and a listed record;
**the weight of a course** is the hypothesis's prior weight times the record's weight under it. -/
def pairWeight (prior : α → Nat) (lik : α → β → Nat) (c : α × β) : Nat := prior c.1 * lik c.1 c.2

/-- **The pair weight factors.** In a generative model, the courses whose hypothesis meets `hyp`
and whose record meets `rec` weigh, for each hypothesis meeting `hyp`, its prior weight times the
weight of the records meeting `rec` under it. -/
theorem mass_pairWeight (prior : α → Nat) (lik : α → β → Nat) (hs : List α) (os : List β)
    (hyp : α → Bool) (rec : β → Bool) :
    mass (openSteps hs os) (pairWeight prior lik) (fun c => hyp c.1 && rec c.2) =
      mass hs (fun h => prior h * mass os (lik h) rec) hyp :=
  mass_pairs prior lik hyp rec os hs

/-- **The weight of the courses agreeing with a record is the sum, over the hypotheses, of each
one's prior weight times the record's weight under it.** Its share of the whole is the marginal
likelihood. -/
theorem evidence (prior : α → Nat) (lik : α → β → Nat) (hs : List α) (os : List β)
    (rec : β → Bool) :
    mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) =
      mass hs (fun h => prior h * mass os (lik h) rec) (fun _ => true) :=
  mass_pairWeight prior lik hs os (fun _ => true) rec

/-- **Two classes of hypotheses compare after a record as their prior weights times the record's
weights under them.** With the record's weight positive, the share of the first under the weighting
restricted to the record is at most the second's exactly where the first's prior weights times the
record's weights, summed, are at most the second's. -/
theorem posterior_le_iff (prior : α → Nat) (lik : α → β → Nat) (hs : List α) (os : List β)
    (rec : β → Bool) (hyp₁ hyp₂ : α → Bool)
    (positive : 0 < mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)) :
    (share (openSteps hs os) (restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => hyp₁ c.1)).le
      (share (openSteps hs os) (restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => hyp₂ c.1)) ↔
      mass hs (fun h => prior h * mass os (lik h) rec) hyp₁ ≤
        mass hs (fun h => prior h * mass os (lik h) rec) hyp₂ := by
  show mass (openSteps hs os) (restrict (fun c => rec c.2) (pairWeight prior lik))
      (fun c => hyp₁ c.1) *
      mass (openSteps hs os) (restrict (fun c => rec c.2) (pairWeight prior lik)) (fun _ => true) ≤
    mass (openSteps hs os) (restrict (fun c => rec c.2) (pairWeight prior lik))
      (fun c => hyp₂ c.1) *
      mass (openSteps hs os) (restrict (fun c => rec c.2) (pairWeight prior lik)) (fun _ => true) ↔ _
  rw [whole_restrict, mass_restrict, mass_restrict, mass_pairWeight, mass_pairWeight]
  exact ⟨fun le => Nat.le_of_mul_le_mul_right le positive, fun le => Nat.mul_le_mul_right _ le⟩

/-- A hypothesis not listed weighs nothing under the test of being it. -/
theorem mass_absent [DecidableEq α] (f : α → Nat) {x : α} :
    ∀ {hs : List α}, ¬ x ∈ hs → mass hs f (fun h => decide (h = x)) = 0
  | [], _ => rfl
  | y :: hs, out => by
    have other : ¬ y = x := fun same =>
      out (Eq.subst (motive := fun z => z ∈ y :: hs) same (.head hs))
    show (if decide (y = x) = true then f y else 0) + mass hs f (fun h => decide (h = x)) = 0
    rw [decide_eq_false other]
    exact (Nat.zero_add _).trans (mass_absent f fun inside => out (.tail y inside))

/-- A listed hypothesis, listed once, is picked out by the test of being it. -/
theorem mass_single [DecidableEq α] (f : α → Nat) (x : α) :
    ∀ {hs : List α}, Distinct hs → x ∈ hs → mass hs f (fun h => decide (h = x)) = f x
  | y :: hs, ⟨fresh, rest⟩, mem =>
    if same : y = x then by
      show (if decide (y = x) = true then f y else 0) + mass hs f (fun h => decide (h = x)) = f x
      rw [decide_eq_true same, mass_absent f (x := x) (hs := hs)
        (fun inside => fresh (Eq.subst (motive := fun z => z ∈ hs) same.symm inside)), Nat.add_zero]
      exact congrArg f same
    else by
      show (if decide (y = x) = true then f y else 0) + mass hs f (fun h => decide (h = x)) = f x
      rw [decide_eq_false same]
      exact (Nat.zero_add _).trans (mass_single f x rest (match mem with
        | .head _ => absurd rfl same
        | .tail _ inside => inside))

/-- **A prior weight is the prior share where the likelihood totals agree.** With the record
weights under each listed hypothesis summing to one total `L`, a hypothesis listed once has, before
any record, the share whose part is its prior weight times `L` and whose whole is the prior weights
summed, times `L`. Where the totals differ, its share is its prior weight times its own total, over
the whole, which in general is another ratio (`Witness.prior_not_share`). -/
theorem prior_share [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat) {hs : List α}
    (os : List β) (L : Nat) (common : ∀ h, h ∈ hs → mass os (lik h) (fun _ => true) = L)
    (distinct : Distinct hs) {h₀ : α} (mem : h₀ ∈ hs) :
    share (openSteps hs os) (pairWeight prior lik) (fun c => decide (c.1 = h₀)) =
      ⟨prior h₀ * L, mass hs prior (fun _ => true) * L⟩ :=
  congr (congrArg Share.mk ((mass_and_true _ _ (fun c : α × β => decide (c.1 = h₀))).symm.trans
      ((mass_pairWeight prior lik hs os (fun h => decide (h = h₀)) (fun _ => true)).trans
        ((mass_single (fun h => prior h * mass os (lik h) (fun _ => true)) h₀ distinct mem).trans
          (congrArg (prior h₀ * ·) (common h₀ mem))))))
    ((evidence prior lik hs os (fun _ => true)).trans
      ((mass_congr_mem (w' := fun h => prior h * L) (e' := fun _ => true) fun h mem =>
          congrArg (fun y => if (fun _ : α => true) h = true then prior h * y else 0)
            (common h mem)).trans
        (mass_mul_right L prior (fun _ => true) hs)))

/-- **Bayes's rule as the weight of the courses agreeing with a record.** In a generative model, a
hypothesis listed once has, under the weighting restricted to a record, the share whose part is its
prior weight times the record's weight under it and whose whole is that product summed over the
hypotheses. The part reads as `P(h₀) P(o | h₀)` where every hypothesis's likelihood weights have
one total (`prior_share`). -/
theorem posterior_single [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₀ : α} (mem : h₀ ∈ hs) :
    share (openSteps hs os) (restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₀)) =
      ⟨prior h₀ * mass os (lik h₀) rec,
        mass hs (fun h => prior h * mass os (lik h) rec) (fun _ => true)⟩ :=
  congr (congrArg Share.mk ((mass_restrict _ _ _ _).trans
      ((mass_pairWeight prior lik hs os (fun h => decide (h = h₀)) rec).trans
        (mass_single (fun h => prior h * mass os (lik h) rec) h₀ distinct mem))))
    ((whole_restrict _ _ _).trans (evidence prior lik hs os rec))

/-- **Two hypotheses compare after a record as prior weights times likelihood weights.** Each
listed once, with the record's weight positive, the first's share given the record is at most the
second's exactly where the first's prior weight times the record's weight under it is at most the
second's. A prior weight is the prior share only where the likelihood totals agree
(`prior_share`). -/
theorem posterior_le_iff_single [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₁ h₂ : α}
    (mem₁ : h₁ ∈ hs) (mem₂ : h₂ ∈ hs)
    (positive : 0 < mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)) :
    (share (openSteps hs os) (restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₁))).le
      (share (openSteps hs os) (restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₂))) ↔
      prior h₁ * mass os (lik h₁) rec ≤ prior h₂ * mass os (lik h₂) rec := by
  rw [← mass_single (fun h => prior h * mass os (lik h) rec) h₁ distinct mem₁,
    ← mass_single (fun h => prior h * mass os (lik h) rec) h₂ distinct mem₂]
  exact posterior_le_iff prior lik hs os rec (fun h => decide (h = h₁)) (fun h => decide (h = h₂))
    positive

end Pairs

/-! ## Courses of independent steps -/

section Steps

variable {S : Type u} {A : Type v}

/-- **The weight of a course of independent steps**: the weight of each step, `w (a, m)` for a
move `a` to `m`, whatever configuration it starts from, composed along the course by counting
(`Weights.along`). -/
def independentWeight (w : A × S → Nat) (s : S) (h : List (A × S)) : Nat :=
  counting.along (fun _ a m => w (a, m)) (fun _ => 1) s h

/-- A course meets a list of step events where it has one step for each event and each step meets
its own. -/
def meetsEach {α : Type u} : List (α → Bool) → List α → Bool
  | [], [] => true
  | [], _ :: _ => false
  | _ :: _, [] => false
  | e :: es, x :: xs => e x && meetsEach es xs

/-- **The weight of the courses of independent steps meeting one event at each step is the product
of what each step's event weighs.** -/
theorem mass_meetsEach (w : A × S → Nat) (moves : List A) (all : List S) :
    ∀ (es : List (A × S → Bool)) (s : S),
      mass (courses moves all es.length) (independentWeight w s) (meetsEach es) =
        es.foldr (fun e acc => mass (openSteps moves all) w e * acc) 1
  | [], _ => rfl
  | e :: es, s =>
    (mass_joinMap (fun p => (courses moves all es.length).map fun h => p :: h)
        (independentWeight w s) (meetsEach (e :: es)) (openSteps moves all)).trans
      ((mass_congr (e := fun _ => true) (e' := e)
          (w' := fun p => w p * es.foldr (fun e acc => mass (openSteps moves all) w e * acc) 1)
          (fun p =>
            ((mass_map (fun h => p :: h) (independentWeight w s) (meetsEach (e :: es))
                (courses moves all es.length)).trans
              (mass_scaled_event (e p) (w p) (independentWeight w p.2) (meetsEach es)
                (courses moves all es.length))).trans
              (congrArg (fun y => if e p = true then w p * y else 0)
                (mass_meetsEach w moves all es p.2)))
          (openSteps moves all)).trans
        (mass_mul_right _ w e (openSteps moves all)))

/-- **The courses of independent steps weigh, together, the whole of one step to the power of
their length.** -/
theorem whole_courses (w : A × S → Nat) (moves : List A) (all : List S) :
    ∀ (n : Nat) (s : S), mass (courses moves all n) (independentWeight w s) (fun _ => true) =
      mass (openSteps moves all) w (fun _ => true) ^ n
  | 0, _ => rfl
  | n + 1, s =>
    (mass_joinMap (fun p => (courses moves all n).map fun h => p :: h)
        (independentWeight w s) (fun _ => true) (openSteps moves all)).trans
      ((mass_congr (e := fun _ => true) (e' := fun _ => true)
          (w' := fun p => w p * mass (openSteps moves all) w (fun _ => true) ^ n)
          (fun p =>
            ((mass_map (fun h => p :: h) (independentWeight w s) (fun _ => true)
                (courses moves all n)).trans
              (mass_mul_left (w p) (independentWeight w p.2) (fun _ => true)
                (courses moves all n))).trans
              (congrArg (w p * ·) (whole_courses w moves all n p.2)))
          (openSteps moves all)).trans
        ((mass_mul_right _ w (fun _ => true) (openSteps moves all)).trans
          (Nat.mul_comm _ _)))

/-- The product of the step shares has the product of the step wholes as its whole. -/
theorem foldr_whole {α : Type u} (l : List α) (w : α → Nat) :
    ∀ es : List (α → Bool),
      (es.foldr (fun e acc => (share l w e).mul acc) Share.one).whole =
        mass l w (fun _ => true) ^ es.length
  | [] => rfl
  | _ :: es => (congrArg (mass l w (fun _ => true) * ·) (foldr_whole l w es)).trans
      (Nat.mul_comm _ _)

theorem foldr_part {α : Type u} (l : List α) (w : α → Nat) :
    ∀ es : List (α → Bool),
      (es.foldr (fun e acc => (share l w e).mul acc) Share.one).part =
        es.foldr (fun e acc => mass l w e * acc) 1
  | [] => rfl
  | _ :: es => congrArg (_ * ·) (foldr_part l w es)

/-- **The share of a conjunction of step events, one at each step of a course of independent
steps, is the product of their shares**, as pairs of naturals. -/
theorem share_meetsEach (w : A × S → Nat) (moves : List A) (all : List S)
    (es : List (A × S → Bool)) (s : S) :
    share (courses moves all es.length) (independentWeight w s) (meetsEach es) =
      es.foldr (fun e acc => (share (openSteps moves all) w e).mul acc) Share.one :=
  congr (congrArg Share.mk ((mass_meetsEach w moves all es s).trans
      (foldr_part (openSteps moves all) w es).symm))
    ((whole_courses w moves all es.length s).trans (foldr_whole (openSteps moves all) w es).symm)

end Steps

/-! ## The exit from a margin -/

section Exit

open Typicality

/-- **The deviation of a course reaches `m`**, either way: with `x = q·a` and `y = p·b` for `a`
ones and `b` zeros, `x + m ≤ y` or `y + m ≤ x`. -/
def deviates (p q m : Nat) (w : List Bool) : Bool :=
  decide (ahead q w + m ≤ behind p w) || decide (behind p w + m ≤ ahead q w)

/-- **A level standing `m` above a need reaches it or falls below it.** Raised `q` by each one and
lowered `p` by each zero, so that weighed by `p` and `q` its rises and falls balance (the binomial
means `Drift.expected_ones` and `Drift.expected_zeros`), the level ends the course at the need or
below it: `x + m ≤ y`. -/
def fallsTo (p q m : Nat) (w : List Bool) : Bool := decide (ahead q w + m ≤ behind p w)

/-- **A break is reaching the need from one more than the margin**: `fallsTo p q (m + 1)` tests
`x + m < y`, the level below the need. Standing at the need is not a break, since the core counts a
need within the level as supported. -/
theorem fallsTo_succ (p q m : Nat) (w : List Bool) :
    fallsTo p q (m + 1) w = decide (ahead q w + m < behind p w) := rfl

/-- A course whose deviation reaches `m` is a course whose squared deviation is at least `m·m`. -/
theorem deviates_offBy (p q m : Nat) (w : List Bool) :
    (if deviates p q m w = true then weight p q w else 0) ≤ offBy p q (m * m) w :=
  match h : deviates p q m w with
  | false => Nat.zero_le _
  | true =>
    have far : m * m + cross p q w ≤ square p q w :=
      match ListTests.or_true_iff.mp h with
      | .inl low => margin_square (of_decide_eq_true low)
      | .inr high => by
        have := margin_square (of_decide_eq_true high)
        show m * m + 2 * (ahead q w * behind p w) ≤ ahead q w * ahead q w + behind p w * behind p w
        rw [Nat.mul_comm (ahead q w), Nat.add_comm (ahead q w * ahead q w)]
        exact this
    show weight p q w ≤ if m * m + cross p q w ≤ square p q w then weight p q w else 0 by
      rw [if_pos far]; exact Nat.le_refl _

/-- The courses of `n` steps weigh `(p + q) ^ n` together, as a mass. -/
theorem whole_typical (p q n : Nat) :
    mass (Typicality.courses n) (weight p q) (fun _ => true) = (p + q) ^ n :=
  (mass_eq_total (weight p q) (fun _ => true) (Typicality.courses n)).trans (total_weight p q n)

/-- **The deviation bound at the horizon.** The courses of `n` steps whose deviation at the horizon
reaches `m` either way weigh, times `m·m`, at most `n·p·q·(p + q)^n`, the weighted squared spread of
all of them (`Typicality.spread`): Chebyshev's bound (`Typicality.typical`) read at a margin. -/
theorem deviates_bound (p q m n : Nat) :
    mass (Typicality.courses n) (weight p q) (deviates p q m) * (m * m) ≤ n * (p * q * (p + q) ^ n) :=
  Nat.le_trans
    (Nat.mul_le_mul_right _
      (Nat.le_trans (Nat.le_of_eq (mass_eq_total (weight p q) (deviates p q m) (Typicality.courses n)))
        (Typicality.total_le (deviates_offBy p q m) (Typicality.courses n))))
    (typical p q n (m * m))

/-- **A level standing `m` above a need reaches it or falls below it at some step**: at some step
of the course, its start included, `x + m ≤ y`. -/
def fallsWithin (p q m : Nat) : List Bool → Bool
  | [] => decide (ahead q [] + m ≤ behind p [])
  | b :: w => fallsWithin p q m w || decide (ahead q (b :: w) + m ≤ behind p (b :: w))

/-- A level that ends the course at the need or below it has reached the need at some step. -/
theorem fallsWithin_of_end {p q m : Nat} :
    ∀ {w : List Bool}, fallsTo p q m w = true → fallsWithin p q m w = true
  | [], falls => falls
  | _ :: w, falls => ListTests.or_right (fallsWithin p q m w) falls

/-- A course in which the level reaches the need at some step reaches the squared deviation `m·m`
at that step. -/
theorem fallsWithin_reachesBy (p q m : Nat) :
    ∀ {w : List Bool}, fallsWithin p q m w = true → reachesBy p q (m * m) w = true
  | [], falls => decide_eq_true (margin_square (of_decide_eq_true falls))
  | _ :: _, falls => match ListTests.or_cases falls with
    | .inl earlier => ListTests.or_left _ (fallsWithin_reachesBy p q m earlier)
    | .inr now => ListTests.or_right _ (decide_eq_true (margin_square (of_decide_eq_true now)))

theorem fallsWithin_entry (p q m : Nat) (w : List Bool) :
    (if fallsWithin p q m w = true then weight p q w else 0) ≤ offByWithin p q (m * m) w :=
  match h : fallsWithin p q m w with
  | false => Nat.zero_le _
  | true => show weight p q w ≤ (if reachesBy p q (m * m) w = true then weight p q w else 0) by
      rw [fallsWithin_reachesBy p q m h]; exact Nat.le_refl _

/-- **The exit bound within the horizon.** The courses of `n` steps in which a level standing `m`
above a need reaches it or falls below it at some step weigh, times `m·m`, at most
`n·p·q·(p + q)^n`: the spread over the margin squared, through Kolmogorov's maximal inequality
(`typical_throughout`). With `m + 1` in place of `m` it bounds the breaks (`fallsTo_succ`). -/
theorem fallsWithin_bound (p q m n : Nat) :
    mass (Typicality.courses n) (weight p q) (fallsWithin p q m) * (m * m) ≤
      n * (p * q * (p + q) ^ n) :=
  Nat.le_trans
    (Nat.mul_le_mul_right _
      (Nat.le_trans
        (Nat.le_of_eq (mass_eq_total (weight p q) (fallsWithin p q m) (Typicality.courses n)))
        (Typicality.total_le (fallsWithin_entry p q m) (Typicality.courses n))))
    (typical_throughout p q n (m * m))

/-- **The courses in which the level ends at the need or below it weigh, times `m·m`, at most the
spread**: the corollary at the horizon. -/
theorem fallsTo_bound (p q m n : Nat) :
    mass (Typicality.courses n) (weight p q) (fallsTo p q m) * (m * m) ≤
      n * (p * q * (p + q) ^ n) :=
  Nat.le_trans
    (Nat.mul_le_mul_right _ (mass_mono (weight p q) (fun _ _ falls => fallsWithin_of_end falls)))
    (fallsWithin_bound p q m n)

/-- **The share of the courses in which the level reaches the need within the horizon is at most
`n·p·q` over `m·m`.** -/
theorem fallsWithin_share (p q m n : Nat) :
    (share (Typicality.courses n) (weight p q) (fallsWithin p q m)).le ⟨n * (p * q), m * m⟩ :=
  show mass (Typicality.courses n) (weight p q) (fallsWithin p q m) * (m * m) ≤
      n * (p * q) * mass (Typicality.courses n) (weight p q) (fun _ => true) by
  rw [whole_typical, mul_assoc_nat]
  exact fallsWithin_bound p q m n

/-- **The reciprocal of the share of the courses in which the level reaches the need within the
horizon is at least `m·m` over `n·p·q`.** -/
theorem fallsWithin_reciprocal (p q m n : Nat) :
    (Share.reciprocal ⟨n * (p * q), m * m⟩).le
      (share (Typicality.courses n) (weight p q) (fallsWithin p q m)).reciprocal :=
  (Share.le_iff_reciprocal _ _).mp (fallsWithin_share p q m n)

end Exit

/-! ## What a record of the course so far says of the exit -/

section Record

open Typicality

theorem joinMap_congr {α : Type u} {β : Type v} {g g' : α → List β} (same : ∀ a, g a = g' a) :
    ∀ l : List α, joinMap g l = joinMap g' l
  | [] => rfl
  | a :: l => show g a ++ joinMap g l = g' a ++ joinMap g' l from
      (congrArg (· ++ joinMap g l) (same a)).trans (congrArg (g' a ++ ·) (joinMap_congr same l))

theorem joinMap_single {α : Type u} : ∀ l : List α, joinMap (fun a => [a]) l = l
  | [] => rfl
  | a :: l => congrArg (a :: ·) (joinMap_single l)

theorem extend_append : ∀ l l' : List (List Bool),
    Typicality.extend (l ++ l') = Typicality.extend l ++ Typicality.extend l'
  | [], _ => rfl
  | w :: l, l' => congrArg (fun r => (true :: w) :: (false :: w) :: r) (extend_append l l')

theorem extend_joinMap {α : Type u} (g : α → List (List Bool)) : ∀ l : List α,
    Typicality.extend (joinMap g l) = joinMap (fun a => Typicality.extend (g a)) l
  | [] => rfl
  | a :: l => (extend_append (g a) (joinMap g l)).trans
      (congrArg (Typicality.extend (g a) ++ ·) (extend_joinMap g l))

theorem extend_map_append (u : List Bool) : ∀ ws : List (List Bool),
    Typicality.extend (ws.map (· ++ u)) = (Typicality.extend ws).map (· ++ u)
  | [] => rfl
  | w :: ws => congrArg (fun r => (true :: (w ++ u)) :: (false :: (w ++ u)) :: r)
      (extend_map_append u ws)

/-- **A course of `k + n` steps is a course of `n` later steps after a course of `k` earlier
ones**: the courses of `k + n` steps list, for each course of `k` steps, the courses of `n` steps
followed by it (a course lists its latest step first). -/
theorem courses_add (k : Nat) : ∀ n : Nat,
    Typicality.courses (k + n) =
      joinMap (fun u => (Typicality.courses n).map (· ++ u)) (Typicality.courses k)
  | 0 => (joinMap_single (Typicality.courses k)).symm
  | n + 1 => (congrArg Typicality.extend (courses_add k n)).trans
      ((extend_joinMap _ (Typicality.courses k)).trans
        (joinMap_congr (fun u => extend_map_append u (Typicality.courses n)) _))

theorem drop_append_length : ∀ v u : List Bool, (v ++ u).drop v.length = u
  | [], _ => rfl
  | _ :: v, u => drop_append_length v u

theorem weight_append (p q : Nat) (u : List Bool) : ∀ v : List Bool,
    weight p q (v ++ u) = weight p q v * weight p q u
  | [] => (Nat.one_mul _).symm
  | true :: v => (congrArg (p * ·) (weight_append p q u v)).trans (mul_assoc_nat _ _ _).symm
  | false :: v => (congrArg (q * ·) (weight_append p q u v)).trans (mul_assoc_nat _ _ _).symm

theorem ones_append (u : List Bool) : ∀ v : List Bool, ones (v ++ u) = ones v + ones u
  | [] => (Nat.zero_add _).symm
  | true :: v => (congrArg (· + 1) (ones_append u v)).trans (Nat.add_right_comm _ _ _)
  | false :: v => ones_append u v

theorem zeros_append (u : List Bool) : ∀ v : List Bool, zeros (v ++ u) = zeros v + zeros u
  | [] => (Nat.zero_add _).symm
  | true :: v => zeros_append u v
  | false :: v => (congrArg (· + 1) (zeros_append u v)).trans (Nat.add_right_comm _ _ _)

/-- **The margin a record shows carries the fall over.** Where a record leaves the level `m'`
above the need, a level that started `m` above it reaches the need after the record exactly where,
counted from the record, it reaches it from `m'`. -/
theorem margin_shift {xv yv xu yu m m' : Nat} (shows : m + xu = m' + yu) :
    xv + xu + m ≤ yv + yu ↔ xv + m' ≤ yv :=
  have same : xv + xu + m = xv + m' + yu := by
    rw [Nat.add_assoc, Nat.add_comm xu m, shows, ← Nat.add_assoc]
  ⟨fun le => le_of_add_le_add_right yu (Nat.le_trans (Nat.le_of_eq same.symm) le),
   fun le => Nat.le_trans (Nat.le_of_eq same) (Nat.add_le_add_right le yu)⟩

/-- **After a record showing the margin `m'`, the level ends at the need or below it exactly where,
counted from the record with the margin `m'`, it does.** -/
theorem fallsTo_append (p q m m' : Nat) {u : List Bool} (shows : m + ahead q u = m' + behind p u)
    (v : List Bool) : fallsTo p q m (v ++ u) = fallsTo p q m' v :=
  bool_eq_of_iff (ListTests.decide_true_iff.trans
    ((show ahead q (v ++ u) + m ≤ behind p (v ++ u) ↔
        ahead q v + ahead q u + m ≤ behind p v + behind p u by
      rw [show ahead q (v ++ u) = ahead q v + ahead q u from
          (congrArg (q * ·) (ones_append u v)).trans (Nat.mul_add _ _ _),
        show behind p (v ++ u) = behind p v + behind p u from
          (congrArg (p * ·) (zeros_append u v)).trans (Nat.mul_add _ _ _)]).trans
      ((margin_shift shows).trans ListTests.decide_true_iff.symm)))

/-- **Reaching the need after a record is reaching it in the record or reaching it from the margin
the record shows.** -/
theorem fallsWithin_append (p q m m' : Nat) {u : List Bool}
    (shows : m + ahead q u = m' + behind p u) :
    ∀ v : List Bool, fallsWithin p q m (v ++ u) = (fallsWithin p q m u || fallsWithin p q m' v)
  | [] => by
    show fallsWithin p q m u = (fallsWithin p q m u || decide (ahead q [] + m' ≤ behind p []))
    cases h : decide (ahead q [] + m' ≤ behind p [])
    · cases fallsWithin p q m u <;> rfl
    · have ends : fallsTo p q m u = true :=
        (fallsTo_append p q m m' shows []).trans h
      rw [fallsWithin_of_end ends]
      rfl
  | b :: v => by
    show (fallsWithin p q m (v ++ u) ||
        decide (ahead q ((b :: v) ++ u) + m ≤ behind p ((b :: v) ++ u))) =
      (fallsWithin p q m u ||
        (fallsWithin p q m' v || decide (ahead q (b :: v) + m' ≤ behind p (b :: v))))
    rw [fallsWithin_append p q m m' shows v]
    rw [show decide (ahead q ((b :: v) ++ u) + m ≤ behind p ((b :: v) ++ u)) =
      decide (ahead q (b :: v) + m' ≤ behind p (b :: v)) from fallsTo_append p q m m' shows (b :: v)]
    cases fallsWithin p q m u <;> rfl

/-- **The courses agreeing with a record factor.** For a record `R` of the earliest `k` steps and an
event `E` that every course of `k + n` steps agreeing with the record meets exactly where its `n`
later steps meet `F`, the courses of `k + n` steps agreeing with the record and meeting `E` weigh
what the record weighs times what `F` weighs over the courses of `n` steps. -/
theorem mass_record (p q k n : Nat) (R E F : List Bool → Bool)
    (carries : ∀ u v : List Bool, u.length = k → R u = true → v.length = n → E (v ++ u) = F v) :
    mass (Typicality.courses (k + n)) (weight p q) (fun w => R (w.drop n) && E w) =
      mass (Typicality.courses k) (weight p q) R * mass (Typicality.courses n) (weight p q) F := by
  rw [courses_add k n, mass_joinMap]
  refine (mass_congr_mem (e := fun _ => true) (e' := R)
      (w' := fun u => weight p q u * mass (Typicality.courses n) (weight p q) F)
      (fun u memu => ?_)).trans
    (mass_mul_right _ (weight p q) R (Typicality.courses k))
  have lenu : u.length = k := Typicality.mem_courses_iff.mp memu
  show mass ((Typicality.courses n).map (· ++ u)) (weight p q) (fun w => R (w.drop n) && E w) =
    if R u = true then weight p q u * mass (Typicality.courses n) (weight p q) F else 0
  rw [mass_map]
  cases hR : R u with
  | false =>
    exact (mass_congr_mem (w' := weight p q) (e' := fun _ => false) fun v mem => by
      have len : v.length = n := Typicality.mem_courses_iff.mp mem
      show (if (R ((v ++ u).drop n) && E (v ++ u)) = true then weight p q (v ++ u) else 0) = 0
      rw [show (v ++ u).drop n = u from len ▸ drop_append_length v u, hR]
      rfl).trans (mass_none _ _)
  | true =>
    refine (mass_congr_mem (w' := fun v => weight p q v * weight p q u) (e' := F)
      fun v mem => ?_).trans
      ((mass_mul_right _ (weight p q) F (Typicality.courses n)).trans (Nat.mul_comm _ _))
    have len : v.length = n := Typicality.mem_courses_iff.mp mem
    show (if (R ((v ++ u).drop n) && E (v ++ u)) = true then weight p q (v ++ u) else 0) =
      (if F v = true then weight p q v * weight p q u else 0)
    rw [show (v ++ u).drop n = u from len ▸ drop_append_length v u, hR, carries u v lenu hR len,
      weight_append]
    rfl

/-- **What a record says of reaching the need within the horizon is the margin it shows.** For a
record of the earliest `k` steps every course of `k` steps agreeing with which leaves the level `m'`
above the need (`m + x = m' + y` there) without having reached it, the courses of `k + n` steps
agreeing with the record in which the level reaches the need at some step weigh what the record
weighs times what the courses of the `n` steps left in which it reaches it from `m'` weigh. -/
theorem record_fallsWithin (p q m m' k n : Nat) (R : List Bool → Bool)
    (shows : ∀ u : List Bool, u.length = k → R u = true →
      m + ahead q u = m' + behind p u ∧ fallsWithin p q m u = false) :
    mass (Typicality.courses (k + n)) (weight p q) (fun w => R (w.drop n) && fallsWithin p q m w) =
      mass (Typicality.courses k) (weight p q) R *
        mass (Typicality.courses n) (weight p q) (fallsWithin p q m') :=
  mass_record p q k n R (fallsWithin p q m) (fallsWithin p q m') fun u v lenu agrees _ =>
    (fallsWithin_append p q m m' (shows u lenu agrees).1 v).trans
      (congrArg (· || fallsWithin p q m' v) (shows u lenu agrees).2)

/-- **Given the record, the share of the courses that reach the need within the horizon is their
share from the margin the record shows, over the steps left**, as ratios. Where the record weighs
nothing this says nothing (`Share.zero_whole`). -/
theorem record_share (p q m m' k n : Nat) (R : List Bool → Bool)
    (shows : ∀ u : List Bool, u.length = k → R u = true →
      m + ahead q u = m' + behind p u ∧ fallsWithin p q m u = false) :
    (share (Typicality.courses (k + n)) (restrict (fun w => R (w.drop n)) (weight p q))
        (fallsWithin p q m)).Same
      (share (Typicality.courses n) (weight p q) (fallsWithin p q m')) := by
  have part : mass (Typicality.courses (k + n)) (restrict (fun w => R (w.drop n)) (weight p q))
      (fallsWithin p q m) = mass (Typicality.courses k) (weight p q) R *
        mass (Typicality.courses n) (weight p q) (fallsWithin p q m') :=
    (mass_restrict _ _ _ _).trans
      ((mass_and_comm _ _ _ _).trans (record_fallsWithin p q m m' k n R shows))
  have whole : mass (Typicality.courses (k + n)) (restrict (fun w => R (w.drop n)) (weight p q))
      (fun _ => true) = mass (Typicality.courses k) (weight p q) R *
        mass (Typicality.courses n) (weight p q) (fun _ => true) :=
    (whole_restrict _ _ _).trans ((mass_and_true _ _ _).symm.trans
      (mass_record p q k n R (fun _ => true) (fun _ => true) fun _ _ _ _ _ => rfl))
  show mass (Typicality.courses (k + n)) (restrict (fun w => R (w.drop n)) (weight p q))
      (fallsWithin p q m) * mass (Typicality.courses n) (weight p q) (fun _ => true) =
    mass (Typicality.courses n) (weight p q) (fallsWithin p q m') *
      mass (Typicality.courses (k + n)) (restrict (fun w => R (w.drop n)) (weight p q))
        (fun _ => true)
  rw [part, whole, mul_assoc_nat]
  exact mul_turn _ _ _

/-- **Given the record, the share of the courses that reach the need within the `n` steps left is
at most `n·p·q` over `m'·m'`**: the spread left over the square of the margin the record shows.
Where the record weighs nothing this says nothing (`Share.zero_whole`). -/
theorem record_bound (p q m m' k n : Nat) (R : List Bool → Bool)
    (shows : ∀ u : List Bool, u.length = k → R u = true →
      m + ahead q u = m' + behind p u ∧ fallsWithin p q m u = false) :
    (share (Typicality.courses (k + n)) (restrict (fun w => R (w.drop n)) (weight p q))
        (fallsWithin p q m)).le ⟨n * (p * q), m' * m'⟩ := by
  have part : mass (Typicality.courses (k + n)) (restrict (fun w => R (w.drop n)) (weight p q))
      (fallsWithin p q m) = mass (Typicality.courses k) (weight p q) R *
        mass (Typicality.courses n) (weight p q) (fallsWithin p q m') :=
    (mass_restrict _ _ _ _).trans
      ((mass_and_comm _ _ _ _).trans (record_fallsWithin p q m m' k n R shows))
  have whole : mass (Typicality.courses (k + n)) (restrict (fun w => R (w.drop n)) (weight p q))
      (fun _ => true) = mass (Typicality.courses k) (weight p q) R * (p + q) ^ n :=
    (whole_restrict _ _ _).trans ((mass_and_true _ _ _).symm.trans
      ((mass_record p q k n R (fun _ => true) (fun _ => true) fun _ _ _ _ _ => rfl).trans
        (congrArg (_ * ·) (whole_typical p q n))))
  show mass (Typicality.courses (k + n)) (restrict (fun w => R (w.drop n)) (weight p q))
      (fallsWithin p q m) * (m' * m') ≤
    n * (p * q) * mass (Typicality.courses (k + n)) (restrict (fun w => R (w.drop n)) (weight p q))
      (fun _ => true)
  rw [part, whole, mul_assoc_nat]
  -- `a·(F·(m'·m')) ≤ n·(p·q)·(a·(p + q)^n)`
  exact Nat.le_trans (Nat.mul_le_mul_left _ (fallsWithin_bound p q m' n)) (Nat.le_of_eq
    ((mul_turn _ n _).trans ((congrArg (n * ·) (mul_turn _ (p * q) _)).trans
      (mul_assoc_nat n (p * q) _).symm)))

end Record

/-! ## Witnesses -/

namespace Witness

open Typicality

/-- **The order of shares is not transitive through `⟨0, 0⟩`**: `⟨1, 1⟩ ≤ ⟨0, 0⟩ ≤ ⟨0, 1⟩`, and
not `⟨1, 1⟩ ≤ ⟨0, 1⟩`. -/
theorem le_not_transitive :
    (⟨1, 1⟩ : Share).le ⟨0, 0⟩ ∧ (⟨0, 0⟩ : Share).le ⟨0, 1⟩ ∧ ¬ (⟨1, 1⟩ : Share).le ⟨0, 1⟩ :=
  ⟨Nat.le_refl 0, Nat.le_refl 0, fun h => (by decide : ¬ (1 * 1 ≤ 0 * 1)) h⟩

/-- **Counting the courses that reach the need at some step can count more than counting those
that end there or below.** With weights one and one, a level one above the need over two steps
reaches it at some step on two of the four courses and ends below it on one: the course down then
up recovers. -/
theorem within_exceeds_end :
    mass (Typicality.courses 2) (weight 1 1) (fallsTo 1 1 1) = 1 ∧
      mass (Typicality.courses 2) (weight 1 1) (fallsWithin 1 1 1) = 2 :=
  ⟨rfl, rfl⟩

/-- Two hypotheses with prior weights 3 and 1. -/
def prior : Bool → Nat
  | false => 3
  | true => 1

/-- Each hypothesis gives its two records the total 5: the record `true` weighs 1 under the first
hypothesis and 5 under the second. -/
def lik : Bool → Bool → Nat
  | false, false => 4
  | false, true => 1
  | true, false => 0
  | true, true => 5

/-- Two hypotheses whose likelihood weights total 1 and 3. -/
def likUneven : Bool → Bool → Nat
  | false, false => 1
  | false, true => 0
  | true, false => 1
  | true, true => 2

/-- **Where the likelihood totals differ, a prior weight is not the prior share**: with prior
weights one and one and likelihood totals 1 and 3, the two hypotheses' courses weigh 1 and 3 before
any record. -/
theorem prior_not_share :
    mass (openSteps [false, true] [false, true]) (pairWeight (fun _ => 1) likUneven)
        (fun c => !c.1) = 1 ∧
      mass (openSteps [false, true] [false, true]) (pairWeight (fun _ => 1) likUneven)
        (fun c => c.1) = 3 :=
  ⟨rfl, rfl⟩

/-- **A record can turn the order of two hypotheses.** The first hypothesis's courses weigh 15 and
the second's 5; restricted to the record `true` they weigh 3 and 5. -/
theorem record_reverses :
    mass (openSteps [false, true] [false, true]) (pairWeight prior lik) (fun c => !c.1) = 15 ∧
      mass (openSteps [false, true] [false, true]) (pairWeight prior lik) (fun c => c.1) = 5 ∧
      mass (openSteps [false, true] [false, true]) (restrict (fun c => c.2) (pairWeight prior lik))
        (fun c => !c.1) = 3 ∧
      mass (openSteps [false, true] [false, true]) (restrict (fun c => c.2) (pairWeight prior lik))
        (fun c => c.1) = 5 :=
  ⟨rfl, rfl, rfl, rfl⟩

end Witness

end ConditionalWeights

end Becoming
