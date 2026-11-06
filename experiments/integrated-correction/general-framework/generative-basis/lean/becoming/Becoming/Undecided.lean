import Becoming.Diagonal
import Becoming.Labelled

/-!
# The third value and revision

`Becoming.Diagonal` reads a family of readings within what it reads: where a map moves every
value, the family misses a reading (`Diagonal.gap_unsaid`), and revising a value by such a map
never rests (`Diagonal.revision_never_rests`); the two-valued liar is the simplest rhythm. This
module adds a third value, undecided, below the two decided values in information, and states
what revision does with it, with no premise.

* **Three values.** A sentence is true (`t`), undecided (`u`) or false (`f`); `u` lies below `t`
  and `f` in information (`Le`), and above a decided value lies only itself (`Le.decided`).
  Terms are built from sentences and the two decided constants by negation, conjunction and
  disjunction, with the strong tables (`Value.neg`, `Value.conj`, `Value.disj`), which agree with
  the two-valued ones on decided values (`eval_embed`).
* **Nothing decided in, nothing decided out.** A term with no constant (`ConstantFree`) is
  undecided wherever every sentence is (`eval_undecided`), so a system whose sentences say terms
  with no constant stays wholly undecided at every stage of its revision (`stays_undecided`):
  revision decides only what a constant decides first.
* **Evaluation is monotone in information** (`eval_mono`, `eval_mono_below`): deciding more of
  the sentences decides more of every term and changes nothing already decided.
* **Revision settles, within exactly `N` steps.** A system of sentences, each saying a term of
  the sentences (`revise`), revised from every sentence undecided (`stage`, the run `Law.run` of
  the revision), rises in information at every step and along the whole run (`stage_up`,
  `stage_mono`); for `N` sentences that speak only of one another (`Closed`), it settles within
  `N` steps (`settles`) and stays there (`settled_from`), at the least of its fixed points
  (`stage_fixed`, `stage_le_fixed`, `least_fixed`). The bound is exact: in the chain whose first
  sentence says true and each next denies the one before, sentence `k` is undecided up to stage
  `k` and decided after (`chain_undecided`, `chain_decided`), so `N + 1` sentences are not steady
  at step `N` (`chain_exact`). The counting behind it is a law of its own: readings on a list that
  only rise, and once steady stay steady, are steady by the list's length (`settles_within`).
* **The liar rests, undecided.** The sentence that denies itself is undecided at every stage of
  the run from all undecided (`liar_rests`); a run of its revision from any start rests exactly where it is undecided
  (`liar_rests_iff`, `neg_fixed_iff`). The sentence that affirms itself keeps whatever value it
  starts with (`truthTeller_keeps`), and from all undecided it rests undecided
  (`truthTeller_rests`).
* **The gap reappears as undecidedness.** Where the two-valued revision of a system has no fixed
  point, as for the liar, whose two-valued revision is the run of negation and never rests
  (`liar_two_valued_moves`, `liar_two_valued_never_rests`, by `Diagonal.revision_never_rests`),
  every fixed point of the three-valued revision leaves a sentence undecided
  (`undecided_of_moves`), the least one included (`least_undecided`), and every run of the
  three-valued revision rests only with a sentence undecided (`rest_undecided`, `liar_undecided`).
  The liar on both sides: two values, never resting; three values, resting undecided
  (`liar_both_sides`). Three-valued negation is monotone in information and does not move every
  value (`neg_not_moves`); no monotone map does (`monotone_fixed`, `monotone_not_moves`), and the
  run of a monotone map from the undecided value rests from its first step
  (`monotone_run_rests`), so a run from the undecided value that never rests is not of a monotone
  map (`never_rests_not_monotone`): the gap of `Diagonal.gap_unsaid` needs a map that decides the
  undecided, which is not monotone (`moves_not_monotone`). A family within what it reads is
  still incomplete with three values (`incomplete`, by `Diagonal.fixed_of_complete` with the
  rotation of the values).

So revision of what a system says of itself, read with an undecided value, settles where the
two-valued revision runs on: what never rests in two values rests undecided in three. The
undecided value is not a third truth beside the two; it is what revision has not decided and,
for the liar, never decides.

**Classical sources.** The tables are Kleene's strong three-valued tables; settling at the least
fixed point from all undecided is Kripke's construction (1975) restricted to finitely many
sentences; `settles_within` is the finite chain condition. What is the spine's own is the reading
of the liar's revision on both sides: `Diagonal.revision_never_rests` with two values and
`liar_rests` with three.

What is not derived: infinitely many sentences (where the least fixed point needs a limit
stage), fixed points other than the least (the truth-teller's decided ones are not reached from
all undecided), and any measure of how many sentences stay undecided. No ethical predicate,
ranking or axiom occurs.
-/

namespace Becoming

universe u

namespace Undecided

/-! ## Three values -/

/-- A sentence's value: true, undecided or false. -/
inductive Value where
  | t
  | u
  | f

namespace Value

/-- Negation: it exchanges the decided values and leaves `u` undecided. -/
def neg : Value → Value
  | t => f
  | u => u
  | f => t

