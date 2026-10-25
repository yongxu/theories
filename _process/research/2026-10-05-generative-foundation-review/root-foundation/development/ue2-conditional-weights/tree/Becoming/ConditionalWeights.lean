import Becoming.Typicality

/-!
# Conditional weights: records, shares and the exit from a margin

`Becoming.Weighted` sums over histories for every weighting of steps and weighs an event on a listed
domain by its mass (`mass`); every weighting there is a premise. `Becoming.Typicality` counts the
courses of `n` steps on two values with natural weights `p` and `q`, with Chebyshev's bound
(`Typicality.typical`) and Kolmogorov's bound at every step (`Typicality.typical_throughout`).
Neither says what a record does to a weighting, what share of the courses an event takes, or how
much weight the courses leaving a margin carry. This module states these on the two layers, with no
premise beyond the weighting each statement names, and with no division, real number or logarithm.

* **Conditional weights.** The weighting given a record keeps the weight of each course agreeing
  with the record and gives every other course nothing (`given`). Under it an event weighs what the
  courses meeting the event and the record weigh (`mass_given`), and its whole is the weight of the
  courses agreeing with the record (`whole_given`). An event weighs what its courses agreeing with a
  record weigh with what its courses disagreeing with it weigh (`mass_split`, the law of total
  weight). A record raises no weight and no mass (`given_le`, `mass_given_le`); two records in turn
  are their conjunction, in either order (`given_given`, `given_comm`).
* **Bayes's rule in counting form.** A share is a part of a whole, two naturals compared by
  cross-multiplication (`Share`, `Share.le`, `Share.Same`); the share of an event is its mass out of
  the whole mass (`share`). A hypothesis's share given a record, taken with the record's share, is
  the record's share given the hypothesis, taken with the hypothesis's share, with no condition
  (`joint_two_ways`), and the courses meeting both weigh the record's weight times the hypothesis's
  share given it, cross-multiplied (`joint_eq_record_times_given`): both count one set of courses.
  In a generative model, each listed hypothesis with each listed record (`openSteps`), a course
  weighs the hypothesis's weight times the record's weight under it (`joint`). The joint weight
  factors (`mass_joint`); the weight of the courses agreeing with a record is the sum over the
  hypotheses of each one's weight times the record's weight under it (`evidence`); a hypothesis
  listed once has, given the record, the share whose part is its weight times the record's weight
  under it and whose whole is that sum (`posterior_single`). So two hypotheses, or two classes of
  them, compare after the record as prior weights times likelihood weights
  (`posterior_le_iff_single`, `posterior_le_iff`), and a record can turn their order
  (`Witness.record_reverses`).
* **Shares and surprise.** Less share is more surprise: one share is at most another exactly where
  the other's reciprocal, the whole over the part, is at most its own (`Share.le_iff_reciprocal`).
  The order is reflexive and transitive through a positive whole (`Share.le_refl`,
  `Share.le_trans`), and a wider event has no smaller share (`share_le_of_included`). Over the pairs
  of two listed domains weighted by products, two independent events weigh the product of their
  masses (`mass_product`) and take the product of their shares, as pairs of naturals
  (`share_product`); both are at least as surprising as either (`share_product_le`, by
  `Share.mul_le_left`), and a record of one part leaves the share of an event of the other as it was
  (`given_independent`). Over the courses of independent steps (`independentWeight`, the composition
  of `Becoming.Weighted` along a course, each step weighed by what it is alone), the share of a
  conjunction of step events, one at each step (`meetsEach`), is the product of their shares
  (`share_meetsEach`, from `mass_meetsEach` and `whole_courses`). Where a logarithm adds surprisals,
  shares multiply here, and so do their reciprocals (`Share.reciprocal_mul`).
* **The exit from a margin.** On the courses of `Becoming.Typicality`, read a level standing `m`
  above a need, raised `q` by each one and lowered `p` by each zero; weighed by `p` and `q`, its
  rises add up to what its falls add up to (`rises_balance_falls`), so no drift wears the margin
  down. The courses of `n` steps whose deviation reaches `m` either way weigh, times `m·m`, at most
  `n·p·q·(p + q)^n`, the weighted squared spread (`deviates_bound`, from `Typicality.typical`). The
  courses in which the level falls to the need at some step within the horizon weigh, times `m·m`,
  at most the same (`fallsWithin_bound`, from `Typicality.typical_throughout`), and those in which
  it ends at the need or below are among them (`fallsTo_bound`). As shares: the courses falling to
  the need within the horizon take at most `n·p·q` over `m·m` of the weight (`fallsWithin_share`),
  so falling to it is at least as surprising as `m·m` over `n·p·q` (`fallsWithin_reciprocal`). The
  count at some step exceeds the count at the end: a course can fall and recover
  (`Witness.within_exceeds_end`).
* **What a record of the course so far says of the exit.** A course of `k + n` steps is a course of
  `n` later steps after a course of `k` earlier ones (`courses_add`; a course lists its latest step
  first). Take a record of the earliest `k` steps every course agreeing with which leaves the level
  `m'` above the need without having fallen to it. The courses agreeing with the record in which the
  level falls to the need within the horizon weigh what the record weighs times what the courses of
  the `n` steps left falling from `m'` weigh (`record_fallsWithin`, through `mass_record`,
  `fallsTo_append` and `fallsWithin_append`). Given the record, their share is that share
  (`record_share`), at most `n·p·q` over `m'·m'` (`record_bound`). A record bears on the exit only
  through the margin it shows and the steps it leaves.

