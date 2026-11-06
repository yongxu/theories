import Becoming.Verification
import Becoming.Enough

/-!
# What a method comes to say in the limit

`Becoming.Verification` states what a finite stretch verifies (the open readings) and what it
refutes (the closed readings). Settling, a run's configuration not changing from some step on, and
recurrence, a move recurring from every step on, are neither: no finite record counts for or
against them. Here is the next level, convergence.

**Methods.** A method guesses, at each horizon of a run, yes or no (`Limit.Method`); it is fixed by
the record where its guess at `k` is the same on runs agreeing up to `k` (`Limit.ByRecord`). It
converges to a guess where from some horizon on it keeps that guess (`Limit.Converges`). A method
verifies a reading in the limit where the reading holds exactly on the runs on which it converges
to yes (`Limit.Verifies`); it refutes a reading in the limit where the reading holds exactly on the
runs on which its yes recurs (`Limit.Refutes`). Classically the second is converging to no exactly
off the reading; constructively, converging to no puts a run outside (`Refutes.outside_of_no`), and
the step back is the last law below. This is identification in the limit (Putnam 1965, Gold 1967),
in the form of Kelly 1996.

**Structure (no premise).** A reading a method fixed by the record verifies in the limit is the
union, over horizons, of the readings "from here on the guess is yes", each closed
(`yesFrom_closed`); a reading it refutes in the limit is the meet of readings "a yes comes at or
after here", each verifiable (`yesAfter_verifiable`). A reading of tests and the reading "some test
succeeds" are both verified and refuted in the limit, by "no test has failed so far" and "some test
has succeeded so far" (`noneFailed_verifies`, `noneFailed_refutes`, `someSucceeded_verifies`,
`someSucceeded_refutes`): the finite levels lie within the limit levels. The meet of two readings
verified in the limit is verified by the conjunction of the guesses (`both_verifies`); the meet of
two refuted in the limit is refuted by the joint guess, yes where each guess has said yes since the
last joint yes (`jointly_refutes`).

**Settling.** Where configurations are told apart, "the last step changed nothing" verifies
settling in the limit (`still_verifies`). On the process of two configurations with every step
allowed, settling and its complement are dense (`Free.settles_dense`, `Free.unsettled_dense`), so
settling is neither verifiable nor refutable (`Free.settles_not_verifiable`,
`Free.settles_not_refutable`), and under Markov's principle no method fixed by the record refutes
it in the limit (`Free.settles_not_refuted`): the run that changes where the method says yes and
stays where it says no defeats every method.

**Recurrence.** On the sequences of moves, "the last move was `true`" refutes recurrence in the limit
(`Sequences.lastMove_refutes`), and its negation verifies in the limit that from some step on every
move is `false` (`Sequences.notLastMove_verifies`); under Markov's principle no method fixed by the
record verifies recurrence in the limit (`Sequences.recurs_not_verified`): the run that plays the
negation of the guess defeats every method.

**Identification.** A guess of values tracks a target in the limit where on each run, from some
horizon on, it is the target's value at the horizon (`Tracks`); it identifies a hypothesis where it
tracks a target that does not change with the horizon (`Identifies`, `identifies_iff_tracks`), and
two targets the same guess tracks agree from some horizon on (`Tracks.agree`). A guess that
identifies the run's hypothesis verifies and refutes in the limit each reading "the hypothesis is
`v`" (`identifies_verifies`, `identifies_refutes`): identification in the limit decides each
hypothesis in the limit. Learning through a map (`Becoming.Learnable`, `Becoming.LearnableRuns`) is
the case of a guess fixed by the record through the map that tracks a feature along the run
(`LearnableRuns.learnable_iff_tracks`); it is identification where the feature does not change along
the run (`LearnableRuns.learnable_iff_identifies`), and not otherwise
(`LearnableRuns.Merge.not_identifies`).

**Calibrations.** Two steps need omniscience, asked of every Boolean sequence. Saying from a run's
not recurring that from some step on its moves are `false` gives the limited principle of
omniscience (`Sequences.eventuallyFalse_lpo`): to say where a run has stopped from its not going on
is to locate where it stopped. Saying which of two guesses recurs from their disjunction recurring
gives it too (`Sequences.either_recurs_lpo`).

So settling is what a method can come to say in the limit and never at a finite stretch, and that
a run changes again and again is what it cannot come to say even there. No ethical predicate,
ranking or axiom occurs.
-/

namespace Becoming

open Generative

universe u v w

namespace Limit

section Methods

variable {S : Type u} {A : Type v} {P : Process S A}

/-- A method: a guess, yes or no, at each horizon of each run. -/
abbrev Method (P : Process S A) := Nat → Run P → Bool

