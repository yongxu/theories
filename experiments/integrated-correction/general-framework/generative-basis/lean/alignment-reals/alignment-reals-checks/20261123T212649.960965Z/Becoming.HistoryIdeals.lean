import Becoming.Ideals
import Becoming.Horizon
import Becoming.HistoryLanguages
import Becoming.Change

/-!
# Histories as ideals of their finite stretches

`Becoming.Ideals` reads a history off its finite stretches as an ideal of their order. Here the
stretches are those of the core's runs and words, and the laws of what a finite history refutes
(`Becoming.Horizon`) are a case of the laws of ideals.

**Runs.** A stretch of the runs of a process is a run and a horizon, read as the run's
configurations up to the horizon and its actions before it; one stretch extends another where its
horizon is at least as late and the two runs agree up to the earlier one (`stretchOrder`). A run is
read as the ideal of the stretches it passes through (`Run.stretches`). Two runs give ideals one
below the other exactly where they agree at every horizon (`Run.stretches_le_iff`), and no run's
ideal is a finite history (`Run.stretches_not_principal`): runs are the unending histories. With no
premise:
* a reading of runs is refutable exactly where it is refutable at a stretch
  (`refutable_iff_refutableBy`), and a run adheres to a reading exactly where it adheres through its
  stretches (`adheres_iff_adheresBy`), that is, where its ideal lies in the hull of the ideals of
  the reading's runs (`adheres_iff_hull`). So Horizon's laws are the case of runs of the laws of
  `Ideals.RefutableBy` and `Ideals.AdheresBy`, and `Becoming.Horizon`, which defines the stretches
  and states these two equivalences, derives them from those laws;
* a reading of runs holding every run that adheres to it is the reading of the runs whose
  stretches all lie in a lower set of stretches, the stretches of the runs it holds
  (`closed_iff_within_lower`): it is made of tests, one for each stretch, read as propositions.
  Where the tests are Boolean and fixed by prefixes, refutability needs Markov's principle
  (`refutable_passes_iff_markov`);
* asked of every process, a refutable reading holds at every run adhering to it exactly under
  double-negation elimination (`refutable_holds_iff`): in the process of the Boolean sequences,
  the run of `false` adheres to "some move is `true`, or `φ`", which is refutable once `¬ ¬ φ`.
  Stability is exactly what removing the double negation needs.
* for the sequences, a run passes through a stretch exactly where the stretch's word is an initial
  word of its moves (`sequence_stretch_iff`): the run case and the word case below are one order
  read two ways.

**Words.** Finite courses of moves, the core's words, are ordered by prefix (`prefixOrder`). A
sequence of moves is read as the ideal of its initial words (`traceIdeal`), a word as the ideal of
its prefixes. A history is finite or infinite (`History`); its ideal (`historyIdeal`) is below
another's exactly where it is a prefix of it (`history_le_iff`): a word of a word as a prefix, a
word of a sequence as an initial word, a sequence of a sequence where they agree at every place;
no sequence is below a word. Two histories give ideals with the same words exactly where they are
the same history (`historyIdeal_same_iff`).

**Which ideals are histories.** An ideal of words with a longest word is a finite history
(`hasLongest_principal`); one with words longer than every length, a word of each length picked, is
an infinite history, whose move at each place is the move there of the word picked for it
(`goesOn_trace`); so an ideal that settles, or goes on with its words picked, is a history
(`classification`). Telling which is deciding whether the history goes on: on the histories of `()`
cut at the first `true` of a Boolean sequence (`cut`), settling or going on is exactly the limited
principle of omniscience (`cut_decided_iff_lpo`). And going on gives a word of each length only
as a proposition; reading the infinite history off them takes the words given.

**Classes of histories.** A prefix-closed language (`HistoryLanguages.PrefixClosed`) is a lower set
of words (`prefixClosed_iff_lower`), so the histories within it are a closed class; a finite
history lies within it where its word is in the language, an infinite one where each of its
initial words is (`history_within_iff`). The class of the finite histories and of the infinite
histories of a property of sequences (`FiniteOr`) has every ideal in its hull (`finiteOr_hull`), so
a sequence outside the property shows the class is not refutable (`finiteOr_not_refutable`).
Recurrence is the case, by the sequence of `false` (`finiteOr_recurs_not_refutable`), as on runs
(`Sequences.recurs_not_refutable`).

**The laws of ideals on the histories of a process** (`Stretches`). The ideals of `stretchOrder P`
are the histories of the process `P`: the principal ideals are its finite histories, and its runs
are the ideals of the stretches they pass through. Each law of `Becoming.Ideals` is read on them,
with no premise:
* Horizon's laws are the laws of points read on runs, and `Becoming.Horizon` proves them so
  (`Refutable.not_not` from `Ideals.RefutableBy.not_not`, and the rest); a refutable class of
  histories is refutable at runs (`refutable_of_class`);
* adhering is the least closed class: a run adheres to a reading exactly where every closed class
  of histories holding the reading's runs holds it, with no double negation (`adheres_iff_closed`);
  that class is unique (`adherence_unique`), adds no stretch (`adheres_content`) and extends any
  two of a run's stretches by one stretch of one of the reading's runs (`adheres_joint`);
* a run lies in a closed class exactly where each of its stretches is a stretch of a history of the
  class (`closed_runs`), and the runs within a lower set of stretches are refutable where every
  history leaving the set shows a stretch outside it (`within_refutable`). Asked of every process,
  a refutable class is closed, and a closed class refutable, each exactly under double-negation
  elimination, with witnesses on the process of `()`s (`Stretches.refutable_closed_iff`,
  `Stretches.closed_refutable_iff`): not being refuted by any finite stretch is not belonging, and
  a history known not to lie within a closed class does not thereby show the stretch at which it
  leaves;
* avoiding a set of stretches is closed with no double negation (`avoids_adheres`), fixed by the
  finite histories (`avoids_runs`), and refutable wherever a history failing to avoid the set holds
  a stretch of it (`avoids_refutable`);
* a lower set of stretches has the process's histories within it as its own (`inherited_histories`),
  ordered as the runs are (`within_order_iff`);
* the completion at runs: no run is compact (`run_not_compact`); a continuous reading of the
  histories is fixed at every run by its values on finite histories (`run_reading_unique`); finite
  stretches tell runs apart (`runs_told_apart`); the finite histories are a compact basis
  (`finite_basis`), and the histories are the completion of the stretches (`histories_representation`);
* which histories are runs: one that settles is a finite history (`Stretches.hasLatest_principal`);
  one going on, with a stretch beyond each horizon picked, is the history of the run read off the
  picks (`pickedRun`, `goesOn_run`). So the classification holds for every process
  (`Stretches.classification`), and on the cut histories of the process of `()`s telling which is
  the limited principle of omniscience (`Stretches.cut_decided_iff_lpo`);
* for the process of all sequences, the runs' histories are the infinite histories of words, in
  order (`sequences_le_iff`), sameness (`sequences_same_iff`) and prefix-closed languages
  (`sequences_within_iff`).

This module states in the core what `HistoryIdeals` (7 October 2026, the completion package)
proved on its own words with `Std` and classical reasoning; there the decision of settling and the
picking of words were taken by excluded middle and choice. No ethical predicate, ranking or axiom
occurs; every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u v w

variable {S : Type u} {A : Type v}

/-! ## Runs: the ideals of their stretches -/