/-- Conjunction: false where one is false, true where both are true, else undecided. -/
def conj : Value → Value → Value
  | t, t => t
  | t, u => u
  | t, f => f
  | u, t => u
  | u, u => u
  | u, f => f
  | f, _ => f

/-- Disjunction: true where one is true, false where both are false, else undecided. -/
def disj : Value → Value → Value
  | t, _ => t
  | u, t => t
  | u, u => u
  | u, f => u
  | f, t => t
  | f, u => u
  | f, f => f

/-- A value is decided: `t` or `f`. -/
def decided : Value → Bool
  | t => true
  | u => false
  | f => true

/-- The decided value of a two-valued one. -/
def embed : Bool → Value
  | true => t
  | false => f

end Value

open Value

/-- Information order: `u` lies below every value, and every value below itself. -/
inductive Le : Value → Value → Prop where
  | bottom (v : Value) : Le u v
  | refl (v : Value) : Le v v

theorem Le.trans : ∀ {a b c : Value}, Le a b → Le b c → Le a c
  | _, _, _, .bottom _, _ => .bottom _
  | _, _, _, .refl _, h => h

/-- Above a decided value lies only itself. -/
theorem Le.decided : ∀ {a b : Value}, Le a b → a.decided = true → b = a
  | _, _, .bottom _, h => Bool.noConfusion h
  | _, _, .refl _, _ => rfl

/-- Two values in order are equal, or the lower is undecided and the upper decided. -/
theorem Le.same_or_rises : ∀ {a b : Value}, Le a b →
    b = a ∨ (a.decided = false ∧ b.decided = true)
  | _, _, .refl _ => .inl rfl
  | _, t, .bottom _ => .inr ⟨rfl, rfl⟩
  | _, u, .bottom _ => .inl rfl
  | _, f, .bottom _ => .inr ⟨rfl, rfl⟩

theorem neg_mono : ∀ {a b : Value}, Le a b → Le a.neg b.neg
  | _, _, .refl _ => .refl _
  | _, _, .bottom _ => .bottom _

theorem conj_mono : ∀ {a b c d : Value}, Le a b → Le c d → Le (conj a c) (conj b d)
  | _, _, _, _, .refl _, .refl _ => .refl _
  | _, t, _, _, .bottom _, .refl t => .bottom _
  | _, t, _, _, .bottom _, .refl u => .refl _
  | _, t, _, _, .bottom _, .refl f => .refl _
  | _, u, _, _, .bottom _, .refl t => .refl _
  | _, u, _, _, .bottom _, .refl u => .refl _
  | _, u, _, _, .bottom _, .refl f => .refl _
  | _, f, _, _, .bottom _, .refl t => .bottom _
  | _, f, _, _, .bottom _, .refl u => .bottom _
  | _, f, _, _, .bottom _, .refl f => .refl _
  | _, _, _, _, .bottom _, .bottom _ => .bottom _
  | t, _, _, t, .refl _, .bottom _ => .bottom _
  | t, _, _, u, .refl _, .bottom _ => .refl _
  | t, _, _, f, .refl _, .bottom _ => .bottom _
  | u, _, _, t, .refl _, .bottom _ => .refl _
  | u, _, _, u, .refl _, .bottom _ => .refl _
  | u, _, _, f, .refl _, .bottom _ => .bottom _
  | f, _, _, t, .refl _, .bottom _ => .refl _
  | f, _, _, u, .refl _, .bottom _ => .refl _
  | f, _, _, f, .refl _, .bottom _ => .refl _

theorem disj_mono : ∀ {a b c d : Value}, Le a b → Le c d → Le (disj a c) (disj b d)
  | _, _, _, _, .refl _, .refl _ => .refl _
  | _, t, _, _, .bottom _, .refl t => .refl _
  | _, t, _, _, .bottom _, .refl u => .bottom _
  | _, t, _, _, .bottom _, .refl f => .bottom _
  | _, u, _, _, .bottom _, .refl t => .refl _
  | _, u, _, _, .bottom _, .refl u => .refl _
  | _, u, _, _, .bottom _, .refl f => .refl _
  | _, f, _, _, .bottom _, .refl t => .refl _
  | _, f, _, _, .bottom _, .refl u => .refl _
  | _, f, _, _, .bottom _, .refl f => .bottom _
  | _, _, _, _, .bottom _, .bottom _ => .bottom _
  | t, _, _, t, .refl _, .bottom _ => .refl _
  | t, _, _, u, .refl _, .bottom _ => .refl _
  | t, _, _, f, .refl _, .bottom _ => .refl _
  | u, _, _, t, .refl _, .bottom _ => .bottom _
  | u, _, _, u, .refl _, .bottom _ => .refl _
  | u, _, _, f, .refl _, .bottom _ => .refl _
  | f, _, _, t, .refl _, .bottom _ => .bottom _
  | f, _, _, u, .refl _, .bottom _ => .refl _
  | f, _, _, f, .refl _, .bottom _ => .bottom _

theorem embed_inj : ∀ {a b : Bool}, embed a = embed b → a = b
  | true, true, _ => rfl
  | false, false, _ => rfl
  | true, false, h => Value.noConfusion h
  | false, true, h => Value.noConfusion h