/-- A method is fixed by the record where its guess at `k` is the same on runs agreeing up to `k`. -/
def ByRecord (m : Method P) : Prop := ∀ k (r r' : Run P), r.AgreeUpTo k r' → m k r = m k r'

/-- The method keeps the guess `b` on `r` from some horizon on. -/
def Converges (m : Method P) (r : Run P) (b : Bool) : Prop := ∃ n, ∀ k, n ≤ k → m k r = b

/-- From `n` on the guess on `r` is yes. -/
def YesFrom (m : Method P) (n : Nat) (r : Run P) : Prop := ∀ k, n ≤ k → m k r = true

/-- A yes comes at or after `n` on `r`. -/
def YesAfter (m : Method P) (n : Nat) (r : Run P) : Prop := ∃ k, n ≤ k ∧ m k r = true

/-- The yes of the method recurs on `r`. -/
def YesRecurs (m : Method P) (r : Run P) : Prop := ∀ n, YesAfter m n r

/-- A method verifies a reading in the limit where the reading holds exactly on the runs on which it
converges to yes. -/
def Verifies (m : Method P) (K : Run P → Prop) : Prop := ∀ r, K r ↔ Converges m r true

/-- A method refutes a reading in the limit where the reading holds exactly on the runs on which its
yes recurs. -/
def Refutes (m : Method P) (K : Run P → Prop) : Prop := ∀ r, K r ↔ YesRecurs m r

/-- **A method converges to at most one guess.** -/
theorem converges_unique {m : Method P} {r : Run P} {b c : Bool} (to_b : Converges m r b)
    (to_c : Converges m r c) : b = c :=
  match to_b, to_c with
  | ⟨n, at_b⟩, ⟨n', at_c⟩ =>
    (at_b (n + n') (Nat.le_add_right n n')).symm.trans (at_c (n + n') (Nat.le_add_left n' n))

/-- **Converging to no, the yes does not recur.** -/
theorem not_recurs_of_no {m : Method P} {r : Run P} (no : Converges m r false) :
    ¬ YesRecurs m r :=
  fun recurs => match no, recurs with
  | ⟨n, at_no⟩, recurs => match recurs n with
    | ⟨k, le, yes⟩ => ListTests.bool_absurd yes (at_no k le)

/-- **A method verifying a reading in the limit and converging to no puts the run outside.** -/
theorem Verifies.outside_of_no {m : Method P} {K : Run P → Prop} (verifies : Verifies m K)
    {r : Run P} (no : Converges m r false) : ¬ K r :=
  fun inside => nomatch converges_unique ((verifies r).mp inside) no

/-- **A method refuting a reading in the limit and converging to no puts the run outside.** -/
theorem Refutes.outside_of_no {m : Method P} {K : Run P → Prop} (refutes : Refutes m K)
    {r : Run P} (no : Converges m r false) : ¬ K r :=
  fun inside => not_recurs_of_no no ((refutes r).mp inside)

/-! ## Structure -/

/-- **A reading verified in the limit is the union of the readings "from `n` on the guess is
yes".** -/
theorem verifies_iff_union {m : Method P} {K : Run P → Prop} (verifies : Verifies m K) (r : Run P) :
    K r ↔ ∃ n, YesFrom m n r :=
  verifies r

/-- **Each reading "from `n` on the guess is yes" is closed**: a run adhering to it is in it, for a
method fixed by the record. -/
theorem yesFrom_closed {m : Method P} (byRecord : ByRecord m) {n : Nat} {r : Run P}
    (adheres : Adheres (YesFrom m n) r) : YesFrom m n r :=
  fun k le => match adheres k with
  | ⟨r', yes, agree⟩ => (byRecord k r r' agree).trans (yes k le)

/-- **A reading refuted in the limit is the meet of the readings "a yes comes at or after `n`".** -/
theorem refutes_iff_meet {m : Method P} {K : Run P → Prop} (refutes : Refutes m K) (r : Run P) :
    K r ↔ ∀ n, YesAfter m n r :=
  refutes r

/-- **Each reading "a yes comes at or after `n`" is verifiable**, for a method fixed by the
record. -/
theorem yesAfter_verifiable {m : Method P} (byRecord : ByRecord m) (n : Nat) :
    Verifiable (YesAfter m n) :=
  fun r ⟨k, le, yes⟩ => ⟨k, fun r' agree => ⟨k, le, (byRecord k r r' agree).symm.trans yes⟩⟩

/-! ## The finite levels lie within the limit levels -/

theorem clear_of_below (s : Nat → Bool) : ∀ {k : Nat}, (∀ j, j < k → s j = false) →
    clear s k = true
  | 0, _ => rfl
  | k + 1, below =>
    bool_and_true (clear_of_below s fun j lt => below j (Nat.lt_succ_of_lt lt))
      (Eq.subst (motive := fun b => (!b) = true) (below k (Nat.lt_succ_self k)).symm rfl)

