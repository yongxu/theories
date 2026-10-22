import Becoming.Selection

/-!
# Learning: induction, generalization, training and the meta level

On 12 October 2026 Ren asked how complete the account of the meta level, of artificial neural
networks, of cognition and of the wisdom about learning is. To the answer that none is
complete, which named the problem of induction as undissolved, Ren replied "please, fully
complete, 我觉得理更像是对结构和变化的规律的建模 finish wisdom root, and resolve the
undissolved". This module states, with no premise beyond what each law names, when learning
through a map comes into accord with what follows, what a model of structure and of change
carries beyond the data, what a selection through the data can reach, and what the next level
up is. A course is a sequence of values, such as a determined law's orbit read through a map;
an extrapolation (`pred`) is any map from the prefix before a step to a proposed value or to
silence.

* **No prefix fixes the next value.** Given two values, two courses share any prefix and
  differ at its next step, so a value proposed from the prefix is not right on both
  (`no_prefix_fixes_next`), and, values decided, misses on one of them
  (`claim_missed_on_one`); both are courses of worlds held by a list
  (`no_prefix_fixes_next_finite`, `holdFrom_lasso`). `Web.tail_unexcluded` of `Becoming.Testing`
  is the same law for level histories.
* **No extrapolation rests on every course.** For every extrapolation, on its diagonal course
  each value it proposes misses at its step (`diagonal`, `diagonal_misses`), so on that course it
  rests at no step (`diagonal_unrested`). The diagonal course is a law's orbit, read at its
  latest value, of a law that keeps the whole prefix, a world no list holds (`diagonal_open`).
* **Extrapolation by elimination.** Taking candidates in order and moving to the next exactly
  where the current one misses (`indexOn`, `byElimination`), the extrapolation never passes a
  candidate that accords, so it misses at most that candidate's place (`index_le_of_accords`)
  and not at arbitrarily late steps (`misses_not_recurring`); every candidate passed missed at
  a step of the prefix (`missed_before`). The extrapolation is through the prefix: one prefix,
  one current candidate and one proposed value (`byElimination_through_prefix`).
* **The courses of finitely many configurations are lassos.** Under a determined law whose
  configurations along an orbit are held by a list `l`, the orbit read through any map repeats
  from some step `i` with some period `q + 1`, `i + q + 1 ≤ l.length` (`lasso_of_held`, from
  `revisits_within`); every such course is the course, through a map, of a world held by a list
  (`lasso_realized`).
* **Induction in a world held by a list.** Over the lasso candidates in diagonal order
  (`lassos`, `pairAt`, `pairAt_place`), the extrapolation by elimination, which proposes only
  from the prefix through a map with decided values and is given neither the
  configurations nor their number, misses fewer than `tri l.length` times, proposes at every
  step from `l.length` on and does not miss at arbitrarily late steps
  (`held_byElimination_bounded`, `lasso_byElimination_bounded`); that it comes to rest
  is unrefuted, a double negation (`held_rest_unrefuted`, `rest_unrefuted`). It comes to rest
  only on lasso courses (`lasso_of_rest`). The step at which it rests is not stated here. Its
  prefix never shows that it has come to rest: given two values, every value it proposes
  misses, at that step, on a course of a world held by a list that shares its prefix
  (`no_prefix_fixes_next_finite`). Its diagonal course is no lasso (`diagonal_not_lasso`).
  In `Alternate` it misses twice and accords from the third step on, at the bound
  `tri 1 + 1 = 2`.
* **The meta level.** Classes of candidates merged along the pairs (`merged`) are learned by
  the same elimination, with the bound composed (`merged_bound`); the extrapolation over every
  merging is unrested on its diagonal course (`merged_unrested`).
* **A lumping generalizes exactly where it lumps.** Within the functions going alike across a
  lumping `π` (`Lumped`), finite data fix the value at an untried input exactly where some
  observed input is lumped with it (`determines_lumped_iff`, `lumped_determines`), and the value
  carried over is right exactly where the world takes one value at the two
  (`lumped_right_iff`, `lumped_world_right`). A class free at `x` beyond the data (`Free`)
  determines there only what all its members share (`free_determines_iff`); the class of every
  function is free at every untried input, so data alone fix nothing there (`every_free`,
  `every_determines_nothing`). In `Shift` sharing across positions is right where the world is
  the same at every position and wrong where it differs.
* **Structure and change are one lumping.** A determined law goes alike under `π` exactly where
  its next configuration, read through `π`, goes alike across what `π` lumps
  (`goAlike_iff_lumped`). An outcome taken at one configuration carries over to another exactly
  where the two go alike by that move (`transfer_right_iff`, `goAlike_iff_at`);
  `carries_law_iff` of `Becoming.Mechanism` is the global form.
* **Training is a selection through the data.** A loss computed from the values on the data,
  and every choice made from it, select alike what agrees on the data
  (`Training.loss_through`); the selection through a formation's couplings of `Becoming.Selection`
  is a selection through the classes alike through them (`Training.web_selectsThrough_iff`).
  Within a class free beyond the data every selection through the data leaves the untried value
  as free as the class
  does (`Training.unselected_beyond_data`), and a fit is right beyond the data, for every world
  in the class, exactly where the class determines it (`Training.fit_right_iff`).
* **Selection through a map of the alternatives.** A selection or valuation through a map of the
  alternatives (`Relabel.Equivariant`, `Relabel.EquivariantValue` of `Becoming.Selection`) is a
  selection through the map's lumping (`selects_through_lumping`, `values_lumped`). It is right
  about what matters only where what matters goes alike across that lumping
  (`selects_right_through`, `values_right_lumped`): where what matters separates two
  alternatives the map lumps, none is right (`selects_not_right_of_parted`,
  `values_not_right_of_parted`); where what matters is read off the map, reading it through the
  map is right (`selects_right_of_reads`, `values_right_of_reads`).

**Readings.**
- 理 is, on Ren's reading, the modeling of the laws of structure and of change. A lumping is a
  model of structure; a lumping the step goes alike across is a model of change; the two are
  one notion (`goAlike_iff_lumped`). What such a model carries beyond the data is what it
  lumps with the data, and it is right there exactly where the world goes alike across
  the lumping. This reading of the formal terms is the AI's.
- (The AI's reading of Ren's correction of 16 October 2026, which Ren approved the same day.) A
  selection is as good as the model it goes through. What a model lumps, no selection through it
  separates; separating them takes a finer model, and whether that model is right is its fit to
  what matters, which a longer prefix does not supply: the prefix gives distinctions, not their
  relevance.
- (The AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D26.) Induction is
  resolved into laws rather than certified. No prefix fixes the next value, even among finite
  worlds. No extrapolation rests on every course; the diagonal course of an extrapolation moves
  off each value it proposes and keeps the whole prefix, an open world. In every world held by a
  list extrapolation by elimination misses a number of times bounded by the number of
  configurations, its coming to rest is unrefuted, and its prefix never shows that it has come to
  rest; it rests only there. The uniformity of nature is no premise: it is the local condition of
  a law, that the world goes alike across what the model lumps.
- (The AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D26.) For a trained
  network the class is what training can reach, and the loss selects only through the data.
  Generalization is right exactly where the world goes alike across the lumping that the
  architecture and the updates impose (sharing across positions, invariance, composition);
  explaining it is identifying that lumping and its correspondence to the world, not the loss.
- (The AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D26.) The meta level
  is learning again, over a merged enumeration, and there is no top.

**Classical sources.** Extrapolation by elimination over an enumeration of candidates is what the
literature calls Gold's identification in the limit by enumeration, a learner refuting
hypotheses (Gold 1967, "Language identification in the limit"; Putnam 1965 for trial-and-error
predicates): the extrapolation changes its proposal finitely often and is right from some step
on, with no step at which its prefix shows that it is. The diagonal course on which every
extrapolation misses is the diagonal argument of Putnam (1963) and Gold (1967) that no learner
identifies every course; the reading of induction as convergence without certainty follows Kelly
(1996). What is the spine's own is the form: every extrapolation and course is stated through the
same maps as the rest of the core, no decision is used beyond what each theorem names, and the
rest of the extrapolation by elimination is stated only as unrefuted (`rest_unrefuted`,
`held_rest_unrefuted`, a double negation), its step being given in `Becoming.Identification`.

What is not derived: which candidates, classes or lumpings an actual formation goes through or
can reach; that the values of its map are decided; that its world is held by a list; that an
actual network's architecture and updates impose a given lumping; the correspondence of any of
these to an actual formation that learns. No ethical predicate, ranking or axiom occurs.

`Learning.GoAlikeAt`, `Learning.goAlike_iff_at`, `Learning.transfer_right_iff` and
`Learning.goAlike_iff_lumped` are in `Becoming.LearningRuns`, so this module does not import the
frame (board item W).
* **Read off the map.** What matters goes alike across a map's lumping exactly where it is read off
  the map (`through_iff_reads`), so some selection through the map selects it exactly where the map
  reads it (`selects_right_iff`).