/-- **Two runs give ideals one below the other exactly where they agree at every horizon.** -/
theorem Run.stretches_le_iff {P : Process S A} {r r' : Run P} :
    Ideals.Ideal.LE r.stretches r'.stretches ↔ ∀ h, r.AgreeUpTo h r' :=
  ⟨fun le h => le (r, h) (Run.AgreeUpTo.refl r h), fun agree e mem => mem.trans (agree e.2)⟩

/-- **No run's ideal is a finite history**: runs are the unending histories. -/
theorem Run.stretches_not_principal {P : Process S A} (r : Run P) (e : Run P × Nat) :
    ¬ Ideals.Ideal.Same r.stretches (Ideals.principal (stretchOrder P) e) :=
  fun same => Nat.not_succ_le_self e.2
    ((same (r, e.2 + 1)).mp (Run.AgreeUpTo.refl r (e.2 + 1))).1

/-- The histories that are runs of a reading: the ideals of the runs it holds. -/
def runClass {P : Process S A} (K : Run P → Prop) : Ideals.Ideal (stretchOrder P) → Prop :=
  fun I => ∃ r, K r ∧ Ideals.Ideal.Same I r.stretches

/-- **A run adheres to a reading exactly where its ideal lies in the hull of the reading's runs.** -/
theorem adheres_iff_hull {P : Process S A} {K : Run P → Prop} {r : Run P} :
    Adheres K r ↔ Ideals.Hull (runClass K) r.stretches :=
  adheres_iff_adheresBy.trans
    ⟨fun adheres e he => match adheres e he with
      | ⟨r', inside, he'⟩ => ⟨r'.stretches, ⟨r', inside, Ideals.Ideal.Same.refl _⟩, he'⟩,
     fun hull e he => match hull e he with
      | ⟨_, ⟨r', inside, same⟩, he'⟩ => ⟨r', inside, (same e).mp he'⟩⟩

/-- **A reading of runs holding every run adhering to it is the reading of the runs whose stretches
lie in a lower set**, the content of its runs: the tests are the stretches, read as
propositions. -/
theorem closed_iff_within_lower {P : Process S A} {K : Run P → Prop} :
    (∀ r, Adheres K r → K r) ↔
      ∃ Q : Run P × Nat → Prop, Ideals.Lower (stretchOrder P) Q ∧
        ∀ r, K r ↔ Ideals.Within (stretchOrder P) Q r.stretches :=
  ⟨fun closed => ⟨Ideals.Content (runClass K), Ideals.content_lower _,
     fun r => ⟨fun inside _ he => ⟨r.stretches, ⟨r, inside, Ideals.Ideal.Same.refl _⟩, he⟩,
       fun within => closed r (adheres_iff_hull.mpr within)⟩⟩,
   fun ⟨_, _, h⟩ r adheres => (h r).mpr fun e he =>
     match adheres_iff_adheresBy.mp adheres e he with
     | ⟨r', inside, he'⟩ => (h r').mp inside e he'⟩

/-- **Asked of every process, a refutable reading holds at every run adhering to it exactly under
double-negation elimination.** The witness: in the process of the Boolean sequences, the run of
`false` adheres to "some move is `true`, or `φ`", which is refutable once `¬ ¬ φ`. -/
theorem refutable_holds_iff :
    (∀ (S A : Type) (P : Process S A) (K : Run P → Prop) (r : Run P),
      Refutable K → Adheres K r → K r) ↔ ∀ φ : Prop, ¬ ¬ φ → φ :=
  ⟨fun law φ notNot =>
    match law Unit Bool (Sequences.process Bool) (fun r => Sequences.Eventually r ∨ φ)
        (Sequences.run fun _ => false)
        (fun _ outside => absurd (fun h => outside (.inr h)) notNot)
        (fun h => ⟨Sequences.splice (fun _ => false) h true,
          .inl ⟨h, Sequences.splice_after _ true (Nat.le_refl h)⟩,
          Sequences.splice_agree _ h true⟩) with
    | .inl ⟨_, atTrue⟩ => nomatch atTrue
    | .inr holds => holds,
   fun dne _ _ _ _ _ refutable adheres => dne _ (refutable.not_not adheres)⟩

namespace HistoryIdeals

variable {A : Type v}

/-! ## Words -/

/-- Words ordered by prefix: `v` is below `w` where `w` extends it. -/
def prefixOrder (A : Type v) : Ideals.Preorder (List A) where
  le v w := ∃ t, v ++ t = w
  refl v := ⟨[], ListTests.append_nil v⟩
  trans := fun ⟨t, e⟩ ⟨t', e'⟩ =>
    ⟨t ++ t', (ListTests.append_assoc _ t t').symm.trans ((congrArg (· ++ t') e).trans e')⟩

theorem length_le_of_le {v w : List A} (h : (prefixOrder A).le v w) : v.length ≤ w.length := by
  obtain ⟨t, rfl⟩ := h
  rw [ListTests.length_append]
  exact Nat.le_add_right _ _

theorem append_eq_self : ∀ {v s : List A}, v ++ s = v → s = []
  | [], _, e => e
  | _ :: _, _, e => append_eq_self (List.cons.inj e).2

theorem append_eq_nil_left : ∀ {t t' : List A}, t ++ t' = [] → t = []
  | [], _, _ => rfl
  | _ :: _, _, e => nomatch e

/-- Prefixes of each other are the same word. -/
theorem prefix_antisymm {v w : List A} (h : (prefixOrder A).le v w) (k : (prefixOrder A).le w v) :
    v = w := by
  obtain ⟨t, e⟩ := h
  obtain ⟨t', e'⟩ := k
  have whole : v ++ (t ++ t') = v :=
    (ListTests.append_assoc v t t').symm.trans ((congrArg (· ++ t') e).trans e')
  have ht : t = [] := append_eq_nil_left (append_eq_self whole)
  subst ht
  exact (ListTests.append_nil v).symm.trans e

/-- A word extending `w` and no longer than it is `w`. -/
theorem eq_of_le_of_length_le {w r : List A} (h : (prefixOrder A).le w r)
    (len : r.length ≤ w.length) : w = r := by
  obtain ⟨t, rfl⟩ := h
  cases t with
  | nil => exact (ListTests.append_nil w).symm
  | cons _ t =>
    rw [ListTests.length_append] at len
    exact absurd (Nat.le_trans len (Nat.le_add_right w.length t.length)) (Nat.not_succ_le_self _)

/-- A word is an initial word of a sequence: its moves are the sequence's first moves. -/
def Initial : List A → (Nat → A) → Prop
  | [], _ => True
  | x :: w, a => x = a 0 ∧ Initial w (fun n => a (n + 1))

/-- The word of the first `n` moves of a sequence. -/
def initialWord (a : Nat → A) : Nat → List A
  | 0 => []
  | n + 1 => a 0 :: initialWord (fun m => a (m + 1)) n

theorem initial_append : ∀ {v t : List A} {a : Nat → A}, Initial (v ++ t) a → Initial v a
  | [], _, _, _ => trivial
  | _ :: _, _, _, ⟨head, rest⟩ => ⟨head, initial_append rest⟩

theorem initialWord_initial : ∀ (a : Nat → A) (n : Nat), Initial (initialWord a n) a
  | _, 0 => trivial
  | a, n + 1 => ⟨rfl, initialWord_initial (fun m => a (m + 1)) n⟩

theorem initialWord_length : ∀ (a : Nat → A) (n : Nat), (initialWord a n).length = n
  | _, 0 => rfl
  | a, n + 1 => congrArg (· + 1) (initialWord_length (fun m => a (m + 1)) n)

/-- Two initial words of one sequence: the shorter is a prefix of the longer. -/
theorem initial_le_of_length : ∀ {v w : List A} {a : Nat → A}, Initial v a → Initial w a →
    v.length ≤ w.length → (prefixOrder A).le v w
  | [], w, _, _, _, _ => ⟨w, rfl⟩
  | _ :: _, [], _, _, _, le => absurd le (Nat.not_succ_le_zero _)
  | _ :: _, _ :: _, a, ⟨hx, hv⟩, ⟨hy, hw⟩, le =>
    match initial_le_of_length hv hw (Nat.le_of_succ_le_succ le) with
    | ⟨t, e⟩ => ⟨t, by rw [hx, hy]; exact congrArg (List.cons (a 0)) e⟩

theorem initial_le_initialWord {w : List A} {a : Nat → A} (hw : Initial w a) :
    (prefixOrder A).le w (initialWord a w.length) :=
  initial_le_of_length hw (initialWord_initial a w.length)
    (Nat.le_of_eq (initialWord_length a w.length).symm)

theorem initial_congr : ∀ {w : List A} {a b : Nat → A}, (∀ n, a n = b n) → Initial w a →
    Initial w b
  | [], _, _, _, _ => trivial
  | _ :: _, _, _, h, ⟨hx, hw⟩ => ⟨hx.trans (h 0), initial_congr (fun n => h (n + 1)) hw⟩

theorem initial_initialWord_iff : ∀ {a b : Nat → A} {n : Nat},
    Initial (initialWord a n) b ↔ ∀ i, i < n → a i = b i
  | _, _, 0 => ⟨fun _ i h => absurd h (Nat.not_lt_zero i), fun _ => trivial⟩
  | _, _, _ + 1 =>
    ⟨fun ⟨h0, hrest⟩ i hi => match i, hi with
      | 0, _ => h0
      | i + 1, hi => initial_initialWord_iff.mp hrest i (Nat.lt_of_succ_lt_succ hi),
     fun h => ⟨h 0 (Nat.succ_pos _),
       initial_initialWord_iff.mpr fun i hi => h (i + 1) (Nat.succ_lt_succ hi)⟩⟩

/-- A sequence read as the ideal of its initial words: an infinite history. -/
def traceIdeal (a : Nat → A) : Ideals.Ideal (prefixOrder A) where
  mem w := Initial w a
  nonempty := ⟨[], trivial⟩
  lower := by
    rintro _ _ ⟨t, rfl⟩ hw
    exact initial_append hw
  directed := fun {v w} hv hw => match Nat.lt_or_ge v.length w.length with
    | .inl lt => ⟨w, hw, initial_le_of_length hv hw (Nat.le_of_lt lt), (prefixOrder A).refl w⟩
    | .inr ge => ⟨v, hv, (prefixOrder A).refl v, initial_le_of_length hw hv ge⟩

/-- No sequence is below a word. -/
theorem trace_not_le_principal (a : Nat → A) (w : List A) :
    ¬ Ideals.Ideal.LE (traceIdeal a) (Ideals.principal (prefixOrder A) w) := by
  intro h
  have hl := length_le_of_le (h (initialWord a (w.length + 1)) (initialWord_initial a (w.length + 1)))
  rw [initialWord_length] at hl
  exact Nat.not_succ_le_self _ hl

/-- One sequence is below another exactly where they agree at every place. -/
theorem trace_le_trace_iff {a b : Nat → A} :
    Ideals.Ideal.LE (traceIdeal a) (traceIdeal b) ↔ ∀ n, a n = b n :=
  ⟨fun h n => initial_initialWord_iff.mp (h (initialWord a (n + 1)) (initialWord_initial a (n + 1))) n
      (Nat.lt_succ_self n),
   fun h _ hw => initial_congr h hw⟩

/-- A history: a word, or a sequence of moves. -/
inductive History (A : Type v) where
  | finite : List A → History A
  | infinite : (Nat → A) → History A

/-- A history read as an ideal of words. -/
def historyIdeal : History A → Ideals.Ideal (prefixOrder A)
  | .finite w => Ideals.principal (prefixOrder A) w
  | .infinite a => traceIdeal a

/-- One history is a prefix of another. -/
def HistoryPrefix : History A → History A → Prop
  | .finite v, .finite w => (prefixOrder A).le v w
  | .finite w, .infinite a => Initial w a
  | .infinite _, .finite _ => False
  | .infinite a, .infinite b => ∀ n, a n = b n

/-- **A history's ideal is below another's exactly where it is a prefix of it.** -/
theorem history_le_iff : ∀ h k : History A,
    Ideals.Ideal.LE (historyIdeal h) (historyIdeal k) ↔ HistoryPrefix h k
  | .finite _, .finite _ => Ideals.principal_le_iff
  | .finite _, .infinite _ => Ideals.principal_le_iff
  | .infinite a, .finite w => ⟨trace_not_le_principal a w, False.elim⟩
  | .infinite _, .infinite _ => trace_le_trace_iff

/-- The same history. -/
def SameHistory : History A → History A → Prop
  | .finite v, .finite w => v = w
  | .finite _, .infinite _ => False
  | .infinite _, .finite _ => False
  | .infinite a, .infinite b => ∀ n, a n = b n

/-- **Two histories give ideals with the same words exactly where they are the same history.** -/
theorem historyIdeal_same_iff : ∀ h k : History A,
    Ideals.Ideal.Same (historyIdeal h) (historyIdeal k) ↔ SameHistory h k
  | .finite _, .finite _ =>
    ⟨fun same => prefix_antisymm (Ideals.principal_le_iff.mp same.le)
        (Ideals.principal_le_iff.mp same.ge),
     fun e => by subst e; exact Ideals.Ideal.Same.refl _⟩
  | .finite w, .infinite a => ⟨fun same => trace_not_le_principal a w same.ge, False.elim⟩
  | .infinite a, .finite w => ⟨fun same => trace_not_le_principal a w same.le, False.elim⟩
  | .infinite _, .infinite _ =>
    ⟨fun same => trace_le_trace_iff.mp same.le,
     fun h => Ideals.Ideal.same_of_le (trace_le_trace_iff.mpr h)
       (trace_le_trace_iff.mpr fun n => (h n).symm)⟩

/-! ## Which ideals of words are histories -/

/-- An ideal of words settles where it has a longest word. -/
def HasLongest (I : Ideals.Ideal (prefixOrder A)) : Prop :=
  ∃ w, I.mem w ∧ ∀ v, I.mem v → v.length ≤ w.length

/-- An ideal of words goes on where it has words longer than every length. -/
def GoesOn (I : Ideals.Ideal (prefixOrder A)) : Prop :=
  ∀ n, ∃ w, I.mem w ∧ n < w.length

/-- **An ideal of words with a longest word is a finite history.** -/
theorem hasLongest_principal {I : Ideals.Ideal (prefixOrder A)} (h : HasLongest I) :
    ∃ w, Ideals.Ideal.Same I (Ideals.principal (prefixOrder A) w) := by
  obtain ⟨w, hw, longest⟩ := h
  refine ⟨w, fun v => ⟨fun hv => ?_, fun hv => I.lower hv hw⟩⟩
  obtain ⟨r, hr, hvr, hwr⟩ := I.directed hv hw
  have e : w = r := eq_of_le_of_length_le hwr (longest r hr)
  subst e
  exact hvr

/-- The move at place `n` of a word longer than `n`. -/
def letter : (w : List A) → (n : Nat) → n < w.length → A
  | [], _, h => absurd h (Nat.not_lt_zero _)
  | x :: _, 0, _ => x
  | _ :: w, n + 1, h => letter w n (Nat.lt_of_succ_lt_succ h)

theorem letter_append : ∀ (v t : List A) (n : Nat) (h : n < v.length) (h' : n < (v ++ t).length),
    letter (v ++ t) n h' = letter v n h
  | [], _, _, h, _ => absurd h (Nat.not_lt_zero _)
  | _ :: _, _, 0, _, _ => rfl
  | _ :: v, t, n + 1, _, _ => letter_append v t n _ _

theorem letter_congr {v w : List A} (e : v = w) (n : Nat) (h : n < v.length) (h' : n < w.length) :
    letter v n h = letter w n h' := by
  subst e
  rfl

theorem initial_iff_letter : ∀ (w : List A) (a : Nat → A),
    Initial w a ↔ ∀ n (h : n < w.length), letter w n h = a n
  | [], _ => ⟨fun _ n h => absurd h (Nat.not_lt_zero n), fun _ => trivial⟩
  | _ :: w, _ =>
    ⟨fun ⟨hx, hw⟩ n h => match n, h with
      | 0, _ => hx
      | n + 1, h => (initial_iff_letter w _).mp hw n (Nat.lt_of_succ_lt_succ h),
     fun h => ⟨h 0 (Nat.succ_pos _),
       (initial_iff_letter w _).mpr fun n hn => h (n + 1) (Nat.succ_lt_succ hn)⟩⟩

/-- **An ideal of words going on, with a word of each length picked, is an infinite history**: its
move at each place is the move there of the word picked for that place. -/
theorem goesOn_trace {I : Ideals.Ideal (prefixOrder A)} (pick : Nat → List A)
    (mem : ∀ n, I.mem (pick n)) (long : ∀ n, n < (pick n).length) :
    Ideals.Ideal.Same I (traceIdeal fun n => letter (pick n) n (long n)) := by
  have inside : ∀ w, I.mem w → Initial w (fun n => letter (pick n) n (long n)) := by
    intro w hw
    apply (initial_iff_letter w _).mpr
    intro n hn
    obtain ⟨r, _, hwr, hpr⟩ := I.directed hw (mem n)
    obtain ⟨t, rfl⟩ := hwr
    obtain ⟨t', e⟩ := hpr
    have hr : n < (w ++ t).length := Nat.lt_of_lt_of_le hn (length_le_of_le ⟨t, rfl⟩)
    have hp : n < (pick n ++ t').length :=
      Nat.lt_of_lt_of_le (long n) (length_le_of_le ⟨t', rfl⟩)
    exact (letter_append w t n hn hr).symm.trans
      ((letter_congr e.symm n hr hp).trans (letter_append (pick n) t' n (long n) hp))
  intro w
  refine ⟨inside w, fun hw => ?_⟩
  exact I.lower (initial_le_of_length hw (inside _ (mem w.length)) (Nat.le_of_lt (long w.length)))
    (mem w.length)

/-- **An ideal of words that settles, or goes on with a word of each length picked, is a
history.** -/
theorem classification {I : Ideals.Ideal (prefixOrder A)}
    (decided : HasLongest I ∨
      ∃ pick : Nat → List A, (∀ n, I.mem (pick n)) ∧ ∀ n, n < (pick n).length) :
    ∃ h : History A, Ideals.Ideal.Same I (historyIdeal h) :=
  match decided with
  | .inl settles => match hasLongest_principal settles with
    | ⟨w, same⟩ => ⟨.finite w, same⟩
  | .inr ⟨pick, mem, long⟩ => ⟨.infinite _, goesOn_trace pick mem long⟩

/-- A finite history settles. -/
theorem principal_hasLongest (w : List A) : HasLongest (Ideals.principal (prefixOrder A) w) :=
  ⟨w, (prefixOrder A).refl w, fun _ hv => length_le_of_le hv⟩

/-- An infinite history goes on. -/
theorem trace_goesOn (a : Nat → A) : GoesOn (traceIdeal a) :=
  fun n => ⟨initialWord a (n + 1), initialWord_initial a (n + 1), by
    rw [initialWord_length]
    exact Nat.lt_succ_self n⟩

/-! ## Settling is deciding whether the history goes on -/

/-- The word of `n` moves `()`. -/
def units : Nat → List Unit
  | 0 => []
  | n + 1 => () :: units n

theorem units_length : ∀ n, (units n).length = n
  | 0 => rfl
  | n + 1 => congrArg (· + 1) (units_length n)

/-- Words of `()` are ordered by length. -/
theorem unit_le_of_length : ∀ {v w : List Unit}, v.length ≤ w.length → (prefixOrder Unit).le v w
  | [], w, _ => ⟨w, rfl⟩
  | _ :: _, [], le => absurd le (Nat.not_succ_le_zero _)
  | () :: _, () :: _, le => match unit_le_of_length (Nat.le_of_succ_le_succ le) with
    | ⟨t, e⟩ => ⟨t, congrArg (List.cons ()) e⟩

/-- The history of `()` cut where `s` first turns `true`: the words of `()` before it. -/
def cut (s : Nat → Bool) : Ideals.Ideal (prefixOrder Unit) where
  mem w := ∀ m, m < w.length → s m = false
  nonempty := ⟨[], fun m h => absurd h (Nat.not_lt_zero m)⟩
  lower := fun hvw hw m hm => hw m (Nat.lt_of_lt_of_le hm (length_le_of_le hvw))
  directed := fun {v w} hv hw => match Nat.lt_or_ge v.length w.length with
    | .inl lt => ⟨w, hw, unit_le_of_length (Nat.le_of_lt lt), (prefixOrder Unit).refl w⟩
    | .inr ge => ⟨v, hv, (prefixOrder Unit).refl v, unit_le_of_length ge⟩

/-- A Boolean sequence is `false` below `n`, or has a least `true`. -/
theorem least_true_or_below (s : Nat → Bool) : ∀ n,
    (∀ m, m < n → s m = false) ∨ ∃ k, (∀ m, m < k → s m = false) ∧ s k = true :=
  fun n => (Clear.or_first s n).imp (fun c _ lt => Clear.false_before s c lt)
    fun ⟨k, _, c, yes⟩ => ⟨k, fun _ lt => Clear.false_before s c lt, yes⟩

/-- **Settling or going on, asked of the cut histories, is exactly the limited principle of
omniscience.** The cut history settles where `s` has a `true` and goes on where `s` is `false`
throughout. -/
theorem cut_decided_iff_lpo : (∀ s : Nat → Bool, HasLongest (cut s) ∨ GoesOn (cut s)) ↔ LPO := by
  constructor
  · intro law s
    rcases law s with ⟨w, hw, longest⟩ | goes
    · refine .inl ⟨w.length, ?_⟩
      cases e : s w.length with
      | true => rfl
      | false =>
        have inside : (cut s).mem (units (w.length + 1)) := by
          intro m hm
          rw [units_length] at hm
          rcases Nat.lt_or_eq_of_le (Nat.le_of_lt_succ hm) with lt | eq
          · exact hw m lt
          · rw [eq]
            exact e
        have hl := longest _ inside
        rw [units_length] at hl
        exact absurd hl (Nat.not_succ_le_self _)
    · refine .inr fun m => ?_
      obtain ⟨_, hw, lt⟩ := goes m
      exact hw m lt
  · intro lpo s
    rcases lpo s with ⟨n, hn⟩ | all
    · rcases least_true_or_below s (n + 1) with below | ⟨k, below, hk⟩
      · rw [below n (Nat.lt_succ_self n)] at hn
        exact nomatch hn
      · refine .inl ⟨units k, fun m hm => below m ?_, fun v hv => ?_⟩
        · rw [units_length] at hm
          exact hm
        · rw [units_length]
          rcases Nat.lt_or_ge k v.length with lt | ge
          · have clash := (hv k lt).symm.trans hk
            exact nomatch clash
          · exact ge
    · refine .inr fun n => ⟨units (n + 1), fun m _ => all m, ?_⟩
      rw [units_length]
      exact Nat.lt_succ_self n

/-! ## Classes of histories -/

/-- **A prefix-closed language is a lower set of words.** -/
theorem prefixClosed_iff_lower (L : List A → Prop) :
    HistoryLanguages.PrefixClosed L ↔ Ideals.Lower (prefixOrder A) L :=
  ⟨fun closed => by
     rintro v _ ⟨t, rfl⟩ hw
     exact closed v t hw,
   fun lower pre suffix h => lower ⟨suffix, rfl⟩ h⟩

/-- A history lies within a language: its word is in it, or each of its initial words is. -/
def WithinLanguage (L : List A → Prop) : History A → Prop
  | .finite w => L w
  | .infinite a => ∀ n, L (initialWord a n)

/-- **A history lies within a prefix-closed language exactly where its word, or each of its
initial words, is in it.** -/
theorem history_within_iff {L : List A → Prop} (closed : HistoryLanguages.PrefixClosed L) :
    ∀ h : History A, Ideals.Within (prefixOrder A) L (historyIdeal h) ↔ WithinLanguage L h
  | .finite _ => Ideals.within_principal_iff ((prefixClosed_iff_lower L).mp closed)
  | .infinite a =>
    ⟨fun h n => h _ (initialWord_initial a n),
     fun h w hw => (prefixClosed_iff_lower L).mp closed (initial_le_initialWord hw) (h w.length)⟩

/-- The finite histories, with the infinite histories of the sequences `K` holds. -/
def FiniteOr (K : (Nat → A) → Prop) (I : Ideals.Ideal (prefixOrder A)) : Prop :=
  (∃ w, Ideals.Ideal.Same I (Ideals.principal (prefixOrder A) w)) ∨
    ∃ a, K a ∧ Ideals.Ideal.Same I (traceIdeal a)

/-- **Every ideal of words is in the hull of the finite histories.** -/
theorem finiteOr_hull (K : (Nat → A) → Prop) (I : Ideals.Ideal (prefixOrder A)) :
    Ideals.Hull (FiniteOr K) I :=
  fun w _ => ⟨Ideals.principal _ w, .inl ⟨w, Ideals.Ideal.Same.refl _⟩, (prefixOrder A).refl w⟩

/-- **A sequence outside `K` shows that the finite histories with the infinite histories of `K` are
not refutable.** -/
theorem finiteOr_not_refutable (K : (Nat → A) → Prop) (a : Nat → A)
    (outside : ∀ b, (∀ n, a n = b n) → ¬ K b) : ¬ Ideals.Refutable (FiniteOr K) :=
  fun refutable => Ideals.RefutableBy.not_not refutable (finiteOr_hull K (traceIdeal a)) fun
    | .inl ⟨w, same⟩ => trace_not_le_principal a w same.le
    | .inr ⟨b, hb, same⟩ => outside b (trace_le_trace_iff.mp same.le) hb

/-- **Recurrence is not refutable among histories**: the sequence of `false` does not recur. -/
theorem finiteOr_recurs_not_refutable :
    ¬ Ideals.Refutable (FiniteOr fun a : Nat → Bool => Sequences.Recurs (Sequences.run a)) :=
  finiteOr_not_refutable _ (fun _ => false) fun _ same recurs => match recurs 0 with
    | ⟨m, _, atTrue⟩ => nomatch ((same m).trans atTrue)

/-- **For the sequences, a run passes through a stretch exactly where the stretch's word is an
initial word of its moves.** -/
theorem sequence_stretch_iff (a : Nat → A) (q : Run (Sequences.process A)) (h : Nat) :
    (Sequences.run a).stretches.mem (q, h) ↔ (traceIdeal a).mem (initialWord q.act h) :=
  Sequences.agree_iff.trans initial_initialWord_iff.symm

end HistoryIdeals

/-! ## The laws of ideals on the histories of a process

The ideals of `stretchOrder P` are the histories of the process `P`: the principal ideals are its
finite histories, and its runs are the ideals of the stretches they pass through; a history that
settles, or goes on with its stretches picked, is one or the other (`Stretches.classification`).
Each law of `Becoming.Ideals` is read here on them. -/

namespace Stretches

open HistoryIdeals (HistoryPrefix SameHistory WithinLanguage initialWord)

variable {P : Process S A}

/-! ### What a finite stretch refutes -/

/-- **A refutable class of histories is refutable at runs**: a history of the class's complement
that is a run shows a stretch no history of the class holds, and every run agreeing with it up to
there passes through that stretch. -/
theorem refutable_of_class {C : Ideals.Ideal (stretchOrder P) → Prop}
    (refutable : Ideals.Refutable C) : Refutable fun r : Run P => C r.stretches :=
  refutable_iff_refutableBy.mpr fun r outside => match refutable r.stretches outside with
    | ⟨e, he, blocked⟩ => ⟨e, he, fun r' inside he' => blocked r'.stretches inside he'⟩

/-! ### Adhering is the least closed class -/

/-- **A run adheres to a reading exactly where every closed class of histories holding the
reading's runs holds it.** With closure in place of refutability, no double negation remains
(compare `Refutable.adheres_least`). -/
theorem adheres_iff_closed {K : Run P → Prop} {r : Run P} :
    Adheres K r ↔ ∀ C : Ideals.Ideal (stretchOrder P) → Prop, Ideals.ScottClosed C →
      (∀ r', K r' → C r'.stretches) → C r.stretches :=
  ⟨fun adheres _ hc sub => Ideals.hull_least hc
      (fun _ ⟨r', inside, same⟩ => hc.same (sub r' inside) same.symm) (adheres_iff_hull.mp adheres),
   fun all => adheres_iff_hull.mpr (all _ (Ideals.hull_closed _)
      fun r' inside => Ideals.AdheresBy.of ⟨r', inside, Ideals.Ideal.Same.refl _⟩)⟩

/-- **The closure is unique**: a closed class of histories holding a reading's runs, and below every
closed class holding them, holds exactly the runs adhering to the reading. -/
theorem adherence_unique {K : Run P → Prop} {H : Ideals.Ideal (stretchOrder P) → Prop}
    (hh : Ideals.ScottClosed H) (contains : ∀ r, K r → H r.stretches)
    (least : ∀ E : Ideals.Ideal (stretchOrder P) → Prop, Ideals.ScottClosed E →
      (∀ r, K r → E r.stretches) → ∀ I, H I → E I) (r : Run P) :
    H r.stretches ↔ Adheres K r :=
  (Ideals.hull_unique hh (fun _ ⟨r', inside, same⟩ => hh.same (contains r' inside) same.symm)
      (fun E he sub => least E he fun r' inside => sub _ ⟨r', inside, Ideals.Ideal.Same.refl _⟩)
      r.stretches).trans adheres_iff_hull.symm

/-- **The runs adhering to a reading pass through no stretch that its runs do not.** -/
theorem adheres_content {K : Run P → Prop} {e : Run P × Nat} :
    (∃ r, Adheres K r ∧ r.stretches.mem e) ↔ ∃ r, K r ∧ r.stretches.mem e :=
  ⟨fun ⟨r, adheres, he⟩ => match (Ideals.hull_content (runClass K) e).mp
      ⟨r.stretches, adheres_iff_hull.mp adheres, he⟩ with
    | ⟨_, ⟨r', inside, same⟩, he'⟩ => ⟨r', inside, (same e).mp he'⟩,
   fun ⟨r, inside, he⟩ => ⟨r, Adheres.of inside, he⟩⟩

/-- **Adhering is joint**: any two stretches of a run adhering to a reading are extended by one
stretch of one run of the reading. -/
theorem adheres_joint {K : Run P → Prop} {r : Run P} (adheres : Adheres K r)
    {e e' : Run P × Nat} (he : r.stretches.mem e) (he' : r.stretches.mem e') :
    ∃ r', K r' ∧ ∃ f, r'.stretches.mem f ∧ (stretchOrder P).le e f ∧ (stretchOrder P).le e' f :=
  match Ideals.hull_joint (adheres_iff_hull.mp adheres) he he' with
  | ⟨_, ⟨r', inside, same⟩, f, hf, hef, hef'⟩ => ⟨r', inside, f, (same f).mp hf, hef, hef'⟩

/-! ### Closed and refutable classes of histories -/

/-- **A run lies in a closed class of histories exactly where each of its stretches is a stretch of a
history of the class**: the lower set the class is within is its content. -/
theorem closed_runs {C : Ideals.Ideal (stretchOrder P) → Prop} (hc : Ideals.ScottClosed C)
    (r : Run P) : C r.stretches ↔ ∀ e, r.stretches.mem e → Ideals.Content C e :=
  match (Ideals.closed_iff_lower C).mp hc with
  | ⟨_, hq, h⟩ => (h r.stretches).trans
      ⟨fun within e he => (Ideals.lower_iff_content hq h e).mp (within e he),
       fun content e he => (Ideals.lower_iff_content hq h e).mpr (content e he)⟩

/-- **Where every history leaving a lower set of stretches shows a stretch outside it, the runs within
the set are refutable.** -/
theorem within_refutable {Q : Run P × Nat → Prop} (hq : Ideals.Lower (stretchOrder P) Q)
    (shown : ∀ I, ¬ Ideals.Within (stretchOrder P) Q I → ∃ e, I.mem e ∧ ¬ Q e) :
    Refutable fun r : Run P => Ideals.Within (stretchOrder P) Q r.stretches :=
  refutable_of_class ((Ideals.within_refutable_iff hq).mpr shown)

/-- The one run of the process of `()`s. -/
def unitRun : Run (Sequences.process Unit) := Sequences.run fun _ => ()

/-- Any two runs of the process of `()`s agree up to every horizon. -/
theorem unit_agree (r r' : Run (Sequences.process Unit)) (h : Nat) : r.AgreeUpTo h r' :=
  ⟨fun _ _ => rfl, fun _ _ => rfl⟩

/-- **Asked of every process, a refutable class of histories is closed exactly under double-negation
elimination.** Not being refuted by any finite stretch is not belonging. The witness, on the
process of `()`s: the histories passing through the stretch at horizon 1, with every history where
`φ` holds, are refutable once `¬ ¬ φ`; closed, they would hold the finite history at horizon 0,
which passes through no stretch at horizon 1, so `φ`. -/
theorem refutable_closed_iff :
    (∀ (S A : Type) (P : Process S A) (C : Ideals.Ideal (stretchOrder P) → Prop),
      Ideals.Refutable C → Ideals.ScottClosed C) ↔ ∀ φ : Prop, ¬ ¬ φ → φ :=
  ⟨fun law φ notNot =>
    match (law Unit Unit (Sequences.process Unit) (fun J => J.mem (unitRun, 1) ∨ φ)
        fun _ outside => absurd (fun h => outside (.inr h)) notNot).lower
        (I := Ideals.principal _ (unitRun, 1)) (J := Ideals.principal _ (unitRun, 0))
        (.inl ((stretchOrder _).refl _))
        (Ideals.principal_le_iff.mpr ⟨Nat.zero_le 1, unit_agree _ _ 0⟩) with
    | .inl atOne => absurd atOne.1 (Nat.not_succ_le_zero 0)
    | .inr holds => holds,
   fun dne _ _ P C refutable =>
    Ideals.refutable_closed_iff.mpr dne (Run P × Nat) (stretchOrder P) C refutable⟩

/-- The finite history at horizon 0 of the process of `()`s, extended to horizon 1 where `φ`
holds. -/
def unitCut (φ : Prop) : Ideals.Ideal (stretchOrder (Sequences.process Unit)) where
  mem e := e.2 ≤ 1 ∧ (e.2 = 1 → φ)
  nonempty := ⟨(unitRun, 0), Nat.zero_le 1, fun e => Nat.noConfusion e⟩
  lower := fun ⟨le, _⟩ ⟨le1, imp⟩ => ⟨Nat.le_trans le le1, fun one =>
    imp (Nat.le_antisymm le1 (Eq.subst (motive := fun n => n ≤ _) one le))⟩
  directed := fun {e e'} he he' => match Nat.lt_or_ge e.2 e'.2 with
    | .inl lt => ⟨e', he', ⟨Nat.le_of_lt lt, unit_agree _ _ _⟩, (stretchOrder _).refl e'⟩
    | .inr ge => ⟨e, he, (stretchOrder _).refl e, ⟨ge, unit_agree _ _ _⟩⟩

/-- **Asked of every process, a closed class of histories is refutable exactly under double-negation
elimination.** A history known not to lie within a closed class does not thereby show the stretch
at which it leaves. The witness, on the process of `()`s: the histories within the stretches at
horizon 0; the history reaching horizon 1 where `φ` holds lies outside them once `¬ ¬ φ`, and a
refuting stretch must be at horizon 1. -/
theorem closed_refutable_iff :
    (∀ (S A : Type) (P : Process S A) (C : Ideals.Ideal (stretchOrder P) → Prop),
      Ideals.ScottClosed C → Ideals.Refutable C) ↔ ∀ φ : Prop, ¬ ¬ φ → φ :=
  ⟨fun law φ notNot =>
    match law Unit Unit (Sequences.process Unit) (Ideals.Within _ fun e => e.2 = 0)
        (Ideals.within_closed _) (unitCut φ)
        (fun within => notNot fun h =>
          Nat.noConfusion (within (unitRun, 1) ⟨Nat.le_refl 1, fun _ => h⟩)) with
    | ⟨e, ⟨le1, imp⟩, blocked⟩ => match Nat.lt_or_eq_of_le le1 with
      | .inr one => imp one
      | .inl lt => absurd ((stretchOrder _).refl e) (blocked (Ideals.principal _ e)
          (fun _ le => Nat.eq_zero_of_le_zero (Nat.le_trans le.1 (Nat.le_of_lt_succ lt)))),
   fun dne _ _ P C hc => Ideals.closed_refutable_iff.mpr dne (Run P × Nat) (stretchOrder P) C hc⟩

/-! ### Avoiding a set of stretches -/

/-- **A run adhering to the runs that avoid a set of stretches avoids it**: avoiding is closed, with
no double negation. -/
theorem avoids_adheres {F : Run P × Nat → Prop} {r : Run P}
    (adheres : Adheres (fun r' => Ideals.Avoids F r'.stretches) r) : Ideals.Avoids F r.stretches :=
  adheres_iff_closed.mp adheres _ (Ideals.avoids_closed F) fun _ h => h

/-- **A closed class of histories holding exactly the finite histories that avoid `F` holds exactly
the runs that avoid it.** -/
theorem avoids_runs {C : Ideals.Ideal (stretchOrder P) → Prop} (hc : Ideals.ScottClosed C)
    {F : Run P × Nat → Prop}
    (h : ∀ e, C (Ideals.principal _ e) ↔ ∀ b, F b → ¬ (stretchOrder P).le b e) (r : Run P) :
    C r.stretches ↔ Ideals.Avoids F r.stretches :=
  Ideals.avoids_unique hc h r.stretches

/-- **Avoiding `F` is refutable at runs wherever every history failing to avoid it holds a stretch of
it.** -/
theorem avoids_refutable {F : Run P × Nat → Prop}
    (found : ∀ I : Ideals.Ideal (stretchOrder P), ¬ Ideals.Avoids F I → ∃ b, F b ∧ I.mem b) :
    Refutable fun r : Run P => Ideals.Avoids F r.stretches :=
  refutable_of_class (Ideals.avoids_refutable_of_found found)

/-! ### A lower set's own histories -/

/-- **Every history of the order a lower set of stretches inherits is a history of the process within
the set.** -/
theorem inherited_histories {Q : Run P × Nat → Prop} (hq : Ideals.Lower (stretchOrder P) Q)
    (J : Ideals.Ideal ((stretchOrder P).restrict Q)) :
    ∃ I : Ideals.Ideal (stretchOrder P), ∃ h : Ideals.Within (stretchOrder P) Q I,
      Ideals.Ideal.Same (I.restrict h) J :=
  ⟨Ideals.Ideal.lift hq J, Ideals.lift_within hq J, Ideals.restrict_lift hq J⟩

/-- **Two runs within a lower set of stretches are ordered in the set's own order exactly where they
agree at every horizon.** -/
theorem within_order_iff {Q : Run P × Nat → Prop} (hq : Ideals.Lower (stretchOrder P) Q)
    {r r' : Run P} (h : Ideals.Within (stretchOrder P) Q r.stretches)
    (h' : Ideals.Within (stretchOrder P) Q r'.stretches) :
    Ideals.Ideal.LE (r.stretches.restrict h) (r'.stretches.restrict h') ↔ ∀ t, r.AgreeUpTo t r' :=
  (Ideals.lift_le_iff hq _ _).symm.trans
    ((⟨fun le e he => (Ideals.lift_restrict hq _ h' e).mp (le e ((Ideals.lift_restrict hq _ h e).mpr he)),
       fun le e he => (Ideals.lift_restrict hq _ h' e).mpr (le e ((Ideals.lift_restrict hq _ h e).mp he))⟩ :
      Ideals.Ideal.LE (Ideals.Ideal.lift hq (r.stretches.restrict h))
          (Ideals.Ideal.lift hq (r'.stretches.restrict h')) ↔
        Ideals.Ideal.LE r.stretches r'.stretches).trans Run.stretches_le_iff)

/-! ### The completion: runs among the histories -/

/-- **No run is compact**: among the histories of its process, a run is attained at no finite
stage. -/
theorem run_not_compact (r : Run P) :
    ¬ Ideals.Compact (Ideals.idealComplete (stretchOrder P)) r.stretches :=
  fun compact => match (Ideals.compact_iff_principal r.stretches).mp compact with
    | ⟨e, same⟩ => Run.stretches_not_principal r e same

/-- **A continuous reading of the histories is fixed at every run by its values on finite
histories**: two continuous readings agreeing there with one monotone reading of the stretches
agree at every run, up to the order's equivalence. -/
theorem run_reading_unique {β : Type w} {Q : Ideals.Preorder β} (D : Ideals.DirectedComplete Q)
    {f : Run P × Nat → β} (hf : Ideals.Monotone (stretchOrder P) Q f)
    {g g' : Ideals.Ideal (stretchOrder P) → β}
    (hg : Ideals.Continuous (Ideals.idealComplete _) D g)
    (hg' : Ideals.Continuous (Ideals.idealComplete _) D g')
    (he : ∀ e, Q.Equiv (g (Ideals.principal _ e)) (f e))
    (he' : ∀ e, Q.Equiv (g' (Ideals.principal _ e)) (f e)) (r : Run P) :
    Q.Equiv (g r.stretches) (g' r.stretches) :=
  match Ideals.unique_continuous_extension D f hf with
  | ⟨_, _, _, unique⟩ => (unique g hg he r.stretches).trans (unique g' hg' he' r.stretches).symm

/-- **Finite stretches tell runs apart**: two runs that every reading "extends `e`", extended to
histories, reads alike agree at every horizon. -/
theorem runs_told_apart {r r' : Run P}
    (h : ∀ e, Ideals.extend Ideals.implicationComplete (Ideals.above _ e)
        (Ideals.above_monotone _ e) r.stretches ↔
      Ideals.extend Ideals.implicationComplete (Ideals.above _ e)
        (Ideals.above_monotone _ e) r'.stretches) :
    ∀ t, r.AgreeUpTo t r' :=
  Run.stretches_le_iff.mp (Ideals.above_readings_separate r.stretches r'.stretches h).le

/-- **The finite histories of a process are a compact basis of its histories.** -/
theorem finite_basis (P : Process S A) :
    Ideals.CompactBasis (stretchOrder P) (Ideals.idealComplete (stretchOrder P))
      (Ideals.principal (stretchOrder P)) :=
  Ideals.principal_basis (stretchOrder P)

/-- **The histories of a process are the completion of its stretches**: a directed-complete order
with a compact basis copying the stretches is the order of the process's histories, by an
equivalence the stretches fix in both directions. -/
theorem histories_representation {β : Type w} {Q : Ideals.Preorder β}
    {D : Ideals.DirectedComplete Q} {e : Run P × Nat → β}
    (R : Ideals.CompactBasis (stretchOrder P) D e) :
    ∃ F : Ideals.OrderEquivalence (Ideals.idealOrder (stretchOrder P)) Q,
      (∀ s, Q.Equiv (F.forward (Ideals.principal _ s)) (e s)) ∧
      ∀ G : Ideals.OrderEquivalence (Ideals.idealOrder (stretchOrder P)) Q,
        (∀ s, Q.Equiv (G.forward (Ideals.principal _ s)) (e s)) →
          (∀ I, Q.Equiv (G.forward I) (F.forward I)) ∧
            ∀ y, Ideals.Ideal.Same (G.backward y) (F.backward y) :=
  Ideals.unique_basis_representation R

/-! ### Which histories of a process are runs -/

/-- Two stretches of one history agree at each step both reach. -/
theorem mem_state {I : Ideals.Ideal (stretchOrder P)} {e e' : Run P × Nat} (he : I.mem e)
    (he' : I.mem e') {s : Nat} (hs : s ≤ e.2) (hs' : s ≤ e'.2) : e.1.state s = e'.1.state s :=
  match I.directed he he' with
  | ⟨_, _, ⟨_, agree⟩, ⟨_, agree'⟩⟩ => (agree.1 s hs).trans (agree'.1 s hs').symm

/-- Two stretches of one history take the same move at each step both pass. -/
theorem mem_act {I : Ideals.Ideal (stretchOrder P)} {e e' : Run P × Nat} (he : I.mem e)
    (he' : I.mem e') {s : Nat} (hs : s < e.2) (hs' : s < e'.2) : e.1.act s = e'.1.act s :=
  match I.directed he he' with
  | ⟨_, _, ⟨_, agree⟩, ⟨_, agree'⟩⟩ => (agree.2 s hs).trans (agree'.2 s hs').symm

/-- A history settles where one of its stretches reaches the latest horizon among them. -/
def HasLatest (I : Ideals.Ideal (stretchOrder P)) : Prop :=
  ∃ e, I.mem e ∧ ∀ e', I.mem e' → e'.2 ≤ e.2

/-- A history goes on where it has stretches beyond every horizon. -/
def GoesOn (I : Ideals.Ideal (stretchOrder P)) : Prop :=
  ∀ h, ∃ e, I.mem e ∧ h < e.2

/-- **A history that settles is a finite history.** -/
theorem hasLatest_principal {I : Ideals.Ideal (stretchOrder P)} (h : HasLatest I) :
    ∃ e, Ideals.Ideal.Same I (Ideals.principal _ e) :=
  match h with
  | ⟨e, he, latest⟩ => ⟨e, fun e' =>
      ⟨fun he' => match I.directed he' he with
        | ⟨_, _, ⟨_, agree⟩, ⟨_, agree'⟩⟩ =>
          ⟨latest e' he', agree.trans (agree'.mono (latest e' he')).symm⟩,
       fun le => I.lower le he⟩⟩

/-- The run a history going on gives, with a stretch beyond each horizon picked: at each step, the
configuration and move of the stretch picked for it. -/
def pickedRun {I : Ideals.Ideal (stretchOrder P)} (pick : Nat → Run P × Nat)
    (mem : ∀ h, I.mem (pick h)) (beyond : ∀ h, h < (pick h).2) : Run P where
  state t := (pick t).1.state t
  act t := (pick t).1.act t
  step t := Eq.subst (motive := fun x => P.step ((pick t).1.state t) ((pick t).1.act t) x)
    (mem_state (mem t) (mem (t + 1)) (beyond t) (Nat.le_of_lt (beyond (t + 1))))
    ((pick t).1.step t)

/-- **A history going on, with a stretch beyond each horizon picked, is the history of a run.** -/
theorem goesOn_run {I : Ideals.Ideal (stretchOrder P)} (pick : Nat → Run P × Nat)
    (mem : ∀ h, I.mem (pick h)) (beyond : ∀ h, h < (pick h).2) :
    Ideals.Ideal.Same I (pickedRun pick mem beyond).stretches := fun e =>
  ⟨fun he => ⟨fun s hs => mem_state he (mem s) hs (Nat.le_of_lt (beyond s)),
     fun s hs => mem_act he (mem s) hs (beyond s)⟩,
   fun ⟨states, acts⟩ => I.lower (q := pick e.2)
     ⟨Nat.le_of_lt (beyond e.2),
      ⟨fun s hs => (states s hs).trans
          (mem_state (mem s) (mem e.2) (Nat.le_of_lt (beyond s))
            (Nat.le_trans hs (Nat.le_of_lt (beyond e.2)))),
       fun s hs => (acts s hs).trans
          (mem_act (mem s) (mem e.2) (beyond s) (Nat.lt_trans hs (beyond e.2)))⟩⟩
     (mem e.2)⟩

/-- **A history of a process that settles, or goes on with a stretch beyond each horizon picked, is
a finite history or the history of a run**: A4 of the completion package, for every process. -/
theorem classification {I : Ideals.Ideal (stretchOrder P)}
    (decided : HasLatest I ∨
      ∃ pick : Nat → Run P × Nat, (∀ h, I.mem (pick h)) ∧ ∀ h, h < (pick h).2) :
    (∃ e, Ideals.Ideal.Same I (Ideals.principal _ e)) ∨ ∃ r : Run P, Ideals.Ideal.Same I r.stretches :=
  match decided with
  | .inl settles => .inl (hasLatest_principal settles)
  | .inr ⟨pick, mem, beyond⟩ => .inr ⟨_, goesOn_run pick mem beyond⟩

/-- **A finite history settles.** -/
theorem principal_hasLatest (e : Run P × Nat) : HasLatest (Ideals.principal (stretchOrder P) e) :=
  ⟨e, (stretchOrder P).refl e, fun _ le => le.1⟩

/-- **A run's history goes on.** -/
theorem run_goesOn (r : Run P) : GoesOn r.stretches :=
  fun h => ⟨(r, h + 1), Run.AgreeUpTo.refl r (h + 1), Nat.lt_succ_self h⟩

/-- The history of the process of `()`s cut where `s` first turns `true`: its stretches before
there. -/
def cut (s : Nat → Bool) : Ideals.Ideal (stretchOrder (Sequences.process Unit)) where
  mem e := ∀ m, m < e.2 → s m = false
  nonempty := ⟨(unitRun, 0), fun m h => absurd h (Nat.not_lt_zero m)⟩
  lower := fun ⟨le, _⟩ he m hm => he m (Nat.lt_of_lt_of_le hm le)
  directed := fun {e e'} he he' => match Nat.lt_or_ge e.2 e'.2 with
    | .inl lt => ⟨e', he', ⟨Nat.le_of_lt lt, unit_agree _ _ _⟩, (stretchOrder _).refl e'⟩
    | .inr ge => ⟨e, he, (stretchOrder _).refl e, ⟨ge, unit_agree _ _ _⟩⟩

theorem cut_hasLatest_iff (s : Nat → Bool) : HasLatest (cut s) ↔ HistoryIdeals.HasLongest (HistoryIdeals.cut s) :=
  ⟨fun ⟨e, he, latest⟩ => ⟨HistoryIdeals.units e.2,
     fun m hm => he m (Eq.subst (motive := fun n => m < n) (HistoryIdeals.units_length e.2) hm),
     fun v hv => Eq.subst (motive := fun n => v.length ≤ n) (HistoryIdeals.units_length e.2).symm
       (latest (unitRun, v.length) hv)⟩,
   fun ⟨w, hw, longest⟩ => ⟨(unitRun, w.length), hw, fun e' he' =>
     Eq.subst (motive := fun n => n ≤ w.length) (HistoryIdeals.units_length e'.2)
       (longest (HistoryIdeals.units e'.2)
         fun m hm => he' m (Eq.subst (motive := fun n => m < n) (HistoryIdeals.units_length e'.2) hm))⟩⟩

theorem cut_goesOn_iff (s : Nat → Bool) : GoesOn (cut s) ↔ HistoryIdeals.GoesOn (HistoryIdeals.cut s) :=
  ⟨fun goes n => match goes n with
    | ⟨e, he, lt⟩ => ⟨HistoryIdeals.units e.2,
        fun m hm => he m (Eq.subst (motive := fun k => m < k) (HistoryIdeals.units_length e.2) hm),
        Eq.subst (motive := fun k => n < k) (HistoryIdeals.units_length e.2).symm lt⟩,
   fun goes h => match goes h with
    | ⟨w, hw, lt⟩ => ⟨(unitRun, w.length), hw, lt⟩⟩

/-- **Settling or going on, asked of the cut histories of the process of `()`s, is exactly the
limited principle of omniscience**: telling whether a history ends is deciding whether it changes
again. -/
theorem cut_decided_iff_lpo : (∀ s : Nat → Bool, HasLatest (cut s) ∨ GoesOn (cut s)) ↔ LPO :=
  (show (∀ s : Nat → Bool, HasLatest (cut s) ∨ GoesOn (cut s)) ↔
      ∀ s : Nat → Bool, HistoryIdeals.HasLongest (HistoryIdeals.cut s) ∨
        HistoryIdeals.GoesOn (HistoryIdeals.cut s) from
    ⟨fun law s => match law s with
      | .inl settles => .inl ((cut_hasLatest_iff s).mp settles)
      | .inr goes => .inr ((cut_goesOn_iff s).mp goes),
     fun law s => match law s with
      | .inl settles => .inl ((cut_hasLatest_iff s).mpr settles)
      | .inr goes => .inr ((cut_goesOn_iff s).mpr goes)⟩).trans
    HistoryIdeals.cut_decided_iff_lpo

/-! ### The process of all sequences: runs and the histories of words -/

/-- **For the process of all sequences, one run's history lies below another's exactly where the
history of its moves is a prefix of the other's** (`HistoryIdeals.history_le_iff`). -/
theorem sequences_le_iff {A : Type v} {r r' : Run (Sequences.process A)} :
    Ideals.Ideal.LE r.stretches r'.stretches ↔ HistoryPrefix (.infinite r.act) (.infinite r'.act) :=
  Run.stretches_le_iff.trans
    ((show (∀ t, r.AgreeUpTo t r') ↔ ∀ n, r.act n = r'.act n from
      ⟨fun agree n => Sequences.agree_iff.mp (agree (n + 1)) n (Nat.lt_succ_self n),
       fun acts _ => Sequences.agree_iff.mpr fun t _ => acts t⟩).trans
      (HistoryIdeals.trace_le_trace_iff.symm.trans
        (HistoryIdeals.history_le_iff (.infinite r.act) (.infinite r'.act))))

/-- **For the process of all sequences, two runs have the same history exactly where their moves
are the same history** (`HistoryIdeals.historyIdeal_same_iff`). -/
theorem sequences_same_iff {A : Type v} {r r' : Run (Sequences.process A)} :
    Ideals.Ideal.Same r.stretches r'.stretches ↔ SameHistory (.infinite r.act) (.infinite r'.act) :=
  ⟨fun same => (HistoryIdeals.historyIdeal_same_iff (.infinite r.act) (.infinite r'.act)).mp
      (Ideals.Ideal.same_of_le (HistoryIdeals.trace_le_trace_iff.mpr (sequences_le_iff.mp same.le))
        (HistoryIdeals.trace_le_trace_iff.mpr (sequences_le_iff.mp same.ge))),
   fun moves => Ideals.Ideal.same_of_le (sequences_le_iff.mpr moves)
     (sequences_le_iff.mpr fun n => (moves n).symm)⟩

/-- **A run of the process of all sequences passes only through stretches whose words lie in a
prefix-closed language exactly where each initial word of its moves is in it**
(`HistoryIdeals.history_within_iff`). -/
theorem sequences_within_iff {A : Type v} {L : List A → Prop}
    (closed : HistoryLanguages.PrefixClosed L) (r : Run (Sequences.process A)) :
    (∀ e, r.stretches.mem e → L (initialWord e.1.act e.2)) ↔ WithinLanguage L (.infinite r.act) :=
  (show (∀ e, r.stretches.mem e → L (initialWord e.1.act e.2)) ↔
      Ideals.Within (HistoryIdeals.prefixOrder A) L (HistoryIdeals.traceIdeal r.act) from
    ⟨fun within w hw => (HistoryIdeals.prefixClosed_iff_lower L).mp closed
        (HistoryIdeals.initial_le_initialWord hw)
        (within (r, w.length) (Run.AgreeUpTo.refl r w.length)),
     fun within _ he =>
      within _ (HistoryIdeals.initial_initialWord_iff.mpr (Sequences.agree_iff.mp he))⟩).trans
    (HistoryIdeals.history_within_iff closed (.infinite r.act))

end Stretches

end Becoming