**Correspondence (an AI reading).** Read a share as a probability: a chance is a number of
situations of a kind (`Becoming.Situations`). Then conditioning is restriction (`mass_given`),
`joint_two_ways` is Bayes's theorem in the form `P(h | o) P(o) = P(o | h) P(h)`, `evidence` is the
marginal likelihood of a generative model, and `posterior_single` is its posterior,
`P(h | o) = P(h) P(o | h) / Σ P(h') P(o | h')`. Surprisal is `log (1 / P)`. No logarithm is taken here, but the
reciprocal share, whose logarithm the surprisal is, reverses the order of shares
(`Share.le_iff_reciprocal`) and multiplies over independent steps (`share_meetsEach`,
`Share.reciprocal_mul`) where surprisal adds. The free-energy principle bounds the surprisal of a
system's states by a variational free energy and reads persisting as keeping that surprisal low,
within the states its continuation needs. The exit bound is the counting form of what that reading
asks of a margin: the share of the courses leaving what a continuation needs, a level above a need,
is at most the spread over the margin squared, so the surprisal of leaving within `n` steps is at
least `log (m·m / (n·p·q))`. It reads the margin and the spread, and no generative model of the
system. That this is the principle's quantity is the AI's reading, stated with its sources in
`development/ue1-fep-bridge/NOTE.md`. The variational bound itself, free energy at least surprisal,
is Gibbs' inequality and needs logarithms; it is drafted for the periphery in
`development/ue2-conditional-weights/periphery`. `record_share` is the counting form of the half of
03's thesis T6 that is seen: where a record holds the level and the need, how near a break is reads
off the margin it shows, the steps it leaves and the spread. That a record not holding the level
bounds nothing, T6's invisible half, is not touched here.

What is not derived: which weighting an actual unfolding has, or that the course which happens is
typical (as in `Becoming.Typicality`); real weights, densities, logarithms, surprisal as a number,
free energy or its bound. Records are Boolean; graded evidence, a likelihood weighting multiplying a
weighting course by course, is the generative model's case only. The exit is stated for one level on
two values whose rises and falls cancel under the weights (each one raising it `q`, each zero
lowering it `p`, with weights `p` and `q`); a level with a drift, several values or steps that are
not independent are not treated. The representation commits to discrete steps and natural weights.
No ethical predicate, ranking or axiom occurs.
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
theorem entry_le (a : Bool) (n : Nat) : (if a = true then n else 0) ≤ n := by
  cases a
  · exact Nat.zero_le n
  · exact Nat.le_refl n

theorem entry_mul_left (a : Bool) (c n : Nat) :
    (if a = true then c * n else 0) = c * (if a = true then n else 0) := by
  cases a
  · exact (Nat.mul_zero c).symm
  · rfl

theorem entry_mul_right (a : Bool) (c n : Nat) :
    (if a = true then n * c else 0) = (if a = true then n else 0) * c := by
  cases a
  · exact (Nat.zero_mul c).symm
  · rfl

theorem entry_and_true (a : Bool) (n : Nat) :
    (if (a && true) = true then n else 0) = (if a = true then n else 0) := by
  cases a <;> rfl

theorem entry_and_comm (a b : Bool) (n : Nat) :
    (if (a && b) = true then n else 0) = (if (b && a) = true then n else 0) := by
  cases a <;> cases b <;> rfl

/-- A record keeps an entry an event keeps or drops it. -/
theorem entry_given_le (a b : Bool) (n : Nat) :
    (if a = true then (if b = true then n else 0) else 0) ≤ (if a = true then n else 0) := by
  cases a
  · exact Nat.le_refl 0
  · exact entry_le b n

end Entries

/-! ## The mass of an event, entry by entry -/

section Mass

variable {Ω : Type u}

/-- Masses whose entries agree agree. -/
theorem mass_congr {w w' : Ω → Nat} {e e' : Ω → Bool}
    (same : ∀ x, (if e x = true then w x else 0) = (if e' x = true then w' x else 0)) :
    ∀ l : List Ω, mass l w e = mass l w' e'
  | [] => rfl
  | x :: l => Naturals.add_congr (same x) (mass_congr same l)

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

/-- The mass on two lists joined is the two masses added. -/
theorem mass_append (w : Ω → Nat) (e : Ω → Bool) :
    ∀ l l' : List Ω, mass (l ++ l') w e = mass l w e + mass l' w e
  | [], _ => (Nat.zero_add _).symm
  | _ :: l, l' => (congrArg (_ + ·) (mass_append w e l l')).trans (Nat.add_assoc _ _ _).symm

/-- The mass on a mapped list reads the map. -/
theorem mass_map {β : Type v} (g : β → Ω) (w : Ω → Nat) (e : Ω → Bool) :
    ∀ l : List β, mass (l.map g) w e = mass l (fun b => w (g b)) (fun b => e (g b))
  | [] => rfl
  | _ :: l => congrArg (_ + ·) (mass_map g w e l)

/-- A weighting scaled at every entry scales the mass. -/
theorem mass_mul_left (c : Nat) (w : Ω → Nat) (e : Ω → Bool) :
    ∀ l : List Ω, mass l (fun x => c * w x) e = c * mass l w e
  | [] => (Nat.mul_zero c).symm
  | x :: l => (Naturals.add_congr (entry_mul_left (e x) c (w x)) (mass_mul_left c w e l)).trans
      (Nat.mul_add c _ _).symm