-/

namespace Becoming

universe u v w

namespace Learning

/-! ## A course and its prefix -/

section Record

variable {O : Type u}

/-- The prefix of a course before step `t`, latest first. -/
def prefixOf (o : Nat → O) : Nat → List O
  | 0 => []
  | t + 1 => o t :: prefixOf o t

/-- The prefix before `t` holds `t` values. -/
theorem prefix_length (o : Nat → O) : ∀ t, (prefixOf o t).length = t
  | 0 => rfl
  | t + 1 => congrArg Nat.succ (prefix_length o t)

/-- The prefix before `t` depends only on the course before `t`. -/
theorem prefix_congr {o o' : Nat → O} : ∀ {t : Nat}, (∀ n, n < t → o n = o' n) →
    prefixOf o t = prefixOf o' t
  | 0, _ => rfl
  | t + 1, same =>
    show o t :: prefixOf o t = o' t :: prefixOf o' t from
      congr (congrArg List.cons (same t (Nat.lt_succ_self t)))
        (prefix_congr fun n lt => same n (Nat.lt_trans lt (Nat.lt_succ_self t)))

/-- In the prefix before `u + k + 1`, the value `k + 1` steps back is the value at `u`. -/
theorem back_prefix (o : Nat → O) (u : Nat) : ∀ k, Copying.nth (prefixOf o (u + k + 1)) k = some (o u)
  | 0 => rfl
  | k + 1 => back_prefix o u k

/-- Before `t`, every value `k + 1 ≤ t` steps back is in the prefix. -/
theorem back_made (o : Nat → O) {k t : Nat} (within : k < t) : ∃ v, Copying.nth (prefixOf o t) k = some v :=
  let ⟨d, at_t⟩ := gap_of_lt within
  ⟨o d, (congrArg (fun n => Copying.nth (prefixOf o n) k)
    (at_t.trans (congrArg Nat.succ (Nat.add_comm k d)))).trans (back_prefix o d k)⟩

/-- A proposal, made or not (silence), misses a value: a value was proposed and the value that
comes differs. -/
def Misses (c : Option O) (v : O) : Prop := ∃ w, c = some w ∧ w ≠ v

/-- Values decided, a miss is decided. -/
instance decMisses [DecidableEq O] : (c : Option O) → (v : O) → Decidable (Misses c v)
  | none, _ => isFalse fun ⟨_, made, _⟩ => nomatch made
  | some w, v =>
    match decEq w v with
    | isTrue same => isFalse fun ⟨_, made, differs⟩ =>
      differs ((Option.some.inj made).symm.trans same)
    | isFalse differs => isTrue ⟨w, rfl, differs⟩

/-- A value proposed that does not miss a value is that value. -/
theorem eq_of_not_missed [DecidableEq O] {w v : O} (unrefuted : ¬ Misses (some w) v) : w = v :=
  match decEq w v with
  | isTrue same => same
  | isFalse differs => absurd ⟨w, rfl, differs⟩ unrefuted

/-- A proposed value does not miss itself. -/
theorem not_missed_self {v : O} : ¬ Misses (some v) v :=
  fun ⟨_, made, differs⟩ => differs (Option.some.inj made).symm

/-- The value `pred` proposes at step `t`, from the prefix before `t`, misses on `o`. -/
def MissesAt (pred : List O → Option O) (o : Nat → O) (t : Nat) : Prop :=
  Misses (pred (prefixOf o t)) (o t)

instance decMissesAt [DecidableEq O] (pred : List O → Option O) (o : Nat → O) (t : Nat) :
    Decidable (MissesAt pred o t) :=
  decMisses _ _

/-- `pred` accords with `o`: it misses at no step, so every value it proposes on `o` is right. -/
def Accords (pred : List O → Option O) (o : Nat → O) : Prop := ∀ t, ¬ MissesAt pred o t

end Record

/-! ## No prefix fixes what comes next -/

section Ahead

variable {O : Type u}

/-- The course `o` before `t`, and `x` from `t` on. -/
def holdFrom (o : Nat → O) (t : Nat) (x : O) (n : Nat) : O := if n < t then o n else x

theorem holdFrom_before (o : Nat → O) {t : Nat} (x : O) {n : Nat} (before : n < t) :
    holdFrom o t x n = o n :=
  if_pos before

theorem holdFrom_after (o : Nat → O) {t : Nat} (x : O) {n : Nat} (after : t ≤ n) :
    holdFrom o t x n = x :=
  if_neg fun before => Nat.lt_irrefl n (Nat.lt_of_lt_of_le before after)

/-- **No prefix fixes the next value.** For every course and every step `t`, given two values
there are two courses with the same prefix before `t`, taking the one value and the other at
`t`; a value proposed from that prefix is not right on both. Nothing about the course is
assumed. -/
theorem no_prefix_fixes_next (pred : List O → Option O) (o : Nat → O) (t : Nat) {x y : O}
    (two : x ≠ y) {w : O} (claims : pred (prefixOf o t) = some w) :
    prefixOf (holdFrom o t x) t = prefixOf o t ∧ prefixOf (holdFrom o t y) t = prefixOf o t ∧
      holdFrom o t x t = x ∧ holdFrom o t y t = y ∧
      ¬ (¬ MissesAt pred (holdFrom o t x) t ∧ ¬ MissesAt pred (holdFrom o t y) t) :=
  have same_x : prefixOf (holdFrom o t x) t = prefixOf o t :=
    prefix_congr fun _ before => holdFrom_before o x before
  have same_y : prefixOf (holdFrom o t y) t = prefixOf o t :=
    prefix_congr fun _ before => holdFrom_before o y before
  have at_x : holdFrom o t x t = x := holdFrom_after o x (Nat.le_refl t)
  have at_y : holdFrom o t y t = y := holdFrom_after o y (Nat.le_refl t)
  ⟨same_x, same_y, at_x, at_y, fun ⟨right_x, right_y⟩ =>
    right_x ⟨w, (congrArg pred same_x).trans claims, fun to_x =>
      right_y ⟨w, (congrArg pred same_y).trans claims, fun to_y =>
        two ((to_x.trans at_x).symm.trans (to_y.trans at_y))⟩⟩⟩

/-- **Values decided, a value proposed from the prefix misses on one of the two courses.** -/
theorem claim_missed_on_one [DecidableEq O] (pred : List O → Option O) (o : Nat → O) (t : Nat)
    {x y : O} (two : x ≠ y) {w : O} (claims : pred (prefixOf o t) = some w) :
    MissesAt pred (holdFrom o t x) t ∨ MissesAt pred (holdFrom o t y) t :=
  have same_x : prefixOf (holdFrom o t x) t = prefixOf o t :=
    prefix_congr fun _ before => holdFrom_before o x before
  have same_y : prefixOf (holdFrom o t y) t = prefixOf o t :=
    prefix_congr fun _ before => holdFrom_before o y before
  match decEq w x with
  | isTrue at_x => .inr ⟨w, (congrArg pred same_y).trans claims, fun to_y =>
      two (at_x.symm.trans (to_y.trans (holdFrom_after o y (Nat.le_refl t))))⟩
  | isFalse off => .inl ⟨w, (congrArg pred same_x).trans claims, fun to_x =>
      off (to_x.trans (holdFrom_after o x (Nat.le_refl t)))⟩

end Ahead

/-! ## The diagonal: a course on which every proposed value misses -/

section Diagonal

variable {O : Type u}

/-- The value set against a proposal: `other w` where `w` is proposed, `x` where none is. -/
def answerTo (other : O → O) (x : O) : Option O → O
  | some w => other w
  | none => x

/-- One step of the law of `pred`'s diagonal course: the value set against its proposal joins
the prefix. -/
def answerStep (pred : List O → Option O) (other : O → O) (x : O) (l : List O) : List O :=
  answerTo other x (pred l) :: l

/-- The course on which every value `pred` proposes misses: the latest value of the orbit of the
law `answerStep`, which keeps the whole prefix. -/
def diagonal (pred : List O → Option O) (other : O → O) (x : O) (t : Nat) : O :=
  answerTo other x (pred (Law.orbit (answerStep pred other x) [] t))

/-- The prefix of the diagonal course is the orbit of the law that keeps it. -/
theorem prefix_diagonal (pred : List O → Option O) (other : O → O) (x : O) :
    ∀ t, prefixOf (diagonal pred other x) t = Law.orbit (answerStep pred other x) [] t
  | 0 => rfl
  | t + 1 => congrArg (List.cons (diagonal pred other x t)) (prefix_diagonal pred other x t)