/-! ## Terms and their values -/

/-- A term built from sentences and the two decided constants by negation, conjunction and
disjunction. -/
inductive Term where
  | var (i : Nat)
  | const (b : Bool)
  | neg (p : Term)
  | conj (p q : Term)
  | disj (p q : Term)

/-- The value of a term where sentence `i` has value `v i`. -/
def eval (v : Nat → Value) : Term → Value
  | .var i => v i
  | .const b => embed b
  | .neg p => (eval v p).neg
  | .conj p q => Value.conj (eval v p) (eval v q)
  | .disj p q => Value.disj (eval v p) (eval v q)

/-- The two-valued value of a term. -/
def eval₂ (b : Nat → Bool) : Term → Bool
  | .var i => b i
  | .const c => c
  | .neg p => !(eval₂ b p)
  | .conj p q => eval₂ b p && eval₂ b q
  | .disj p q => eval₂ b p || eval₂ b q

/-- A term speaks only of the first `N` sentences. -/
def Bounded (N : Nat) : Term → Prop
  | .var i => i < N
  | .const _ => True
  | .neg p => Bounded N p
  | .conj p q => Bounded N p ∧ Bounded N q
  | .disj p q => Bounded N p ∧ Bounded N q

/-- A term with no constant. -/
def ConstantFree : Term → Prop
  | .var _ => True
  | .const _ => False
  | .neg p => ConstantFree p
  | .conj p q => ConstantFree p ∧ ConstantFree q
  | .disj p q => ConstantFree p ∧ ConstantFree q

/-- **Nothing decided in, nothing decided out**: a term with no constant is undecided where
every sentence is. -/
theorem eval_undecided {v : Nat → Value} (blank : ∀ i, v i = u) : ∀ p, ConstantFree p → eval v p = u
  | .var i, _ => blank i
  | .const _, free => free.elim
  | .neg p, free => congrArg Value.neg (eval_undecided blank p free)
  | .conj p q, ⟨fp, fq⟩ => (congrArg (fun x => Value.conj x (eval v q)) (eval_undecided blank p fp)).trans
      (congrArg (Value.conj u) (eval_undecided blank q fq))
  | .disj p q, ⟨fp, fq⟩ => (congrArg (fun x => Value.disj x (eval v q)) (eval_undecided blank p fp)).trans
      (congrArg (Value.disj u) (eval_undecided blank q fq))

/-- **Evaluation is monotone in information.** -/
theorem eval_mono {v w : Nat → Value} (le : ∀ i, Le (v i) (w i)) : ∀ p, Le (eval v p) (eval w p)
  | .var i => le i
  | .const _ => .refl _
  | .neg p => neg_mono (eval_mono le p)
  | .conj p q => conj_mono (eval_mono le p) (eval_mono le q)
  | .disj p q => disj_mono (eval_mono le p) (eval_mono le q)

/-- Evaluation is monotone in information on the sentences a term speaks of. -/
theorem eval_mono_below {N : Nat} {v w : Nat → Value} (le : ∀ i, i < N → Le (v i) (w i)) :
    ∀ p, Bounded N p → Le (eval v p) (eval w p)
  | .var i, b => le i b
  | .const _, _ => .refl _
  | .neg p, b => neg_mono (eval_mono_below le p b)
  | .conj p q, ⟨bp, bq⟩ => conj_mono (eval_mono_below le p bp) (eval_mono_below le q bq)
  | .disj p q, ⟨bp, bq⟩ => disj_mono (eval_mono_below le p bp) (eval_mono_below le q bq)

/-- A term's value depends only on the sentences it speaks of. -/
theorem eval_congr {N : Nat} {v w : Nat → Value} (agree : ∀ i, i < N → v i = w i) :
    ∀ p, Bounded N p → eval v p = eval w p
  | .var i, b => agree i b
  | .const _, _ => rfl
  | .neg p, b => congrArg Value.neg (eval_congr agree p b)
  | .conj p q, ⟨bp, bq⟩ => (congrArg (fun x => Value.conj x (eval v q)) (eval_congr agree p bp)).trans
      (congrArg (Value.conj (eval w p)) (eval_congr agree q bq))
  | .disj p q, ⟨bp, bq⟩ => (congrArg (fun x => Value.disj x (eval v q)) (eval_congr agree p bp)).trans
      (congrArg (Value.disj (eval w p)) (eval_congr agree q bq))

theorem neg_embed : ∀ a : Bool, (embed a).neg = embed (!a)
  | true => rfl
  | false => rfl

theorem conj_embed : ∀ a b : Bool, Value.conj (embed a) (embed b) = embed (a && b)
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

theorem disj_embed : ∀ a b : Bool, Value.disj (embed a) (embed b) = embed (a || b)
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