theorem mass_mul_right (c : Nat) (w : Ω → Nat) (e : Ω → Bool) :
    ∀ l : List Ω, mass l (fun x => w x * c) e = mass l w e * c
  | [] => (Nat.zero_mul c).symm
  | x :: l => (Naturals.add_congr (entry_mul_right (e x) c (w x)) (mass_mul_right c w e l)).trans
      (add_mul_split _ _ c).symm

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

section Given

variable {Ω : Type u}

/-- **The weighting given a record**: a course agreeing with the record keeps its weight, every
other course weighs nothing. -/
def given (record : Ω → Bool) (weight : Ω → Nat) (x : Ω) : Nat :=
  if record x = true then weight x else 0

/-- **Conditioning is restriction.** Under the weighting given a record, an event weighs what the
courses meeting both the event and the record weigh. -/
theorem mass_given (r : Ω → Bool) (w : Ω → Nat) (e : Ω → Bool) (l : List Ω) :
    mass l (given r w) e = mass l w (fun x => e x && r x) :=
  mass_congr (fun x => entry_and (e x) (r x) (w x)) l

/-- **The weight of the courses agreeing with a record** is the whole of the weighting given it. -/
theorem whole_given (r : Ω → Bool) (w : Ω → Nat) (l : List Ω) :
    mass l (given r w) (fun _ => true) = mass l w r :=
  mass_given r w (fun _ => true) l

/-- **The law of total weight.** An event weighs what its courses agreeing with a record weigh with
what its courses disagreeing with it weigh. -/
theorem mass_split (r : Ω → Bool) (w : Ω → Nat) (e : Ω → Bool) :
    ∀ l : List Ω, mass l w e = mass l w (fun x => e x && r x) + mass l w (fun x => e x && !r x)
  | [] => rfl
  | x :: l => (congrArg (_ + ·) (mass_split r w e l)).trans
      ((congrArg (· + _) (entry_split (e x) (r x) (w x)).symm).trans
        (Nat.add_add_add_comm _ _ _ _))

/-- **A record raises no course's weight.** -/
theorem given_le (r : Ω → Bool) (w : Ω → Nat) (x : Ω) : given r w x ≤ w x :=
  entry_le (r x) (w x)

/-- **A record raises no mass.** -/
theorem mass_given_le (r : Ω → Bool) (w : Ω → Nat) (e : Ω → Bool) (l : List Ω) :
    mass l (given r w) e ≤ mass l w e :=
  mass_le_of_entries (fun x => entry_given_le (e x) (r x) (w x)) l

/-- **Two records in turn are their conjunction.** -/
theorem given_given (r₁ r₂ : Ω → Bool) (w : Ω → Nat) (x : Ω) :
    given r₂ (given r₁ w) x = given (fun y => r₁ y && r₂ y) w x :=
  (entry_swap (r₁ x) (r₂ x) (w x)).trans (entry_and (r₁ x) (r₂ x) (w x))

/-- **Records commute**: taken in either order they give one weighting. -/
theorem given_comm (r₁ r₂ : Ω → Bool) (w : Ω → Nat) (x : Ω) :
    given r₂ (given r₁ w) x = given r₁ (given r₂ w) x :=
  entry_swap (r₁ x) (r₂ x) (w x)

end Given

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

/-- The whole over the part. Read through a logarithm, it is the share's surprisal. -/
def reciprocal (a : Share) : Share := ⟨a.whole, a.part⟩

theorem le_refl (a : Share) : a.le a := Nat.le_refl _

/-- The order of shares is transitive through a share with a positive whole. -/
theorem le_trans {a b c : Share} (pos : 0 < b.whole) (ab : a.le b) (bc : b.le c) : a.le c :=
  Nat.le_of_mul_le_mul_right
    (calc a.part * c.whole * b.whole
        = a.part * b.whole * c.whole := Naturals.mul_right_comm _ _ _
      _ ≤ b.part * a.whole * c.whole := Nat.mul_le_mul_right _ ab
      _ = b.part * c.whole * a.whole := Naturals.mul_right_comm _ _ _
      _ ≤ c.part * b.whole * a.whole := Nat.mul_le_mul_right _ bc
      _ = c.part * a.whole * b.whole := Naturals.mul_right_comm _ _ _) pos

/-- **Less share is more surprise.** One share is at most another exactly where the other's
reciprocal is at most its reciprocal. -/
theorem le_iff_reciprocal (a b : Share) : a.le b ↔ b.reciprocal.le a.reciprocal :=
  ⟨fun le => show b.whole * a.part ≤ a.whole * b.part by
      rw [Nat.mul_comm b.whole, Nat.mul_comm a.whole]; exact le,
   fun le => show a.part * b.whole ≤ b.part * a.whole by
      rw [Nat.mul_comm a.part, Nat.mul_comm b.part]; exact le⟩

/-- **Where surprisal adds, the reciprocal multiplies**: the reciprocal of two shares taken
together is their reciprocals taken together. -/
theorem reciprocal_mul (a b : Share) : (a.mul b).reciprocal = a.reciprocal.mul b.reciprocal := rfl

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