/-- **Every proposed value misses on the diagonal course.** Where `other` moves every value,
every value `pred` proposes on its diagonal course misses at its step. It holds of every
`pred`: of every extrapolation, whatever candidates it goes through and however it revises. -/
theorem diagonal_misses (pred : List O → Option O) {other : O → O} (moves : ∀ v, other v ≠ v)
    (x : O) {t : Nat} {w : O} (claims : pred (prefixOf (diagonal pred other x) t) = some w) :
    MissesAt pred (diagonal pred other x) t :=
  have at_orbit : pred (Law.orbit (answerStep pred other x) [] t) = some w :=
    (congrArg pred (prefix_diagonal pred other x t)).symm.trans claims
  have answered : diagonal pred other x t = other w := congrArg (answerTo other x) at_orbit
  ⟨w, claims, fun same => moves w (same.trans answered).symm⟩

/-- **No extrapolation comes to rest on every course.** On the diagonal course of `pred` there
is no step from which on `pred` proposes a value and is right. -/
theorem diagonal_unrested (pred : List O → Option O) {other : O → O} (moves : ∀ v, other v ≠ v)
    (x : O) : ¬ ∃ T, ∀ t, T ≤ t → pred (prefixOf (diagonal pred other x) t) =
      some (diagonal pred other x t) :=
  fun ⟨T, rests⟩ =>
    match diagonal_misses pred moves x (rests T (Nat.le_refl T)) with
    | ⟨_, made, differs⟩ =>
      differs (Option.some.inj ((rests T (Nat.le_refl T)).symm.trans made)).symm

/-- The law keeping the prefix holds `t` values at step `t`. -/
theorem answer_orbit_length (pred : List O → Option O) (other : O → O) (x : O) :
    ∀ t, (Law.orbit (answerStep pred other x) [] t).length = t
  | 0 => rfl
  | t + 1 => congrArg Nat.succ (answer_orbit_length pred other x t)

/-- **The diagonal world is open.** No list holds the configurations of the law whose orbit,
read at its latest value, is the diagonal course: it keeps the whole prefix, so it never returns
(`unlisted_of_new` of `Becoming.Recurrence`). -/
theorem diagonal_open (pred : List O → Option O) (other : O → O) (x : O) :
    ¬ ∃ l : List (List O), ∀ n, Law.orbit (answerStep pred other x) [] n ∈ l :=
  unlisted_of_new fun i j lt same =>
    Nat.ne_of_lt lt ((answer_orbit_length pred other x i).symm.trans
      ((congrArg List.length same).trans (answer_orbit_length pred other x j)))

/-- Another value: with two values told apart, `swapTo x y v` differs from `v`. -/
def swapTo [DecidableEq O] (x y : O) (v : O) : O := if v = x then y else x

theorem swapTo_moves [DecidableEq O] {x y : O} (two : x ≠ y) : ∀ v, swapTo x y v ≠ v :=
  fun v => match decEq v x with
  | isTrue at_x => fun same =>
    two (at_x.symm.trans (same.symm.trans (if_pos at_x)))
  | isFalse off => fun same => off ((if_neg off).symm.trans same).symm

end Diagonal

/-! ## Extrapolation by elimination -/

section Refutation

variable {O : Type u} [DecidableEq O]

/-- Elimination over candidates `H`: from a prefix, the index of the current candidate,
starting at `0` and moving to the next exactly where the current one misses. The index is the
number of misses so far. -/
def indexOn (H : Nat → List O → Option O) : List O → Nat
  | [] => 0
  | v :: l => if Misses (H (indexOn H l) l) v then indexOn H l + 1 else indexOn H l

/-- The extrapolation by elimination: the value proposed by the current candidate. -/
def byElimination (H : Nat → List O → Option O) (l : List O) : Option O := H (indexOn H l) l

/-- The index held at step `t` of `o`. -/
abbrev index (H : Nat → List O → Option O) (o : Nat → O) (t : Nat) : Nat :=
  indexOn H (prefixOf o t)

variable {H : Nat → List O → Option O} {o : Nat → O}

theorem index_missed {t : Nat} (refuted : MissesAt (byElimination H) o t) :
    index H o (t + 1) = index H o t + 1 :=
  if_pos refuted

theorem index_kept {t : Nat} (kept : ¬ MissesAt (byElimination H) o t) :
    index H o (t + 1) = index H o t :=
  if_neg kept

theorem index_succ_le (t : Nat) : index H o (t + 1) ≤ index H o t + 1 :=
  match decMissesAt (byElimination H) o t with
  | isTrue refuted => Nat.le_of_eq (index_missed refuted)
  | isFalse kept => Nat.le_trans (Nat.le_of_eq (index_kept kept)) (Nat.le_succ _)

theorem index_le_succ (t : Nat) : index H o t ≤ index H o (t + 1) :=
  match decMissesAt (byElimination H) o t with
  | isTrue refuted => Nat.le_trans (Nat.le_succ _) (Nat.le_of_eq (index_missed refuted).symm)
  | isFalse kept => Nat.le_of_eq (index_kept kept).symm

theorem index_mono (t : Nat) : ∀ d, index H o t ≤ index H o (t + d)
  | 0 => Nat.le_refl _
  | d + 1 => Nat.le_trans (index_mono t d) (index_le_succ (t + d))

theorem index_mono_le {T t : Nat} (le : T ≤ t) : index H o T ≤ index H o t :=
  let ⟨d, at_t⟩ := le_dest le
  Eq.subst (motive := fun n => index H o T ≤ index H o n) at_t.symm (index_mono T d)

/-- **The extrapolation by elimination never passes a candidate that accords.** Where candidate
`j` misses at no step of `o`, the current candidate is never beyond `j`: it misses at most `j`
times. -/
theorem index_le_of_accords {j : Nat} (holds : Accords (H j) o) : ∀ t, index H o t ≤ j
  | 0 => Nat.zero_le j
  | t + 1 =>
    match Nat.lt_or_ge (index H o t) j with
    | .inl below => Nat.le_trans (index_succ_le t) below
    | .inr reached =>
      have at_j : index H o t = j := Nat.le_antisymm (index_le_of_accords holds t) reached
      have kept : ¬ MissesAt (byElimination H) o t := fun refuted =>
        holds t (Eq.subst (motive := fun n => Misses (H n (prefixOf o t)) (o t)) at_j refuted)
      Nat.le_of_eq ((index_kept kept).trans at_j)

/-- **Every candidate passed missed at a step of the prefix.** Each candidate before the current
one at `t` was current at some earlier step and missed there. -/
theorem missed_before : ∀ (t k : Nat), k < index H o t →
    ∃ s, s < t ∧ index H o s = k ∧ MissesAt (H k) o s
  | 0, k, below => absurd below (Nat.not_lt_zero k)
  | t + 1, k, below =>
    match decMissesAt (byElimination H) o t with
    | isTrue refuted =>
      have below' : k ≤ index H o t :=
        Nat.le_of_lt_succ (Eq.subst (motive := fun n => k < n) (index_missed refuted) below)
      match Nat.lt_or_eq_of_le below' with
      | .inl earlier =>
        let ⟨s, before, held, refuted_s⟩ := missed_before t k earlier
        ⟨s, Nat.lt_trans before (Nat.lt_succ_self t), held, refuted_s⟩
      | .inr at_k =>
        ⟨t, Nat.lt_succ_self t, at_k.symm,
          Eq.subst (motive := fun n => Misses (H n (prefixOf o t)) (o t)) at_k.symm refuted⟩
    | isFalse kept =>
      let ⟨s, before, held, refuted_s⟩ :=
        missed_before t k (Eq.subst (motive := fun n => k < n) (index_kept kept) below)
      ⟨s, Nat.lt_trans before (Nat.lt_succ_self t), held, refuted_s⟩

/-- Misses at arbitrarily late steps raise the index past every bound. -/
theorem index_unbounded (late : ∀ T, ∃ t, T ≤ t ∧ MissesAt (byElimination H) o t) :
    ∀ m, ∃ T, m ≤ index H o T
  | 0 => ⟨0, Nat.zero_le _⟩
  | m + 1 =>
    let ⟨T, reached⟩ := index_unbounded late m
    let ⟨t, later, refuted⟩ := late T
    ⟨t + 1, Nat.le_trans (Nat.succ_le_succ (Nat.le_trans reached (index_mono_le later)))
      (Nat.le_of_eq (index_missed refuted).symm)⟩

/-- **Misses do not recur where a candidate accords.** Where some candidate misses at no step
of `o`, the extrapolation by elimination does not miss at arbitrarily late steps. -/
theorem misses_not_recurring {j : Nat} (holds : Accords (H j) o) :
    ¬ ∀ T, ∃ t, T ≤ t ∧ MissesAt (byElimination H) o t :=
  fun late =>
    let ⟨T, reached⟩ := index_unbounded late (j + 1)
    Nat.not_succ_le_self j (Nat.le_trans reached (index_le_of_accords holds T))