/-- On decided values the three-valued evaluation is the two-valued one. -/
theorem eval_embed (b : Nat → Bool) : ∀ p, eval (fun i => embed (b i)) p = embed (eval₂ b p)
  | .var _ => rfl
  | .const _ => rfl
  | .neg p => (congrArg Value.neg (eval_embed b p)).trans (neg_embed _)
  | .conj p q => ((congrArg (fun x => Value.conj x (eval (fun i => embed (b i)) q))
      (eval_embed b p)).trans (congrArg (Value.conj (embed (eval₂ b p))) (eval_embed b q))).trans
      (conj_embed _ _)
  | .disj p q => ((congrArg (fun x => Value.disj x (eval (fun i => embed (b i)) q))
      (eval_embed b p)).trans (congrArg (Value.disj (embed (eval₂ b p))) (eval_embed b q))).trans
      (disj_embed _ _)

/-! ## Readings on a list that only rise -/

section Counting

variable {X : Type u}

/-- How many members of `l` the reading `c` marks. -/
def marked (c : X → Bool) : List X → Nat
  | [] => 0
  | x :: l => match c x with
    | true => marked c l + 1
    | false => marked c l

theorem marked_le (c : X → Bool) : ∀ l : List X, marked c l ≤ l.length
  | [] => Nat.le_refl 0
  | x :: l => by
    show (match c x with | true => marked c l + 1 | false => marked c l) ≤ l.length + 1
    cases c x with
    | true => exact Nat.succ_le_succ (marked_le c l)
    | false => exact Nat.le_succ_of_le (marked_le c l)