/-- **Bayes's rule in counting form.** A hypothesis's share under the weighting given a record,
taken with the record's share, is the record's share under the weighting given the hypothesis,
taken with the hypothesis's share, as ratios, with no condition: both count the courses meeting
the hypothesis and the record. -/
theorem joint_two_ways (l : List Ω) (w : Ω → Nat) (h r : Ω → Bool) :
    ((share l (given r w) h).mul (share l w r)).Same ((share l (given h w) r).mul (share l w h)) := by
  show mass l (given r w) h * mass l w r * (mass l (given h w) (fun _ => true) *
      mass l w (fun _ => true)) =
    mass l (given h w) r * mass l w h * (mass l (given r w) (fun _ => true) *
      mass l w (fun _ => true))
  rw [mass_given r w h l, mass_given h w r l, whole_given h w l, whole_given r w l,
    mass_and_comm l w r h]
  exact Naturals.mul_mul_mul_comm _ _ _ _

/-- **The weight of the courses meeting a hypothesis and a record is the record's weight times the
hypothesis's share given the record**, cross-multiplied: no division. -/
theorem joint_eq_record_times_given (l : List Ω) (w : Ω → Nat) (h r : Ω → Bool) :
    mass l w (fun x => h x && r x) * (share l (given r w) h).whole =
      mass l w r * (share l (given r w) h).part :=
  show mass l w (fun x => h x && r x) * mass l (given r w) (fun _ => true) =
    mass l w r * mass l (given r w) h by
  rw [whole_given r w l, mass_given r w h l]
  exact Nat.mul_comm _ _

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

/-- What an event of the first part weighs on the pairs. -/
theorem mass_first (w₁ : α → Nat) (w₂ : β → Nat) (e₁ : α → Bool) (as : List α) (bs : List β) :
    mass (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1) =
      mass as w₁ e₁ * mass bs w₂ (fun _ => true) :=
  (mass_and_true (openSteps as bs) (fun c : α × β => w₁ c.1 * w₂ c.2)
      (fun c : α × β => e₁ c.1)).symm.trans
    (mass_product w₁ w₂ e₁ (fun _ => true) as bs)

/-- **A record of one independent part leaves the other's share as it was**: the share of an event
of the first part, under the weighting given a record of the second, is its share, as ratios. -/
theorem given_independent (w₁ : α → Nat) (w₂ : β → Nat) (e₁ : α → Bool) (r : β → Bool)
    (as : List α) (bs : List β) :
    (share (openSteps as bs) (given (fun c => r c.2) fun c => w₁ c.1 * w₂ c.2)
        (fun c => e₁ c.1)).Same
      (share (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1)) := by
  have meets : mass (openSteps as bs) (given (fun c : α × β => r c.2) fun c => w₁ c.1 * w₂ c.2)
      (fun c => e₁ c.1) = mass as w₁ e₁ * mass bs w₂ r :=
    (mass_given _ _ _ _).trans (mass_product w₁ w₂ e₁ r as bs)
  have agrees : mass (openSteps as bs) (given (fun c : α × β => r c.2) fun c => w₁ c.1 * w₂ c.2)
      (fun _ => true) = mass as w₁ (fun _ => true) * mass bs w₂ r :=
    (whole_given _ _ _).trans (mass_product w₁ w₂ (fun _ => true) r as bs)
  have whole : mass (openSteps as bs) (fun c : α × β => w₁ c.1 * w₂ c.2) (fun _ => true) =
      mass as w₁ (fun _ => true) * mass bs w₂ (fun _ => true) :=
    mass_product w₁ w₂ (fun _ => true) (fun _ => true) as bs
  show mass (openSteps as bs) (given (fun c => r c.2) fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1) *
      mass (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun _ => true) =
    mass (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1) *
      mass (openSteps as bs) (given (fun c => r c.2) fun c => w₁ c.1 * w₂ c.2) (fun _ => true)
  rw [meets, agrees, whole, mass_first]
  exact (Naturals.mul_mul_mul_comm _ _ _ _).trans
    ((congrArg (mass as w₁ e₁ * mass as w₁ (fun _ => true) * ·)
      (Nat.mul_comm (mass bs w₂ r) (mass bs w₂ (fun _ => true)))).trans
      (Naturals.mul_mul_mul_comm _ _ _ _).symm)

/-- The courses of a generative model are its pairs of a listed hypothesis and a listed record;
**the weight of a course** is the hypothesis's weight times the record's weight under it. -/
def joint (prior : α → Nat) (lik : α → β → Nat) (c : α × β) : Nat := prior c.1 * lik c.1 c.2

/-- **The joint weight factors.** In a generative model, the courses whose hypothesis meets `hyp`
and whose record meets `rec` weigh, for each hypothesis meeting `hyp`, its weight times the weight
of the records meeting `rec` under it. -/
theorem mass_joint (prior : α → Nat) (lik : α → β → Nat) (hs : List α) (os : List β)
    (hyp : α → Bool) (rec : β → Bool) :
    mass (openSteps hs os) (joint prior lik) (fun c => hyp c.1 && rec c.2) =
      mass hs (fun h => prior h * mass os (lik h) rec) hyp :=
  mass_pairs prior lik hyp rec os hs