/-- **The extrapolation is through the prefix.** On two courses with the same prefix before
`t`, the current candidate and the proposed value at `t` are the same. -/
theorem byElimination_through_prefix {o' : Nat → O} {t : Nat} (same : prefixOf o t = prefixOf o' t) :
    index H o t = index H o' t ∧ byElimination H (prefixOf o t) = byElimination H (prefixOf o' t) :=
  ⟨congrArg (indexOn H) same, congrArg (byElimination H) same⟩

/-- That a bounded sequence of counts that never falls is constant from some step on is
unrefuted (a double negation). -/
theorem stable_unrefuted {f : Nat → Nat} (mono : ∀ t, f t ≤ f (t + 1)) {K : Nat}
    (bound : ∀ t, f t ≤ K) : ¬ ¬ ∃ T, ∀ t, T ≤ t → f t = f T :=
  have mono_add : ∀ T d, f T ≤ f (T + d) := fun T d =>
    Nat.rec (motive := fun d => f T ≤ f (T + d)) (Nat.le_refl _)
      (fun d ih => Nat.le_trans ih (mono (T + d))) d
  have mono_le : ∀ {T t}, T ≤ t → f T ≤ f t := fun le =>
    let ⟨d, at_t⟩ := le_dest le
    Eq.subst (motive := fun n => f _ ≤ f n) at_t.symm (mono_add _ d)
  have climb : ∀ m T, K ≤ f T + m → ¬ ¬ ∃ T, ∀ t, T ≤ t → f t = f T := fun m =>
    Nat.rec (motive := fun m => ∀ T, K ≤ f T + m → ¬ ¬ ∃ T, ∀ t, T ≤ t → f t = f T)
      (fun T top never => never ⟨T, fun t later =>
        Nat.le_antisymm (Nat.le_trans (bound t) top) (mono_le later)⟩)
      (fun m ih T room never =>
        have moves : ¬ ¬ ∃ t, T ≤ t ∧ f t ≠ f T := fun still =>
          never ⟨T, fun t later => match Nat.decEq (f t) (f T) with
            | isTrue same => same
            | isFalse differs => absurd ⟨t, later, differs⟩ still⟩
        moves fun ⟨t, later, differs⟩ =>
          have rose : f T + 1 ≤ f t :=
            Nat.lt_of_le_of_ne (mono_le later) (fun same => differs same.symm)
          ih t (Nat.le_trans room
            (Nat.le_trans (Nat.le_of_eq (Nat.succ_add (f T) m).symm)
              (Nat.add_le_add_right rose m))) never)
      m
  climb K 0 (Nat.le_add_left K (f 0))

end Refutation

/-! ## Lassos: the courses of finitely many configurations -/

section Lassos

variable {O : Type u}

/-- From step `i` on, the course repeats with period `q + 1`. -/
def Lasso (o : Nat → O) (i q : Nat) : Prop := ∀ u, i ≤ u → o (u + (q + 1)) = o u

/-- **A world held by a list has a lasso course.** Under a determined law whose configurations
along an orbit are held by a list `l`, the orbit read through any map repeats, from some step
`i` on, with some period `q + 1`, where `i + q + 1 ≤ l.length` (from `revisits_within`). -/
theorem lasso_of_held {S : Type v} {next : S → S} {s : S} {l : List S}
    (held : ∀ n, Law.orbit next s n ∈ l) (reg : S → O) :
    ∃ i q, i + q + 1 ≤ l.length ∧ Lasso (fun n => reg (Law.orbit next s n)) i q :=
  let ⟨i, _, lt, within, same⟩ := revisits_within l (Law.orbit next s) (fun n _ => held n)
  let ⟨q, at_j⟩ := gap_of_lt lt
  have back_to : Law.orbit next s (i + (q + 1)) = Law.orbit next s i :=
    (congrArg (Law.orbit next s) at_j).symm.trans same.symm
  ⟨i, q, Eq.subst (motive := fun n => n ≤ l.length) at_j within, fun _ later =>
    let ⟨d, at_u⟩ := le_dest later
    congrArg reg
      ((congrArg (fun n => Law.orbit next s (n + (q + 1))) at_u).trans
        ((congrArg (Law.orbit next s) (Nat.add_right_comm i d (q + 1))).trans
          ((Law.orbit_add next s (i + (q + 1)) d).trans
            ((congrArg (fun x => Law.orbit next x d) back_to).trans
              ((Law.orbit_add next s i d).symm.trans
                (congrArg (Law.orbit next s) at_u.symm))))))⟩

/-- The law of a lasso world: positions `0, …, i + q`, each going to the next, the last to `i`. -/
def lassoNext (i q : Nat) (n : Nat) : Nat := if n < i + q then n + 1 else i

/-- Along the lasso world, the position stays within `i + q` and the course read from it agrees
with the course from the step on. -/
theorem lasso_positions {o : Nat → O} {i q : Nat} (lasso : Lasso o i q) :
    ∀ n, Law.orbit (lassoNext i q) 0 n ≤ i + q ∧
      ∀ k, o (Law.orbit (lassoNext i q) 0 n + k) = o (n + k)
  | 0 => ⟨Nat.zero_le _, fun _ => rfl⟩
  | n + 1 =>
    let ⟨within, agree⟩ := lasso_positions lasso n
    match Nat.lt_or_ge (Law.orbit (lassoNext i q) 0 n) (i + q) with
    | .inl inside =>
      have moved : Law.orbit (lassoNext i q) 0 (n + 1) = Law.orbit (lassoNext i q) 0 n + 1 :=
        if_pos inside
      ⟨Eq.subst (motive := fun p => p ≤ i + q) moved.symm inside, fun k =>
        (congrArg (fun p => o (p + k)) moved).trans
          ((congrArg o (Nat.succ_add _ k)).trans
            ((agree (k + 1)).trans (congrArg o (Nat.succ_add n k).symm)))⟩
    | .inr last =>
      have at_last : Law.orbit (lassoNext i q) 0 n = i + q := Nat.le_antisymm within last
      have wrapped : Law.orbit (lassoNext i q) 0 (n + 1) = i :=
        if_neg fun inside => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le inside last)
      ⟨Eq.subst (motive := fun p => p ≤ i + q) wrapped.symm (Nat.le_add_right i q), fun k =>
        (congrArg (fun p => o (p + k)) wrapped).trans
          ((lasso (i + k) (Nat.le_add_right i k)).symm.trans
            ((congrArg o (congrArg Nat.succ (Nat.add_right_comm i k q))).trans
              ((congrArg (fun p => o (p + (k + 1))) at_last).symm.trans
                ((agree (k + 1)).trans (congrArg o (Nat.succ_add n k).symm)))))⟩

/-- **A lasso course is the course of a world held by a list.** The lasso world on positions
`0, …, i + q` is held by the list of its positions and, read through `o`, takes the values of
`o` at every step. -/
theorem lasso_realized {o : Nat → O} {i q : Nat} (lasso : Lasso o i q) :
    (∀ n, Law.orbit (lassoNext i q) 0 n ∈ downFrom (i + q)) ∧
      ∀ n, o (Law.orbit (lassoNext i q) 0 n) = o n :=
  ⟨fun n => mem_downFrom (lasso_positions lasso n).1, fun n => (lasso_positions lasso n).2 0⟩

/-- A course held at one value from step `t` on repeats from `t` with period `1`. -/
theorem holdFrom_lasso (o : Nat → O) (t : Nat) (x : O) : Lasso (holdFrom o t x) t 0 :=
  fun u later => (holdFrom_after o x (Nat.le_trans later (Nat.le_succ u))).trans
    (holdFrom_after o x later).symm

/-- **Not even within finite worlds does a prefix fix the next value.** The two courses of
`no_prefix_fixes_next` are lasso courses, so courses of worlds held by a list
(`lasso_realized`): whatever value an extrapolation proposes next from a prefix, it misses in
some finite world with that prefix. -/
theorem no_prefix_fixes_next_finite (pred : List O → Option O) (o : Nat → O) (t : Nat)
    {x y : O} (two : x ≠ y) {w : O} (claims : pred (prefixOf o t) = some w) :
    Lasso (holdFrom o t x) t 0 ∧ Lasso (holdFrom o t y) t 0 ∧
      prefixOf (holdFrom o t x) t = prefixOf o t ∧ prefixOf (holdFrom o t y) t = prefixOf o t ∧
      ¬ (¬ MissesAt pred (holdFrom o t x) t ∧ ¬ MissesAt pred (holdFrom o t y) t) :=
  let ⟨same_x, same_y, _, _, one⟩ := no_prefix_fixes_next pred o t two claims
  ⟨holdFrom_lasso o t x, holdFrom_lasso o t y, same_x, same_y, one⟩

/-- The lasso candidate `h = (i, q)`: at a step `t` with `i + q + 1 ≤ t` it proposes the value
`q + 1` steps back; before, it stays silent. -/
def lasso (h : Nat × Nat) (l : List O) : Option O :=
  if h.1 + h.2 + 1 ≤ l.length then Copying.nth l h.2 else none