theorem marked_mono {c c' : X → Bool} : ∀ {l : List X},
    (∀ x, x ∈ l → c x = true → c' x = true) → marked c l ≤ marked c' l
  | [], _ => Nat.le_refl 0
  | x :: l, up => by
    have rest : marked c l ≤ marked c' l := marked_mono fun y m => up y (.tail x m)
    show (match c x with | true => marked c l + 1 | false => marked c l) ≤
      (match c' x with | true => marked c' l + 1 | false => marked c' l)
    cases hx : c x with
    | true =>
      have hx' : c' x = true := up x (.head l) hx
      rw [hx']
      exact Nat.succ_le_succ rest
    | false =>
      cases c' x with
      | true => exact Nat.le_succ_of_le rest
      | false => exact rest

/-- A reading that rises at a member of the list, and falls nowhere, marks one more. -/
theorem marked_rises {c c' : X → Bool} : ∀ {l : List X},
    (∀ x, x ∈ l → c x = true → c' x = true) → (∃ x, x ∈ l ∧ c x = false ∧ c' x = true) →
      marked c l + 1 ≤ marked c' l
  | [], _, ⟨_, m, _⟩ => absurd m (fun h => nomatch h)
  | x :: l, up, ⟨y, m, off, on⟩ => by
    have up' : ∀ z, z ∈ l → c z = true → c' z = true := fun z m => up z (.tail x m)
    show (match c x with | true => marked c l + 1 | false => marked c l) + 1 ≤
      (match c' x with | true => marked c' l + 1 | false => marked c' l)
    cases mem_cons_cases m with
    | inl at_x =>
      subst at_x
      rw [off, on]
      exact Nat.succ_le_succ (marked_mono up')
    | inr m' =>
      have rest : marked c l + 1 ≤ marked c' l := marked_rises up' ⟨y, m', off, on⟩
      cases hx : c x with
      | true =>
        have hx' : c' x = true := up x (.head l) hx
        rw [hx']
        exact Nat.succ_le_succ rest
      | false =>
        cases c' x with
        | true => exact Nat.le_succ_of_le rest
        | false => exact rest

/-- Each member passes one of two tests, so every member passes the first or some member the
second. -/
theorem each_or_some {A B : X → Prop} : ∀ {l : List X}, (∀ x, x ∈ l → A x ∨ B x) →
    (∀ x, x ∈ l → A x) ∨ ∃ x, x ∈ l ∧ B x
  | [], _ => .inl fun _ m => absurd m (fun h => nomatch h)
  | x :: l, each => match each x (.head l), each_or_some (fun y m => each y (.tail x m)) with
    | .inr b, _ => .inr ⟨x, .head l, b⟩
    | _, .inr ⟨y, m, b⟩ => .inr ⟨y, .tail x m, b⟩
    | .inl a, .inl rest => .inl fun y m => match mem_cons_cases m with
      | .inl at_x => at_x ▸ a
      | .inr m' => rest y m'

/-- A property kept by every step from `j` on holds at every later step. -/
theorem kept_from {Q : Nat → Prop} (next : ∀ k, Q k → Q (k + 1)) {j : Nat} (start : Q j)
    {k : Nat} (le : j ≤ k) : Q k := by
  induction le with
  | refl => exact start
  | step _ ih => exact next _ ih

/-- **Readings that only rise settle by the list's length.** Let readings `c k` of the members of
`l`, at steps `k`, only rise; let steadiness at a step carry to the next; and at each step let
the readings be steady or rise at some member. Then they are steady at the step `l.length`. -/
theorem settles_within (l : List X) (c : Nat → X → Bool) {Steady : Nat → Prop}
    (up : ∀ k x, x ∈ l → c k x = true → c (k + 1) x = true)
    (next : ∀ k, Steady k → Steady (k + 1))
    (step : ∀ k, Steady k ∨ ∃ x, x ∈ l ∧ c k x = false ∧ c (k + 1) x = true) :
    Steady l.length :=
  have climb : ∀ k, (∃ j, j ≤ k ∧ Steady j) ∨ k ≤ marked (c k) l := fun k => by
    induction k with
    | zero => exact .inr (Nat.zero_le _)
    | succ k ih =>
      cases ih with
      | inl found =>
        let ⟨j, le, steady⟩ := found
        exact .inl ⟨j, Nat.le_succ_of_le le, steady⟩
      | inr count =>
        cases step k with
        | inl steady => exact .inl ⟨k, Nat.le_succ k, steady⟩
        | inr rises =>
          exact .inr (Nat.le_trans (Nat.succ_le_succ count) (marked_rises (up k) rises))
  match climb l.length with
  | .inl ⟨_, le, steady⟩ => kept_from next steady le
  | .inr count => match step l.length with
    | .inl steady => steady
    | .inr rises => absurd (Nat.le_trans (Nat.succ_le_succ count)
        (Nat.le_trans (marked_rises (up _) rises) (marked_le _ l))) (Nat.not_succ_le_self _)

end Counting

/-! ## Revision of a system of sentences -/

theorem upto_length : ∀ n, (upto n).length = n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (upto_length n)

/-- A system of sentences: sentence `i` says `sys i`. One revision gives each sentence the value
of what it says. -/
def revise (sys : Nat → Term) (v : Nat → Value) : Nat → Value := fun i => eval v (sys i)

/-- Every sentence undecided. -/
def blank : Nat → Value := fun _ => u

/-- The values after `n` revisions from every sentence undecided: the run of revision from
`blank` (`Law.run`, whose states are the orbit). -/
def stage (sys : Nat → Term) (n : Nat) : Nat → Value := (Law.run (revise sys) blank).state n

/-- The first `N` sentences speak only of one another. -/
def Closed (sys : Nat → Term) (N : Nat) : Prop := ∀ i, i < N → Bounded N (sys i)

/-- Revision is steady at step `n` on the first `N` sentences. -/
def Steady (sys : Nat → Term) (N n : Nat) : Prop := ∀ i, i < N → stage sys (n + 1) i = stage sys n i

variable {sys : Nat → Term} {N : Nat}

/-- **Revision rises in information at every step.** -/
theorem stage_up (sys : Nat → Term) : ∀ n i, Le (stage sys n i) (stage sys (n + 1) i)
  | 0, _ => .bottom _
  | n + 1, i => eval_mono (stage_up sys n) (sys i)

/-- **Revision rises along the run**: what is decided at a step stays decided, alike, at every
later step. -/
theorem stage_mono (sys : Nat → Term) (i : Nat) {m : Nat} : ∀ {n : Nat}, m ≤ n →
    Le (stage sys m i) (stage sys n i) := fun le => by
  induction le with
  | refl => exact .refl _
  | step _ ih => exact ih.trans (stage_up sys _ i)

/-- **A system with no constant stays wholly undecided** at every stage: revision decides only
what a constant decides first. -/
theorem stays_undecided (free : ∀ i, ConstantFree (sys i)) : ∀ n i, stage sys n i = u
  | 0, _ => rfl
  | n + 1, i => eval_undecided (stays_undecided free n) (sys i) (free i)

/-- Steady at one step, steady at the next. -/
theorem Steady.next (closed : Closed sys N) {n : Nat} (steady : Steady sys N n) :
    Steady sys N (n + 1) :=
  fun i lt => eval_congr steady (sys i) (closed i lt)

/-- At each step revision is steady or decides a sentence it had not decided. -/
theorem steady_or_rises (sys : Nat → Term) (N n : Nat) :
    Steady sys N n ∨ ∃ i, i ∈ upto N ∧ (stage sys n i).decided = false ∧
      (stage sys (n + 1) i).decided = true :=
  match each_or_some (l := upto N) (fun i _ => (stage_up sys n i).same_or_rises) with
  | .inl same => .inl fun i lt => same i (mem_upto lt)
  | .inr rises => .inr rises

/-- **Revision settles within `N` steps.** -/
theorem settles (closed : Closed sys N) : Steady sys N N :=
  Eq.subst (motive := fun k => Steady sys N k) (upto_length N) <|
    settles_within (Steady := Steady sys N) (upto N) (fun n i => (stage sys n i).decided)
    (fun n i _ on => congrArg Value.decided ((stage_up sys n i).decided on) |>.trans on)
    (fun _ steady => steady.next closed) (steady_or_rises sys N)

/-- Once settled, revision stays settled. -/
theorem settled_from (closed : Closed sys N) {m : Nat} (le : N ≤ m) :
    ∀ i, i < N → stage sys m i = stage sys N i :=
  have steady : ∀ k, N ≤ k → Steady sys N k := fun _ le' =>
    kept_from (fun _ s => s.next closed) (settles closed) le'
  have stays : ∀ k, N ≤ k → ∀ i, i < N → stage sys k i = stage sys N i := fun k le' => by
    induction le' with
    | refl => exact fun _ _ => rfl
    | step le'' ih => exact fun i lt => (steady _ le'' i lt).trans (ih i lt)
  stays m le

/-- The settled values are a fixed point of revision. -/
theorem stage_fixed (closed : Closed sys N) : ∀ i, i < N → revise sys (stage sys N) i = stage sys N i :=
  settles closed

/-- **Revision from every sentence undecided stays below every fixed point.** -/
theorem stage_le_fixed (closed : Closed sys N) {w : Nat → Value}
    (fixed : ∀ i, i < N → eval w (sys i) = w i) : ∀ n i, i < N → Le (stage sys n i) (w i)
  | 0, _, _ => .bottom _
  | n + 1, i, lt => (fixed i lt) ▸ eval_mono_below (stage_le_fixed closed fixed n) (sys i) (closed i lt)

/-- **The settled values are the least fixed point**, reached within `N` steps. -/
theorem least_fixed (closed : Closed sys N) :
    (∀ i, i < N → revise sys (stage sys N) i = stage sys N i) ∧
      ∀ w : Nat → Value, (∀ i, i < N → eval w (sys i) = w i) → ∀ i, i < N → Le (stage sys N i) (w i) :=
  ⟨stage_fixed closed, fun _ fixed => stage_le_fixed closed fixed N⟩

/-! ## The bound is exact -/

/-- Sentence `0` says true, and sentence `k + 1` denies sentence `k`. -/
def chain : Nat → Term
  | 0 => .const true
  | k + 1 => .neg (.var k)

theorem chain_closed (N : Nat) : Closed chain N := fun i lt => match i, lt with
  | 0, _ => trivial
  | _ + 1, lt => Nat.lt_of_succ_lt lt

theorem neg_decided : ∀ {v : Value}, v.decided = true → v.neg.decided = true
  | t, _ => rfl
  | f, _ => rfl
  | u, h => Bool.noConfusion h

/-- Sentence `k` of the chain is undecided up to stage `k`. -/
theorem chain_undecided : ∀ n k, n ≤ k → stage chain n k = u
  | 0, _, _ => rfl
  | _ + 1, 0, le => absurd le (Nat.not_succ_le_zero _)
  | n + 1, k + 1, le => congrArg Value.neg (chain_undecided n k (Nat.le_of_succ_le_succ le))

/-- Sentence `k` of the chain is decided from stage `k + 1` on. -/
theorem chain_decided : ∀ n k, k < n → (stage chain n k).decided = true
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | _ + 1, 0, _ => rfl
  | n + 1, k + 1, lt => neg_decided (chain_decided n k (Nat.lt_of_succ_lt_succ lt))

/-- **The bound is exact**: revision of `N + 1` sentences of the chain is steady at step `N + 1`
(`settles`) and not at step `N`. -/
theorem chain_exact (N : Nat) : Steady chain (N + 1) (N + 1) ∧ ¬ Steady chain (N + 1) N :=
  ⟨settles (chain_closed (N + 1)),
   fun steady => Bool.noConfusion ((congrArg Value.decided ((steady N (Nat.lt_succ_self N)).trans
    (chain_undecided N N (Nat.le_refl N)))).symm.trans (chain_decided (N + 1) N (Nat.lt_succ_self N)))⟩

/-! ## The liar and the truth-teller -/

/-- Sentence `0` says its own negation. -/
def liar : Nat → Term := fun _ => .neg (.var 0)

/-- Sentence `0` says itself. -/
def truthTeller : Nat → Term := fun _ => .var 0

theorem liar_closed : Closed liar 1 := fun _ _ => Nat.lt_succ_self 0

/-- **The liar rests, undecided**, at every stage of the run from all undecided (`stage`). -/
theorem liar_rests : ∀ n i, stage liar n i = u
  | 0, _ => rfl
  | n + 1, _ => congrArg Value.neg (liar_rests n 0)

/-- Undecided is the only value negation keeps. -/
theorem neg_fixed_iff : ∀ v : Value, v.neg = v ↔ v = u
  | t => ⟨fun h => Value.noConfusion h, fun h => Value.noConfusion h⟩
  | u => ⟨fun _ => rfl, fun _ => rfl⟩
  | f => ⟨fun h => Value.noConfusion h, fun h => Value.noConfusion h⟩

/-- **A run of the liar's revision rests exactly where the liar is undecided**, from every
start. -/
theorem liar_rests_iff (v : Nat → Value) (n : Nat) :
    (Law.run (revise liar) v).state (n + 1) 0 = (Law.run (revise liar) v).state n 0 ↔
      (Law.run (revise liar) v).state n 0 = u :=
  neg_fixed_iff _

/-- Every value is a fixed point of the truth-teller: every run of its revision keeps the value
it starts with. -/
theorem truthTeller_keeps (v : Nat → Value) : ∀ n, (Law.run (revise truthTeller) v).state n 0 = v 0
  | 0 => rfl
  | n + 1 => truthTeller_keeps v n

/-- The truth-teller rests undecided too: the least of its fixed points. -/
theorem truthTeller_rests : ∀ n i, stage truthTeller n i = u
  | 0, _ => rfl
  | n + 1, _ => truthTeller_rests n 0

/-! ## The gap reappears as undecidedness -/

/-- Within the first `N` sentences, one is undecided or none is. -/
theorem some_undecided_or_none (w : Nat → Value) :
    ∀ N, (∃ i, i < N ∧ w i = u) ∨ ∀ i, i < N → (w i).decided = true
  | 0 => .inr fun _ lt => absurd lt (Nat.not_lt_zero _)
  | N + 1 => match some_undecided_or_none w N with
    | .inl ⟨i, lt, at_u⟩ => .inl ⟨i, Nat.lt_succ_of_lt lt, at_u⟩
    | .inr decidedBelow => by
      cases h : w N with
      | u => exact .inl ⟨N, Nat.lt_succ_self N, h⟩
      | t => exact .inr fun i lt => match Nat.lt_or_ge i N with
        | .inl lt' => decidedBelow i lt'
        | .inr ge => by
          rw [Nat.le_antisymm (Nat.le_of_lt_succ lt) ge, h]
          rfl
      | f => exact .inr fun i lt => match Nat.lt_or_ge i N with
        | .inl lt' => decidedBelow i lt'
        | .inr ge => by
          rw [Nat.le_antisymm (Nat.le_of_lt_succ lt) ge, h]
          rfl

/-- The two-valued reading of a value: `t` true, every other false. -/
def asBool : Value → Bool
  | t => true
  | u => false
  | f => false

theorem embed_asBool : ∀ {v : Value}, v.decided = true → embed (asBool v) = v
  | t, _ => rfl
  | f, _ => rfl
  | u, h => Bool.noConfusion h

/-- **The gap reappears as undecidedness.** Where the two-valued revision of a closed system has
no fixed point, every fixed point of the three-valued revision leaves a sentence undecided. -/
theorem undecided_of_moves (closed : Closed sys N)
    (moves : ∀ b : Nat → Bool, ∃ i, i < N ∧ eval₂ b (sys i) ≠ b i) {w : Nat → Value}
    (fixed : ∀ i, i < N → eval w (sys i) = w i) : ∃ i, i < N ∧ w i = u :=
  match some_undecided_or_none w N with
  | .inl found => found
  | .inr decided =>
    let b : Nat → Bool := fun i => asBool (w i)
    match moves b with
    | ⟨i, lt, ne⟩ => absurd (embed_inj (((eval_embed b (sys i)).symm.trans
        ((eval_congr (fun j lt' => embed_asBool (decided j lt')) (sys i) (closed i lt)).trans
          (fixed i lt))).trans (embed_asBool (decided i lt)).symm)) ne

/-- In particular the least fixed point leaves a sentence undecided. -/
theorem least_undecided (closed : Closed sys N)
    (moves : ∀ b : Nat → Bool, ∃ i, i < N ∧ eval₂ b (sys i) ≠ b i) :
    ∃ i, i < N ∧ stage sys N i = u :=
  undecided_of_moves closed moves (stage_fixed closed)

/-- **Where the two-valued revision has no fixed point, a run of revision rests only with a
sentence undecided**, from every start: a run of revision that rests is at a fixed point. -/
theorem rest_undecided (closed : Closed sys N)
    (moves : ∀ b : Nat → Bool, ∃ i, i < N ∧ eval₂ b (sys i) ≠ b i) (v : Nat → Value) (n : Nat)
    (rest : ∀ i, i < N → (Law.run (revise sys) v).state (n + 1) i = (Law.run (revise sys) v).state n i) :
    ∃ i, i < N ∧ (Law.run (revise sys) v).state n i = u :=
  undecided_of_moves (w := (Law.run (revise sys) v).state n) closed moves rest

/-- The liar's two-valued revision is negation, which moves every value
(`Diagonal.flip_moves`; revised, it never rests, `Diagonal.revision_never_rests`). -/
theorem liar_two_valued_moves (b : Nat → Bool) : ∃ i, i < 1 ∧ eval₂ b (liar i) ≠ b i :=
  ⟨0, Nat.lt_succ_self 0, fun same => Diagonal.flip_moves (b 0) same.symm⟩

/-- One two-valued revision of a system. -/
def revise₂ (sys : Nat → Term) (b : Nat → Bool) : Nat → Bool := fun i => eval₂ b (sys i)

/-- The liar's two-valued revision is the run of negation on its value. -/
theorem liar_two_valued_run (b : Nat → Bool) :
    ∀ n, (Law.run (revise₂ liar) b).state n 0 = (Law.run (fun x : Bool => !x) (b 0)).state n
  | 0 => rfl
  | n + 1 => congrArg (fun x => !x) (liar_two_valued_run b n)

/-- **With two values the liar's revision never rests** (`Diagonal.revision_never_rests`); with
three it rests, undecided (`liar_rests`). -/
theorem liar_two_valued_never_rests (b : Nat → Bool) (n : Nat) :
    (Law.run (revise₂ liar) b).state (n + 1) 0 ≠ (Law.run (revise₂ liar) b).state n 0 :=
  fun same => Diagonal.revision_never_rests Diagonal.flip_moves (b 0) n
    ((liar_two_valued_run b (n + 1)).symm.trans (same.trans (liar_two_valued_run b n)))

/-- **Every run of the liar's three-valued revision that rests has the liar undecided**: the
general law (`rest_undecided`) at the liar, whose two-valued revision has no fixed point. -/
theorem liar_undecided (v : Nat → Value) (n : Nat)
    (rest : (Law.run (revise liar) v).state (n + 1) 0 = (Law.run (revise liar) v).state n 0) :
    (Law.run (revise liar) v).state n 0 = u :=
  match rest_undecided liar_closed liar_two_valued_moves v n (fun i lt => match i, lt with
    | 0, _ => rest
    | _ + 1, lt => absurd (Nat.lt_of_succ_lt_succ lt) (Nat.not_lt_zero _)) with
  | ⟨0, _, at_u⟩ => at_u
  | ⟨_ + 1, lt, _⟩ => absurd (Nat.lt_of_succ_lt_succ lt) (Nat.not_lt_zero _)

/-! ## Monotone maps and the gap -/

/-- A map of values monotone in information. -/
def Monotone (g : Value → Value) : Prop := ∀ a b, Le a b → Le (g a) (g b)

theorem neg_monotone : Monotone Value.neg := fun _ _ le => neg_mono le

/-- **A map monotone in information keeps what it makes of the undecided value**: where it
decides the undecided value, it keeps the decision. -/
theorem monotone_settles {g : Value → Value} (mono : Monotone g) : ∃ v, g u = v ∧ g v = v := by
  cases h : g u with
  | u => exact ⟨u, rfl, h⟩
  | t =>
    have le : Le t (g t) := h ▸ mono u t (.bottom t)
    exact ⟨t, rfl, le.decided rfl⟩
  | f =>
    have le : Le f (g f) := h ▸ mono u f (.bottom f)
    exact ⟨f, rfl, le.decided rfl⟩

/-- Every map monotone in information has a value alike with its image. -/
theorem monotone_fixed {g : Value → Value} (mono : Monotone g) : ∃ v, v = g v :=
  match monotone_settles mono with
  | ⟨v, _, kept⟩ => ⟨v, kept.symm⟩

/-- No map monotone in information moves every value. -/
theorem monotone_not_moves {g : Value → Value} (mono : Monotone g) : ¬ Diagonal.Moves Eq g :=
  fun moves => match monotone_fixed mono with
    | ⟨v, same⟩ => moves v same

/-- Three-valued negation is monotone, so it keeps the undecided value: it does not move every
value, as the two-valued negation does (`Diagonal.flip_moves`). -/
theorem neg_not_moves : ¬ Diagonal.Moves Eq Value.neg :=
  monotone_not_moves neg_monotone

/-- **The run of a monotone map from the undecided value rests from its first step.** -/
theorem monotone_run_rests {g : Value → Value} (mono : Monotone g) :
    ∃ v, ∀ n, (Law.run g u).state (n + 1) = v :=
  match monotone_settles mono with
  | ⟨v, first, kept⟩ => ⟨v, fun n => by
      induction n with
      | zero => exact first
      | succ n ih => exact (congrArg g ih).trans kept⟩

/-- A run from the undecided value that never rests is not the run of a monotone map. -/
theorem never_rests_not_monotone {g : Value → Value}
    (never : ∀ n, (Law.run g u).state (n + 1) ≠ (Law.run g u).state n) : ¬ Monotone g :=
  fun mono => match monotone_run_rests mono with
    | ⟨_, rests⟩ => never 1 ((rests 1).trans (rests 0).symm)

/-- **The gap needs a map that is not monotone.** A map moving every value has runs that never
rest, from every start (`Diagonal.revision_never_rests`), and so is not monotone in information. -/
theorem moves_not_monotone {g : Value → Value} (moves : Diagonal.Moves Eq g) :
    (∀ v n, (Law.run g v).state (n + 1) ≠ (Law.run g v).state n) ∧ ¬ Monotone g :=
  ⟨fun v n => Diagonal.revision_never_rests moves v n,
   never_rests_not_monotone fun n => Diagonal.revision_never_rests moves u n⟩

/-- **The liar on both sides.** With two values its revision never rests; with three it rests
undecided at every stage, since three-valued negation does not move every value. -/
theorem liar_both_sides (b : Nat → Bool) (n : Nat) :
    (Law.run (revise₂ liar) b).state (n + 1) 0 ≠ (Law.run (revise₂ liar) b).state n 0 ∧
      stage liar n 0 = u ∧ ¬ Diagonal.Moves Eq Value.neg :=
  ⟨liar_two_valued_never_rests b n, liar_rests n 0, neg_not_moves⟩

/-- The rotation of the three values. -/
def rotate : Value → Value
  | t => u
  | u => f
  | f => t

theorem rotate_moves : Diagonal.Moves Eq rotate
  | t => fun h => Value.noConfusion h
  | u => fun h => Value.noConfusion h
  | f => fun h => Value.noConfusion h

/-- A family of three-valued readings within what it reads is still incomplete: it misses the
gap of the rotation (`Diagonal.fixed_of_complete`). -/
theorem incomplete {A : Type u} (ψ : A → A → Value) : ¬ ∀ g, Diagonal.Says Eq ψ g :=
  fun all => match Diagonal.fixed_of_complete ψ all rotate with
    | ⟨v, same⟩ => rotate_moves v same

end Undecided

end Becoming