theorem and_congr2 {a a' b b' : Bool} (e : a = a') (e' : b = b') : (a && b) = (a' && b') := by
  rw [e, e']

theorem clear_congr {s s' : Nat → Bool} : ∀ {k : Nat}, (∀ j, j < k → s j = s' j) →
    clear s k = clear s' k
  | 0, _ => rfl
  | k + 1, same =>
    and_congr2 (clear_congr fun j lt => same j (Nat.lt_succ_of_lt lt))
      (congrArg not (same k (Nat.lt_succ_self k)))

theorem clear_false_of_true {s : Nat → Bool} {j k : Nat} (yes : s j = true) (lt : j < k) :
    clear s k = false :=
  Clear.false_of_not _ fun c => ListTests.bool_absurd yes (Clear.false_before s c lt)

theorem true_of_not_clear {s : Nat → Bool} {k : Nat} (no : clear s k = false) : ∃ j, s j = true :=
  match Clear.or_first s k with
  | .inl c => (ListTests.bool_absurd c no).elim
  | .inr ⟨j, _, _, yes⟩ => ⟨j, yes⟩

theorem eq_true_of_not_false : ∀ {b : Bool}, (!b) = false → b = true
  | true, _ => rfl
  | false, no => nomatch no

section Tests

variable {fails : Nat → Run P → Bool}

/-- The guess "no test has failed before `k`". -/
def noneFailed (fails : Nat → Run P → Bool) : Method P := fun k r => clear (fun j => fails j r) k

/-- **"No test has failed so far" is fixed by the record**, for tests fixed by prefixes. -/
theorem noneFailed_byRecord (byPrefixes : ByPrefixes fails) : ByRecord (noneFailed fails) :=
  fun _ r r' agree => clear_congr fun j lt => byPrefixes j r r' (agree.mono lt)

/-- **A reading of tests is verified in the limit by "no test has failed so far".** -/
theorem noneFailed_verifies : Verifies (noneFailed fails) (Passes fails) :=
  fun _ => ⟨fun passes => ⟨0, fun _ _ => clear_of_below _ fun j _ => passes j⟩,
    fun ⟨n, yes⟩ j => Clear.false_before _
      (yes (n + j + 1) (Nat.le_trans (Nat.le_add_right n j) (Nat.le_succ _)))
      (Nat.lt_succ_of_le (Nat.le_add_left j n))⟩

/-- **A reading of tests is refuted in the limit by "no test has failed so far".** -/
theorem noneFailed_refutes : Refutes (noneFailed fails) (Passes fails) :=
  fun _ => ⟨fun passes n => ⟨n, Nat.le_refl n, clear_of_below _ fun j _ => passes j⟩,
    fun recurs j => match recurs (j + 1) with
      | ⟨_, le, yes⟩ => Clear.false_before _ yes le⟩

end Tests

section Successes

variable {succeeds : Nat → Run P → Bool}

/-- Some test succeeds. -/
def Succeeds (succeeds : Nat → Run P → Bool) (r : Run P) : Prop := ∃ n, succeeds n r = true

/-- The guess "some test has succeeded before `k`". -/
def someSucceeded (succeeds : Nat → Run P → Bool) : Method P :=
  fun k r => !clear (fun j => succeeds j r) k

/-- **"Some test has succeeded so far" is fixed by the record**, for tests fixed by prefixes. -/
theorem someSucceeded_byRecord (byPrefixes : ByPrefixes succeeds) :
    ByRecord (someSucceeded succeeds) :=
  fun _ r r' agree => congrArg not (clear_congr fun j lt => byPrefixes j r r' (agree.mono lt))

theorem someSucceeded_of {r : Run P} {j k : Nat} (yes : succeeds j r = true) (lt : j < k) :
    someSucceeded succeeds k r = true :=
  ListTests.not_eq_true_of_false (clear_false_of_true (s := fun j => succeeds j r) yes lt)

theorem succeeds_of_some {r : Run P} {k : Nat} (yes : someSucceeded succeeds k r = true) :
    Succeeds succeeds r :=
  true_of_not_clear (ListTests.false_of_not yes)

/-- **"Some test succeeds" is verified in the limit by "some test has succeeded so far".** -/
theorem someSucceeded_verifies : Verifies (someSucceeded succeeds) (Succeeds succeeds) :=
  fun _ => ⟨fun ⟨j, yes⟩ => ⟨j + 1, fun _ le => someSucceeded_of yes le⟩,
    fun ⟨n, yes⟩ => succeeds_of_some (yes n (Nat.le_refl n))⟩

/-- **"Some test succeeds" is refuted in the limit by "some test has succeeded so far".** -/
theorem someSucceeded_refutes : Refutes (someSucceeded succeeds) (Succeeds succeeds) :=
  fun _ => ⟨fun ⟨j, yes⟩ n => ⟨n + j + 1, Nat.le_trans (Nat.le_add_right n j) (Nat.le_succ _),
      someSucceeded_of yes (Nat.lt_succ_of_le (Nat.le_add_left j n))⟩,
    fun recurs => match recurs 0 with
      | ⟨_, _, yes⟩ => succeeds_of_some yes⟩

end Successes

/-! ## Meets -/

/-- The conjunction of two guesses. -/
def both (m m' : Method P) : Method P := fun k r => m k r && m' k r

/-- **The conjunction of guesses fixed by the record is fixed by the record.** -/
theorem both_byRecord {m m' : Method P} (byRecord : ByRecord m) (byRecord' : ByRecord m') :
    ByRecord (both m m') :=
  fun k r r' agree => and_congr2 (byRecord k r r' agree) (byRecord' k r r' agree)

/-- **The meet of two readings verified in the limit is verified in the limit by the conjunction
of the guesses.** -/
theorem both_verifies {m m' : Method P} {K K' : Run P → Prop} (verifies : Verifies m K)
    (verifies' : Verifies m' K') : Verifies (both m m') fun r => K r ∧ K' r :=
  fun r => ⟨fun ⟨inside, inside'⟩ => match (verifies r).mp inside, (verifies' r).mp inside' with
      | ⟨n, yes⟩, ⟨n', yes'⟩ => ⟨n + n', fun k le => bool_and_true
          (yes k (Nat.le_trans (Nat.le_add_right n n') le))
          (yes' k (Nat.le_trans (Nat.le_add_left n' n) le))⟩,
    fun ⟨n, yes⟩ => ⟨(verifies r).mpr ⟨n, fun k le => ListTests.and_left (yes k le)⟩,
      (verifies' r).mpr ⟨n, fun k le => ListTests.and_right (yes k le)⟩⟩⟩

/-- Each guess has said yes since the last joint yes: the pending marks and the guesses now. -/
def joint (p : Bool × Bool) (a b : Bool) : Bool := (p.1 || a) && (p.2 || b)

/-- The marks after a step: cleared at a joint yes, else carried with the guesses now. -/
def mark (p : Bool × Bool) (a b : Bool) : Bool × Bool :=
  (!joint p a b && (p.1 || a), !joint p a b && (p.2 || b))

/-- What each of two guesses has said since their last joint yes, before the guesses at `k`. -/
def pending (m m' : Method P) : Nat → Run P → Bool × Bool
  | 0, _ => (false, false)
  | k + 1, r => mark (pending m m' k r) (m k r) (m' k r)

/-- The joint guess: yes where each guess has said yes since the last joint yes. -/
def jointly (m m' : Method P) : Method P := fun k r => joint (pending m m' k r) (m k r) (m' k r)

theorem mark_cleared {p : Bool × Bool} {a b : Bool} (yes : joint p a b = true) :
    (mark p a b).1 = false ∧ (mark p a b).2 = false :=
  show ((!joint p a b) && (p.1 || a)) = false ∧ ((!joint p a b) && (p.2 || b)) = false by
    rw [yes]; exact ⟨rfl, rfl⟩

theorem mark_carried {p : Bool × Bool} {a b : Bool} (no : joint p a b = false) :
    (mark p a b).1 = (p.1 || a) ∧ (mark p a b).2 = (p.2 || b) :=
  show ((!joint p a b) && (p.1 || a)) = (p.1 || a) ∧ ((!joint p a b) && (p.2 || b)) = (p.2 || b) by
    rw [no]; exact ⟨rfl, rfl⟩

/-- **The joint guess of guesses fixed by the record is fixed by the record.** -/
theorem pending_byRecord {m m' : Method P} (byRecord : ByRecord m) (byRecord' : ByRecord m') :
    ∀ k (r r' : Run P), r.AgreeUpTo k r' → pending m m' k r = pending m m' k r'
  | 0, _, _, _ => rfl
  | k + 1, r, r', agree =>
    have before := agree.mono (Nat.le_succ k)
    show mark (pending m m' k r) (m k r) (m' k r) = mark (pending m m' k r') (m k r') (m' k r') by
      rw [pending_byRecord byRecord byRecord' k r r' before, byRecord k r r' before,
        byRecord' k r r' before]

theorem jointly_byRecord {m m' : Method P} (byRecord : ByRecord m) (byRecord' : ByRecord m') :
    ByRecord (jointly m m') :=
  fun k r r' agree =>
    show joint (pending m m' k r) (m k r) (m' k r) = joint (pending m m' k r') (m k r') (m' k r') by
      rw [pending_byRecord byRecord byRecord' k r r' agree, byRecord k r r' agree,
        byRecord' k r r' agree]

/-- A mark set at `c + d`, with none at `c`, goes back to a yes of its guess at or after `c`. -/
theorem mark_origin {p g : Nat → Bool} {c : Nat} (origin : ∀ k, p (k + 1) = true → (p k || g k) = true)
    (cleared : p c = false) : ∀ d, (p (c + d) || g (c + d)) = true → ∃ j, c ≤ j ∧ g j = true
  | d, said => match ListTests.or_cases said with
    | .inr yes => ⟨c + d, Nat.le_add_right c d, yes⟩
    | .inl marked => match d with
      | 0 => (ListTests.bool_absurd marked cleared).elim
      | d + 1 => mark_origin origin cleared d (origin (c + d) marked)

/-- A yes of a guess at `a`, with no joint yes from `a` before `a + d`, is still marked at `a + d`. -/
theorem mark_kept {p g J : Nat → Bool} {a : Nat}
    (carry : ∀ k, J k = false → p (k + 1) = (p k || g k)) (yes : g a = true) :
    ∀ d, (∀ k, a ≤ k → k < a + d → J k = false) → (p (a + d) || g (a + d)) = true
  | 0, _ => ListTests.or_right _ yes
  | d + 1, none_ => ListTests.or_left _ ((carry (a + d) (none_ (a + d) (Nat.le_add_right a d)
      (Nat.lt_succ_self _))).trans
      (mark_kept carry yes d fun k le lt => none_ k le (Nat.lt_succ_of_lt lt)))

/-- **The meet of two readings refuted in the limit is refuted in the limit by the joint guess**: yes
where each guess has said yes since the last joint yes. The joint yes recurs exactly where both
yeses recur. -/
theorem jointly_refutes {m m' : Method P} {K K' : Run P → Prop} (refutes : Refutes m K)
    (refutes' : Refutes m' K') : Refutes (jointly m m') fun r => K r ∧ K' r :=
  fun r =>
    let J := fun k => jointly m m' k r
    have origin₁ : ∀ k, (pending m m' (k + 1) r).1 = true →
        ((pending m m' k r).1 || m k r) = true := fun _ marked => ListTests.and_right marked
    have origin₂ : ∀ k, (pending m m' (k + 1) r).2 = true →
        ((pending m m' k r).2 || m' k r) = true := fun _ marked => ListTests.and_right marked
    have carry₁ : ∀ k, J k = false → (pending m m' (k + 1) r).1 = ((pending m m' k r).1 || m k r) :=
      fun _ no => (mark_carried no).1
    have carry₂ : ∀ k, J k = false →
        (pending m m' (k + 1) r).2 = ((pending m m' k r).2 || m' k r) :=
      fun _ no => (mark_carried no).2
    have both_recur : YesRecurs (jointly m m') r → YesRecurs m r ∧ YesRecurs m' r := fun recurs =>
      have after : ∀ n, ∃ c, n ≤ c ∧ J c = true ∧ ∃ d, J (c + 1 + d) = true := fun n =>
        match recurs n with
        | ⟨c, le, yes⟩ => match recurs (c + 1) with
          | ⟨_, le', yes'⟩ => match le_dest le' with
            | ⟨d, gap⟩ => ⟨c, le, yes, d,
                Eq.subst (motive := fun x => J x = true) gap yes'⟩
      ⟨fun n => match after n with
        | ⟨c, le, yes, d, yes'⟩ =>
          match mark_origin (p := fun k => (pending m m' k r).1) (g := fun k => m k r) (c := c + 1)
              origin₁ (show (pending m m' (c + 1) r).1 = false from (mark_cleared yes).1) d
              (ListTests.and_left (b := (pending m m' (c + 1 + d) r).2 || m' (c + 1 + d) r) yes') with
          | ⟨j, le_j, said⟩ => ⟨j, Nat.le_trans le (Nat.le_trans (Nat.le_succ c) le_j), said⟩,
       fun n => match after n with
        | ⟨c, le, yes, d, yes'⟩ =>
          match mark_origin (p := fun k => (pending m m' k r).2) (g := fun k => m' k r) (c := c + 1)
              origin₂ (show (pending m m' (c + 1) r).2 = false from (mark_cleared yes).2) d
              (ListTests.and_right (a := (pending m m' (c + 1 + d) r).1 || m (c + 1 + d) r) yes') with
          | ⟨j, le_j, said⟩ => ⟨j, Nat.le_trans le (Nat.le_trans (Nat.le_succ c) le_j), said⟩⟩
    have joint_recurs : YesRecurs m r → YesRecurs m' r → YesRecurs (jointly m m') r :=
      fun first second n => match first n, second n with
      | ⟨a, le_a, yes_a⟩, ⟨b, le_b, yes_b⟩ =>
        match false_below_or_true (fun t => J (n + t)) (a + b + 1) with
        | .inr ⟨t, yes⟩ => ⟨n + t, Nat.le_add_right n t, yes⟩
        | .inl below =>
          have none_ : ∀ k, n ≤ k → k < n + (a + b) → J k = false := fun _ le lt =>
            match le_dest le with
            | ⟨t, gap⟩ => Eq.subst (motive := fun x => J x = false) gap.symm
                (below t (Nat.lt_succ_of_lt (Nat.lt_of_add_lt_add_left
                  (Eq.subst (motive := fun x => x < n + (a + b)) gap lt))))
          have end_a : a ≤ n + (a + b) :=
            Nat.le_trans (Nat.le_add_right a b) (Nat.le_add_left (a + b) n)
          have end_b : b ≤ n + (a + b) :=
            Nat.le_trans (Nat.le_add_left b a) (Nat.le_add_left (a + b) n)
          match le_dest end_a, le_dest end_b with
          | ⟨da, gap_a⟩, ⟨db, gap_b⟩ =>
            have kept₁ := mark_kept (p := fun k => (pending m m' k r).1) (J := J) (g := fun k => m k r) carry₁ yes_a da
              fun k le lt => none_ k (Nat.le_trans le_a le)
                (Eq.subst (motive := fun x => k < x) gap_a.symm lt)
            have kept₂ := mark_kept (p := fun k => (pending m m' k r).2) (J := J) (g := fun k => m' k r) carry₂ yes_b db
              fun k le lt => none_ k (Nat.le_trans le_b le)
                (Eq.subst (motive := fun x => k < x) gap_b.symm lt)
            (ListTests.bool_absurd (bool_and_true
              (Eq.subst (motive := fun x => ((pending m m' x r).1 || m x r) = true) gap_a.symm
                kept₁)
              (Eq.subst (motive := fun x => ((pending m m' x r).2 || m' x r) = true) gap_b.symm
                kept₂))
              (below (a + b) (Nat.lt_succ_self _))).elim
    ⟨fun ⟨inside, inside'⟩ => joint_recurs ((refutes r).mp inside) ((refutes' r).mp inside'),
     fun recurs => match both_recur recurs with
      | ⟨first, second⟩ => ⟨(refutes r).mpr first, (refutes' r).mpr second⟩⟩

/-! ## Identification -/

section Identification

variable {V : Type w}

/-- A guess of values tracks the target `h` in the limit where on each run, from some horizon on,
it is the target's value at the horizon. The target may change with the horizon. -/
def Tracks (g : Nat → Run P → V) (h : Nat → Run P → V) : Prop :=
  ∀ r, ∃ n, ∀ k, n ≤ k → g k r = h k r

/-- A guess of values identifies the hypothesis `H` in the limit where on each run it is `H`'s value
from some horizon on: it tracks the target that is `H` at every horizon. -/
def Identifies (g : Nat → Run P → V) (H : Run P → V) : Prop :=
  Tracks g fun _ r => H r

/-- **Identification is tracking a target that does not change with the horizon.** -/
theorem identifies_iff_tracks {g : Nat → Run P → V} {H : Run P → V} :
    Identifies g H ↔ Tracks g fun _ r => H r :=
  Iff.rfl

/-- **Tracked by the same guess, two targets agree from some horizon on**, on every run. -/
theorem Tracks.agree {g : Nat → Run P → V} {h h' : Nat → Run P → V} (tracks : Tracks g h)
    (tracks' : Tracks g h') (r : Run P) : ∃ n, ∀ k, n ≤ k → h k r = h' k r :=
  match tracks r, tracks' r with
  | ⟨n, at_h⟩, ⟨n', at_h'⟩ => ⟨n + n', fun k le =>
    (at_h k (Nat.le_trans (Nat.le_add_right n n') le)).symm.trans
      (at_h' k (Nat.le_trans (Nat.le_add_left n' n) le))⟩

/-- The guess "the guessed value is `v`". -/
def says [DecidableEq V] (g : Nat → Run P → V) (v : V) : Method P := fun k r => decide (g k r = v)

/-- **"The guessed value is `v`" is fixed by the record where the guess of values is.** -/
theorem says_byRecord [DecidableEq V] {g : Nat → Run P → V} (byRecord : ∀ k (r r' : Run P),
    r.AgreeUpTo k r' → g k r = g k r') (v : V) : ByRecord (says g v) :=
  fun k r r' agree => congrArg (fun x => decide (x = v)) (byRecord k r r' agree)

/-- **Identification in the limit verifies each hypothesis in the limit.** -/
theorem identifies_verifies [DecidableEq V] {g : Nat → Run P → V} {H : Run P → V}
    (identifies : Identifies g H) (v : V) : Verifies (says g v) fun r => H r = v :=
  fun r => match identifies r with
  | ⟨n, at_H⟩ => ⟨fun is_v => ⟨n, fun k le => decide_eq_true ((at_H k le).trans is_v)⟩,
    fun ⟨n', yes⟩ => (at_H (n + n') (Nat.le_add_right n n')).symm.trans
      (of_decide_eq_true (yes (n + n') (Nat.le_add_left n' n)))⟩

/-- **Identification in the limit refutes each hypothesis in the limit.** -/
theorem identifies_refutes [DecidableEq V] {g : Nat → Run P → V} {H : Run P → V}
    (identifies : Identifies g H) (v : V) : Refutes (says g v) fun r => H r = v :=
  fun r => match identifies r with
  | ⟨n, at_H⟩ => ⟨fun is_v n' => ⟨n + n', Nat.le_add_left n' n,
      decide_eq_true ((at_H (n + n') (Nat.le_add_right n n')).trans is_v)⟩,
    fun recurs => match recurs n with
      | ⟨k, le, yes⟩ => (at_H k le).symm.trans (of_decide_eq_true yes)⟩

end Identification

/-! ## Settling -/

section Settling

variable [DecidableEq S]

/-- The guess "the last step changed nothing". -/
def still : Nat → Run P → Bool
  | 0, _ => true
  | k + 1, r => decide (r.state (k + 1) = r.state k)

/-- **"The last step changed nothing" is fixed by the record.** -/
theorem still_byRecord : ByRecord (still (P := P))
  | 0, _, _, _ => rfl
  | k + 1, r, r', agree =>
    show decide (r.state (k + 1) = r.state k) = decide (r'.state (k + 1) = r'.state k) by
      rw [agree.1 (k + 1) (Nat.le_refl _), agree.1 k (Nat.le_succ k)]

/-- **Where configurations are told apart, "the last step changed nothing" verifies settling in the
limit.** -/
theorem still_verifies : Verifies (still (P := P)) Enough.Settles :=
  fun r => ⟨fun ⟨T, stays⟩ => ⟨T + 1, fun k le => match k, le with
      | 0, le => absurd le (Nat.not_succ_le_zero T)
      | k + 1, le => decide_eq_true (stays k (Nat.le_of_succ_le_succ le))⟩,
    fun ⟨n, yes⟩ => ⟨n, fun k le =>
      of_decide_eq_true (p := r.state (k + 1) = r.state k) (yes (k + 1) (Nat.le_succ_of_le le))⟩⟩

end Settling

end Methods

/-! ## Sequences built against a method -/

/-- The stage `k` of a sequence built step by step: its values before `k`, then `false`. The value
at `k` is `next k` of the stage `k`. -/
def stage (next : Nat → (Nat → Bool) → Bool) : Nat → Nat → Bool
  | 0 => fun _ => false
  | k + 1 => fun t => if t < k then stage next k t else if t = k then next k (stage next k) else false

/-- The sequence built step by step: its value at `k` is `next k` of its values before `k`. -/
def built (next : Nat → (Nat → Bool) → Bool) (t : Nat) : Bool := stage next (t + 1) t

theorem stage_eq (next : Nat → (Nat → Bool) → Bool) : ∀ k t, t < k → stage next k t = built next t
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | k + 1, t, lt => match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt) with
    | .inl before => (if_pos before).trans (stage_eq next k t before)
    | .inr same => same ▸ rfl

theorem built_eq (next : Nat → (Nat → Bool) → Bool) (k : Nat) :
    built next k = next k (stage next k) :=
  show (if k < k then stage next k k else if k = k then next k (stage next k) else false) = _ by
    rw [if_neg (Nat.lt_irrefl k), if_pos rfl]

/-! ## Recurrence on the sequences of moves -/

namespace Sequences

open Becoming.Sequences (process agree_iff)

local notation "Recurs" => Becoming.Sequences.Recurs
local notation "run" => Becoming.Sequences.run

/-- The guess "the last move was `true`". -/
def lastMove : Method (process Bool)
  | 0, _ => false
  | k + 1, r => r.act k

/-- From some step on every move is `false`. -/
def EventuallyFalse (r : Run (process Bool)) : Prop := ∃ n, ∀ k, n ≤ k → r.act k = false

/-- **"The last move was `true`" is fixed by the record.** -/
theorem lastMove_byRecord : ByRecord lastMove
  | 0, _, _, _ => rfl
  | k + 1, _, _, agree => agree.2 k (Nat.lt_succ_self k)

/-- **"The last move was `true`" refutes recurrence in the limit.** -/
theorem lastMove_refutes : Refutes lastMove Recurs :=
  fun _ => ⟨fun recurs n => match recurs n with
      | ⟨k, le, yes⟩ => ⟨k + 1, Nat.le_succ_of_le le, yes⟩,
    fun recurs n => match recurs (n + 1) with
      | ⟨0, le, _⟩ => absurd le (Nat.not_succ_le_zero n)
      | ⟨k + 1, le, yes⟩ => ⟨k, Nat.le_of_succ_le_succ le, yes⟩⟩

/-- The guess "the last move was not `true`". -/
def notLastMove : Method (process Bool) := fun k r => !lastMove k r

theorem notLastMove_byRecord : ByRecord notLastMove :=
  fun k r r' agree => congrArg not (lastMove_byRecord k r r' agree)

/-- **"The last move was not `true`" verifies in the limit that from some step on every move is
`false`.** -/
theorem notLastMove_verifies : Verifies notLastMove EventuallyFalse :=
  fun _ => ⟨fun ⟨n, no⟩ => ⟨n + 1, fun k le => match k, le with
      | 0, le => absurd le (Nat.not_succ_le_zero n)
      | k + 1, le => ListTests.not_eq_true_of_false (no k (Nat.le_of_succ_le_succ le))⟩,
    fun ⟨n, yes⟩ => ⟨n, fun k le => ListTests.false_of_not (yes (k + 1) (Nat.le_succ_of_le le))⟩⟩

/-- **A run from some step on `false` throughout does not recur.** -/
theorem not_recurs_of_eventuallyFalse {r : Run (process Bool)} (eventually : EventuallyFalse r) :
    ¬ Recurs r :=
  fun recurs => match eventually with
  | ⟨n, no⟩ => match recurs n with
    | ⟨k, le, yes⟩ => ListTests.bool_absurd yes (no k le)

/-- The next move against a method: the negation of its guess on the run so far. -/
def againstNext (m : Method (process Bool)) (k : Nat) (p : Nat → Bool) : Bool := !m k (run p)

/-- The run playing the negation of the method's guess. -/
def against (m : Method (process Bool)) : Run (process Bool) :=
  run (built (againstNext m))

/-- **The run built against a method fixed by the record plays the negation of its guess.** -/
theorem against_act {m : Method (process Bool)} (byRecord : ByRecord m) (k : Nat) :
    (against m).act k = !m k (against m) :=
  have agree : (against m).AgreeUpTo k (run (stage (againstNext m) k)) :=
    agree_iff.mpr fun t lt => (stage_eq (againstNext m) k t lt).symm
  (built_eq (againstNext m) k).trans (congrArg not (byRecord k _ _ agree).symm)

/-- **Under Markov's principle no method fixed by the record verifies recurrence in the limit.**
The run playing the negation of the guess recurs exactly where the method does not converge to
yes. -/
theorem recurs_not_verified (markov : Markov) {m : Method (process Bool)} (byRecord : ByRecord m) :
    ¬ Verifies m Recurs :=
  fun verifies =>
    have flip := against_act byRecord
    have not_yes : ¬ Converges m (against m) true := fun ⟨n, yes⟩ =>
      match (verifies (against m)).mpr ⟨n, yes⟩ n with
      | ⟨k, le, played⟩ =>
        ListTests.bool_absurd played ((flip k).trans (congrArg not (yes k le)))
    not_yes ((verifies (against m)).mp fun n =>
      match markov (fun j => (against m).act (n + j)) (fun all => not_yes ⟨n, fun k le =>
          match le_dest le with
          | ⟨j, gap⟩ => eq_true_of_not_false ((flip k).symm.trans
              (Eq.subst (motive := fun x => (against m).act x = false) gap.symm (all j)))⟩) with
      | ⟨j, played⟩ => ⟨n + j, Nat.le_add_right n j, played⟩)

/-- **Saying from a run's not recurring that from some step on its moves are `false` is the limited
principle of omniscience.** The witness marks only the first `true` of a sequence: it does not recur,
and the step from which it is `false` decides whether the sequence is ever `true`. -/
theorem eventuallyFalse_lpo
    (law : ∀ r : Run (process Bool), ¬ Recurs r → EventuallyFalse r) : LPO :=
  fun s =>
    let first : Nat → Bool := fun j => s j && clear s j
    have marks : ∀ {j}, first j = true → s j = true ∧ clear s j = true := fun yes =>
      ⟨ListTests.and_left yes, ListTests.and_right yes⟩
    have once : ¬ Recurs (run first) := fun recurs =>
      match recurs 0 with
      | ⟨a, _, at_a⟩ => match recurs (a + 1) with
        | ⟨_, le, at_b⟩ =>
          Nat.lt_irrefl a (Eq.subst (motive := fun x => a < x)
            (Clear.first_unique s (marks at_a).2 (marks at_a).1 (marks at_b).2 (marks at_b).1).symm
            le)
    match law (run first) once with
    | ⟨N, after⟩ => match Clear.or_first s N with
      | .inr ⟨j, _, _, yes⟩ => .inl ⟨j, yes⟩
      | .inl c => .inr fun _ => ListTests.false_of_not_true fun yes =>
        match Clear.first_of_true s yes with
        | ⟨j, cj, yj⟩ => match Nat.lt_or_ge j N with
          | .inl lt => ListTests.bool_absurd yj (Clear.false_before s c lt)
          | .inr ge => ListTests.bool_absurd (bool_and_true yj cj) (after j ge)

theorem or_not_self : ∀ b : Bool, (b || !b) = true
  | true => rfl
  | false => rfl

/-- **Saying which of two guesses recurs, from their disjunction recurring, is the limited principle
of omniscience.** The witness: "no `true` so far" and "some `true` so far" of a sequence. -/
theorem either_recurs_lpo
    (law : ∀ (m m' : Method (process Bool)) (r : Run (process Bool)),
      YesRecurs (fun k r => m k r || m' k r) r → YesRecurs m r ∨ YesRecurs m' r) : LPO :=
  fun s =>
    match law (fun k _ => clear s k) (fun k _ => !clear s k) (run fun _ => false)
        (fun n => ⟨n, Nat.le_refl n, or_not_self _⟩) with
    | .inl none_ => .inr fun n => match none_ (n + 1) with
      | ⟨_, le, c⟩ => Clear.false_before s c le
    | .inr some_ => match some_ 0 with
      | ⟨_, _, yes⟩ => .inl (true_of_not_clear (ListTests.false_of_not yes))

end Sequences

/-! ## Settling on the free process -/

namespace Free

open Enough.Free (process alternating)

/-- The run of the free process through the configurations `x`. -/
def run (x : Nat → Bool) : Run process := ⟨x, fun _ => (), fun _ => trivial⟩

/-- The configurations `x` up to `h`, then each step by `f`. -/
def after (x : Nat → Bool) (h : Nat) (f : Bool → Bool) : Nat → Bool
  | 0 => x 0
  | t + 1 => if t + 1 ≤ h then x (t + 1) else f (after x h f t)

theorem after_agree (x : Nat → Bool) (h : Nat) (f : Bool → Bool) :
    ∀ t, t ≤ h → after x h f t = x t
  | 0, _ => rfl
  | _ + 1, le => if_pos le

theorem after_step (x : Nat → Bool) {h : Nat} (f : Bool → Bool) {n : Nat} (le : h ≤ n) :
    after x h f (n + 1) = f (after x h f n) :=
  if_neg (Nat.not_le_of_gt (Nat.lt_succ_of_le le))

theorem agree_after (r : Run process) (h : Nat) (f : Bool → Bool) :
    r.AgreeUpTo h (run (after r.state h f)) :=
  ⟨fun t le => (after_agree r.state h f t le).symm, fun _ _ => rfl⟩

/-- **Settling is dense**: every finite record of the free process is a record of a run that
settles. -/
theorem settles_dense : Dense (Enough.Settles (P := process)) :=
  fun r h => ⟨run (after r.state h id), ⟨h, fun _ le => after_step r.state id le⟩,
    agree_after r h id⟩

/-- **Not settling is dense**: every finite record of the free process is a record of a run that
changes at every later step. -/
theorem unsettled_dense : Dense fun r : Run process => ¬ Enough.Settles r :=
  fun r h => ⟨run (after r.state h not), fun ⟨T, stays⟩ =>
      ListTests.not_ne_self _ ((after_step r.state not (Nat.le_add_right h T)).symm.trans
        (stays (h + T) (Nat.le_add_left T h))),
    agree_after r h not⟩

/-- **Settling is not verifiable**: the run staying at `false` settles and adheres to not
settling. -/
theorem settles_not_verifiable : ¬ Verifiable (Enough.Settles (P := process)) :=
  not_verifiable_of_adheres (r := run fun _ => false) (unsettled_dense _) ⟨0, fun _ _ => rfl⟩

/-- **Settling is not refutable**: the alternating run does not settle and adheres to settling. -/
theorem settles_not_refutable : ¬ Refutable (Enough.Settles (P := process)) :=
  not_refutable_of_adheres (settles_dense alternating) Enough.Free.stays_meet_not_assured.2.2.1

/-- **Where the free process's configurations are told apart, settling is verified in the
limit.** -/
theorem settles_verified : Verifies (still (P := process)) Enough.Settles := still_verifies

/-- Flip `b` where `c` is yes. -/
def toggle : Bool → Bool → Bool
  | b, true => !b
  | b, false => b

/-- The next configuration against a method: the last one, flipped where the method says yes. -/
def againstNext (m : Method process) : Nat → (Nat → Bool) → Bool
  | 0, _ => false
  | k + 1, p => toggle (p k) (m k (run p))

/-- The run changing where the method says yes and staying where it says no. -/
def against (m : Method process) : Run process :=
  run (built (againstNext m))

/-- **The run built against a method fixed by the record changes exactly where the method says
yes.** -/
theorem against_state {m : Method process} (byRecord : ByRecord m) (k : Nat) :
    (against m).state (k + 1) = toggle ((against m).state k) (m k (against m)) :=
  have agree : (against m).AgreeUpTo k (run (stage (againstNext m) (k + 1))) :=
    ⟨fun t le => (stage_eq (againstNext m) (k + 1) t (Nat.lt_succ_of_le le)).symm, fun _ _ => rfl⟩
  have last : stage (againstNext m) (k + 1) k = (against m).state k :=
    stage_eq (againstNext m) (k + 1) k (Nat.lt_succ_self k)
  (built_eq (againstNext m) (k + 1)).trans (show toggle (stage (againstNext m) (k + 1) k)
      (m k (run (stage (againstNext m) (k + 1)))) = _ by
    rw [last, byRecord k _ _ agree])

/-- **Under Markov's principle no method fixed by the record refutes settling in the limit.** The
run changing where the method says yes settles exactly where its yes does not recur. -/
theorem settles_not_refuted (markov : Markov) {m : Method process} (byRecord : ByRecord m) :
    ¬ Refutes m Enough.Settles :=
  fun refutes =>
    have moves := against_state byRecord
    have not_recurs : ¬ YesRecurs m (against m) := fun recurs =>
      match (refutes (against m)).mpr recurs with
      | ⟨T, stays⟩ => match recurs T with
        | ⟨k, le, yes⟩ => ListTests.not_ne_self _
            (Eq.subst (motive := fun c => toggle ((against m).state k) c = (against m).state k)
              yes ((moves k).symm.trans (stays k le)))
    not_recurs fun n =>
      match markov (fun j => m (n + j) (against m)) (fun all =>
          not_recurs ((refutes (against m)).mp ⟨n, fun k le => match le_dest le with
            | ⟨j, gap⟩ => (moves k).trans (Eq.subst
                (motive := fun c => toggle ((against m).state k) c = (against m).state k)
                (Eq.subst (motive := fun x => m x (against m) = false) gap.symm (all j)).symm
                rfl)⟩)) with
      | ⟨j, yes⟩ => ⟨n + j, Nat.le_add_right n j, yes⟩

end Free

end Limit

end Becoming