theorem lasso_claims {o : Nat → O} {h : Nat × Nat} {t : Nat} (within : h.1 + h.2 + 1 ≤ t) :
    lasso h (prefixOf o t) = Copying.nth (prefixOf o t) h.2 :=
  if_pos (Eq.subst (motive := fun n => h.1 + h.2 + 1 ≤ n) (prefix_length o t).symm within)

theorem lasso_silent {o : Nat → O} {h : Nat × Nat} {t : Nat} (early : t < h.1 + h.2 + 1) :
    lasso h (prefixOf o t) = none :=
  if_neg fun within => Nat.lt_irrefl t (Nat.lt_of_lt_of_le early
    (Eq.subst (motive := fun n => h.1 + h.2 + 1 ≤ n) (prefix_length o t) within))

/-- **A lasso candidate accords with its course.** -/
theorem lasso_accords {o : Nat → O} {i q : Nat} (repeats : Lasso o i q) : Accords (lasso (i, q)) o :=
  fun t ⟨_, claims, differs⟩ =>
    match Nat.lt_or_ge t (i + q + 1) with
    | .inl early => nomatch (lasso_silent (o := o) (h := (i, q)) early).symm.trans claims
    | .inr within =>
      let ⟨d, at_t⟩ := le_dest within
      have at_t' : t = i + d + q + 1 :=
        at_t.trans ((Nat.add_right_comm (i + q) 1 d).trans
          (congrArg Nat.succ (Nat.add_right_comm i q d)))
      have value : lasso (i, q) (prefixOf o t) = some (o (i + d)) :=
        (lasso_claims (o := o) (h := (i, q)) within).trans
          ((congrArg (fun n => Copying.nth (prefixOf o n) q) at_t').trans (back_prefix o (i + d) q))
      differs ((Option.some.inj (claims.symm.trans value)).trans
        ((repeats (i + d) (Nat.le_add_right i d)).symm.trans (congrArg o at_t'.symm)))

end Lassos

/-! ## The lasso candidates in order -/

section Order

/-- The next pair along the diagonals: `(0, q)` to `(q + 1, 0)`, `(i + 1, q)` to `(i, q + 1)`. -/
def nextPair : Nat × Nat → Nat × Nat
  | (0, q) => (q + 1, 0)
  | (i + 1, q) => (i, q + 1)

/-- The pair at place `k`: `(0, 0), (1, 0), (0, 1), (2, 0), (1, 1), (0, 2), …`. -/
def pairAt : Nat → Nat × Nat
  | 0 => (0, 0)
  | k + 1 => nextPair (pairAt k)

/-- Triangular numbers: `tri (m + 1) = tri m + m + 1`. -/
def tri : Nat → Nat
  | 0 => 0
  | m + 1 => tri m + m + 1

/-- The diagonal of a pair. -/
def diag (h : Nat × Nat) : Nat := h.1 + h.2

theorem pairAt_walk : ∀ j {k i q : Nat}, pairAt k = (i + j, q) → pairAt (k + j) = (i, q + j)
  | 0, _, _, _, at_k => at_k
  | j + 1, k, i, q, at_k =>
    have step : pairAt (k + 1) = (i + j, q + 1) := congrArg nextPair at_k
    (congrArg pairAt (Nat.succ_add k j).symm).trans
      ((pairAt_walk j step).trans (congrArg (Prod.mk i) (Nat.succ_add q j)))

/-- The diagonal `m` starts at place `tri m`. -/
theorem pairAt_tri : ∀ m, pairAt (tri m) = (m, 0)
  | 0 => rfl
  | m + 1 =>
    have walked : pairAt (tri m + m) = (0, 0 + m) :=
      pairAt_walk m ((pairAt_tri m).trans (congrArg (fun a => (a, 0)) (Nat.zero_add m).symm))
    show nextPair (pairAt (tri m + m)) = (m + 1, 0) from
      (congrArg nextPair walked).trans (congrArg (fun a => (a + 1, 0)) (Nat.zero_add m))

/-- **Every pair has its place.** `(i, q)` is at place `tri (i + q) + q`. -/
theorem pairAt_place (i q : Nat) : pairAt (tri (i + q) + q) = (i, q) :=
  (pairAt_walk q (pairAt_tri (i + q))).trans (congrArg (Prod.mk i) (Nat.zero_add q))

theorem diag_next : ∀ h : Nat × Nat, diag h ≤ diag (nextPair h)
  | (0, q) => Nat.le_trans (Nat.le_of_eq (Nat.zero_add q)) (Nat.le_succ q)
  | (i + 1, q) => Nat.le_of_eq (Nat.add_right_comm i 1 q)

theorem diag_mono (k : Nat) : ∀ d, diag (pairAt k) ≤ diag (pairAt (k + d))
  | 0 => Nat.le_refl _
  | d + 1 => Nat.le_trans (diag_mono k d) (diag_next (pairAt (k + d)))

theorem diag_le {k k' : Nat} (le : k ≤ k') : diag (pairAt k) ≤ diag (pairAt k') :=
  let ⟨d, at_k'⟩ := le_dest le
  Eq.subst (motive := fun n => diag (pairAt k) ≤ diag (pairAt n)) at_k'.symm (diag_mono k d)

theorem tri_mono (m : Nat) : ∀ d, tri m ≤ tri (m + d)
  | 0 => Nat.le_refl _
  | d + 1 => Nat.le_trans (tri_mono m d)
      (Nat.le_trans (Nat.le_add_right (tri (m + d)) (m + d)) (Nat.le_succ _))

/-- The place of `(i, q)` comes before the start of the next diagonal. -/
theorem place_lt (i q : Nat) : tri (i + q) + q < tri (i + q + 1) :=
  Nat.succ_le_succ (Nat.add_le_add_left (Nat.le_add_left q i) (tri (i + q)))

/-- The lasso candidates in the order of their pairs. -/
def lassos {O : Type u} : Nat → List O → Option O := fun k => lasso (pairAt k)

end Order

/-! ## Learning a lasso course -/

section LearningLassos

variable {O : Type u} [DecidableEq O] {o : Nat → O}

/-- **On a lasso course the misses of elimination are bounded.** On a course repeating from step
`i` with period `q + 1`, the extrapolation by elimination over the lasso candidates, which is
given neither `i` nor `q`: its current candidate is never beyond place `tri (i + q) + q`,
so it misses at most that many times; it proposes at every step from `i + q + 1` on; and it does
not miss at arbitrarily late steps. -/
theorem lasso_byElimination_bounded {i q : Nat} (repeats : Lasso o i q) :
    (∀ t, index lassos o t ≤ tri (i + q) + q) ∧
      (∀ t, i + q + 1 ≤ t → ∃ v, byElimination lassos (prefixOf o t) = some v) ∧
      ¬ ∀ T, ∃ t, T ≤ t ∧ MissesAt (byElimination lassos) o t :=
  have holds : Accords (lassos (tri (i + q) + q)) o :=
    Eq.subst (motive := fun h => Accords (lasso h) o) (pairAt_place i q).symm (lasso_accords repeats)
  have bound := index_le_of_accords holds
  ⟨bound, fun t within =>
    have near : diag (pairAt (index lassos o t)) ≤ i + q :=
      Nat.le_trans (diag_le (bound t)) (Nat.le_of_eq (congrArg diag (pairAt_place i q)))
    have claims_at : (pairAt (index lassos o t)).1 + (pairAt (index lassos o t)).2 + 1 ≤ t :=
      Nat.le_trans (Nat.succ_le_succ near) within
    let ⟨v, found⟩ := back_made o (Nat.lt_of_le_of_lt
      (Nat.le_add_left (pairAt (index lassos o t)).2 (pairAt (index lassos o t)).1)
      (Nat.lt_of_lt_of_le
        (Nat.lt_succ_self ((pairAt (index lassos o t)).1 + (pairAt (index lassos o t)).2))
        claims_at))
    ⟨v, (lasso_claims claims_at).trans found⟩,
   misses_not_recurring holds⟩

/-- **On a lasso course, that elimination comes to rest is unrefuted.** It is not refuted that
from some step on it proposes at every step and is right (a double negation); the step is not
stated here. Its prefix never shows that it rests: given two values, a value proposed from a
prefix is not right on both of two courses that share the prefix and differ at its next
step (`no_prefix_fixes_next`). -/
theorem rest_unrefuted {i q : Nat} (repeats : Lasso o i q) :
    ¬ ¬ ∃ T, ∀ t, T ≤ t → byElimination lassos (prefixOf o t) = some (o t) :=
  let ⟨bound, claims, _⟩ := lasso_byElimination_bounded repeats
  fun never => stable_unrefuted (f := index lassos o) index_le_succ bound fun ⟨T, stays⟩ =>
    never ⟨T + (i + q + 1), fun t later =>
      have after_T : T ≤ t := Nat.le_trans (Nat.le_add_right T _) later
      have kept : ¬ MissesAt (byElimination lassos) o t := fun refuted =>
        Nat.ne_of_lt (Nat.lt_succ_self (index lassos o t))
          (((stays t after_T).trans (stays (t + 1) (Nat.le_succ_of_le after_T)).symm).trans
            (index_missed refuted))
      let ⟨_, made⟩ := claims t (Nat.le_trans (Nat.le_add_left _ T) later)
      made.trans (congrArg some (eq_of_not_missed fun refuted =>
        kept (Eq.subst (motive := fun c => Misses c (o t)) made.symm refuted)))⟩

/-- **Elimination over the lasso candidates comes to rest only on lasso courses.** Where from
step `T` on it proposes at every step and is right, the course repeats from some step on. -/
theorem lasso_of_rest {T : Nat} (rests : ∀ t, T ≤ t → byElimination lassos (prefixOf o t) = some (o t)) :
    ∃ i q, Lasso o i q :=
  have kept : ∀ t, T ≤ t → ¬ MissesAt (byElimination lassos) o t := fun t later =>
    Eq.subst (motive := fun c => ¬ Misses c (o t)) (rests t later).symm not_missed_self
  have stays : ∀ d, index lassos o (T + d) = index lassos o T := fun d =>
    Nat.rec (motive := fun d => index lassos o (T + d) = index lassos o T) rfl
      (fun d ih => (index_kept (kept (T + d) (Nat.le_add_right T d))).trans ih) d
  let h := pairAt (index lassos o T)
  ⟨h.1 + T, h.2, fun u later =>
    have past_T : T ≤ u + h.2 + 1 :=
      Nat.le_trans (Nat.le_add_left T h.1)
        (Nat.le_trans later (Nat.le_trans (Nat.le_add_right u h.2) (Nat.le_succ _)))
    have held : index lassos o (u + h.2 + 1) = index lassos o T :=
      let ⟨e, at_t⟩ := le_dest past_T
      Eq.subst (motive := fun n => index lassos o n = index lassos o T) at_t.symm (stays e)
    have within : h.1 + h.2 + 1 ≤ u + h.2 + 1 :=
      Nat.succ_le_succ (Nat.add_le_add_right
        (Nat.le_trans (Nat.le_add_right h.1 T) later) h.2)
    have claim : byElimination lassos (prefixOf o (u + h.2 + 1)) = some (o u) :=
      (congrArg (fun n => lasso (pairAt n) (prefixOf o (u + h.2 + 1))) held).trans
        ((lasso_claims within).trans (back_prefix o u h.2))
    (Option.some.inj ((rests (u + h.2 + 1) past_T).symm.trans claim))⟩

/-- **Induction in a world held by a list: the misses are bounded.** Under a determined law
whose configurations along an orbit are held by a list `l`, the extrapolation by elimination
over the lasso candidates, proposing from the orbit's prefix through a map `reg` with decided
values and given neither the configurations nor their number: misses fewer than
`tri l.length` times; proposes at every step from `l.length` on; and does not miss at
arbitrarily late steps. -/
theorem held_byElimination_bounded {S : Type v} {next : S → S} {s : S} {l : List S}
    (held : ∀ n, Law.orbit next s n ∈ l) (reg : S → O) :
    (∀ t, index lassos (fun n => reg (Law.orbit next s n)) t < tri l.length) ∧
      (∀ t, l.length ≤ t →
        ∃ v, byElimination lassos (prefixOf (fun n => reg (Law.orbit next s n)) t) = some v) ∧
      ¬ ∀ T, ∃ t, T ≤ t ∧ MissesAt (byElimination lassos) (fun n => reg (Law.orbit next s n)) t :=
  let ⟨i, q, within, repeats⟩ := lasso_of_held held reg
  let ⟨bound, claims, stop⟩ := lasso_byElimination_bounded repeats
  have top : tri (i + q) + q < tri l.length :=
    Nat.lt_of_lt_of_le (place_lt i q)
      (let ⟨d, at_l⟩ := le_dest within
       Eq.subst (motive := fun n => tri (i + q + 1) ≤ tri n) at_l.symm (tri_mono _ d))
  ⟨fun t => Nat.lt_of_le_of_lt (bound t) top,
   fun t later => claims t (Nat.le_trans within later), stop⟩

/-- **Induction in a world held by a list: that elimination comes to rest is unrefuted.** Under
a determined law whose configurations along an orbit are held by a list, it is not refuted that
from some step on the extrapolation by elimination over the lasso candidates proposes at every
step and is right (a double negation). -/
theorem held_rest_unrefuted {S : Type v} {next : S → S} {s : S} {l : List S}
    (held : ∀ n, Law.orbit next s n ∈ l) (reg : S → O) :
    ¬ ¬ ∃ T, ∀ t, T ≤ t → byElimination lassos (prefixOf (fun n => reg (Law.orbit next s n)) t) =
      some (reg (Law.orbit next s t)) :=
  let ⟨_, _, _, repeats⟩ := lasso_of_held held reg
  rest_unrefuted repeats

/-- **The diagonal world is no lasso.** The diagonal course of elimination over the lasso
candidates repeats from no step: it is the course of no world held by a list. -/
theorem diagonal_not_lasso {other : O → O} (moves : ∀ v, other v ≠ v) (x : O) {i q : Nat} :
    ¬ Lasso (diagonal (byElimination lassos) other x) i q :=
  fun repeats => rest_unrefuted repeats fun ⟨T, rests⟩ =>
    diagonal_unrested (byElimination lassos) moves x ⟨T, rests⟩

end LearningLassos

/-! ## The meta level: learning over classes -/

section Meta

variable {O : Type u} [DecidableEq O] {o : Nat → O}

/-- Classes of candidates merged into one enumeration along the pairs. -/
def merged (G : Nat → Nat → List O → Option O) : Nat → List O → Option O :=
  fun k => G (pairAt k).1 (pairAt k).2

/-- **Learning over classes is elimination again.** Where candidate `j` of class `c` accords,
the current candidate of elimination over the merged enumeration is never beyond place
`tri (c + j) + j`: choosing a class is learning with the same law, one enumeration wider. -/
theorem merged_bound (G : Nat → Nat → List O → Option O) {c j : Nat} (holds : Accords (G c j) o) :
    ∀ t, index (merged G) o t ≤ tri (c + j) + j :=
  index_le_of_accords (H := merged G)
    (Eq.subst (motive := fun h : Nat × Nat => Accords (G h.1 h.2) o) (pairAt_place c j).symm holds)

/-- **Elimination over every merging is unrested on its diagonal course.** However the classes
are chosen and merged, every value elimination over them proposes on its diagonal course misses,
and no list holds that world (`diagonal_misses`, `diagonal_open`). Read as no top level:
learning at the next level up is again learning, and again incomplete. -/
theorem merged_unrested (G : Nat → Nat → List O → Option O) {other : O → O} (moves : ∀ v, other v ≠ v)
    (x : O) : ¬ ∃ T, ∀ t, T ≤ t → byElimination (merged G) (prefixOf (diagonal (byElimination (merged G))
      other x) t) = some (diagonal (byElimination (merged G)) other x t) :=
  diagonal_unrested (byElimination (merged G)) moves x

end Meta

/-! ## Generalization: a lumping and what it carries -/

section Lumping

variable {I : Type u} {V : Type v} {K : Type w}

/-- Within the class `C`, the values on the data `D` fix the value at `x`. -/
def Determines (C : (I → V) → Prop) (D : I → Prop) (x : I) : Prop :=
  ∀ g g', C g → C g' → (∀ i, D i → g i = g' i) → g x = g' x

/-- `g` goes alike across what `π` lumps: inputs alike under `π` take one value. -/
def Lumped (π : I → K) (g : I → V) : Prop := ∀ i i', π i = π i' → g i = g i'

/-- The class `C` is free at `x` beyond the data `D`: every member's values on the data combine
with every member's value at `x`. -/
def Free (C : (I → V) → Prop) (D : I → Prop) (x : I) : Prop :=
  ∀ g g', C g → C g' → ∃ h, C h ∧ (∀ i, D i → h i = g i) ∧ h x = g' x

/-- Whether some observed input is lumped with `x` is decided by telling lumps apart. -/
def decideSeen [DecidableEq K] (π : I → K) (x : I) :
    (data : List I) → Decidable (∃ d, d ∈ data ∧ π d = π x)
  | [] => isFalse fun ⟨_, mem, _⟩ => nomatch mem
  | a :: l =>
    match decEq (π a) (π x) with
    | isTrue same => isTrue ⟨a, List.Mem.head l, same⟩
    | isFalse differs =>
      match decideSeen π x l with
      | isTrue found => isTrue (match found with
        | ⟨d, mem, same⟩ => ⟨d, List.Mem.tail a mem, same⟩)
      | isFalse unseen => isFalse fun ⟨d, mem, same⟩ =>
        match mem_cons_split mem with
        | .inl at_a => differs (Eq.subst (motive := fun e => π e = π x) at_a same)
        | .inr mem' => unseen ⟨d, mem', same⟩

/-- A lumping that puts `x` with an observed input lets the data fix the value at `x`. -/
theorem lumped_determines {π : I → K} {D : I → Prop} {x : I} (seen : ∃ d, D d ∧ π d = π x) :
    Determines (Lumped (V := V) π) D x :=
  fun _ _ lumped lumped' agree =>
    let ⟨d, at_d, same⟩ := seen
    (lumped x d same.symm).trans ((agree d at_d).trans (lumped' d x same))

/-- **A lumping generalizes exactly where it lumps.** Within the functions going alike across
`π`, finite data fix the value at `x` exactly where some observed input is lumped with `x`,
given two values. -/
theorem determines_lumped_iff [DecidableEq K] {π : I → K} {data : List I} {x : I} {y z : V}
    (two : y ≠ z) :
    Determines (Lumped (V := V) π) (· ∈ data) x ↔ ∃ d, d ∈ data ∧ π d = π x :=
  ⟨fun determines =>
    match decideSeen π x data with
    | isTrue seen => seen
    | isFalse unseen =>
      absurd ((determines (fun _ => y) (fun i => if π i = π x then z else y)
          (fun _ _ _ => rfl)
          (fun _ _ same => congrArg (fun k => if k = π x then z else y) same)
          (fun d at_d => (if_neg fun same => unseen ⟨d, at_d, same⟩).symm)).trans
        (if_pos rfl)) two,
   lumped_determines⟩

/-- **The transfer is right exactly where the world goes alike across the lumping.** A member
of the class fitting the world `f` on the data takes at `x` the value of an observed input
lumped with `x`; it is right exactly where `f` takes one value at the two. -/
theorem lumped_right_iff {π : I → K} {D : I → Prop} {f g : I → V} {x d : I}
    (lumped : Lumped π g) (fits : ∀ i, D i → g i = f i) (at_d : D d) (same : π d = π x) :
    g x = f x ↔ f d = f x :=
  have transfer : g x = f d := (lumped x d same.symm).trans (fits d at_d)
  ⟨fun right => transfer.symm.trans right, fun alike => transfer.trans alike⟩

/-- A world going alike across the lumping is learned at every input lumped with an observed
one. -/
theorem lumped_world_right {π : I → K} {D : I → Prop} {f g : I → V} {x d : I}
    (world : Lumped π f) (lumped : Lumped π g) (fits : ∀ i, D i → g i = f i) (at_d : D d)
    (same : π d = π x) : g x = f x :=
  (lumped_right_iff lumped fits at_d same).mpr (world d x same)

/-- **A class free beyond the data determines nothing there but what all its members share.** -/
theorem free_determines_iff {C : (I → V) → Prop} {D : I → Prop} {x : I} (free : Free C D x) :
    Determines C D x ↔ ∀ g g', C g → C g' → g x = g' x :=
  ⟨fun determines g g' member member' =>
    let ⟨h, member_h, agree, at_x⟩ := free g g' member member'
    (determines g h member member_h fun i at_i => (agree i at_i).symm).trans at_x,
   fun shared g g' member member' _ => shared g g' member member'⟩

/-- Every function: the class lumping nothing is free at every input not observed. -/
theorem every_free [DecidableEq I] {D : I → Prop} {x : I} (unseen : ¬ D x) :
    Free (fun _ : I → V => True) D x :=
  fun g g' _ _ => ⟨fun i => if i = x then g' x else g i, trivial,
    fun _ at_i => if_neg fun same => unseen (Eq.subst (motive := D) same at_i), if_pos rfl⟩

/-- **Data alone fix no untried value.** Within every function, given two values, the data
fix the value at no input they do not hold. -/
theorem every_determines_nothing [DecidableEq I] {D : I → Prop} {x : I} (unseen : ¬ D x)
    {y z : V} (two : y ≠ z) : ¬ Determines (fun _ : I → V => True) D x :=
  fun determines =>
    two ((free_determines_iff (every_free unseen)).mp determines (fun _ => y) (fun _ => z)
      trivial trivial)

end Lumping

/-! ## Structure and change: one lumping -/

/-! ## Training as selection -/

namespace Training

variable {X : Type u} {I : Type u} {V : Type v}

/-- A selection among candidates is through a relation of being alike: alike candidates are
selected alike. -/
def Through (alike : X → X → Prop) (select : X → Prop) : Prop :=
  ∀ x x', alike x x' → (select x ↔ select x')

/-- Two functions agree on the data. -/
def AgreeOn (D : I → Prop) (g g' : I → V) : Prop := ∀ i, D i → g i = g' i

/-- P64's selection through a formation's couplings is a selection through the classes of
histories alike through them. -/
theorem web_selectsThrough_iff {F C : Type} {W : Web F C} {obs : F → C → Prop} {f : F}
    {t : Nat} {select : (Nat → C → Nat) → Prop} :
    W.SelectsThrough obs f t select ↔
      Through (fun l l' => W.AlikeThroughUpTo obs f l l' t) select :=
  Iff.rfl

/-- **A loss on the data selects through the data.** A loss computed from the values on the
data, and every choice made from it, select alike two functions agreeing on the data. -/
theorem loss_through {D : I → Prop} {L : Type w} (loss : (I → V) → L)
    (on_data : ∀ g g', AgreeOn D g g' → loss g = loss g') (choose : L → Prop) :
    Through (AgreeOn D) (fun g => choose (loss g)) :=
  fun g g' agree =>
    have same : choose (loss g) = choose (loss g') := congrArg choose (on_data g g' agree)
    ⟨Eq.mp same, Eq.mpr same⟩

/-- **Training through the data leaves the untried value as free as the class leaves it.**
Every selection through the data, within a class free at `x` beyond the data: for every
selected member and every value a member takes at `x`, a selected member agreeing with it on
the data takes that value. -/
theorem unselected_beyond_data {C : (I → V) → Prop} {D : I → Prop} {x : I}
    {select : (I → V) → Prop} (through : Through (AgreeOn D) select) (free : Free C D x)
    {g g' : I → V} (member : C g) (member' : C g') (chosen : select g) :
    ∃ h, C h ∧ select h ∧ AgreeOn D h g ∧ h x = g' x :=
  let ⟨h, member_h, agree, at_x⟩ := free g g' member member'
  ⟨h, member_h, (through h g agree).mpr chosen, agree, at_x⟩

/-- **A fit is right beyond the data exactly where the class determines it.** Every member of
`C` agreeing on the data with a world in `C` takes the world's value at `x`, for every such
world, exactly where the data determine the value at `x` within `C`. For a trained network,
`C` is what the training can reach: the architecture, the starting points and the dynamics of
the updates, not the loss. -/
theorem fit_right_iff {C : (I → V) → Prop} {D : I → Prop} {x : I} :
    (∀ f g, C f → C g → AgreeOn D g f → g x = f x) ↔ Determines C D x :=
  ⟨fun right g g' member member' agree => right g' g member' member agree,
   fun determines f g member member' agree =>
    determines g f member' member agree⟩

end Training

/-! ## Selection through a map of the alternatives

A selector tells alternatives apart through its map of them, an entry for each alternative
(`Becoming.Selection`, namespace `Relabel`); the map lumps together the alternatives it gives one
entry. A selection through the map is a selection through that lumping, and it is right about
what matters only where what matters goes alike across the lumping. -/

section Model

open Relabel

variable {K : Type u} {V : Type v} {W : Type w} [DecidableEq K]

/-- **A selection through a map is a selection through its lumping.** Alternatives the map `r`
lumps together are selected alike. -/
theorem selects_through_lumping {select : (K → V) → K → Prop} (equivariant : Equivariant select)
    (r : K → V) : Training.Through (fun i i' => r i = r i') (select r) :=
  fun _ _ tie => equivariant.tied tie

/-- A valuation through a model goes alike across what the model lumps. -/
theorem values_lumped {value : (K → V) → K → W} (equivariant : EquivariantValue value)
    (r : K → V) : Lumped r (value r) :=
  fun _ _ tie => equivariant.tied tie

/-- **A selection through a map is right about what matters only where what matters goes
alike across the map's lumping.** If a selection through `r` selects exactly the alternatives
satisfying `p`, then `p` holds alike of alternatives `r` lumps together. -/
theorem selects_right_through {select : (K → V) → K → Prop} (equivariant : Equivariant select)
    {r : K → V} {p : K → Prop} (right : ∀ i, select r i ↔ p i) :
    Training.Through (fun i i' => r i = r i') p :=
  fun i i' tie => (right i).symm.trans ((equivariant.tied tie).trans (right i'))

/-- **What a map lumps, no selection through it can separate.** Where `p` holds of one of two
alternatives the map `r` lumps together and not of the other, no selection through `r` selects
exactly the alternatives satisfying `p`: that takes a finer map. -/
theorem selects_not_right_of_parted {select : (K → V) → K → Prop}
    (equivariant : Equivariant select) {r : K → V} {p : K → Prop} {j k : K} (tie : r j = r k)
    (holds : p j) (fails : ¬ p k) : ¬ ∀ i, select r i ↔ p i :=
  fun right => fails ((selects_right_through equivariant right j k tie).mp holds)

/-- **A map reading what matters selects it.** Where `p` is read off the map `r` through
`q`, the selection reading every map through `q` is a selection through the map, and it
selects exactly the alternatives satisfying `p`. -/
theorem selects_right_of_reads {r : K → V} {p : K → Prop} (q : V → Prop)
    (reads : ∀ i, p i ↔ q (r i)) :
    Equivariant (fun (r' : K → V) (i : K) => q (r' i)) ∧ ∀ i, q (r i) ↔ p i :=
  ⟨fun _ _ _ _ relabel i => iff_of_eq (congrArg q (relabel i)), fun i => (reads i).symm⟩

/-- A valuation through a map gives every alternative the value `f` that matters only where `f`
goes alike across the map's lumping. -/
theorem values_right_lumped {value : (K → V) → K → W} (equivariant : EquivariantValue value)
    {r : K → V} {f : K → W} (right : ∀ i, value r i = f i) : Lumped r f :=
  fun i i' tie => (right i).symm.trans ((equivariant.tied tie).trans (right i'))

/-- Where `f` parts two alternatives the map `r` lumps together, no valuation through `r` gives
every alternative its value under `f`. -/
theorem values_not_right_of_parted {value : (K → V) → K → W}
    (equivariant : EquivariantValue value) {r : K → V} {f : K → W} {j k : K} (tie : r j = r k)
    (parted : f j ≠ f k) : ¬ ∀ i, value r i = f i :=
  fun right => parted (values_right_lumped equivariant right j k tie)

/-- Where `f` is read off the map `r` through `h`, the valuation reading every map through
`h` is a valuation through the map, and it gives every alternative its value under `f`. -/
theorem values_right_of_reads {r : K → V} {f : K → W} (h : V → W) (reads : ∀ i, f i = h (r i)) :
    EquivariantValue (fun (r' : K → V) (i : K) => h (r' i)) ∧ ∀ i, h (r i) = f i :=
  ⟨fun _ _ _ _ relabel i => congrArg h (relabel i), fun i => (reads i).symm⟩

omit [DecidableEq K] in
/-- **Going alike across a lumping is being read off the map.** What matters goes alike across the
alternatives the map `r` lumps together exactly where it is read off the map: through what holds
of some alternative the map gives that entry. -/
theorem through_iff_reads {r : K → V} {p : K → Prop} :
    Training.Through (fun i i' => r i = r i') p ↔ ∃ q : V → Prop, ∀ i, p i ↔ q (r i) :=
  ⟨fun through => ⟨fun v => ∃ j, r j = v ∧ p j, fun i =>
      ⟨fun holds => ⟨i, rfl, holds⟩, fun ⟨j, tie, holds⟩ => (through j i tie).mp holds⟩⟩,
   fun ⟨q, reads⟩ i i' tie => (reads i).trans ((iff_of_eq (congrArg q tie)).trans (reads i').symm)⟩

/-- **Some selection through a map selects what matters exactly where the map reads it.** A
selection through `r` selecting exactly the alternatives satisfying `p` exists exactly where `p`
goes alike across the lumping of `r`, which is exactly where `p` is read off `r`. -/
theorem selects_right_iff {r : K → V} {p : K → Prop} :
    (∃ select : (K → V) → K → Prop, Equivariant select ∧ ∀ i, select r i ↔ p i) ↔
      ∃ q : V → Prop, ∀ i, p i ↔ q (r i) :=
  ⟨fun ⟨_, equivariant, right⟩ => through_iff_reads.mp (selects_right_through equivariant right),
   fun ⟨q, reads⟩ => ⟨_, selects_right_of_reads q reads⟩⟩

end Model

/-! ## Witnesses -/

namespace Shift

/-! Inputs are a position and a content. The lumping reads the content and forgets the
position: one value for a content wherever it stands. Two inputs at the first position are
observed. -/

/-- The content, wherever it stands. -/
def content : Bool × Bool → Bool := fun i => i.2

/-- The observed inputs: both contents at the first position. -/
def data : List (Bool × Bool) := [(false, false), (false, true)]

/-- A world that is the same at every position. -/
def same : Bool × Bool → Bool := fun i => i.2

/-- A world that differs between positions. -/
def both : Bool × Bool → Bool := fun i => i.1 && i.2

/-- **Sharing across positions fixes the untried position.** -/
theorem determines : Determines (Lumped (V := Bool) content) (· ∈ data) (true, true) :=
  lumped_determines ⟨(false, true), List.Mem.tail _ (List.Mem.head _), rfl⟩

/-- **Every function fixes nothing there.** -/
theorem every_nothing : ¬ Determines (fun _ : Bool × Bool → Bool => True) (· ∈ data) (true, true) :=
  every_determines_nothing (fun mem => match mem with
    | .tail _ (.tail _ mem') => nomatch mem') (y := false) (z := true)
    (fun same => Bool.noConfusion same)

/-- **Right where the world is the same at every position.** The content read alone fits the
world `same` on the data and is right at the untried input. -/
theorem right_same : content (true, true) = same (true, true) :=
  lumped_world_right (π := content) (D := (· ∈ data)) (f := same) (g := content) (x := (true, true))
    (d := (false, true))
    (fun _ _ alike => alike) (fun _ _ alike => alike) (fun _ _ => rfl)
    (List.Mem.tail _ (List.Mem.head _)) rfl

/-- **Wrong where it differs between positions.** The function that is `false` everywhere goes
alike across the lumping and fits the world `both` on the data, and is wrong at the untried
input, where `both` differs from its observed input of the same content. -/
theorem wrong_both : Lumped content (fun _ : Bool × Bool => false) ∧
    (∀ i, i ∈ data → (fun _ : Bool × Bool => false) i = both i) ∧
    (fun _ : Bool × Bool => false) (true, true) ≠ both (true, true) :=
  have fits : ∀ i, i ∈ [((false, false) : Bool × Bool), (false, true)] →
      (fun _ : Bool × Bool => false) i = both i := fun i mem =>
    match i, mem with
    | _, .head _ => rfl
    | _, .tail _ (.head _) => rfl
    | _, .tail _ (.tail _ mem') => nomatch mem'
  ⟨fun _ _ _ => rfl, fits, fun right => Bool.noConfusion
    ((lumped_right_iff (π := content) (f := both) (g := fun _ => false) (x := (true, true))
      (d := (false, true)) (fun _ _ _ => rfl) fits (List.Mem.tail _ (List.Mem.head _))
      rfl).mp right)⟩

end Shift

namespace Alternate

/-! The course `false, true, false, true, …`: a lasso from step `0` with period `2`. -/

/-- The alternating course. -/
def course (t : Nat) : Bool := Law.orbit not false t

/-- It repeats with period `2` from the start. -/
theorem repeats : Lasso course 0 1 :=
  fun u _ => show (!!(course u)) = course u from
    match course u with
    | true => rfl
    | false => rfl

/-- Elimination misses twice, at steps `1` and `2`, and its current candidate is `(0, 1)`
from step `3` on. -/
theorem index_three : index lassos course 3 = 2 := rfl

/-- **Two misses, then rest.** From step `3` on the current candidate is `(0, 1)`, the place
`tri 1 + 1 = 2` of `lasso_byElimination_bounded`, and each value it proposes is right. -/
theorem rests : ∀ t, 3 ≤ t → byElimination lassos (prefixOf course t) = some (course t) :=
  fun t later =>
    have held : index lassos course t = 2 :=
      Nat.le_antisymm ((lasso_byElimination_bounded repeats).1 t)
        (Nat.le_trans (Nat.le_of_eq index_three.symm) (index_mono_le later))
    let ⟨d, at_t⟩ := le_dest (Nat.le_trans (Nat.le_succ 2) later)
    have at_t' : t = d + 1 + 1 := at_t.trans (Nat.add_comm 2 d)
    (congrArg (fun n => lasso (pairAt n) (prefixOf course t)) held).trans
      ((lasso_claims (h := (0, 1)) (Nat.le_trans (Nat.le_succ 2) later)).trans
        ((congrArg (fun n => Copying.nth (prefixOf course n) 1) at_t').trans
          ((back_prefix course d 1).trans
            (congrArg some ((repeats d (Nat.zero_le d)).symm.trans
              (congrArg course at_t'.symm))))))

end Alternate

end Learning

end Becoming