/-- **The weight of the courses agreeing with a record is the sum, over the hypotheses, of each
one's weight times the record's weight under it.** -/
theorem evidence (prior : α → Nat) (lik : α → β → Nat) (hs : List α) (os : List β)
    (rec : β → Bool) :
    mass (openSteps hs os) (joint prior lik) (fun c => rec c.2) =
      mass hs (fun h => prior h * mass os (lik h) rec) (fun _ => true) :=
  mass_joint prior lik hs os (fun _ => true) rec

/-- **Two classes of hypotheses compare after a record as their weights times the record's weights
under them.** With the record's weight positive, the share of the first under the weighting given
the record is at most the second's exactly where the first's weights times the record's weights,
summed, are at most the second's. -/
theorem posterior_le_iff (prior : α → Nat) (lik : α → β → Nat) (hs : List α) (os : List β)
    (rec : β → Bool) (hyp₁ hyp₂ : α → Bool)
    (positive : 0 < mass (openSteps hs os) (joint prior lik) (fun c => rec c.2)) :
    (share (openSteps hs os) (given (fun c => rec c.2) (joint prior lik)) (fun c => hyp₁ c.1)).le
        (share (openSteps hs os) (given (fun c => rec c.2) (joint prior lik)) (fun c => hyp₂ c.1)) ↔
      mass hs (fun h => prior h * mass os (lik h) rec) hyp₁ ≤
        mass hs (fun h => prior h * mass os (lik h) rec) hyp₂ := by
  show mass (openSteps hs os) (given (fun c => rec c.2) (joint prior lik)) (fun c => hyp₁ c.1) *
      mass (openSteps hs os) (given (fun c => rec c.2) (joint prior lik)) (fun _ => true) ≤
    mass (openSteps hs os) (given (fun c => rec c.2) (joint prior lik)) (fun c => hyp₂ c.1) *
      mass (openSteps hs os) (given (fun c => rec c.2) (joint prior lik)) (fun _ => true) ↔ _
  rw [whole_given, mass_given, mass_given, mass_joint, mass_joint]
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

/-- **Bayes's rule as the weight of the courses agreeing with a record.** In a generative model, a
hypothesis listed once has, under the weighting given a record, the share whose part is its weight
times the record's weight under it and whose whole is that product summed over the hypotheses. -/
theorem posterior_single [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₀ : α} (mem : h₀ ∈ hs) :
    share (openSteps hs os) (given (fun c => rec c.2) (joint prior lik))
        (fun c => decide (c.1 = h₀)) =
      ⟨prior h₀ * mass os (lik h₀) rec,
        mass hs (fun h => prior h * mass os (lik h) rec) (fun _ => true)⟩ :=
  congr (congrArg Share.mk ((mass_given _ _ _ _).trans
      ((mass_joint prior lik hs os (fun h => decide (h = h₀)) rec).trans
        (mass_single (fun h => prior h * mass os (lik h) rec) h₀ distinct mem))))
    ((whole_given _ _ _).trans (evidence prior lik hs os rec))

/-- **Two hypotheses compare after a record as prior weights times likelihood weights.** Each
listed once, with the record's weight positive, the first's share given the record is at most the
second's exactly where the first's weight times the record's weight under it is at most the
second's. -/
theorem posterior_le_iff_single [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₁ h₂ : α}
    (mem₁ : h₁ ∈ hs) (mem₂ : h₂ ∈ hs)
    (positive : 0 < mass (openSteps hs os) (joint prior lik) (fun c => rec c.2)) :
    (share (openSteps hs os) (given (fun c => rec c.2) (joint prior lik))
        (fun c => decide (c.1 = h₁))).le
      (share (openSteps hs os) (given (fun c => rec c.2) (joint prior lik))
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

/-- The mass over a joined listing is the sum of the masses over its parts. -/
theorem mass_joinMap {α : Type u} {β : Type v} (g : α → List β) (w : β → Nat) (e : β → Bool) :
    ∀ l : List α, mass (joinMap g l) w e = mass l (fun a => mass (g a) w e) (fun _ => true)
  | [] => rfl
  | a :: l => (mass_append w e (g a) (joinMap g l)).trans (congrArg (_ + ·) (mass_joinMap g w e l))

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
steps, is the product of their shares**, as pairs of naturals. So what surprisal adds over the
steps, the shares multiply, and the reciprocals multiply (`Share.reciprocal_mul`). -/
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

/-- **The deviation of a course reaches `m`**, either way: with `x = q·a` and `y = p·b` for `a`
ones and `b` zeros, `x + m ≤ y` or `y + m ≤ x`. -/
def deviates (p q m : Nat) (w : List Bool) : Bool :=
  decide (ahead q w + m ≤ behind p w) || decide (behind p w + m ≤ ahead q w)

/-- **A level standing `m` above a need falls to it.** Raised `q` by each one and lowered `p` by
each zero, so that weighed by `p` and `q` its rises and falls balance (`rises_balance_falls`), the
level ends the course at the need or below it: `x + m ≤ y`. -/
def fallsTo (p q m : Nat) (w : List Bool) : Bool := decide (ahead q w + m ≤ behind p w)

theorem rises_step (p q : Nat) (w : List Bool) :
    weight p q (true :: w) * ahead q (true :: w) + weight p q (false :: w) * ahead q (false :: w) =
      (p + q) * (weight p q w * ahead q w) + weight p q w * (p * q) := by
  show p * weight p q w * (ahead q w + q) + q * weight p q w * ahead q w = _
  rw [split p (weight p q w) (ahead q w) q, mul_assoc_nat q (weight p q w) (ahead q w),
    add_mul_split p q (weight p q w * ahead q w), Nat.add_right_comm]

theorem falls_step (p q : Nat) (w : List Bool) :
    weight p q (true :: w) * behind p (true :: w) + weight p q (false :: w) * behind p (false :: w) =
      (p + q) * (weight p q w * behind p w) + weight p q w * (p * q) := by
  show p * weight p q w * behind p w + q * weight p q w * (behind p w + p) = _
  rw [split q (weight p q w) (behind p w) p, mul_assoc_nat p (weight p q w) (behind p w),
    add_mul_split p q (weight p q w * behind p w), Nat.mul_comm q p, ← Nat.add_assoc]

/-- **The level's rises balance its falls.** Over the courses of `n` steps, each weighted, the rises
`x = q·a` add up to what the falls `y = p·b` add up to: each step adds `p·q` times the weight to
both. -/
theorem rises_balance_falls (p q : Nat) : ∀ n,
    total (Typicality.courses n) (fun w => weight p q w * ahead q w) =
      total (Typicality.courses n) (fun w => weight p q w * behind p w)
  | 0 => rfl
  | n + 1 => by
    show total (Typicality.extend (Typicality.courses n)) (fun w => weight p q w * ahead q w) =
      total (Typicality.extend (Typicality.courses n)) (fun w => weight p q w * behind p w)
    rw [Typicality.total_extend, Typicality.total_extend, Typicality.total_congr (rises_step p q),
      Typicality.total_congr (falls_step p q), Typicality.total_add, Typicality.total_add,
      Typicality.total_mul, Typicality.total_mul, rises_balance_falls p q n]

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

/-- **The exit bound.** The courses of `n` steps whose deviation reaches `m` weigh, times `m·m`, at
most `n·p·q·(p + q)^n`, which is the weighted squared spread of all of them (`Typicality.spread`):
Chebyshev's bound (`Typicality.typical`) read at a margin. -/
theorem deviates_bound (p q m n : Nat) :
    mass (Typicality.courses n) (weight p q) (deviates p q m) * (m * m) ≤ n * (p * q * (p + q) ^ n) :=
  Nat.le_trans
    (Nat.mul_le_mul_right _
      (Nat.le_trans (Nat.le_of_eq (mass_eq_total (weight p q) (deviates p q m) (Typicality.courses n)))
        (Typicality.total_le (deviates_offBy p q m) (Typicality.courses n))))
    (typical p q n (m * m))

/-- **A level standing `m` above a need falls to it at some step**: at some step of the course,
its start included, `x + m ≤ y`. -/
def fallsWithin (p q m : Nat) : List Bool → Bool
  | [] => decide (ahead q [] + m ≤ behind p [])
  | b :: w => fallsWithin p q m w || decide (ahead q (b :: w) + m ≤ behind p (b :: w))

/-- A level that ends the course at the need or below has fallen to it at some step. -/
theorem fallsWithin_of_end {p q m : Nat} :
    ∀ {w : List Bool}, fallsTo p q m w = true → fallsWithin p q m w = true
  | [], falls => falls
  | _ :: w, falls => ListTests.or_right (fallsWithin p q m w) falls

/-- A course in which the level falls to the need at some step reaches the squared deviation
`m·m` at that step. -/
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
above a need falls to it at some step weigh, times `m·m`, at most `n·p·q·(p + q)^n`: the spread
over the margin squared, through Kolmogorov's maximal inequality (`typical_throughout`). -/
theorem fallsWithin_bound (p q m n : Nat) :
    mass (Typicality.courses n) (weight p q) (fallsWithin p q m) * (m * m) ≤
      n * (p * q * (p + q) ^ n) :=
  Nat.le_trans
    (Nat.mul_le_mul_right _
      (Nat.le_trans
        (Nat.le_of_eq (mass_eq_total (weight p q) (fallsWithin p q m) (Typicality.courses n)))
        (Typicality.total_le (fallsWithin_entry p q m) (Typicality.courses n))))
    (typical_throughout p q n (m * m))

/-- **The courses in which the level ends at the need or below weigh, times `m·m`, at most the
spread**: the corollary at the horizon. -/
theorem fallsTo_bound (p q m n : Nat) :
    mass (Typicality.courses n) (weight p q) (fallsTo p q m) * (m * m) ≤
      n * (p * q * (p + q) ^ n) :=
  Nat.le_trans
    (Nat.mul_le_mul_right _ (mass_mono (weight p q) (fun _ _ falls => fallsWithin_of_end falls)))
    (fallsWithin_bound p q m n)

/-- **The share of the courses in which the level falls to the need within the horizon is at most
`n·p·q` over `m·m`.** -/
theorem fallsWithin_share (p q m n : Nat) :
    (share (Typicality.courses n) (weight p q) (fallsWithin p q m)).le ⟨n * (p * q), m * m⟩ :=
  show mass (Typicality.courses n) (weight p q) (fallsWithin p q m) * (m * m) ≤
      n * (p * q) * mass (Typicality.courses n) (weight p q) (fun _ => true) by
  rw [whole_typical, mul_assoc_nat]
  exact fallsWithin_bound p q m n

/-- **Falling to the need is at least as surprising as the margin squared over the spread**: the
reciprocal of the share of the courses in which the level falls to the need within the horizon is
at least `m·m` over `n·p·q`. -/
theorem fallsWithin_reciprocal (p q m n : Nat) :
    (Share.reciprocal ⟨n * (p * q), m * m⟩).le
      (share (Typicality.courses n) (weight p q) (fallsWithin p q m)).reciprocal :=
  (Share.le_iff_reciprocal _ _).mp (fallsWithin_share p q m n)

end Exit

/-! ## What a record of the course so far says of the exit -/

section Record

open Typicality

/-- Masses whose entries agree on the listed members agree. -/
theorem mass_congr_mem {Ω : Type u} {w w' : Ω → Nat} {e e' : Ω → Bool} :
    ∀ {l : List Ω}, (∀ x, x ∈ l → (if e x = true then w x else 0) = (if e' x = true then w' x else 0)) →
      mass l w e = mass l w' e'
  | [], _ => rfl
  | x :: _, same => Naturals.add_congr (same x (.head _))
      (mass_congr_mem fun y mem => same y (.tail x mem))

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
above the need, a level that started `m` above it falls to it after the record exactly where,
counted from the record, it falls `m'`. -/
theorem margin_shift {xv yv xu yu m m' : Nat} (shows : m + xu = m' + yu) :
    xv + xu + m ≤ yv + yu ↔ xv + m' ≤ yv :=
  have same : xv + xu + m = xv + m' + yu := by
    rw [Nat.add_assoc, Nat.add_comm xu m, shows, ← Nat.add_assoc]
  ⟨fun le => le_of_add_le_add_right yu (Nat.le_trans (Nat.le_of_eq same.symm) le),
   fun le => Nat.le_trans (Nat.le_of_eq same) (Nat.add_le_add_right le yu)⟩

/-- **After a record showing the margin `m'`, the level ends at the need or below exactly where,
counted from the record with the margin `m'`, it does.** -/
theorem fallsTo_append (p q m m' : Nat) {u : List Bool} (shows : m + ahead q u = m' + behind p u)
    (v : List Bool) : fallsTo p q m (v ++ u) = fallsTo p q m' v :=
  bool_eq_of_iff (ListTests.decide_true_iff.trans
    ((show ahead q (v ++ u) + m ≤ behind p (v ++ u) ↔ ahead q v + ahead q u + m ≤ behind p v + behind p u by
      rw [show ahead q (v ++ u) = ahead q v + ahead q u from
          (congrArg (q * ·) (ones_append u v)).trans (Nat.mul_add _ _ _),
        show behind p (v ++ u) = behind p v + behind p u from
          (congrArg (p * ·) (zeros_append u v)).trans (Nat.mul_add _ _ _)]).trans
      ((margin_shift shows).trans ListTests.decide_true_iff.symm)))

/-- **A fall after a record is a fall in the record or a fall from the margin it shows.** -/
theorem fallsWithin_append (p q m m' : Nat) {u : List Bool} (shows : m + ahead q u = m' + behind p u) :
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

/-- **The courses agreeing with a record factor.** For a record `R` of the earliest `k` steps and
an event `E` that every course agreeing with the record meets exactly where its `n` later steps
meet `F`, the courses of `k + n` steps agreeing with the record and meeting `E` weigh what the
record weighs times what `F` weighs over the courses of `n` steps. -/
theorem mass_record (p q k n : Nat) (R E F : List Bool → Bool)
    (carries : ∀ u v : List Bool, R u = true → v.length = n → E (v ++ u) = F v) :
    mass (Typicality.courses (k + n)) (weight p q) (fun w => R (w.drop n) && E w) =
      mass (Typicality.courses k) (weight p q) R * mass (Typicality.courses n) (weight p q) F := by
  rw [courses_add k n, mass_joinMap]
  refine (mass_congr (e := fun _ => true) (e' := R)
      (w' := fun u => weight p q u * mass (Typicality.courses n) (weight p q) F)
      (fun u => ?_) (Typicality.courses k)).trans
    (mass_mul_right _ (weight p q) R (Typicality.courses k))
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
    refine (mass_congr_mem (w' := fun v => weight p q v * weight p q u) (e' := F) fun v mem => ?_).trans
      ((mass_mul_right _ (weight p q) F (Typicality.courses n)).trans (Nat.mul_comm _ _))
    have len : v.length = n := Typicality.mem_courses_iff.mp mem
    show (if (R ((v ++ u).drop n) && E (v ++ u)) = true then weight p q (v ++ u) else 0) =
      (if F v = true then weight p q v * weight p q u else 0)
    rw [show (v ++ u).drop n = u from len ▸ drop_append_length v u, hR, carries u v hR len,
      weight_append]
    rfl

/-- **What a record says of a break within the horizon is the margin it shows.** For a record of
the earliest `k` steps every course agreeing with which leaves the level `m'` above the need
(`m + x = m' + y` there) without having fallen to it, the courses of `k + n` steps agreeing with
the record in which the level falls to the need at some step weigh what the record weighs times
what the courses of the `n` steps left in which it falls from `m'` weigh. -/
theorem record_fallsWithin (p q m m' k n : Nat) (R : List Bool → Bool)
    (shows : ∀ u, R u = true → m + ahead q u = m' + behind p u ∧ fallsWithin p q m u = false) :
    mass (Typicality.courses (k + n)) (weight p q) (fun w => R (w.drop n) && fallsWithin p q m w) =
      mass (Typicality.courses k) (weight p q) R *
        mass (Typicality.courses n) (weight p q) (fallsWithin p q m') :=
  mass_record p q k n R (fallsWithin p q m) (fallsWithin p q m') fun u v agrees _ =>
    (fallsWithin_append p q m m' (shows u agrees).1 v).trans
      (congrArg (· || fallsWithin p q m' v) (shows u agrees).2)

/-- **Given the record, the share of the courses that break within the horizon is their share from
the margin the record shows, over the steps left**, as ratios. -/
theorem record_share (p q m m' k n : Nat) (R : List Bool → Bool)
    (shows : ∀ u, R u = true → m + ahead q u = m' + behind p u ∧ fallsWithin p q m u = false) :
    (share (Typicality.courses (k + n)) (given (fun w => R (w.drop n)) (weight p q))
        (fallsWithin p q m)).Same
      (share (Typicality.courses n) (weight p q) (fallsWithin p q m')) := by
  have part : mass (Typicality.courses (k + n)) (given (fun w => R (w.drop n)) (weight p q))
      (fallsWithin p q m) = mass (Typicality.courses k) (weight p q) R *
        mass (Typicality.courses n) (weight p q) (fallsWithin p q m') :=
    (mass_given _ _ _ _).trans ((mass_and_comm _ _ _ _).trans (record_fallsWithin p q m m' k n R shows))
  have whole : mass (Typicality.courses (k + n)) (given (fun w => R (w.drop n)) (weight p q))
      (fun _ => true) = mass (Typicality.courses k) (weight p q) R *
        mass (Typicality.courses n) (weight p q) (fun _ => true) :=
    (whole_given _ _ _).trans ((mass_and_true _ _ _).symm.trans
      (mass_record p q k n R (fun _ => true) (fun _ => true) fun _ _ _ _ => rfl))
  show mass (Typicality.courses (k + n)) (given (fun w => R (w.drop n)) (weight p q))
      (fallsWithin p q m) * mass (Typicality.courses n) (weight p q) (fun _ => true) =
    mass (Typicality.courses n) (weight p q) (fallsWithin p q m') *
      mass (Typicality.courses (k + n)) (given (fun w => R (w.drop n)) (weight p q)) (fun _ => true)
  rw [part, whole, mul_assoc_nat]
  exact mul_turn _ _ _

/-- **Given the record, the share of the courses that break within the `n` steps left is at most
`n·p·q` over `m'·m'`**: the spread left over the square of the margin the record shows. -/
theorem record_bound (p q m m' k n : Nat) (R : List Bool → Bool)
    (shows : ∀ u, R u = true → m + ahead q u = m' + behind p u ∧ fallsWithin p q m u = false) :
    (share (Typicality.courses (k + n)) (given (fun w => R (w.drop n)) (weight p q))
        (fallsWithin p q m)).le ⟨n * (p * q), m' * m'⟩ := by
  have part : mass (Typicality.courses (k + n)) (given (fun w => R (w.drop n)) (weight p q))
      (fallsWithin p q m) = mass (Typicality.courses k) (weight p q) R *
        mass (Typicality.courses n) (weight p q) (fallsWithin p q m') :=
    (mass_given _ _ _ _).trans ((mass_and_comm _ _ _ _).trans (record_fallsWithin p q m m' k n R shows))
  have whole : mass (Typicality.courses (k + n)) (given (fun w => R (w.drop n)) (weight p q))
      (fun _ => true) = mass (Typicality.courses k) (weight p q) R * (p + q) ^ n :=
    (whole_given _ _ _).trans ((mass_and_true _ _ _).symm.trans
      ((mass_record p q k n R (fun _ => true) (fun _ => true) fun _ _ _ _ => rfl).trans
        (congrArg (_ * ·) (whole_typical p q n))))
  show mass (Typicality.courses (k + n)) (given (fun w => R (w.drop n)) (weight p q))
      (fallsWithin p q m) * (m' * m') ≤
    n * (p * q) * mass (Typicality.courses (k + n)) (given (fun w => R (w.drop n)) (weight p q))
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

/-- **Counting the courses that fall at some step counts more than counting those that end
fallen.** With weights one and one, a level one above the need over two steps falls to it at some
step on two of the four courses and ends there on one: the course down then up recovers. -/
theorem within_exceeds_end :
    mass (Typicality.courses 2) (weight 1 1) (fallsTo 1 1 1) = 1 ∧
      mass (Typicality.courses 2) (weight 1 1) (fallsWithin 1 1 1) = 2 :=
  ⟨rfl, rfl⟩

/-- Two hypotheses weighing 3 and 1. -/
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

/-- **A record can turn the order of two hypotheses.** The first hypothesis's courses weigh 15 and
the second's 5; given the record `true` they weigh 3 and 5. -/
theorem record_reverses :
    mass (openSteps [false, true] [false, true]) (joint prior lik) (fun c => !c.1) = 15 ∧
      mass (openSteps [false, true] [false, true]) (joint prior lik) (fun c => c.1) = 5 ∧
      mass (openSteps [false, true] [false, true]) (given (fun c => c.2) (joint prior lik))
        (fun c => !c.1) = 3 ∧
      mass (openSteps [false, true] [false, true]) (given (fun c => c.2) (joint prior lik))
        (fun c => c.1) = 5 :=
  ⟨rfl, rfl, rfl, rfl⟩

end Witness

end ConditionalWeights

end Becoming
