import Becoming.Description
import Becoming.Refinement

/-!
# Identification: what a bounded prefix fixes

Read as a truth that modelling projects, the projection being where the limit lies, an
unfolding leaves three questions: whether it has a law of this kind, deriving the law from a
finite prefix, and naming the classes of the split that makes sense without an axiom.
`Becoming.Description` answers the first: every history read through a map is a law read
through a map, and its states are read off it
(`alike_moments_iff`, `finitely_many_states_iff`). `Becoming.Learning` shows that no prefix
fixes the next value, not even among worlds a list holds; that the extrapolation by elimination,
not given the number of configurations, comes to rest is unrefuted
(`held_rest_unrefuted`), and its prefix never shows that it has: given two values, every value
it proposes misses, at that step, on a course of a world held by a list sharing its prefix
(`no_prefix_fixes_next_finite`). This module states what the situation adds: a bound on its
states. With no premise beyond the bound:

* **Two periods.** A course with period `p + 1` that comes back after `Q` steps at each of its
  first `p` steps comes back after `Q` steps at every step (`period_extends`; Fine and Wilf,
  1965). So two courses repeating from steps `i`, `i'` with periods `q + 1`, `q' + 1` that agree
  before `(i + q + 1) + (i' + q')` agree at every step (`lassos_agree`).
* **A bounded prefix fixes the course.** A history has at most `N` states exactly where it
  repeats from some step `i` with some period `q + 1`, `i + q + 1 ≤ N`
  (`statesBelow_iff_lasso`). Two histories with at most `N` and `N'` states that agree before
  `N + N' - 1` agree at every step (`bounded_agree`): their prefixes before `N + N' - 1` fix
  them (`prefix_fixes`). Before `N + N' - 2` they do not: for every `T` a history with one
  state and one with `T + 1` share their prefix before `T` and differ at `T`
  (`prefix_short`), for every `N ≥ 2` two histories with at most `N` states share their
  prefix before `N + N - 2` and differ there (`prefix_short_twice`), and for every `N` and `N'`
  a history with at most `N` states and one with at most `N'` share their prefix before
  `N + N' - 2` and differ there (`bounded_agree_exact`): the length `N + N' - 1` is exact for
  every pair of bounds. Prefixes are equal exactly where the courses agree before their length
  (`prefix_eq_iff`).
* **Induction is deduction where the bound is given.** On a history with at most `N` states, a
  lasso candidate within `N` that the prefix before `N + N - 1` bears out is the law of the
  whole course (`lasso_of_fits`, `bounded_induction`), and one always is
  (`bounded_hypothesis`). The extrapolation given the bound `N` (`withBound`), silent before step
  `N + N - 1` and from then on proposing by the first candidate within `N` that the prefix bears
  out, misses at no step of any history with at most `N` states and is right at every step
  from `N + N - 1` on (`withBound_accords`, `withBound_exact`). No extrapolation that misses at no
  step of every history with at most `N ≥ 2` states proposes at step `N + N - 2` on each of them
  (`withBound_earliest`): the extrapolation given the bound proposes as early as any can. The
  two-valued negation, on which no fixed value is borne out (`Diagonal.revision_never_rests`), is
  derived from step `3` on by the extrapolation given two states (`negation_derived`).
* **Elimination not given the bound rests within it.** A lasso candidate within `N` that misses
  at no step of a stretch of `N + N - 1` steps misses at no later step
  (`no_miss_persists`). So on a history with at most `N` states the extrapolation by elimination
  over the lasso candidates, given neither `N` nor the course, proposes at every step from
  `N + (N + N - 1) * tri N` on and is right (`byElimination_rests`); in a world a list holds, `N` is
  the list's length (`held_byElimination_rests`), and on a lasso course the rest that
  `Becoming.Learning` leaves unrefuted is found (`rests_of_lasso`). The step is a function of
  the bound, which the extrapolation is not given: its prefix does not show it. The step is
  cubic in `N`: on the two-valued negation along a cycle of `N = 2m + 3` places, which is broken
  once in every turn, elimination misses at step `(N³ - N) / 4` (`byElimination_missed_late`), each
  even shift it passes costing a whole turn, so no earlier step bounds its rest on every history
  with at most `N` states (`byElimination_rest_cubic`).
* **The rest step needs no bound.** The extrapolation by the least bound (`leastBound`), given
  no bound, proposes by the first lasso candidate the prefix bears out within the least
  bound within which one is; it is right at every step from `N + N - 1` on of every history with
  at most `N` states, for every `N` (`leastBound_exact`). No extrapolation, given the bound or
  without, is right at step `N + N - 2` on every such history for `N ≥ 2` (`rest_earliest`), so
  `N + N - 1` is the optimal rest step and being given the bound does not move it. What the bound buys is
  silence: no extrapolation right at step `1` on every history with one state misses at no step
  of every history with two states (`rest_without_bound_missed`), while the extrapolation with the
  bound is silent before `N + N - 1` and misses nowhere (`withBound_accords`).
* **The diagonal world of an extrapolation exceeds its bound.** The course on which every value
  the extrapolation given the bound `N` proposes misses has more than `N` states
  (`answer_exceeds_bound`): a world that contains the extrapolation and moves off every value it
  proposes is not within the bound the extrapolation is given.
* **The split that makes sense, named with no quotient.** In a world a list holds, under a
  determined law, two configurations have the same future through the map exactly where their
  futures through the map agree before `2N - 1` (`Law.sameFuture_iff_below`). Naming each
  configuration by its future through the map before that step, a finite list, makes sense
  (`Law.name_identifiesAlike`); the names carry the law (`Law.name_carries`) and likeness is decided
  by comparing them (`Law.decideAlike`). Naming by the whole future through the map would need
  function extensionality, which Lean proves from the quotient axiom `Quot.sound`; the bound
  makes the finite name enough. The states of a history with at most `N` states are read the same way
  (`sameAhead_iff_below`, `statesBelow_shift`).
* **Moore's bound: within one world, `N - 1` steps.** Under a determined law, two members of a
  list of `N` members closed under the law have the same future through the map exactly where
  their futures through the map agree for `N - 1` steps, wherever the values of the members are compared
  decidedly (`Law.sameFuture_iff_classes`). Agreeing for `k + 1` steps (`Law.AgreeTo`) is a chain
  of equivalences, each finer than the one before (`Law.agreeTo_refining`); members taking
  different values through the map make two classes, each strict refinement adds one, and so the chain stops
  within `N - 2` (`Refining.steady_within` of `Becoming.Refinement`), after which, the law being
  determined, it never refines again (`Law.AgreeTo.steady_on`). For every `N ≥ 2` the bound is
  exact: on a path of `N` positions to a last one that stays, read through a map that takes only
  whether the last is reached, the first two positions agree for `N - 2` steps and differ at the next
  (`Law.sameFuture_classes_exact`). Two moments of a history with at most `N` states whose
  values are decided are one state exactly where they agree for `N - 1` steps
  (`sameAhead_iff_classes`).
* **Moore's bound needs no decision.** What is decided is the positions, not the values. Read
  on the positions of the list, the law is a law on positions (`Law.orbit_memberAt`), whose
  equality is decided. Joining, pair by pair, the positions the agreements join
  (`Law.joinOrbits`) gives a labelling of the positions whose labels have one value each
  (`Law.joinOrbits_sound`); the labelling's agreements are its own, and Moore's bound for it
  carries over to the values. So two members of a list of `N` members closed under a determined
  law have the same future through the map exactly where their futures through the map agree
  for `N - 1` steps, with no premise (`Law.sameFuture_iff_within`), and two moments of a history with at
  most `N` states are one state exactly where they agree for `N - 1` steps
  (`sameAhead_iff_within`). Before this, with no decision, the agreement at every step was only
  refuted by nothing (`Law.sameFuture_classes_unrefuted`).

The world in these statements is any world a list holds: a controller or a cognition inside it
is part of the configuration the map reads, as in `Becoming.Description`'s
`Law.adaptive_identifiesAlike_iff`.
The bound `N + N' - 1` is the one of Fine and Wilf, and for two histories it is Moore's bound
(1956) for the two systems taken together, attained for every pair of bounds. Within one world,
or one history, the configurations share their classes, and Moore's bound is `N - 1`, with no
premise. The extrapolations here are what Gold calls learners in the limit (Gold 1967,
identification in the limit): elimination over the lasso candidates is his identification by
enumeration, and the extrapolation given the bound (`withBound`) and the extrapolation by the least
bound (`leastBound`) fix every history with at most `N` states from step `N + N - 1` on, which is
the Moore and Fine–Wilf bound read as a learning bound. The cubic step of elimination
(`byElimination_rest_cubic`) is stated for the diagonal order in which `Learning.lassos`
enumerates the candidates; another order is not covered.

`Law.name_identifiesAlike`, `Law.name_carries` and `Law.decideAlike` are in
`Becoming.IdentificationRuns` (board item W).
-/

namespace Becoming

universe u v w

namespace Identification

/-! ## Two periods -/

section Periods

variable {O : Type u}

/-- Every step is a remainder up to `p` and a number of whole periods `p + 1`. -/
theorem residue (p : Nat) : ∀ n, ∃ r k, r ≤ p ∧ n = r + (p + 1) * k
  | 0 => ⟨0, 0, Nat.zero_le p, rfl⟩
  | n + 1 =>
    match residue p n with
    | ⟨r, k, le, at_n⟩ =>
      match Nat.lt_or_ge r p with
      | .inl lt => ⟨r + 1, k, lt,
          (congrArg Nat.succ at_n).trans (Nat.succ_add r ((p + 1) * k)).symm⟩
      | .inr ge =>
        have top : r = p := Nat.le_antisymm le ge
        ⟨0, k + 1, Nat.zero_le p,
          (congrArg Nat.succ at_n).trans ((Nat.succ_add r ((p + 1) * k)).symm.trans
            ((congrArg (fun m => m + 1 + (p + 1) * k) top).trans
              ((Nat.add_comm (p + 1) ((p + 1) * k)).trans
                (Nat.zero_add ((p + 1) * k + (p + 1))).symm)))⟩

/-- A course with period `p + 1` takes, after whole periods, the value it took. -/
theorem periodic_whole {x : Nat → O} {p : Nat} (per : ∀ n, x (n + (p + 1)) = x n) (r : Nat) :
    ∀ k, x (r + (p + 1) * k) = x r
  | 0 => rfl
  | k + 1 =>
    (congrArg x (Nat.add_assoc r ((p + 1) * k) (p + 1)).symm).trans
      ((per (r + (p + 1) * k)).trans (periodic_whole per r k))

/-- **Two periods (Fine and Wilf).** A course with period `p + 1` that comes back after `Q`
steps at each of its first `p` steps comes back after `Q` steps at every step. The remainders
of `p + Q, p + 2Q, …` walk through one cycle; the one step not given, at `p`, is passed round
the rest of the cycle. -/
theorem period_extends {x : Nat → O} {p Q : Nat} (per : ∀ n, x (n + (p + 1)) = x n)
    (first : ∀ n, n < p → x (n + Q) = x n) : ∀ n, x (n + Q) = x n := by
  have walk : ∀ t, ∃ r k, r ≤ p ∧ p + Q * (t + 1) = r + (p + 1) * k ∧
      (x (p + Q) = x p ∨ x (p + Q) = x r) := by
    intro t
    induction t with
    | zero =>
      match residue p (p + Q) with
      | ⟨r, k, le, at_pQ⟩ =>
        exact ⟨r, k, le, (congrArg (p + ·) (Nat.mul_one Q)).trans at_pQ,
          Or.inr ((congrArg x at_pQ).trans (periodic_whole per r k))⟩
    | succ t ih =>
      match ih with
      | ⟨r, k, le, at_t, said⟩ =>
        have step : p + Q * (t + 1 + 1) = r + Q + (p + 1) * k :=
          (Nat.add_assoc p (Q * (t + 1)) Q).symm.trans
            ((congrArg (· + Q) at_t).trans (Nat.add_right_comm r ((p + 1) * k) Q))
        match residue p (r + Q) with
        | ⟨r', k', le', at_rQ⟩ =>
          have next : p + Q * (t + 1 + 1) = r' + (p + 1) * (k' + k) :=
            step.trans ((congrArg (· + (p + 1) * k) at_rQ).trans
              ((Nat.add_assoc r' ((p + 1) * k') ((p + 1) * k)).trans
                (congrArg (r' + ·) (Nat.left_distrib (p + 1) k' k).symm)))
          have moved : x r' = x (r + Q) :=
            (periodic_whole per r' k').symm.trans (congrArg x at_rQ.symm)
          match Nat.decEq r p with
          | isTrue at_p =>
            exact ⟨r', k' + k, le', next, Or.inl (match said with
              | .inl done => done
              | .inr to_r => to_r.trans (congrArg x at_p))⟩
          | isFalse off =>
            have kept : x r' = x r := moved.trans (first r (Nat.lt_of_le_of_ne le off))
            exact ⟨r', k' + k, le', next, match said with
              | .inl done => Or.inl done
              | .inr to_r => Or.inr (to_r.trans kept.symm)⟩
  have back : x (p + Q) = x p :=
    match walk p with
    | ⟨r, k, _, at_end, said⟩ =>
      have closes : x r = x p :=
        (periodic_whole per r k).symm.trans ((congrArg x at_end.symm).trans
          ((congrArg (fun m => x (p + m)) (Nat.mul_comm Q (p + 1))).trans
            (periodic_whole per p Q)))
      match said with
      | .inl done => done
      | .inr to_r => to_r.trans closes
  intro n
  match residue p n with
  | ⟨r, k, le, at_n⟩ =>
    have at_r : x (r + Q) = x r :=
      match Nat.decEq r p with
      | isTrue at_p => Eq.subst (motive := fun m => x (m + Q) = x m) at_p.symm back
      | isFalse off => first r (Nat.lt_of_le_of_ne le off)
    calc x (n + Q) = x (r + Q + (p + 1) * k) :=
          congrArg x ((congrArg (· + Q) at_n).trans (Nat.add_right_comm r ((p + 1) * k) Q))
      _ = x (r + Q) := periodic_whole per (r + Q) k
      _ = x r := at_r
      _ = x n := (periodic_whole per r k).symm.trans (congrArg x at_n.symm)

/-- **Two lassos that agree long enough agree at every step.** Courses repeating from steps
`i`, `i'` with periods `q + 1`, `q' + 1` that agree before `(i + q + 1) + (i' + q')` agree at
every step. -/
theorem lassos_agree {o o' : Nat → O} {i q i' q' : Nat} (lasso : Learning.Lasso o i q)
    (lasso' : Learning.Lasso o' i' q')
    (agree : ∀ n, n < (i + q + 1) + (i' + q') → o n = o' n) : ∀ n, o n = o' n := by
  have shuffle : i + i' + (q + q' + 1) = (i + q + 1) + (i' + q') :=
    ((congrArg (i + i' + ·) (Nat.succ_add q q')).symm.trans
      (Nat.add_add_add_comm i i' (q + 1) q')).trans
      (congrArg (· + (i' + q')) (rfl : i + (q + 1) = i + q + 1))
  have per : ∀ n, o (i + i' + n + (q + 1)) = o (i + i' + n) := fun n =>
    lasso (i + i' + n) (Nat.le_trans (Nat.le_add_right i i') (Nat.le_add_right _ n))
  have per' : ∀ n, o' (i + i' + n + (q' + 1)) = o' (i + i' + n) := fun n =>
    lasso' (i + i' + n) (Nat.le_trans (Nat.le_add_left i' i) (Nat.le_add_right _ n))
  have perx : ∀ n, o (i + i' + (n + (q + 1))) = o (i + i' + n) := fun n =>
    (congrArg o (Nat.add_assoc (i + i') n (q + 1)).symm).trans (per n)
  have pery : ∀ n, o' (i + i' + (n + (q' + 1))) = o' (i + i' + n) := fun n =>
    (congrArg o' (Nat.add_assoc (i + i') n (q' + 1)).symm).trans (per' n)
  have early : ∀ n, n < q + q' + 1 → o (i + i' + n) = o' (i + i' + n) := fun n lt =>
    agree _ (Eq.subst (motive := fun m => i + i' + n < m) shuffle (Nat.add_lt_add_left lt _))
  have comes_back : ∀ n, o (i + i' + (n + (q' + 1))) = o (i + i' + n) :=
    period_extends (x := fun n => o (i + i' + n)) perx fun n lt =>
      (early (n + (q' + 1)) (Nat.add_lt_add_right lt (q' + 1))).trans
        ((pery n).trans (early n (Nat.lt_of_lt_of_le lt
          (Nat.le_trans (Nat.le_add_right q q') (Nat.le_succ _)))).symm)
  have late : ∀ n, o (i + i' + n) = o' (i + i' + n) := fun n =>
    match residue q' n with
    | ⟨r, k, le, at_n⟩ =>
      (congrArg (fun m => o (i + i' + m)) at_n).trans
        ((periodic_whole (x := fun n => o (i + i' + n)) comes_back r k).trans
          ((early r (Nat.lt_of_lt_of_le (Nat.lt_succ_of_le le)
            (Nat.succ_le_succ (Nat.le_add_left q' q)))).trans
            ((periodic_whole (x := fun n => o' (i + i' + n)) pery r k).symm.trans
              (congrArg (fun m => o' (i + i' + m)) at_n.symm))))
  intro n
  match Nat.lt_or_ge n (i + i') with
  | .inl before =>
    exact agree n (Nat.lt_of_lt_of_le before
      (Nat.add_le_add (Nat.le_add_right i (q + 1)) (Nat.le_add_right i' q')))
  | .inr after =>
    match le_dest after with
    | ⟨d, at_n⟩ => exact (congrArg o at_n).trans ((late d).trans (congrArg o' at_n.symm))

end Periods

/-! ## Strong induction and the lasso world -/

section Positions

/-- Strong induction, from the steps before each step. -/
theorem below_upto {P : Nat → Prop} (step : ∀ m, (∀ n, n < m → P n) → P m) :
    ∀ m n, n < m → P n
  | 0, n, lt => absurd lt (Nat.not_lt_zero n)
  | m + 1, n, lt =>
    step n fun k before => below_upto step m k (Nat.lt_of_lt_of_le before (Nat.le_of_lt_succ lt))

theorem below_all {P : Nat → Prop} (step : ∀ m, (∀ n, n < m → P n) → P m) : ∀ n, P n :=
  fun n => below_upto step (n + 1) n (Nat.lt_succ_self n)

/-- Along `Becoming.Learning`'s lasso world, the position is the step up to `i + q`. -/
theorem lassoPos_early {i q : Nat} :
    ∀ n, n ≤ i + q → Law.orbit (Learning.lassoNext i q) 0 n = n
  | 0, _ => rfl
  | n + 1, le =>
    (congrArg (Learning.lassoNext i q) (lassoPos_early n (Nat.le_of_succ_le le))).trans
      (if_pos (Nat.lt_of_succ_le le))

/-- From `i` on, the lasso world's position comes back after `q + 1` steps. -/
theorem lassoPos_period {i q : Nat} :
    ∀ d, Law.orbit (Learning.lassoNext i q) 0 (i + d + (q + 1)) =
      Law.orbit (Learning.lassoNext i q) 0 (i + d)
  | 0 =>
    (congrArg (Learning.lassoNext i q) (lassoPos_early (i + q) (Nat.le_refl _))).trans
      ((if_neg (Nat.lt_irrefl (i + q))).trans (lassoPos_early i (Nat.le_add_right i q)).symm)
  | d + 1 =>
    (congrArg (Law.orbit (Learning.lassoNext i q) 0)
      (Nat.add_right_comm (i + d) 1 (q + 1))).trans
      (congrArg (Learning.lassoNext i q) (lassoPos_period d))

end Positions

/-! ## What a bounded prefix fixes -/

section Bounded

variable {O : Type u}

/-- Fewer states before a smaller bound are fewer before a larger one. -/
theorem statesBelow_mono {o : Nat → O} {L N : Nat} (below : StatesBelow o L) (le : L ≤ N) :
    StatesBelow o N :=
  fun t => match below t with
    | ⟨i, lt, same⟩ => ⟨i, Nat.lt_of_lt_of_le lt le, same⟩

/-- **A history has at most `N` states exactly where it repeats from some step `i` with some
period `q + 1`, `i + q + 1 ≤ N`.** The bounded form of `finitely_many_states_iff` and of
`finitely_many_states_iff_lasso`. -/
theorem statesBelow_iff_lasso {o : Nat → O} {N : Nat} :
    StatesBelow o N ↔ ∃ i q, i + q + 1 ≤ N ∧ Learning.Lasso o i q :=
  ⟨fun below =>
    match shared_below N (fun t i => SameAhead o t i) (fun n _ => below n) with
    | ⟨t, _, _, lt, le, h, h'⟩ =>
      match gap_of_lt lt with
      | ⟨q, at_t'⟩ =>
        ⟨t, q, Eq.subst (motive := fun n => n ≤ N) at_t' le,
          lasso_iff_sameAhead.mpr
            (Eq.subst (motive := fun n => SameAhead o t n) at_t' (h.trans h'.symm))⟩,
   fun ⟨i, q, within, lasso⟩ =>
    statesBelow_mono
      (statesBelow_of_same (Nat.lt_succ_of_le (Nat.le_add_right i q))
        (lasso_iff_sameAhead.mp lasso)) within⟩

/-- A history with at most `N` states has a state: the bound is at least one. -/
theorem statesBelow_pos {o : Nat → O} {N : Nat} (below : StatesBelow o N) : 0 < N :=
  match below 0 with
  | ⟨_, lt, _⟩ => Nat.lt_of_le_of_lt (Nat.zero_le _) lt

/-- A positive bound is at most twice itself less one. -/
theorem le_twice_less_one : ∀ {N : Nat}, 0 < N → N ≤ N + N - 1
  | 0, lt => absurd lt (Nat.lt_irrefl 0)
  | m + 1, _ => Nat.le_add_right (m + 1) m

/-- **Two bounded histories are fixed by their agreement before `N + N' - 1`.** -/
theorem bounded_agree {o o' : Nat → O} {N N' : Nat} (bound : StatesBelow o N)
    (bound' : StatesBelow o' N') (agree : ∀ n, n < N + N' - 1 → o n = o' n) :
    ∀ n, o n = o' n :=
  match statesBelow_iff_lasso.mp bound, statesBelow_iff_lasso.mp bound' with
  | ⟨i, q, within, lasso⟩, ⟨i', q', within', lasso'⟩ =>
    have short : (i + q + 1) + (i' + q') ≤ N + N' - 1 :=
      Nat.sub_le_sub_right (Nat.add_le_add within within') 1
    lassos_agree lasso lasso' fun n lt => agree n (Nat.lt_of_lt_of_le lt short)

/-- **Prefixes are equal exactly where the courses agree before their length.** -/
theorem prefix_eq_iff {o o' : Nat → O} : ∀ {T : Nat},
    Learning.prefixOf o T = Learning.prefixOf o' T ↔ ∀ n, n < T → o n = o' n
  | 0 => ⟨fun _ n lt => absurd lt (Nat.not_lt_zero n), fun _ => rfl⟩
  | T + 1 =>
    ⟨fun same n lt =>
      match List.cons.inj
          (show o T :: Learning.prefixOf o T = o' T :: Learning.prefixOf o' T from same) with
      | ⟨now, before⟩ =>
        match Nat.lt_or_ge n T with
        | .inl lt' => prefix_eq_iff.mp before n lt'
        | .inr ge =>
          have at_T : n = T := Nat.le_antisymm (Nat.le_of_lt_succ lt) ge
          (congrArg o at_T).trans (now.trans (congrArg o' at_T).symm),
     Learning.prefix_congr⟩

/-- **The prefix before `N + N' - 1` fixes a history with at most `N` states among those with at
most `N'`.** -/
theorem prefix_fixes {o o' : Nat → O} {N N' : Nat} (bound : StatesBelow o N)
    (bound' : StatesBelow o' N')
    (same : Learning.prefixOf o (N + N' - 1) = Learning.prefixOf o' (N + N' - 1)) :
    ∀ n, o n = o' n :=
  bounded_agree bound bound' (prefix_eq_iff.mp same)

/-- **The prefix before `N + N' - 2` does not.** For every `T`, given two values, a history
with one state and one with at most `T + 1` share their prefix before `T` and differ at `T`
(`Becoming.Learning`'s `holdFrom`). -/
theorem prefix_short {x y : O} (two : x ≠ y) (T : Nat) :
    ∃ o o' : Nat → O, StatesBelow o 1 ∧ StatesBelow o' (T + 1) ∧
      Learning.prefixOf o T = Learning.prefixOf o' T ∧ o T ≠ o' T :=
  ⟨fun _ => x, Learning.holdFrom (fun _ => x) T y,
   statesBelow_iff_lasso.mpr ⟨0, 0, Nat.le_refl 1, fun _ _ => rfl⟩,
   statesBelow_iff_lasso.mpr ⟨T, 0, Nat.le_refl (T + 1), Learning.holdFrom_lasso _ T y⟩,
   Learning.prefix_congr fun _ before => (Learning.holdFrom_before (fun _ => x) y before).symm,
   fun same => two (same.trans (Learning.holdFrom_after _ y (Nat.le_refl T)))⟩

/-- The course of `Becoming.Learning`'s lasso world on positions `0, …, i + q`, read through the
map taking `y` at position `m` and `x` elsewhere. -/
def mark (i q m : Nat) (x y : O) (n : Nat) : O :=
  if Law.orbit (Learning.lassoNext i q) 0 n = m then y else x

/-- **For two histories with at most `N` states each, the prefix before `N + N - 2` does not fix
the course.** With `N = M + 2`: the course marking every `N`-th step from step `M + 1`, and the
course marking every `(N - 1)`-th step from step `M + 1`, share their prefix before `M + M + 2`
and differ at it. So `N + N - 1` is exact for two histories with the same bound. -/
theorem prefix_short_twice {x y : O} (two : x ≠ y) (M : Nat) :
    ∃ o o' : Nat → O, StatesBelow o (M + 2) ∧ StatesBelow o' (M + 2) ∧
      Learning.prefixOf o (M + M + 2) = Learning.prefixOf o' (M + M + 2) ∧
        o (M + M + 2) ≠ o' (M + M + 2) := by
  let pos := Law.orbit (Learning.lassoNext 0 (M + 1)) 0
  let pos' := Law.orbit (Learning.lassoNext 1 M) 0
  have early : ∀ n, n ≤ M + 1 → pos n = n := fun n le =>
    lassoPos_early (i := 0) (q := M + 1) n
      (Eq.subst (motive := fun k => n ≤ k) (Nat.zero_add (M + 1)).symm le)
  have early' : ∀ n, n ≤ M + 1 → pos' n = n := fun n le =>
    lassoPos_early (i := 1) (q := M) n
      (Eq.subst (motive := fun k => n ≤ k) (Nat.add_comm M 1) le)
  have period : ∀ u, pos (u + (M + 2)) = pos u := fun u =>
    Eq.subst (motive := fun k => pos (k + (M + 2)) = pos k) (Nat.zero_add u)
      (lassoPos_period (i := 0) (q := M + 1) u)
  have period' : ∀ d, pos' (1 + d + (M + 1)) = pos' (1 + d) := fun d =>
    lassoPos_period (i := 1) (q := M) d
  have later : ∀ d, d ≤ M → pos (M + 2 + d) = d ∧ pos' (M + 2 + d) = 1 + d := fun d le =>
    have at_n : M + 2 + d = 1 + d + (M + 1) :=
      (Nat.add_assoc (M + 1) 1 d).trans (Nat.add_comm (M + 1) (1 + d))
    ⟨(congrArg pos (Nat.add_comm (M + 2) d)).trans
        ((period d).trans (early d (Nat.le_succ_of_le le))),
     (congrArg pos' at_n).trans ((period' d).trans
        (early' (1 + d) (Eq.subst (motive := fun k => 1 + d ≤ k) (Nat.add_comm 1 M)
          (Nat.add_le_add_left le 1))))⟩
  have twice : M + M + 2 = M + 2 + M :=
    (Nat.add_assoc M M 2).trans (Nat.add_comm M (M + 2))
  let o : Nat → O := mark 0 (M + 1) (M + 1) x y
  let o' : Nat → O := mark 1 M (M + 1) x y
  have lasso : Learning.Lasso o 0 (M + 1) := fun u _ =>
    congrArg (fun k => if k = M + 1 then y else x) (period u)
  have lasso' : Learning.Lasso o' 1 M := fun u le =>
    match le_dest le with
    | ⟨d, at_u⟩ =>
      congrArg (fun k => if k = M + 1 then y else x)
        ((congrArg (fun n => pos' (n + (M + 1))) at_u).trans
          ((period' d).trans (congrArg pos' at_u.symm)))
  have agree : ∀ n, n < M + M + 2 → o n = o' n := fun n lt =>
    match Nat.lt_or_ge n (M + 2) with
    | .inl first =>
      have le : n ≤ M + 1 := Nat.le_of_lt_succ first
      congrArg (fun k => if k = M + 1 then y else x) ((early n le).trans (early' n le).symm)
    | .inr beyond =>
      match le_dest beyond with
      | ⟨d, at_n⟩ =>
        have short : d < M :=
          Nat.lt_of_add_lt_add_left
            (Eq.subst (motive := fun k => k < M + 2 + M) at_n
              (Eq.subst (motive := fun k => n < k) twice lt))
        have off : pos n ≠ M + 1 := fun same =>
          have at_d : d = M + 1 :=
            (later d (Nat.le_of_lt short)).1.symm.trans ((congrArg pos at_n).symm.trans same)
          Nat.lt_irrefl M (Nat.lt_trans (Nat.lt_succ_self M)
            (Eq.subst (motive := fun k => k < M) at_d short))
        have off' : pos' n ≠ M + 1 := fun same =>
          have at_d : 1 + d = M + 1 :=
            (later d (Nat.le_of_lt short)).2.symm.trans ((congrArg pos' at_n).symm.trans same)
          Nat.lt_irrefl M (Eq.subst (motive := fun k => k < M)
            (Nat.succ.inj ((Nat.add_comm d 1).trans at_d)) short)
        (if_neg off).trans (if_neg off').symm
  have at_end := later M (Nat.le_refl M)
  have left : o (M + M + 2) = x :=
    if_neg fun same => Nat.succ_ne_self M
      (at_end.1.symm.trans ((congrArg pos twice).symm.trans same)).symm
  have right : o' (M + M + 2) = y :=
    if_pos (((congrArg pos' twice).trans at_end.2).trans (Nat.add_comm 1 M))
  exact ⟨o, o',
    statesBelow_iff_lasso.mpr
      ⟨0, M + 1, Nat.le_of_eq (congrArg (· + 1) (Nat.zero_add (M + 1))), lasso⟩,
    statesBelow_iff_lasso.mpr ⟨1, M, Nat.le_of_eq (congrArg (· + 1) (Nat.add_comm 1 M)), lasso'⟩,
    prefix_eq_iff.mpr agree,
    fun same => two (left.symm.trans (same.trans right))⟩

/-- **The length `N + N' - 1` is exact for every pair of bounds.** Given two values, for all `M`
and `M'`, a history with at most `M + 1` states and one with at most `M' + 1` share their prefix
before `M + M'` and differ at `M + M'`. The first marks every `(M + 1)`-th step, placed so that
the steps from `M'` to `M + M' - 1` are unmarked and step `M + M'` is marked; the second
follows it before step `M'` and stays unmarked from then on. With `M = 0` this is
`prefix_short`; with `M = M'` it is the case `N = N'` of `prefix_short_twice`. -/
theorem bounded_agree_exact {x y : O} (two : x ≠ y) (M M' : Nat) :
    ∃ o o' : Nat → O, StatesBelow o (M + 1) ∧ StatesBelow o' (M' + 1) ∧
      Learning.prefixOf o (M + M') = Learning.prefixOf o' (M + M') ∧ o (M + M') ≠ o' (M + M') := by
  let pos := Law.orbit (Learning.lassoNext 0 M) 0
  have early : ∀ j, j ≤ M → pos j = j := fun j le =>
    lassoPos_early (i := 0) (q := M) j
      (Eq.subst (motive := fun k => j ≤ k) (Nat.zero_add M).symm le)
  have period : ∀ u, pos (u + (M + 1)) = pos u := fun u =>
    Eq.subst (motive := fun k => pos (k + (M + 1)) = pos k) (Nat.zero_add u)
      (lassoPos_period (i := 0) (q := M) u)
  have placed : ∀ j, j ≤ M → pos (M' + j + M * M') = j := fun j le =>
    (congrArg pos ((congrArg (· + M * M') (Nat.add_comm M' j)).trans
      ((Nat.add_assoc j M' (M * M')).trans (congrArg (j + ·)
        ((Nat.add_comm M' (M * M')).trans (Nat.succ_mul M M').symm))))).trans
      ((periodic_whole (x := pos) period j M').trans (early j le))
  let o : Nat → O := fun n => mark 0 M M x y (n + M * M')
  let o' : Nat → O := Learning.holdFrom o M' x
  have lasso : Learning.Lasso o 0 M := fun u _ =>
    congrArg (fun k => if k = M then y else x)
      ((congrArg pos (Nat.add_right_comm u (M + 1) (M * M'))).trans (period (u + M * M')))
  have agree : ∀ n, n < M + M' → o n = o' n := fun n lt =>
    match Nat.lt_or_ge n M' with
    | .inl before => (Learning.holdFrom_before o x before).symm
    | .inr after =>
      match le_dest after with
      | ⟨j, at_n⟩ =>
        have short : j < M :=
          Nat.lt_of_add_lt_add_left
            (Eq.subst (motive := fun k => k < M' + M) at_n
              (Eq.subst (motive := fun k => n < k) (Nat.add_comm M M') lt))
        have unmarked : o n = x := if_neg fun marked =>
          Nat.ne_of_lt short ((placed j (Nat.le_of_lt short)).symm.trans
            ((congrArg (fun k => pos (k + M * M')) at_n).symm.trans marked))
        unmarked.trans (Learning.holdFrom_after o x after).symm
  have marked : o (M + M') = y :=
    if_pos ((congrArg (fun k => pos (k + M * M')) (Nat.add_comm M M')).trans
      (placed M (Nat.le_refl M)))
  have stays : o' (M + M') = x := Learning.holdFrom_after o x (Nat.le_add_left M' M)
  exact ⟨o, o',
    statesBelow_iff_lasso.mpr ⟨0, M, Nat.le_of_eq (congrArg (· + 1) (Nat.zero_add M)), lasso⟩,
    statesBelow_iff_lasso.mpr ⟨M', 0, Nat.le_refl (M' + 1), Learning.holdFrom_lasso o M' x⟩,
    prefix_eq_iff.mpr agree,
    fun same => two (stays.symm.trans (same.symm.trans marked))⟩

/-- A later stretch of a history with at most `N` states has at most `N` states. -/
theorem statesBelow_shift {o : Nat → O} {N : Nat} (bound : StatesBelow o N) (t : Nat) :
    StatesBelow (fun n => o (t + n)) N :=
  match statesBelow_iff_lasso.mp bound with
  | ⟨i, q, within, lasso⟩ =>
    statesBelow_iff_lasso.mpr ⟨i, q, within, fun u later =>
      (congrArg o (Nat.add_assoc t u (q + 1)).symm).trans
        (lasso (t + u) (Nat.le_trans later (Nat.le_add_left u t)))⟩

/-- **The states of a bounded history are read off a finite prefix.** Two moments of a history
with at most `N` states are one state exactly where the courses from them agree for
`N + N - 1` steps. -/
theorem sameAhead_iff_below {o : Nat → O} {N : Nat} (bound : StatesBelow o N) {t t' : Nat} :
    SameAhead o t t' ↔ ∀ n, n < N + N - 1 → o (t + n) = o (t' + n) :=
  ⟨fun same n _ => same n,
   fun agree => bounded_agree (statesBelow_shift bound t) (statesBelow_shift bound t') agree⟩

end Bounded

/-! ## Induction where the bound is given -/

section Induction

variable {O : Type u}

/-- **With the bound given, a candidate the prefix bears out is the law of the course.** On a
history with at most `N` states, a lasso `(i, q)` within `N` that accords with the prefix before
`N + N - 1` accords at every step. The lasso world read off the prefix is a second history within
`N` agreeing with the first before `N + N - 1`. -/
theorem lasso_of_fits {o : Nat → O} {N i q : Nat} (bound : StatesBelow o N)
    (within : i + q + 1 ≤ N)
    (fits : ∀ u, i ≤ u → u + (q + 1) < N + N - 1 → o (u + (q + 1)) = o u) :
    Learning.Lasso o i q := by
  let pos := Law.orbit (Learning.lassoNext i q) 0
  have lasso : Learning.Lasso (fun n => o (pos n)) i q := fun u le =>
    match le_dest le with
    | ⟨d, at_u⟩ =>
      congrArg o ((congrArg (fun n => pos (n + (q + 1))) at_u).trans
        ((lassoPos_period d).trans (congrArg pos at_u.symm)))
  have agree : ∀ n, n < N + N - 1 → o (pos n) = o n := below_all fun m before lt =>
    match Nat.lt_or_ge m (i + q + 1) with
    | .inl early => congrArg o (lassoPos_early m (Nat.le_of_lt_succ early))
    | .inr late =>
      match le_dest late with
      | ⟨d, at_m⟩ =>
        have at_m' : m = i + d + (q + 1) := at_m.trans (Nat.add_right_comm i (q + 1) d)
        have u_lt : i + d < m :=
          Eq.subst (motive := fun k => i + d < k) at_m'.symm
            (Nat.lt_succ_of_le (Nat.le_add_right (i + d) q))
        (congrArg (fun k => o (pos k)) at_m').trans
          ((lasso (i + d) (Nat.le_add_right i d)).trans
            ((before (i + d) u_lt (Nat.lt_trans u_lt lt)).trans
              ((fits (i + d) (Nat.le_add_right i d)
                (Eq.subst (motive := fun k => k < N + N - 1) at_m' lt)).symm.trans
                (congrArg o at_m'.symm))))
  have all : ∀ n, o (pos n) = o n :=
    bounded_agree (statesBelow_iff_lasso.mpr ⟨i, q, within, lasso⟩) bound agree
  exact fun u le => (all _).symm.trans ((lasso u le).trans (all u))

/-- A lasso candidate that misses at no step before `T` accords with the prefix before `T`. -/
theorem fits_of_no_miss [DecidableEq O] {o : Nat → O} {i q T : Nat}
    (unrefuted : ∀ t, t < T → ¬ Learning.MissesAt (Learning.lasso (i, q)) o t) :
    ∀ u, i ≤ u → u + (q + 1) < T → o (u + (q + 1)) = o u :=
  fun u le lt =>
    have claims : Learning.lasso (i, q) (Learning.prefixOf o (u + (q + 1))) = some (o u) :=
      (Learning.lasso_claims (o := o) (h := (i, q)) (Nat.add_le_add_right le (q + 1))).trans
        (Learning.back_prefix o u q)
    (Learning.eq_of_not_missed
      (Eq.subst (motive := fun c => ¬ Learning.Misses c (o (u + (q + 1)))) claims
        (unrefuted _ lt))).symm

/-- **In a bounded situation induction is deduction.** On a history with at most `N` states, a
lasso candidate within `N` that misses at no step before `N + N - 1` misses at no step. -/
theorem bounded_induction [DecidableEq O] {o : Nat → O} {N i q : Nat}
    (bound : StatesBelow o N) (within : i + q + 1 ≤ N)
    (unrefuted : ∀ t, t < N + N - 1 → ¬ Learning.MissesAt (Learning.lasso (i, q)) o t) :
    Learning.Accords (Learning.lasso (i, q)) o :=
  Learning.lasso_accords (lasso_of_fits bound within (fits_of_no_miss unrefuted))

/-- On a history with at most `N` states some lasso candidate within `N` accords. -/
theorem bounded_hypothesis {o : Nat → O} {N : Nat} (bound : StatesBelow o N) :
    ∃ i q, i + q + 1 ≤ N ∧ Learning.Accords (Learning.lasso (i, q)) o :=
  match statesBelow_iff_lasso.mp bound with
  | ⟨i, q, within, lasso⟩ => ⟨i, q, within, Learning.lasso_accords lasso⟩

end Induction

/-! ## The extrapolation given the bound -/

section WithBound

variable {O : Type u}

/-- Every value `pred` proposes along a prefix, each from the prefix before it, is borne out. -/
def BorneOut (pred : List O → Option O) : List O → Prop
  | [] => True
  | v :: l => ¬ Learning.Misses (pred l) v ∧ BorneOut pred l

instance decBorneOut [DecidableEq O] (pred : List O → Option O) :
    (l : List O) → Decidable (BorneOut pred l)
  | [] => isTrue trivial
  | v :: l =>
    match Learning.decMisses (pred l) v, decBorneOut pred l with
    | isTrue refuted, _ => isFalse fun ⟨unrefuted, _⟩ => unrefuted refuted
    | isFalse unrefuted, isTrue borne => isTrue ⟨unrefuted, borne⟩
    | isFalse _, isFalse unborne => isFalse fun ⟨_, borne⟩ => unborne borne

/-- A prefix bears out `pred` exactly where `pred` misses at no step before its length. -/
theorem borneOut_prefix_iff {pred : List O → Option O} {o : Nat → O} : ∀ {T : Nat},
    BorneOut pred (Learning.prefixOf o T) ↔ ∀ t, t < T → ¬ Learning.MissesAt pred o t
  | 0 => ⟨fun _ t lt => absurd lt (Nat.not_lt_zero t), fun _ => trivial⟩
  | T + 1 =>
    ⟨fun ⟨now, before⟩ t lt =>
      match Nat.lt_or_ge t T with
      | .inl lt' => borneOut_prefix_iff.mp before t lt'
      | .inr ge =>
        Eq.subst (motive := fun s => ¬ Learning.MissesAt pred o s)
          (Nat.le_antisymm ge (Nat.le_of_lt_succ lt)) now,
     fun all => ⟨all T (Nat.lt_succ_self T),
       borneOut_prefix_iff.mpr fun t lt => all t (Nat.lt_succ_of_lt lt)⟩⟩

/-- The pairs `(i, q)` with `q < Q`, for one `i`. -/
def column (i : Nat) : Nat → List (Nat × Nat)
  | 0 => []
  | Q + 1 => (i, Q) :: column i Q

/-- The pairs `(i, q)` with `i < I` and `q < Q`. -/
def grid (Q : Nat) : Nat → List (Nat × Nat)
  | 0 => []
  | I + 1 => column I Q ++ grid Q I

theorem mem_column {i q : Nat} : ∀ {Q : Nat}, q < Q → (i, q) ∈ column i Q
  | 0, lt => absurd lt (Nat.not_lt_zero q)
  | Q + 1, lt =>
    match Nat.lt_or_ge q Q with
    | .inl lt' => List.Mem.tail _ (mem_column lt')
    | .inr ge =>
      Eq.subst (motive := fun k => (i, k) ∈ column i (Q + 1))
        (Nat.le_antisymm ge (Nat.le_of_lt_succ lt)) (List.Mem.head _)

theorem mem_grid {i q Q : Nat} (lt_q : q < Q) : ∀ {I : Nat}, i < I → (i, q) ∈ grid Q I
  | 0, lt => absurd lt (Nat.not_lt_zero i)
  | I + 1, lt =>
    match Nat.lt_or_ge i I with
    | .inl lt' => List.mem_append_right _ (mem_grid lt_q lt')
    | .inr ge =>
      List.mem_append_left _
        (Eq.subst (motive := fun k => (i, q) ∈ column k Q)
          (Nat.le_antisymm (Nat.le_of_lt_succ lt) ge) (mem_column lt_q))

/-- The first member of a list meeting a decided condition. -/
def firstFit {α : Type} (p : α → Prop) (dec : ∀ a, Decidable (p a)) : List α → Option α
  | [] => none
  | a :: l => if p a then some a else firstFit p dec l

theorem firstFit_sound {α : Type} {p : α → Prop} {dec : ∀ a, Decidable (p a)} :
    ∀ {l : List α} {a : α}, firstFit p dec l = some a → p a
  | [], _, found => nomatch found
  | b :: l, _, found =>
    match Decidable.em (p b) with
    | .inl pb => Eq.subst (motive := p) (Option.some.inj ((if_pos pb).symm.trans found)) pb
    | .inr npb => firstFit_sound (l := l) ((if_neg npb).symm.trans found)

theorem firstFit_found {α : Type} {p : α → Prop} {dec : ∀ a, Decidable (p a)} :
    ∀ {l : List α} {a : α}, a ∈ l → p a → ∃ b, firstFit p dec l = some b
  | [], _, mem, _ => nomatch mem
  | b :: _, a, mem, pa =>
    match Decidable.em (p b) with
    | .inl pb => ⟨b, if_pos pb⟩
    | .inr npb =>
      match a, mem, pa with
      | _, .head _, pa => absurd pa npb
      | _, .tail _ mem', pa =>
        match firstFit_found (dec := dec) mem' pa with
        | ⟨c, found⟩ => ⟨c, (if_neg npb).trans found⟩

/-- The condition the extrapolation given the bound `N` puts on a candidate: within `N`, and
borne out by the prefix. -/
def Fits (N : Nat) (l : List O) (h : Nat × Nat) : Prop :=
  h.1 + h.2 + 1 ≤ N ∧ BorneOut (Learning.lasso h) l

instance decFits [DecidableEq O] (N : Nat) (l : List O) (h : Nat × Nat) :
    Decidable (Fits N l h) :=
  instDecidableAnd

/-- The value proposed by a candidate, if one is found. -/
def claimBy (l : List O) : Option (Nat × Nat) → Option O
  | some h => Learning.lasso h l
  | none => none

/-- **The extrapolation given the bound `N`.** Silent before step `N + N - 1`; from then on it
proposes by the first lasso candidate within `N` that the prefix bears out. -/
def withBound [DecidableEq O] (N : Nat) (l : List O) : Option O :=
  if N + N - 1 ≤ l.length then claimBy l (firstFit (Fits N l) (decFits N l) (grid N N))
  else none

/-- **The extrapolation given the bound is right at every step from `N + N - 1` on** of every
history with at most `N` states. -/
theorem withBound_exact [DecidableEq O] {o : Nat → O} {N t : Nat} (bound : StatesBelow o N)
    (late : N + N - 1 ≤ t) : withBound N (Learning.prefixOf o t) = some (o t) :=
  have long : N + N - 1 ≤ (Learning.prefixOf o t).length :=
    Eq.subst (motive := fun n => N + N - 1 ≤ n) (Learning.prefix_length o t).symm late
  have N_le : N ≤ N + N - 1 := le_twice_less_one (statesBelow_pos bound)
  match bounded_hypothesis bound with
  | ⟨i, q, within, holds⟩ =>
    have true_fits : Fits N (Learning.prefixOf o t) (i, q) :=
      ⟨within, borneOut_prefix_iff.mpr fun t' _ => holds t'⟩
    have member : (i, q) ∈ grid N N :=
      mem_grid (Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_left q i)) within)
        (Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_right i q)) within)
    match firstFit_found (dec := decFits N (Learning.prefixOf o t)) member true_fits with
    | ⟨(i', q'), found⟩ =>
      have fits : Fits N (Learning.prefixOf o t) (i', q') := firstFit_sound found
      have speaks : i' + q' + 1 ≤ t := Nat.le_trans fits.1 (Nat.le_trans N_le late)
      have holds' : Learning.Accords (Learning.lasso (i', q')) o :=
        bounded_induction bound fits.1 fun t' lt =>
          borneOut_prefix_iff.mp fits.2 t' (Nat.lt_of_lt_of_le lt late)
      match Learning.back_made o
          (Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_left q' i')) speaks) with
      | ⟨v, at_back⟩ =>
        have value : Learning.lasso (i', q') (Learning.prefixOf o t) = some v :=
          (Learning.lasso_claims (o := o) (h := (i', q')) speaks).trans at_back
        have right : v = o t :=
          Learning.eq_of_not_missed
            (Eq.subst (motive := fun c => ¬ Learning.Misses c (o t)) value (holds' t))
        (if_pos long).trans ((congrArg (claimBy (Learning.prefixOf o t)) found).trans
          (value.trans (congrArg some right)))

/-- **The extrapolation given the bound misses at no step** of any history with at most `N`
states. -/
theorem withBound_accords [DecidableEq O] {o : Nat → O} {N : Nat} (bound : StatesBelow o N) :
    Learning.Accords (withBound N) o := fun t =>
  match Nat.lt_or_ge t (N + N - 1) with
  | .inl early =>
    fun ⟨_, made, _⟩ =>
      nomatch (show withBound N (Learning.prefixOf o t) = none from
        if_neg fun long => Nat.lt_irrefl t (Nat.lt_of_lt_of_le early
          (Eq.subst (motive := fun n => N + N - 1 ≤ n) (Learning.prefix_length o t) long))
        ).symm.trans made
  | .inr late =>
    Eq.subst (motive := fun c => ¬ Learning.Misses c (o t)) (withBound_exact bound late).symm
      Learning.not_missed_self

/-- **No extrapolation can always propose sooner.** Given two values, no extrapolation that misses
at no step of every history with at most `M + 2` states proposes at step `M + M + 2` on each of
them; the extrapolation given the bound proposes from step `M + M + 3` on. -/
theorem withBound_earliest {x y : O} (two : x ≠ y) (pred : List O → Option O) (M : Nat) :
    ¬ ∀ o : Nat → O, StatesBelow o (M + 2) →
      Learning.Accords pred o ∧ ∃ w, pred (Learning.prefixOf o (M + M + 2)) = some w :=
  fun all =>
    match prefix_short_twice two M with
    | ⟨o, o', bound, bound', same, differ⟩ =>
      match all o bound, all o' bound' with
      | ⟨holds, w, claims⟩, ⟨holds', _, _⟩ =>
        have claims' : pred (Learning.prefixOf o' (M + M + 2)) = some w :=
          (congrArg pred same).symm.trans claims
        holds _ ⟨w, claims, fun right => holds' _ ⟨w, claims', fun right' =>
          differ (right.symm.trans right')⟩⟩

/-- **The liar's truth is derived.** The extrapolation given two states is right about
the two-valued negation at every step from `3` on: what no fixed value accords with
(`Diagonal.revision_never_rests`) is a rhythm read off the prefix. -/
theorem negation_derived : ∀ t, 3 ≤ t →
    withBound 2 (Learning.prefixOf Negation.course t) = some (Negation.course t) :=
  fun _ late => withBound_exact (statesBelow_of_same (Nat.zero_lt_succ 1) Negation.zero_two) late

/-- **The diagonal world of an extrapolation exceeds the bound it is given.** Where `other`
moves every value, the course on which every value the extrapolation given the bound `N`
proposes misses has more than `N` states. -/
theorem answer_exceeds_bound [DecidableEq O] {other : O → O} (moves : ∀ v, other v ≠ v)
    (x : O) (N : Nat) : ¬ StatesBelow (Learning.diagonal (withBound N) other x) N :=
  fun bound => Learning.diagonal_unrested (withBound N) moves x
    ⟨N + N - 1, fun _ late => withBound_exact bound late⟩

end WithBound

/-! ## Elimination not given the bound rests within it -/

section Resting

variable {O : Type u} [DecidableEq O] {o : Nat → O}

/-- **A lasso candidate without a miss for `N + N - 1` steps misses at no later step.** On a
history with at most `N` states, a lasso `(a, b)` within `N` that misses at no step from `s ≥ a`
to before `s + (N + N - 1)` misses at no step from `s` on: the stretch from `s` repeats with
period `b + 1` on its prefix before `N + N - 1`, so at every step (`lasso_of_fits`). -/
theorem no_miss_persists {N a b s : Nat} (bound : StatesBelow o N) (within : a + b + 1 ≤ N)
    (from_s : a ≤ s)
    (window : ∀ t, s ≤ t → t < s + (N + N - 1) →
      ¬ Learning.MissesAt (Learning.lasso (a, b)) o t) :
    ∀ t, s ≤ t → ¬ Learning.MissesAt (Learning.lasso (a, b)) o t := by
  have period_le : b + 1 ≤ N + N - 1 :=
    Nat.le_trans (Nat.le_trans (Nat.succ_le_succ (Nat.le_add_left b a)) within)
      (le_twice_less_one (statesBelow_pos bound))
  have fits : ∀ u, 0 ≤ u → u + (b + 1) < N + N - 1 →
      o (s + (u + (b + 1))) = o (s + u) := fun u _ lt =>
    have at_t : s + (u + (b + 1)) = s + u + b + 1 :=
      (Nat.add_assoc s u (b + 1)).symm
    have claims : Learning.lasso (a, b) (Learning.prefixOf o (s + (u + (b + 1)))) =
        some (o (s + u)) :=
      (Learning.lasso_claims (o := o) (h := (a, b))
        (Eq.subst (motive := fun n => a + b + 1 ≤ n) at_t.symm
          (Nat.succ_le_succ (Nat.add_le_add_right
            (Nat.le_trans from_s (Nat.le_add_right s u)) b)))).trans
        ((congrArg (fun n => Copying.nth (Learning.prefixOf o n) b) at_t).trans
          (Learning.back_prefix o (s + u) b))
    (Learning.eq_of_not_missed
      (Eq.subst (motive := fun c => ¬ Learning.Misses c (o (s + (u + (b + 1))))) claims
        (window _ (Nat.le_add_right s _) (Nat.add_lt_add_left lt s)))).symm
  have shifted : Learning.Lasso (fun n => o (s + n)) 0 b :=
    lasso_of_fits (statesBelow_shift bound s)
      (Nat.le_trans (Nat.le_of_eq (congrArg (· + 1) (Nat.zero_add b)))
        (Nat.le_trans (Nat.succ_le_succ (Nat.le_add_left b a)) within))
      fits
  have from_here : Learning.Lasso o s b := fun u le =>
    match le_dest le with
    | ⟨d, at_u⟩ =>
      (congrArg (fun n => o (n + (b + 1))) at_u).trans
        ((congrArg o (Nat.add_assoc s d (b + 1))).trans
          ((shifted d (Nat.zero_le d)).trans (congrArg o at_u.symm)))
  intro t from_t refuted
  match Nat.lt_or_ge t (s + (N + N - 1)) with
  | .inl early => exact window t from_t early refuted
  | .inr late =>
    have far : s + b + 1 ≤ t := Nat.le_trans (Nat.add_le_add_left period_le s) late
    have same : Learning.lasso (a, b) (Learning.prefixOf o t) =
        Learning.lasso (s, b) (Learning.prefixOf o t) :=
      (Learning.lasso_claims (o := o) (h := (a, b))
        (Nat.le_trans (Nat.succ_le_succ (Nat.add_le_add_right from_s b)) far)).trans
        (Learning.lasso_claims (o := o) (h := (s, b)) far).symm
    exact Learning.lasso_accords from_here t
      (Eq.subst (motive := fun c => Learning.Misses c (o t)) same refuted)

/-- **Elimination not given the bound comes to rest within it.** On a history with at
most `N` states, the extrapolation by elimination over the lasso candidates, given neither
`N` nor the course (`Becoming.Learning`'s `byElimination lassos`), proposes at every step from
`N + (N + N - 1) * tri N` on and is right. Its candidates all lie within `N`; in each stretch of
`N + N - 1` steps from `N` on it misses, or its current candidate never misses again
(`no_miss_persists`); it misses fewer than `tri N` times. Its prefix does not show the
step (`Becoming.Learning`'s `no_prefix_fixes_next_finite`); the bound does. -/
theorem byElimination_rests {N : Nat} (bound : StatesBelow o N) :
    ∀ t, N + (N + N - 1) * Learning.tri N ≤ t →
      Learning.byElimination Learning.lassos (Learning.prefixOf o t) = some (o t) := by
  match statesBelow_iff_lasso.mp bound with
  | ⟨i, q, within, repeats⟩ =>
    match Learning.lasso_byElimination_bounded repeats with
    | ⟨top, claims, _⟩ =>
      let W := N + N - 1
      let k := Learning.index Learning.lassos o
      let start := fun j => N + W * j
      have few : Learning.tri (i + q) + q + 1 ≤ Learning.tri N :=
        Nat.le_trans (Learning.place_lt i q)
          (match le_dest within with
           | ⟨d, at_N⟩ =>
             Eq.subst (motive := fun n => Learning.tri (i + q + 1) ≤ Learning.tri n) at_N.symm
               (Learning.tri_mono _ d))
      have held_within : ∀ t, (Learning.pairAt (k t)).1 + (Learning.pairAt (k t)).2 + 1 ≤ N :=
        fun t => Nat.le_trans (Nat.succ_le_succ (Nat.le_trans (Learning.diag_le (top t))
          (Nat.le_of_eq (congrArg Learning.diag (Learning.pairAt_place i q))))) within
      have stays : ∀ s, N ≤ s → k (s + W) = k s → ∀ t, s ≤ t →
          ¬ Learning.MissesAt (Learning.byElimination Learning.lassos) o t := by
        intro s from_N steady
        let h := Learning.pairAt (k s)
        have h_first : h.1 ≤ s :=
          Nat.le_trans (Nat.le_trans (Nat.le_add_right h.1 h.2)
            (Nat.le_trans (Nat.le_succ _) (held_within s))) from_N
        have flat : ∀ t, s ≤ t → t < s + W → k t = k s ∧ k (t + 1) = k s := fun t from_s lt =>
          have up : k (t + 1) ≤ k s :=
            Nat.le_trans (Learning.index_mono_le (Nat.succ_le_of_lt lt)) (Nat.le_of_eq steady)
          have mid : k t = k s :=
            Nat.le_antisymm (Nat.le_trans (Learning.index_le_succ t) up)
              (Learning.index_mono_le from_s)
          ⟨mid, Nat.le_antisymm up (Nat.le_trans (Nat.le_of_eq mid.symm)
            (Learning.index_le_succ t))⟩
        have claim_is : ∀ t, k t = k s →
            Learning.byElimination Learning.lassos (Learning.prefixOf o t) =
              Learning.lasso h (Learning.prefixOf o t) := fun t at_t =>
          congrArg (fun n => Learning.lasso (Learning.pairAt n) (Learning.prefixOf o t)) at_t
        have window : ∀ t, s ≤ t → t < s + W →
            ¬ Learning.MissesAt (Learning.lasso (h.1, h.2)) o t := fun t from_s lt refuted =>
          match flat t from_s lt with
          | ⟨mid, next⟩ =>
            Nat.succ_ne_self (k s) (((congrArg (· + 1) mid).symm.trans
              (Learning.index_missed (H := Learning.lassos) (o := o) (t := t)
                (Eq.subst (motive := fun c => Learning.Misses c (o t)) (claim_is t mid).symm
                  refuted)).symm).trans next)
        have never := no_miss_persists bound (held_within s) h_first window
        have kept : ∀ d, k (s + d) = k s := fun d =>
          Nat.rec (motive := fun d => k (s + d) = k s) rfl
            (fun d ih => (Learning.index_kept (fun refuted =>
              never (s + d) (Nat.le_add_right s d)
                (Eq.subst (motive := fun c => Learning.Misses c (o (s + d)))
                  (claim_is (s + d) ih) refuted))).trans ih) d
        intro t from_s refuted
        match le_dest from_s with
        | ⟨d, at_t⟩ =>
          have at_t_k : k t = k s := (congrArg k at_t).trans (kept d)
          exact never t from_s
            (Eq.subst (motive := fun c => Learning.Misses c (o t)) (claim_is t at_t_k) refuted)
      have climb : ∀ j, j ≤ k (start j) ∨
          ∀ t, start j ≤ t → ¬ Learning.MissesAt (Learning.byElimination Learning.lassos) o t := by
        intro j
        induction j with
        | zero => exact .inl (Nat.zero_le _)
        | succ j ih =>
          have step : start (j + 1) = start j + W := (Nat.add_assoc N (W * j) W).symm
          have later : start j ≤ start (j + 1) :=
            Eq.subst (motive := fun n => start j ≤ n) step.symm (Nat.le_add_right _ W)
          match ih with
          | .inr quiet => exact .inr fun t from_t => quiet t (Nat.le_trans later from_t)
          | .inl count =>
            have from_N : N ≤ start j := Nat.le_add_right N _
            match Nat.lt_or_ge (k (start j)) (k (start (j + 1))) with
            | .inl rose => exact .inl (Nat.le_trans (Nat.succ_le_succ count) (Nat.succ_le_of_lt rose))
            | .inr ge =>
              have steady : k (start j + W) = k (start j) :=
                Nat.le_antisymm (Eq.subst (motive := fun n => k n ≤ k (start j)) step ge)
                  (Learning.index_mono_le (Nat.le_add_right _ W))
              exact .inr fun t from_t =>
                stays (start j) from_N steady t (Nat.le_trans later from_t)
      have quiet : ∀ t, start (Learning.tri (i + q) + q + 1) ≤ t →
          ¬ Learning.MissesAt (Learning.byElimination Learning.lassos) o t :=
        match climb (Learning.tri (i + q) + q + 1) with
        | .inl count => absurd (Nat.le_trans count (top _)) (Nat.not_succ_le_self _)
        | .inr quiet => quiet
      have soon : start (Learning.tri (i + q) + q + 1) ≤ N + W * Learning.tri N :=
        Nat.add_le_add_left (Nat.mul_le_mul (Nat.le_refl W) few) N
      intro t late
      have kept := quiet t (Nat.le_trans soon late)
      match claims t (Nat.le_trans within (Nat.le_trans (Nat.le_add_right N _) late)) with
      | ⟨_, made⟩ =>
        exact made.trans (congrArg some (Learning.eq_of_not_missed fun refuted =>
          kept (Eq.subst (motive := fun c => Learning.Misses c (o t)) made.symm refuted)))

/-- **On a lasso course elimination comes to rest at a step that is found.** Where the course
repeats from step `i` with period `q + 1`, elimination over the lasso candidates proposes at every
step from a step bounded by `i` and `q` on and is right: the rest that `Becoming.Learning`'s
`rest_unrefuted` leaves unrefuted is found. -/
theorem rests_of_lasso {i q : Nat} (repeats : Learning.Lasso o i q) :
    ∃ T, ∀ t, T ≤ t → Learning.byElimination Learning.lassos (Learning.prefixOf o t) = some (o t) :=
  ⟨_, byElimination_rests (statesBelow_iff_lasso.mpr ⟨i, q, Nat.le_refl _, repeats⟩)⟩

/-- **Induction in a world held by a list: elimination rests within a bound on the list.** Under
a determined law whose configurations along an orbit are held by a list `l`, the extrapolation by
elimination over the lasso candidates, given neither the configurations nor their number,
proposes at every step from `N + (N + N - 1) * tri N` on and is right, `N` the length of
`l`. -/
theorem held_byElimination_rests {S : Type v} {next : S → S} {s : S} {l : List S}
    (held : ∀ n, Law.orbit next s n ∈ l) (reg : S → O) :
    ∀ t, l.length + (l.length + l.length - 1) * Learning.tri l.length ≤ t →
      Learning.byElimination Learning.lassos
          (Learning.prefixOf (fun n => reg (Law.orbit next s n)) t) =
        some (reg (Law.orbit next s t)) :=
  byElimination_rests (statesBelow_iff_lasso.mpr (Learning.lasso_of_held held reg))

end Resting

/-! ## The rest step needs no bound -/

section LeastBound

variable {O : Type u}

/-- The candidate found, or else the next search. -/
def orFit (found next : Option (Nat × Nat)) : Option (Nat × Nat) :=
  match found with
  | some h => some h
  | none => next

/-- The first lasso candidate the prefix bears out within the least bound `M ≤ m` within which
one is borne out. -/
def leastFit [DecidableEq O] (l : List O) : Nat → Option (Nat × Nat)
  | 0 => none
  | m + 1 => orFit (leastFit l m) (firstFit (Fits (m + 1) l) (decFits (m + 1) l) (grid (m + 1) (m + 1)))

/-- What the least bound finds within `m` is within `m` and borne out by the prefix. -/
theorem leastFit_sound [DecidableEq O] {l : List O} :
    ∀ {m : Nat} {h : Nat × Nat}, leastFit l m = some h → Fits m l h
  | 0, h, found => nomatch (found : (none : Option (Nat × Nat)) = some h)
  | m + 1, h, found =>
    match e : leastFit l m with
    | some h' =>
      have same : h' = h := Option.some.inj
        ((congrArg (fun f => orFit f (firstFit (Fits (m + 1) l) (decFits (m + 1) l)
          (grid (m + 1) (m + 1)))) e).symm.trans found)
      match leastFit_sound e with
      | ⟨within, borne⟩ => Eq.subst (motive := fun g => Fits (m + 1) l g) same
          ⟨Nat.le_succ_of_le within, borne⟩
    | none => firstFit_sound
        ((congrArg (fun f => orFit f (firstFit (Fits (m + 1) l) (decFits (m + 1) l)
          (grid (m + 1) (m + 1)))) e).symm.trans found)

/-- Where a candidate within `N` is borne out, the least bound finds one within `N`. -/
theorem leastFit_within [DecidableEq O] {l : List O} {N : Nat} {h₀ : Nat × Nat}
    (fits : Fits N l h₀) : ∀ {m : Nat}, N ≤ m → ∃ h, leastFit l m = some h ∧ h.1 + h.2 + 1 ≤ N
  | 0, le => absurd (Nat.le_trans fits.1 le) (Nat.not_succ_le_zero _)
  | m + 1, le =>
    have unfolds : ∀ f : Option (Nat × Nat), leastFit l m = f → leastFit l (m + 1) =
        orFit f (firstFit (Fits (m + 1) l) (decFits (m + 1) l) (grid (m + 1) (m + 1))) :=
      fun _ e => congrArg (fun f => orFit f (firstFit (Fits (m + 1) l) (decFits (m + 1) l)
        (grid (m + 1) (m + 1)))) e
    match e : leastFit l m with
    | some h =>
      ⟨h, unfolds _ e, match le_succ_cases le with
        | .inl le' => match leastFit_within fits le' with
          | ⟨_, found, within⟩ => Eq.subst (motive := fun g => g.1 + g.2 + 1 ≤ N)
              (Option.some.inj (found.symm.trans e)) within
        | .inr top => Eq.subst (motive := fun n => h.1 + h.2 + 1 ≤ n) top.symm
            (Nat.le_succ_of_le (leastFit_sound e).1)⟩
    | none => match le_succ_cases le with
      | .inl le' => match leastFit_within fits le' with
        | ⟨h', found, _⟩ => nomatch (found.symm.trans e : some h' = none)
      | .inr top =>
        have fits' : Fits (m + 1) l h₀ := Eq.subst (motive := fun n => Fits n l h₀) top fits
        have member : h₀ ∈ grid (m + 1) (m + 1) :=
          mem_grid (Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_left h₀.2 h₀.1)) fits'.1)
            (Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_right h₀.1 h₀.2)) fits'.1)
        match firstFit_found (dec := decFits (m + 1) l) member fits' with
        | ⟨h, found⟩ => ⟨h, (unfolds _ e).trans found,
            Eq.subst (motive := fun n => h.1 + h.2 + 1 ≤ n) top.symm (firstFit_sound found).1⟩

/-- **The extrapolation by the least bound.** Built without a bound, it proposes by the first
lasso candidate the prefix bears out within the least bound within which one is. -/
def leastBound [DecidableEq O] (l : List O) : Option O := claimBy l (leastFit l l.length)

/-- **The rest step needs no bound.** The extrapolation by the least bound, given no bound,
is right at every step from `N + N - 1` on of every history with at most `N` states, for every
`N`: as early as the extrapolation given the bound `N` (`withBound_exact`), and as early as any
extrapolation can be (`rest_earliest`). What it finds is within the true bound, since the
candidate that accords is borne out, and a candidate within `N` borne out before `N + N - 1`
accords (`bounded_induction`). -/
theorem leastBound_exact [DecidableEq O] {o : Nat → O} {N t : Nat} (bound : StatesBelow o N)
    (late : N + N - 1 ≤ t) : leastBound (Learning.prefixOf o t) = some (o t) :=
  have N_le : N ≤ N + N - 1 := le_twice_less_one (statesBelow_pos bound)
  have long : N ≤ (Learning.prefixOf o t).length :=
    Eq.subst (motive := fun n => N ≤ n) (Learning.prefix_length o t).symm (Nat.le_trans N_le late)
  match bounded_hypothesis bound with
  | ⟨i, q, within, holds⟩ =>
    match leastFit_within (l := Learning.prefixOf o t) (h₀ := (i, q))
        ⟨within, borneOut_prefix_iff.mpr fun t' _ => holds t'⟩ long with
    | ⟨(i', q'), found, within'⟩ =>
      have borne := (leastFit_sound found).2
      have speaks : i' + q' + 1 ≤ t := Nat.le_trans within' (Nat.le_trans N_le late)
      have holds' : Learning.Accords (Learning.lasso (i', q')) o :=
        bounded_induction bound within' fun t' lt =>
          borneOut_prefix_iff.mp borne t' (Nat.lt_of_lt_of_le lt late)
      match Learning.back_made o
          (Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_left q' i')) speaks) with
      | ⟨v, at_back⟩ =>
        have value : Learning.lasso (i', q') (Learning.prefixOf o t) = some v :=
          (Learning.lasso_claims (o := o) (h := (i', q')) speaks).trans at_back
        have right : v = o t :=
          Learning.eq_of_not_missed
            (Eq.subst (motive := fun c => ¬ Learning.Misses c (o t)) value (holds' t))
        (congrArg (claimBy (Learning.prefixOf o t)) found).trans (value.trans (congrArg some right))

/-- **No extrapolation rests sooner.** Given two values, no extrapolation is right at step
`M + M + 2` on every history with at most `M + 2` states: with or without the bound, `N + N - 1`
is the earliest step from which an extrapolation can be right on every history with at most
`N ≥ 2` states. -/
theorem rest_earliest {x y : O} (two : x ≠ y) (pred : List O → Option O) (M : Nat) :
    ¬ ∀ o : Nat → O, StatesBelow o (M + 2) →
      pred (Learning.prefixOf o (M + M + 2)) = some (o (M + M + 2)) :=
  fun all => match prefix_short_twice two M with
    | ⟨o, o', bound, bound', same, differ⟩ =>
      differ (Option.some.inj ((all o bound).symm.trans ((congrArg pred same).trans (all o' bound'))))

/-- **Being given the bound buys silence, not an earlier rest.** Given two values, no extrapolation right at
step `1` on every history with one state misses at no step of every history with two states. An
extrapolation not given the bound that rests at `N + N - 1` for every `N`, as the
extrapolation by the least bound does, proposes where a larger bound would keep it silent, and
misses there; the extrapolation given the bound is silent instead (`withBound_accords`). -/
theorem rest_without_bound_missed {x y : O} (two : x ≠ y) (pred : List O → Option O) :
    ¬ ((∀ o : Nat → O, StatesBelow o 1 → pred (Learning.prefixOf o 1) = some (o 1)) ∧
      ∀ o : Nat → O, StatesBelow o 2 → Learning.Accords pred o) :=
  fun ⟨rests, holds⟩ =>
    have still_one : StatesBelow (fun _ => x) 1 :=
      statesBelow_iff_lasso.mpr ⟨0, 0, Nat.le_refl 1, fun _ _ => rfl⟩
    have turn_two : StatesBelow (Learning.holdFrom (fun _ => x) 1 y) 2 :=
      statesBelow_iff_lasso.mpr ⟨1, 0, Nat.le_refl 2, Learning.holdFrom_lasso (fun _ => x) 1 y⟩
    have same : Learning.prefixOf (Learning.holdFrom (fun _ => x) 1 y) 1 =
        Learning.prefixOf (fun _ => x) 1 :=
      congrArg (· :: []) (Learning.holdFrom_before (fun _ => x) y Nat.zero_lt_one)
    holds _ turn_two 1 ⟨x, (congrArg pred same).trans (rests _ still_one), fun right =>
      two (right.trans (Learning.holdFrom_after (fun _ => x) y (Nat.le_refl 1)))⟩

end LeastBound

/-! ## Elimination rests at a cubic step -/

section CubicRest

theorem course_two (a : Nat) : Negation.course (a + 2) = Negation.course a :=
  ListTests.not_not (Negation.course a)

theorem course_even (a : Nat) : ∀ e, Negation.course (a + 2 * e) = Negation.course a
  | 0 => rfl
  | e + 1 => (course_two (a + 2 * e)).trans (course_even a e)

theorem course_double : ∀ e, Negation.course (2 * e) = true
  | 0 => rfl
  | e + 1 => (course_two (2 * e)).trans (course_double e)

theorem course_odd (e : Nat) : Negation.course (2 * e + 1) = false :=
  congrArg (fun b => !b) (course_double e)

/-- The place along a cycle of `n + 1` places. -/
def cyclePos (n t : Nat) : Nat := Law.orbit (Learning.lassoNext 0 n) 0 t

theorem cyclePos_block (n : Nat) : ∀ (j : Nat) {x : Nat}, x ≤ n → cyclePos n ((n + 1) * j + x) = x
  | 0, x, le =>
    (congrArg (cyclePos n) (Nat.zero_add x)).trans
      (lassoPos_early (i := 0) (q := n) x
        (Eq.subst (motive := fun b => x ≤ b) (Nat.zero_add n).symm le))
  | j + 1, x, le =>
    have shape : (n + 1) * (j + 1) + x = 0 + ((n + 1) * j + x) + (n + 1) :=
      (Nat.add_right_comm ((n + 1) * j) (n + 1) x).trans
        (congrArg (· + (n + 1)) (Nat.zero_add _).symm)
    (congrArg (cyclePos n) shape).trans
      ((lassoPos_period (i := 0) (q := n) ((n + 1) * j + x)).trans
        ((congrArg (cyclePos n) (Nat.zero_add _)).trans (cyclePos_block n j le)))

/-- **The two-valued negation along a cycle of `n + 1` places.** Where `n + 1` is odd, the
negation cannot close around the cycle: it is broken once in every turn. -/
def oddCycle (n t : Nat) : Bool := Negation.course (cyclePos n t)

theorem oddCycle_block (n j : Nat) {x : Nat} (le : x ≤ n) :
    oddCycle n ((n + 1) * j + x) = Negation.course x :=
  congrArg Negation.course (cyclePos_block n j le)

/-- The negation along a cycle of `n + 1` places has at most `n + 1` states. -/
theorem oddCycle_lasso (n : Nat) : Learning.Lasso (oddCycle n) 0 n := fun u _ =>
  congrArg Negation.course
    ((congrArg (cyclePos n) (congrArg (· + (n + 1)) (Nat.zero_add u).symm)).trans
      ((lassoPos_period (i := 0) (q := n) u).trans (congrArg (cyclePos n) (Nat.zero_add u))))

theorem oddCycle_below (n : Nat) : StatesBelow (oddCycle n) (n + 1) :=
  statesBelow_iff_lasso.mpr ⟨0, n, Nat.le_of_eq (congrArg (· + 1) (Nat.zero_add n)),
    oddCycle_lasso n⟩

/-- A lasso candidate proposes the value `q + 1` steps back. -/
theorem lasso_back {O : Type u} {o : Nat → O} {i q u : Nat} (from_i : i ≤ u) :
    Learning.lasso (i, q) (Learning.prefixOf o (u + q + 1)) = some (o u) :=
  (Learning.lasso_claims (o := o) (h := (i, q))
    (Nat.succ_le_succ (Nat.add_le_add_right from_i q))).trans (Learning.back_prefix o u q)

/-- Elimination keeps a candidate that does not miss. -/
theorem run_kept {O : Type u} [DecidableEq O] {H : Nat → List O → Option O} {o : Nat → O}
    {s k : Nat} (held : Learning.index H o s = k) :
    ∀ w, (∀ d, d < w → ¬ Learning.Misses (H k (Learning.prefixOf o (s + d))) (o (s + d))) →
      Learning.index H o (s + w) = k
  | 0, _ => held
  | w + 1, right =>
    have before : Learning.index H o (s + w) = k :=
      run_kept held w (fun d lt => right d (Nat.lt_succ_of_lt lt))
    (Learning.index_kept (fun refuted => right w (Nat.lt_succ_self w)
      (Eq.subst (motive := fun j => Learning.Misses (H j (Learning.prefixOf o (s + w))) (o (s + w)))
        before refuted))).trans before

/-- Elimination moves on from a candidate that misses. -/
theorem moved_on {O : Type u} [DecidableEq O] {H : Nat → List O → Option O} {o : Nat → O}
    {t k : Nat} (held : Learning.index H o t = k)
    (wrong : Learning.Misses (H k (Learning.prefixOf o t)) (o t)) :
    Learning.MissesAt (Learning.byElimination H) o t ∧ Learning.index H o (t + 1) = k + 1 :=
  have refuted : Learning.MissesAt (Learning.byElimination H) o t :=
    Eq.subst (motive := fun j => Learning.Misses (H j (Learning.prefixOf o t)) (o t)) held.symm wrong
  ⟨refuted, (Learning.index_missed refuted).trans (congrArg (· + 1) held)⟩

theorem missed_of {v w : Bool} {c : Option Bool} (claims : c = some v) (differs : v ≠ w) :
    Learning.Misses c w := ⟨v, claims, differs⟩

theorem not_missed_of {v w : Bool} {c : Option Bool} (claims : c = some v) (same : v = w) :
    ¬ Learning.Misses c w :=
  Eq.subst (motive := fun c => ¬ Learning.Misses c w) claims.symm
    (Eq.subst (motive := fun x => ¬ Learning.Misses (some x) w) same.symm Learning.not_missed_self)

theorem four_assoc (a x q : Nat) : a + x + q + 1 = a + (x + q + 1) :=
  congrArg (· + 1) (Nat.add_assoc a x q)

theorem shift_run (a x q d : Nat) : a + x + q + 1 + d = a + (x + d) + q + 1 :=
  (Nat.add_right_comm (a + x + q) 1 d).trans
    (congrArg (· + 1) ((Nat.add_right_comm (a + x) q d).trans
      (congrArg (· + q) (Nat.add_assoc a x d))))

variable {n : Nat}

/-- **An even shift runs to the end of the turn.** The candidate proposing the value `2e + 2`
steps back, current from a place at least `2e + 2` into a turn of the odd cycle, is right to the
end of the turn and misses at its first place. -/
theorem even_shift_runs {e g j s₀ w i k : Nat} (fit : 2 * e + 2 + (2 * g + 1) = n + 1)
    (run : s₀ + w = 2 * g + 1) (from_i : i ≤ (n + 1) * j + s₀)
    (pair : Learning.pairAt k = (i, 2 * e + 1))
    (held : Learning.index Learning.lassos (oddCycle n) ((n + 1) * j + s₀ + (2 * e + 1) + 1) = k) :
    Learning.MissesAt (Learning.byElimination Learning.lassos) (oddCycle n) ((n + 1) * (j + 1)) ∧
      Learning.index Learning.lassos (oddCycle n) ((n + 1) * (j + 1) + 1) = k + 1 := by
  let B := (n + 1) * j
  let o := oddCycle n
  have claim : ∀ x, i ≤ B + x →
      Learning.lassos k (Learning.prefixOf o (B + x + (2 * e + 1) + 1)) = some (o (B + x)) :=
    fun x le => (congrArg (fun h => Learning.lasso h (Learning.prefixOf o (B + x + (2 * e + 1) + 1)))
      pair).trans (lasso_back le)
  have room : ∀ d, d < w → s₀ + d + (2 * e + 2) ≤ n := fun d lt =>
    Nat.le_of_lt_succ (Eq.subst (motive := fun b => s₀ + d + (2 * e + 2) < b) fit
      (Eq.subst (motive := fun b => s₀ + d + (2 * e + 2) < b)
        (Nat.add_comm (2 * g + 1) (2 * e + 2))
        (Nat.add_lt_add_right (Eq.subst (motive := fun b => s₀ + d < b) run
          (Nat.add_lt_add_left lt s₀)) (2 * e + 2))))
  have kept := run_kept held w fun d lt =>
    have le := room d lt
    not_missed_of
      ((congrArg (fun t => Learning.lassos k (Learning.prefixOf o t)) (shift_run B s₀ (2 * e + 1) d)).trans
        ((claim (s₀ + d) (Nat.le_trans from_i (Nat.add_le_add_left (Nat.le_add_right s₀ d) B))).trans
          (congrArg some (oddCycle_block n j
            (Nat.le_trans (Nat.le_add_right (s₀ + d) (2 * e + 2)) le)))))
      ((course_even (s₀ + d) (e + 1)).symm.trans
        ((oddCycle_block n j le).symm.trans
          (congrArg o ((four_assoc B (s₀ + d) (2 * e + 1)).symm.trans
            (shift_run B s₀ (2 * e + 1) d).symm))))
  have at_end : (n + 1) * j + s₀ + (2 * e + 1) + 1 + w = (n + 1) * (j + 1) :=
    (shift_run B s₀ (2 * e + 1) w).trans
      ((congrArg (fun x => B + x + (2 * e + 1) + 1) run).trans
        ((four_assoc B (2 * g + 1) (2 * e + 1)).trans
          (congrArg (B + ·) ((Nat.add_comm (2 * g + 1) (2 * e + 2)).trans fit))))
  have g_le : 2 * g + 1 ≤ n := Nat.le_of_lt_succ (Eq.subst (motive := fun b => 2 * g + 1 < b) fit
    (Eq.subst (motive := fun b => 2 * g + 1 < b) (Nat.add_comm (2 * g + 1) (2 * e + 2))
      (Nat.lt_add_of_pos_right (Nat.zero_lt_succ _))))
  have held_end : Learning.index Learning.lassos o ((n + 1) * (j + 1)) = k :=
    Eq.subst (motive := fun t => Learning.index Learning.lassos o t = k) at_end kept
  have wrong : Learning.Misses (Learning.lassos k (Learning.prefixOf o ((n + 1) * (j + 1))))
      (o ((n + 1) * (j + 1))) :=
    missed_of
      ((congrArg (fun t => Learning.lassos k (Learning.prefixOf o t))
        ((at_end.symm.trans (shift_run B s₀ (2 * e + 1) w)).trans
          (congrArg (fun x => B + x + (2 * e + 1) + 1) run))).trans
        ((claim (2 * g + 1) (Eq.subst (motive := fun x => i ≤ B + x) run
          (Nat.le_trans from_i (Nat.add_le_add_left (Nat.le_add_right s₀ w) B)))).trans
          (congrArg some ((oddCycle_block n j g_le).trans (course_odd g)))))
      (fun same => nomatch (same.trans (oddCycle_block n (j + 1) (Nat.zero_le n)) : false = true))
  exact moved_on held_end wrong

/-- **An odd shift runs to its own place.** The candidate proposing the value `2e + 1` steps
back, current from a place `a ≤ 2e + 1` of a turn after the first, is right before place `2e + 1`
and misses there. -/
theorem odd_shift_runs {e h j a w i k : Nat} (fit : 2 * e + 1 + 2 * (h + 1) = n + 1)
    (run : a + w = 2 * e + 1) (diag : i + 2 * e ≤ n)
    (pair : Learning.pairAt k = (i, 2 * e))
    (held : Learning.index Learning.lassos (oddCycle n) ((n + 1) * (j + 1) + a) = k) :
    Learning.MissesAt (Learning.byElimination Learning.lassos) (oddCycle n)
        ((n + 1) * (j + 1) + (2 * e + 1)) ∧
      Learning.index Learning.lassos (oddCycle n) ((n + 1) * (j + 1) + (2 * e + 1) + 1) = k + 1 := by
  let B' := (n + 1) * j
  let B := (n + 1) * (j + 1)
  let o := oddCycle n
  have claim : ∀ u, i ≤ u →
      Learning.lassos k (Learning.prefixOf o (u + 2 * e + 1)) = some (o u) :=
    fun u le => (congrArg (fun p => Learning.lasso p (Learning.prefixOf o (u + 2 * e + 1)))
      pair).trans (lasso_back le)
  have i_le : i ≤ n := Nat.le_trans (Nat.le_add_right i (2 * e)) diag
  have late : n + 1 ≤ B := Nat.le_add_left (n + 1) B'
  have back_turn : ∀ r, B' + (r + 2 * (h + 1)) + 2 * e + 1 = B + r := fun r =>
    (four_assoc B' (r + 2 * (h + 1)) (2 * e)).trans
      ((congrArg (B' + ·) ((congrArg (· + 1) (Nat.add_assoc r (2 * (h + 1)) (2 * e))).trans
        ((congrArg (r + ·) ((Nat.add_comm (2 * (h + 1)) (2 * e + 1)).trans fit)).trans
          (Nat.add_comm r (n + 1))))).trans (Nat.add_assoc B' (n + 1) r).symm)
  have kept := run_kept held w fun d lt =>
    have r_lt : a + d < 2 * e + 1 := Eq.subst (motive := fun b => a + d < b) run
      (Nat.add_lt_add_left lt a)
    have r_le : a + d ≤ n := Nat.le_trans (Nat.le_of_lt_succ r_lt)
      (Nat.le_trans (Nat.le_add_left (2 * e) i) diag)
    have u_le : a + d + 2 * (h + 1) ≤ n := Nat.le_of_lt_succ
      (Eq.subst (motive := fun b => a + d + 2 * (h + 1) < b) fit
        (Nat.add_lt_add_right r_lt (2 * (h + 1))))
    have at_t : B + a + d = B' + (a + d + 2 * (h + 1)) + 2 * e + 1 :=
      (Nat.add_assoc B a d).trans (back_turn (a + d)).symm
    have chain : i + 2 * e + 1 ≤ B' + (a + d + 2 * (h + 1)) + 2 * e + 1 :=
      Nat.le_trans (Nat.le_trans (Nat.succ_le_succ diag) late)
        (Eq.subst (motive := fun b => B ≤ b) (back_turn (a + d)).symm (Nat.le_add_right B (a + d)))
    have from_i : i ≤ B' + (a + d + 2 * (h + 1)) :=
      le_of_add_le_add_right (2 * e) (Nat.le_of_succ_le_succ chain)
    not_missed_of
      ((congrArg (fun t => Learning.lassos k (Learning.prefixOf o t)) at_t).trans
        ((claim _ from_i).trans (congrArg some (oddCycle_block n j u_le))))
      ((course_even (a + d) (h + 1)).trans
        ((oddCycle_block n (j + 1) r_le).symm.trans
          (congrArg o (Nat.add_assoc B a d).symm)))
  have at_end : (n + 1) * (j + 1) + a + w = (n + 1) * (j + 1) + (2 * e + 1) :=
    (Nat.add_assoc B a w).trans (congrArg (B + ·) run)
  have held_end : Learning.index Learning.lassos o (B + (2 * e + 1)) = k :=
    Eq.subst (motive := fun t => Learning.index Learning.lassos o t = k) at_end kept
  have e_le : 2 * e + 1 ≤ n := Nat.le_of_lt_succ (Eq.subst (motive := fun b => 2 * e + 1 < b) fit
    (Nat.lt_add_of_pos_right (Nat.zero_lt_succ _)))
  have wrong : Learning.Misses (Learning.lassos k (Learning.prefixOf o (B + (2 * e + 1))))
      (o (B + (2 * e + 1))) :=
    missed_of ((claim B (Nat.le_trans i_le (Nat.le_trans (Nat.le_succ n) late))).trans
        (congrArg some (oddCycle_block n (j + 1) (Nat.zero_le n))))
      (fun same => nomatch (same.trans ((oddCycle_block n (j + 1) e_le).trans (course_odd e)) :
        true = false))
  exact moved_on held_end wrong

/-- **The shift by one misses at once** anywhere inside a turn. -/
theorem unit_shift_missed {j x i k : Nat} (inside : x + 1 ≤ n) (from_i : i ≤ (n + 1) * j + x)
    (pair : Learning.pairAt k = (i, 0))
    (held : Learning.index Learning.lassos (oddCycle n) ((n + 1) * j + x + 1) = k) :
    Learning.MissesAt (Learning.byElimination Learning.lassos) (oddCycle n) ((n + 1) * j + x + 1) ∧
      Learning.index Learning.lassos (oddCycle n) ((n + 1) * j + x + 1 + 1) = k + 1 :=
  moved_on held (missed_of
    ((congrArg (fun p => Learning.lasso p (Learning.prefixOf (oddCycle n) ((n + 1) * j + x + 1)))
      pair).trans ((lasso_back (q := 0) from_i).trans
        (congrArg some (oddCycle_block n j (Nat.le_of_succ_le inside)))))
    (fun same => ListTests.not_ne_self (Negation.course x)
      (same.trans (oddCycle_block n j (x := x + 1) inside)).symm))

/-- The current pair of elimination over the lasso candidates one step into turn `J` of the
negation along a cycle of `n + 1` places. -/
def turnHeld (n J : Nat) : Nat × Nat :=
  Learning.pairAt (Learning.index Learning.lassos (oddCycle n) ((n + 1) * J + 1))

theorem turn_fit {e M : Nat} (lt : e < M) : ∃ g, 2 * e + 2 + (2 * g + 1) = 2 * M + 1 :=
  match gap_of_lt lt with
  | ⟨g, at_M⟩ => ⟨g, congrArg (· + 1)
      (((Nat.add_assoc (2 * e) 2 (2 * g)).trans (congrArg (2 * e + ·) (Nat.add_comm 2 (2 * g)))).trans
        ((Nat.left_distrib 2 e (g + 1)).symm.trans (congrArg (2 * ·) at_M.symm)))⟩

theorem turn_room {e g M : Nat} (fit : 2 * e + 2 + (2 * g + 1) = 2 * M + 1) : 2 * e + 2 ≤ 2 * M :=
  Nat.le_of_succ_le_succ (Eq.subst (motive := fun b => 2 * e + 2 + 1 ≤ b) fit
    (Nat.add_le_add_left (Nat.succ_le_succ (Nat.zero_le (2 * g))) (2 * e + 2)))

/-- **A pair of shifts in one turn.** Current one step into a turn, an odd shift `2e + 1` not
ending its diagonal misses at its place and the even shift after it at the start of the
next turn. -/
theorem turn_pair {M e i j : Nat} (lt : e < M) (diag : i + 1 + 2 * e ≤ 2 * M)
    (now : turnHeld (2 * M) (j + 1) = (i + 1, 2 * e)) :
    Learning.MissesAt (Learning.byElimination Learning.lassos) (oddCycle (2 * M))
        ((2 * M + 1) * (j + 1 + 1)) ∧
      turnHeld (2 * M) (j + 1 + 1) = Learning.nextPair (i, 2 * e + 1) :=
  let k := Learning.index Learning.lassos (oddCycle (2 * M)) ((2 * M + 1) * (j + 1) + 1)
  match turn_fit lt with
  | ⟨g, fit⟩ =>
    have fitO : 2 * e + 1 + 2 * (g + 1) = 2 * M + 1 :=
      (congrArg (· + 1) (Nat.add_right_comm (2 * e + 1) 1 (2 * g))).symm.trans fit
    have pair₁ : Learning.pairAt (k + 1) = (i, 2 * e + 1) := congrArg Learning.nextPair now
    match odd_shift_runs (n := 2 * M) (a := 1) (w := 2 * e) (k := k) fitO (Nat.add_comm 1 (2 * e))
      diag now rfl with
    | ⟨_, next⟩ =>
      match even_shift_runs (n := 2 * M) (j := j + 1) (s₀ := 0) (w := 2 * g + 1) (k := k + 1) fit
        (Nat.zero_add _)
        (Nat.le_trans (Nat.le_trans (Nat.le_succ i)
          (Nat.le_trans (Nat.le_add_right (i + 1) (2 * e)) diag))
          (Nat.le_trans (Nat.le_succ (2 * M)) (Nat.le_add_left (2 * M + 1) ((2 * M + 1) * j))))
        pair₁ next with
      | ⟨refuted, after⟩ =>
        ⟨refuted, ((congrArg Learning.pairAt after).trans
          (congrArg Learning.nextPair pair₁ : Learning.pairAt (k + 1 + 1) = _))⟩

/-- **The end of a diagonal of odd length.** Current one step into a turn, the odd shift `2e + 1`
ending its diagonal misses at its place, the shift by one opening the next diagonal at
once, and the shift by two at the start of the next turn. -/
theorem turn_end {M e j : Nat} (lt : e < M) (now : turnHeld (2 * M) (j + 1) = (0, 2 * e)) :
    Learning.MissesAt (Learning.byElimination Learning.lassos) (oddCycle (2 * M))
        ((2 * M + 1) * (j + 1 + 1)) ∧
      turnHeld (2 * M) (j + 1 + 1) = Learning.nextPair (2 * e, 1) :=
  let k := Learning.index Learning.lassos (oddCycle (2 * M)) ((2 * M + 1) * (j + 1) + 1)
  match turn_fit lt with
  | ⟨g, fit⟩ =>
    have fitO : 2 * e + 1 + 2 * (g + 1) = 2 * M + 1 :=
      (congrArg (· + 1) (Nat.add_right_comm (2 * e + 1) 1 (2 * g))).symm.trans fit
    have pair₁ : Learning.pairAt (k + 1) = (2 * e + 1, 0) := congrArg Learning.nextPair now
    have pair₂ : Learning.pairAt (k + 1 + 1) = (2 * e, 2 * 0 + 1) := congrArg Learning.nextPair pair₁
    have room := turn_room fit
    match odd_shift_runs (n := 2 * M) (a := 1) (w := 2 * e) (k := k) fitO (Nat.add_comm 1 (2 * e))
      (Eq.subst (motive := fun b => b ≤ 2 * M) (Nat.zero_add (2 * e)).symm
        (Nat.le_trans (Nat.le_add_right (2 * e) 2) room)) now rfl with
    | ⟨_, first⟩ =>
      match unit_shift_missed (n := 2 * M) (j := j + 1) (x := 2 * e + 1) (k := k + 1) room
        (Nat.le_add_left (2 * e + 1) _) pair₁ first with
      | ⟨_, second⟩ =>
        have fitE : 2 * 0 + 2 + (2 * (e + g) + 1) = 2 * M + 1 :=
          (congrArg (· + 1) ((congrArg (2 + ·) (Nat.left_distrib 2 e g)).trans
            ((Nat.add_comm 2 (2 * e + 2 * g)).trans
              (Nat.add_right_comm (2 * e) 2 (2 * g)).symm))).trans fit
        match even_shift_runs (n := 2 * M) (e := 0) (g := e + g) (j := j + 1) (s₀ := 2 * e + 1)
          (w := 2 * g) (k := k + 1 + 1) fitE
          ((Nat.add_right_comm (2 * e) 1 (2 * g)).trans
            (congrArg (· + 1) (Nat.left_distrib 2 e g).symm))
          (Nat.le_trans (Nat.le_succ (2 * e)) (Nat.le_add_left (2 * e + 1) _))
          pair₂ second with
        | ⟨refuted, after⟩ =>
          ⟨refuted, ((congrArg Learning.pairAt after).trans
            (congrArg Learning.nextPair pair₂ : Learning.pairAt (k + 1 + 1 + 1) = _))⟩

/-- **A walk along a diagonal.** From an odd shift `2e + 1`, each pair of shifts takes one
turn. -/
theorem turn_walk {M : Nat} : ∀ (f e j i : Nat), e + f ≤ M → i + 2 * f + 2 * e ≤ 2 * M →
    turnHeld (2 * M) (j + 1) = (i + 2 * f, 2 * e) → turnHeld (2 * M) (j + 1 + f) = (i, 2 * (e + f))
  | 0, _, _, _, _, _, now => now
  | f + 1, e, j, i, room, diag, now =>
    match turn_pair (i := i + 2 * f + 1)
      (Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_right e f)) room) diag now with
    | ⟨_, next⟩ =>
      have after := turn_walk f (e + 1) (j + 1) i
        (Eq.subst (motive := fun b => b ≤ M) (Nat.add_right_comm e f 1) room)
        (Eq.subst (motive := fun b => b ≤ 2 * M) (Nat.add_right_comm (i + 2 * f) 2 (2 * e)) diag)
        next
      (congrArg (turnHeld (2 * M)) (Nat.add_right_comm (j + 1) 1 f).symm).trans
        (after.trans (congrArg (fun x => (i, 2 * x)) (Nat.add_right_comm e 1 f)))

/-- **Two diagonals take an odd number of turns.** One step into a turn at the start of the
diagonal `2c + 2`, elimination is one step into the turn `2c + 3` later at the start of the
diagonal `2c + 4`. -/
theorem turn_double {M c j : Nat} (room : c + 2 ≤ M)
    (now : turnHeld (2 * M) (j + 1) = (2 * (c + 1), 0)) :
    turnHeld (2 * M) (j + (c + 1) + 1 + c + 1 + 1) = (2 * (c + 2), 0) :=
  have twice : 2 * c + 4 ≤ 2 * M := Nat.mul_le_mul_left 2 room
  have first := turn_walk (M := M) (c + 1) 0 j 0
    (Eq.subst (motive := fun b => b ≤ M) (Nat.zero_add (c + 1)).symm (Nat.le_of_succ_le room))
    (Eq.subst (motive := fun b => b + 2 * 0 ≤ 2 * M) (Nat.zero_add (2 * (c + 1))).symm
      (Nat.le_trans (Nat.le_add_right (2 * c + 2) 2) twice))
    (now.trans (congrArg (·, 0) (Nat.zero_add (2 * (c + 1))).symm))
  have first' : turnHeld (2 * M) (j + (c + 1) + 1) = (0, 2 * (c + 1)) :=
    (congrArg (turnHeld (2 * M)) (Nat.add_right_comm j 1 (c + 1))).symm.trans
      (first.trans (congrArg (fun x => (0, 2 * x)) (Nat.zero_add (c + 1))))
  match turn_end (e := c + 1) room first' with
  | ⟨_, turned⟩ =>
    have second := turn_walk (M := M) c 1 (j + (c + 1) + 1) 1
      (Eq.subst (motive := fun b => b ≤ M) (Nat.add_comm c 1) (Nat.le_of_succ_le room))
      (Eq.subst (motive := fun b => b + 2 * 1 ≤ 2 * M) (Nat.add_comm (2 * c) 1)
        (Nat.le_trans (Nat.le_succ (2 * c + 3)) twice))
      ((turned : turnHeld (2 * M) (j + (c + 1) + 1 + 1) = (2 * c + 1, 2)).trans
        (congrArg (·, 2) (Nat.add_comm (2 * c) 1)))
    match turn_pair (i := 0) (e := 1 + c) (j := j + (c + 1) + 1 + c)
      (Eq.subst (motive := fun b => b + 1 ≤ M) (Nat.add_comm c 1) room)
      (Eq.subst (motive := fun b => 0 + 1 + 2 * b ≤ 2 * M) (Nat.add_comm c 1)
        (Eq.subst (motive := fun b => b ≤ 2 * M) (Nat.add_comm (2 * (c + 1)) 1)
          (Nat.le_trans (Nat.le_succ (2 * c + 3)) twice)))
      ((congrArg (turnHeld (2 * M)) (Nat.add_right_comm (j + (c + 1) + 1) 1 c)).symm.trans second) with
    | ⟨_, ended⟩ =>
      (ended : turnHeld (2 * M) _ = (2 * (1 + c) + 1 + 1, 0)).trans
        (congrArg (fun x => (2 * (x + 1), 0)) (Nat.add_comm 1 c))

/-- **The first turn.** One step into the second turn the current candidate is the start of the
diagonal `2`. -/
theorem start_turn (m : Nat) : turnHeld (2 * (m + 1)) 1 = (2, 0) :=
  have first : Learning.index Learning.lassos (oddCycle (2 * (m + 1))) 1 = 0 := rfl
  match unit_shift_missed (n := 2 * (m + 1)) (j := 0) (x := 0) (i := 0) (k := 0)
    (Nat.succ_le_succ (Nat.zero_le _)) (Nat.zero_le _) rfl first with
  | ⟨_, second⟩ =>
    match unit_shift_missed (n := 2 * (m + 1)) (j := 0) (x := 1) (i := 1) (k := 0 + 1)
      (Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le _))) (Nat.le_refl _) rfl second with
    | ⟨_, third⟩ =>
      match even_shift_runs (n := 2 * (m + 1)) (e := 0) (g := m) (j := 0) (s₀ := 1) (w := 2 * m) (i := 0)
        (k := 0 + 1 + 1)
        (congrArg (· + 1) (Nat.add_comm 2 (2 * m)) : 2 * 0 + 2 + (2 * m + 1) = 2 * (m + 1) + 1)
        (Nat.add_comm 1 (2 * m)) (Nat.zero_le _) rfl third with
      | ⟨_, fourth⟩ => congrArg Learning.pairAt fourth

/-- **The diagonals in pairs.** One step into turn `(c + 1)²` the current candidate is the start
of the diagonal `2c + 2`. -/
theorem turn_diagonals (m : Nat) : ∀ c, c + 1 ≤ m + 1 →
    turnHeld (2 * (m + 1)) ((c + 1) * (c + 1)) = (2 * (c + 1), 0)
  | 0, _ => start_turn m
  | c + 1, room =>
    (congrArg (turnHeld (2 * (m + 1)))
      (congrArg (fun y => y + (c + 2) + (c + 2)) (Nat.succ_mul (c + 1) c) :
        (c + 1 + 1) * (c + 1 + 1) = (c + 1) * c + c + (c + 1) + 1 + c + 1 + 1)).trans
      (turn_double (j := (c + 1) * c + c) room (turn_diagonals m c (Nat.le_of_succ_le room)))

/-- **Elimination misses at a cubic step.** On the two-valued negation along a cycle of
`N = 2m + 3` places, a history with at most `N` states, the extrapolation by elimination over
the lasso candidates misses at step `(N³ - N) / 4 = (2m + 3)(m + 1)(m + 2)`: it passes every
diagonal of candidates before the one with the period `N`, each even shift costing a whole
turn. -/
theorem byElimination_missed_late (m : Nat) :
    Learning.MissesAt (Learning.byElimination Learning.lassos) (oddCycle (2 * (m + 1)))
      ((2 * (m + 1) + 1) * ((m + 1) * (m + 1) + (m + 1))) :=
  have last := turn_diagonals m m (Nat.le_refl _)
  have along := turn_walk (M := m + 1) m 0 ((m + 1) * m + m) 2
    (Nat.le_trans (Nat.le_of_eq (Nat.zero_add m)) (Nat.le_succ m))
    (Nat.le_of_eq (Nat.add_comm 2 (2 * m)))
    (last.trans (congrArg (·, 0) (Nat.add_comm (2 * m) 2)))
  match turn_pair (M := m + 1) (i := 1) (e := 0 + m) (j := (m + 1) * m + m + m)
    (Nat.lt_succ_of_le (Nat.le_of_eq (Nat.zero_add m)))
    (Eq.subst (motive := fun b => 1 + 1 + 2 * b ≤ 2 * (m + 1)) (Nat.zero_add m).symm
      (Nat.le_of_eq (Nat.add_comm 2 (2 * m))))
    ((congrArg (turnHeld (2 * (m + 1))) (Nat.add_right_comm ((m + 1) * m + m) 1 m)).symm.trans
      along) with
  | ⟨refuted, _⟩ =>
    Eq.subst (motive := fun y => Learning.MissesAt (Learning.byElimination Learning.lassos)
        (oddCycle (2 * (m + 1))) ((2 * (m + 1) + 1) * (y + 1)))
      (Nat.add_right_comm ((m + 1) * m + m) 1 m).symm refuted

/-- **Elimination rests no earlier than a cubic step.** A step from which the extrapolation by
elimination over the lasso candidates is right on every two-valued history with at
most `N = 2m + 3` states comes after `(N³ - N) / 4`. With `byElimination_rests` its rest step is cubic
in `N`; the extrapolation by the least bound rests from `2N - 1` (`leastBound_exact`). -/
theorem byElimination_rest_cubic (m : Nat) {T : Nat}
    (rests : ∀ o : Nat → Bool, StatesBelow o (2 * m + 3) → ∀ t, T ≤ t →
      Learning.byElimination Learning.lassos (Learning.prefixOf o t) = some (o t)) :
    (2 * m + 3) * ((m + 1) * (m + 2)) < T :=
  match Nat.lt_or_ge ((2 * m + 3) * ((m + 1) * (m + 2))) T with
  | .inl early => early
  | .inr late =>
    match byElimination_missed_late m with
    | ⟨_, claims, differs⟩ =>
      absurd (Option.some.inj (claims.symm.trans
        (rests (oddCycle (2 * (m + 1))) (oddCycle_below (2 * (m + 1))) _ late))) differs

end CubicRest

end Identification

/-! ## The split that makes sense, named with no quotient -/

namespace Law

variable {S : Type v} {R : Type w}

/-- An orbit from a member of a list closed under the law stays in it. -/
theorem orbit_held {next : S → S} {l : List S} (closed : ∀ s, s ∈ l → next s ∈ l) {s : S}
    (mem : s ∈ l) : ∀ n, Law.orbit next s n ∈ l
  | 0 => mem
  | n + 1 => closed _ (orbit_held closed mem n)

/-- The future through the map of a member of a list closed under the law has at most as many
states as the list has members. -/
theorem statesBelow_held {next : S → S} {l : List S} (closed : ∀ s, s ∈ l → next s ∈ l)
    {s : S} (mem : s ∈ l) (o : S → R) :
    StatesBelow (fun n => o (Law.orbit next s n)) l.length :=
  match Learning.lasso_of_held (orbit_held closed mem) o with
  | ⟨i, q, within, lasso⟩ => Identification.statesBelow_iff_lasso.mpr ⟨i, q, within, lasso⟩

/-- **In a world a list closes, the same future through the map is decided by a finite prefix.**
Two members have the same future through the map exactly where their futures through the map
agree for `N + N - 1` steps, `N` the length of the list. -/
theorem sameFuture_iff_below {next : S → S} {o : S → R} {l : List S}
    (closed : ∀ s, s ∈ l → next s ∈ l) {s s' : S} (mem : s ∈ l) (mem' : s' ∈ l) :
    Law.SameFuture next o s s' ↔
      ∀ n, n < l.length + l.length - 1 → o (Law.orbit next s n) = o (Law.orbit next s' n) :=
  ⟨fun same n _ => same n,
   fun agree => Identification.bounded_agree (statesBelow_held closed mem o)
     (statesBelow_held closed mem' o) agree⟩

/-- The name of a configuration: its future through the map before step `T`, latest first. -/
def name (next : S → S) (o : S → R) (T : Nat) (s : S) : List R :=
  Learning.prefixOf (fun n => o (Law.orbit next s n)) T

/-! ## Moore's bound: the classes of one world -/

section Classes

variable {next : S → S} {o : S → R}

/-- Two configurations take the same values through the map for `k + 1` steps under a law. -/
def AgreeTo (next : S → S) (o : S → R) : Nat → S → S → Prop
  | 0, s, s' => o s = o s'
  | k + 1, s, s' => o s = o s' ∧ AgreeTo next o k (next s) (next s')

/-- Agreeing for `k + 1` steps is agreeing at each step up to `k`. -/
theorem agreeTo_iff : ∀ {k : Nat} {s s' : S},
    AgreeTo next o k s s' ↔ ∀ n, n ≤ k → o (Law.orbit next s n) = o (Law.orbit next s' n)
  | 0, _, _ =>
    ⟨fun same n le => match n, le with
      | 0, _ => same
      | m + 1, le => absurd le (Nat.not_succ_le_zero m),
     fun agree => agree 0 (Nat.le_refl 0)⟩
  | _ + 1, s, s' =>
    ⟨fun ⟨same, ahead⟩ n le => match n, le with
      | 0, _ => same
      | m + 1, le =>
        (congrArg o (Law.orbit_shift next s m)).trans
          ((agreeTo_iff.mp ahead m (Nat.le_of_succ_le_succ le)).trans
            (congrArg o (Law.orbit_shift next s' m)).symm),
     fun agree => ⟨agree 0 (Nat.zero_le _), agreeTo_iff.mpr fun m le =>
      (congrArg o (Law.orbit_shift next s m)).symm.trans
        ((agree (m + 1) (Nat.succ_le_succ le)).trans (congrArg o (Law.orbit_shift next s' m)))⟩⟩

theorem AgreeTo.self : ∀ (k : Nat) (s : S), AgreeTo next o k s s
  | 0, _ => rfl
  | k + 1, s => ⟨rfl, AgreeTo.self k (next s)⟩

theorem AgreeTo.symm : ∀ {k : Nat} {s s' : S}, AgreeTo next o k s s' → AgreeTo next o k s' s
  | 0, _, _, same => Eq.symm same
  | _ + 1, _, _, ⟨same, ahead⟩ => ⟨Eq.symm same, AgreeTo.symm ahead⟩

theorem AgreeTo.trans : ∀ {k : Nat} {s s' s'' : S},
    AgreeTo next o k s s' → AgreeTo next o k s' s'' → AgreeTo next o k s s''
  | 0, _, _, _, same, same' => Eq.trans same same'
  | _ + 1, _, _, _, ⟨same, ahead⟩, ⟨same', ahead'⟩ => ⟨Eq.trans same same', AgreeTo.trans ahead ahead'⟩

theorem AgreeTo.of_succ : ∀ {k : Nat} {s s' : S}, AgreeTo next o (k + 1) s s' → AgreeTo next o k s s'
  | 0, _, _, ⟨same, _⟩ => same
  | _ + 1, _, _, ⟨same, ahead⟩ => ⟨same, AgreeTo.of_succ ahead⟩

/-- Agreeing for more and more steps is a chain of equivalences, each finer than the one
before. -/
theorem agreeTo_refining (next : S → S) (o : S → R) : Refining (AgreeTo next o) :=
  ⟨AgreeTo.self, AgreeTo.symm, AgreeTo.trans, AgreeTo.of_succ⟩

/-- Among members of a list closed under the law, agreeing for `k + 1` steps is decided where
the values of the members are compared decidedly. -/
theorem AgreeTo.decided {l : List S} (closed : ∀ s, s ∈ l → next s ∈ l)
    (values : ∀ s s', s ∈ l → s' ∈ l → Decided (o s = o s')) :
    ∀ k s s', s ∈ l → s' ∈ l → Decided (AgreeTo next o k s s')
  | 0, s, s', mem, mem' => values s s' mem mem'
  | k + 1, s, s', mem, mem' =>
    (values s s' mem mem').and
      (AgreeTo.decided closed values k (next s) (next s') (closed s mem) (closed s' mem'))

/-- Under a law, where agreeing stops refining it never refines again. -/
theorem AgreeTo.steady_on {l : List S} (closed : ∀ s, s ∈ l → next s ∈ l) {k : Nat}
    (steady : SteadyAt (AgreeTo next o) l k) :
    ∀ j {s s' : S}, s ∈ l → s' ∈ l → AgreeTo next o k s s' → AgreeTo next o (k + j) s s'
  | 0, _, _, _, _, agree => agree
  | j + 1, s, s', mem, mem', agree =>
    match steady s s' mem mem' agree with
    | ⟨same, ahead⟩ =>
      ⟨same, AgreeTo.steady_on closed steady j (closed s mem) (closed s' mem') ahead⟩

/-- **Moore's bound: one world's configurations are told apart within `N - 1` steps.** Under a
determined law, two members of a list of `N` members closed under the law have the same
future through the map exactly where their futures through the map agree for `N - 1` steps,
wherever the values of the members are compared decidedly. Agreeing for `k + 1` steps is a chain
of equivalences (`agreeTo_refining`); configurations taking different values make two
classes, and each strict refinement adds one (`Refining.steady_within`). -/
theorem sameFuture_iff_classes {l : List S} (closed : ∀ s, s ∈ l → next s ∈ l)
    (values : ∀ s s', s ∈ l → s' ∈ l → Decided (o s = o s')) {s s' : S} (mem : s ∈ l)
    (mem' : s' ∈ l) :
    Law.SameFuture next o s s' ↔
      ∀ n, n < l.length - 1 → o (Law.orbit next s n) = o (Law.orbit next s' n) :=
  ⟨fun same n _ => same n, fun agree =>
    match Decided.exists_listed (l := l) (fun x inx =>
        Decided.exists_listed (l := l) fun y iny => (values x y inx iny).not) with
    | .inr absent => fun n =>
      (values _ _ (orbit_held closed mem n) (orbit_held closed mem' n)).of_not_not fun differ =>
        absent ⟨_, orbit_held closed mem n, _, orbit_held closed mem' n, differ⟩
    | .inl ⟨x, inx, y, iny, differ⟩ =>
      have apart : DistinctUnder (AgreeTo next o 0) [x, y] :=
        ⟨fun _ inz same => match mem_cons_cases inz with
          | .inl here => differ (Eq.subst (motive := fun w => o x = o w) here same)
          | .inr later => (nomatch later),
         DistinctUnder.single y⟩
      have within : ∀ z, z ∈ [x, y] → z ∈ l := fun _ inz => match mem_cons_cases inz with
        | .inl here => Eq.subst (motive := fun w => w ∈ l) here.symm inx
        | .inr later => match mem_cons_cases later with
          | .inl here => Eq.subst (motive := fun w => w ∈ l) here.symm iny
          | .inr none' => nomatch none'
      match (agreeTo_refining next o).steady_within (AgreeTo.decided closed values) apart within with
      | ⟨k, bound, steady⟩ => fun n =>
        agreeTo_iff.mp
          (AgreeTo.steady_on closed steady n mem mem' (agreeTo_iff.mpr fun m le =>
            agree m (le_pred_of_succ_le (Nat.le_trans (Nat.add_le_add_right le 2) bound))))
          n (Nat.le_add_left n k)⟩

/-- **Moore's bound, refuted by nothing.** Under a determined law, that two members of a list of
`N` members closed under the law, agreeing for `N - 1` steps, agree at a step is refuted by
nothing. `sameFuture_iff_within` proves the agreement itself, with no premise. -/
theorem sameFuture_classes_unrefuted {l : List S} (closed : ∀ s, s ∈ l → next s ∈ l) {s s' : S}
    (mem : s ∈ l) (mem' : s' ∈ l)
    (agree : ∀ n, n < l.length - 1 → o (Law.orbit next s n) = o (Law.orbit next s' n)) (n : Nat) :
    ¬ ¬ o (Law.orbit next s n) = o (Law.orbit next s' n) :=
  fun refuted => not_not_within (P := fun x => ∀ y, y ∈ l → Decided (o x = o y))
    (fun x => not_not_within (fun y => not_not_decided (o x = o y)) l) l
    fun values => refuted
      ((sameFuture_iff_classes closed (fun x y inx iny => values x inx y iny) mem mem').mpr agree n)

/-- The positions `0, …, m` are `m + 1`. -/
theorem upto_length : ∀ m, (downFrom m).length = m + 1
  | 0 => rfl
  | m + 1 => congrArg (· + 1) (upto_length m)

/-- **Moore's bound is exact for every `N ≥ 2`.** A path of `N = M + 2` positions to a last one
that stays, read through a map that takes only whether the last is reached: its first two positions agree for
`M` steps and differ at the next. -/
theorem sameFuture_classes_exact {x y : R} (two : x ≠ y) (M : Nat) :
    ∃ (next : Nat → Nat) (o : Nat → R) (l : List Nat), l.length = M + 2 ∧
      (∀ p, p ∈ l → next p ∈ l) ∧ 0 ∈ l ∧ 1 ∈ l ∧
      (∀ n, n < M → o (Law.orbit next 0 n) = o (Law.orbit next 1 n)) ∧
      o (Law.orbit next 0 M) ≠ o (Law.orbit next 1 M) :=
  let next := Learning.lassoNext (M + 1) 0
  let o : Nat → R := fun p => if p < M + 1 then x else y
  have closed : ∀ p, next p ∈ downFrom (M + 1) := fun p =>
    match Nat.lt_or_ge p (M + 1) with
    | .inl inside => Eq.subst (motive := fun v => v ∈ downFrom (M + 1))
        (if_pos inside : next p = p + 1).symm (mem_downFrom inside)
    | .inr last => Eq.subst (motive := fun v => v ∈ downFrom (M + 1))
        (if_neg (fun inside => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le inside last)) : next p = M + 1).symm
        (mem_downFrom (Nat.le_refl _))
  have from0 : ∀ n, n ≤ M + 1 → Law.orbit next 0 n = n := fun n le =>
    Identification.lassoPos_early (i := M + 1) (q := 0) n le
  have start : next 0 = 1 := if_pos (Nat.zero_lt_succ M)
  have from1 : ∀ n, n ≤ M → Law.orbit next 1 n = n + 1 := fun n le =>
    (congrArg (fun v => Law.orbit next v n) start.symm).trans
      ((Law.orbit_shift next 0 n).symm.trans (from0 (n + 1) (Nat.succ_le_succ le)))
  ⟨next, o, downFrom (M + 1), upto_length (M + 1), fun p _ => closed p,
   mem_downFrom (Nat.zero_le _), mem_downFrom (Nat.succ_le_succ (Nat.zero_le M)),
   fun n early =>
    (congrArg o (from0 n (Nat.le_trans (Nat.le_of_lt early) (Nat.le_succ M)))).trans
      ((if_pos (Nat.lt_succ_of_lt early) : o n = x).trans
        ((if_pos (Nat.succ_lt_succ early) : o (n + 1) = x).symm.trans
          (congrArg o (from1 n (Nat.le_of_lt early))).symm)),
   fun same => two
    ((if_pos (Nat.lt_succ_self M) : o M = x).symm.trans
      ((congrArg o (from0 M (Nat.le_succ M))).symm.trans
        (same.trans ((congrArg o (from1 M (Nat.le_refl M))).trans
          (if_neg (Nat.lt_irrefl (M + 1)) : o (M + 1) = y)))))⟩

end Classes

/-! ## Moore's bound with no premise: positions decided, not values -/

section Positions

variable {next : S → S} {o : S → R}

theorem memberAt_mem (d : S) : ∀ {l : List S} {i : Nat}, i < l.length → memberAt d l i ∈ l
  | [], _, lt => absurd lt (Nat.not_lt_zero _)
  | _ :: r, 0, _ => List.Mem.head r
  | x :: _, _ + 1, lt => List.Mem.tail x (memberAt_mem d (Nat.lt_of_succ_lt_succ lt))

/-- A member of a list is at a position of it. -/
theorem position_of_mem (d : S) : ∀ {l : List S} {x : S}, x ∈ l →
    ∃ i, i < l.length ∧ memberAt d l i = x
  | [], _, mem => nomatch mem
  | _ :: _, _, mem => match mem_cons_cases mem with
    | .inl here => ⟨0, Nat.zero_lt_succ _, Eq.symm here⟩
    | .inr later => match position_of_mem d later with
      | ⟨i, lt, at_i⟩ => ⟨i + 1, Nat.succ_lt_succ lt, at_i⟩

/-- Finitely many existences are chosen together. -/
theorem choose_below {P : Nat → Nat → Prop} :
    ∀ (m : Nat), (∀ i, i < m → ∃ k, P i k) → ∃ f : Nat → Nat, ∀ i, i < m → P i (f i)
  | 0, _ => ⟨fun _ => 0, fun _ lt => absurd lt (Nat.not_lt_zero _)⟩
  | m + 1, each =>
    match choose_below m (fun i lt => each i (Nat.lt_succ_of_lt lt)), each m (Nat.lt_succ_self m) with
    | ⟨f, holds⟩, ⟨k, at_m⟩ =>
      ⟨fun i => if i < m then f i else k, fun i lt =>
        match Nat.lt_or_ge i m with
        | .inl inside => Eq.subst (motive := fun v => P i v)
            (if_pos inside : (if i < m then f i else k) = f i).symm (holds i inside)
        | .inr past => Eq.subst (motive := fun v => P i v)
            (if_neg (fun inside => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le inside past)) :
              (if i < m then f i else k) = k).symm
            (Eq.subst (motive := fun j => P j k)
              (Nat.le_antisymm (Nat.le_of_lt_succ lt) past).symm at_m)⟩

/-- A law on the positions of a list carries the law on its members. -/
theorem orbit_memberAt {l : List S} {d : S} {f : Nat → Nat}
    (follows : ∀ i, i < l.length → f i < l.length ∧ next (memberAt d l i) = memberAt d l (f i))
    {i : Nat} (lt : i < l.length) :
    ∀ n, Law.orbit f i n < l.length ∧ Law.orbit next (memberAt d l i) n = memberAt d l (Law.orbit f i n)
  | 0 => ⟨lt, rfl⟩
  | n + 1 => match orbit_memberAt follows lt n with
    | ⟨inside, at_n⟩ => ⟨(follows _ inside).1, (congrArg next at_n).trans (follows _ inside).2⟩

/-- Relabel so that every position labelled as `b` is labelled as `a`. -/
def merge (g : Nat → Nat) (a b : Nat) (i : Nat) : Nat := if g i = g b then g a else g i

/-- A labelling of positions is sound for their values where positions of one label have one
value. -/
def SoundFor (v : Nat → R) (g : Nat → Nat) : Prop := ∀ i j, g i = g j → v i = v j

/-- Merging two positions of one value keeps a labelling sound. -/
theorem merge_sound {v : Nat → R} {g : Nat → Nat} {a b : Nat} (sound : SoundFor v g)
    (same : v a = v b) : SoundFor v (merge g a b) := fun i j joined =>
  match Nat.decEq (g i) (g b), Nat.decEq (g j) (g b) with
  | isTrue at_i, isTrue at_j => (sound i b at_i).trans (sound j b at_j).symm
  | isTrue at_i, isFalse off_j =>
    (sound i b at_i).trans (same.symm.trans (sound a j
      ((if_pos at_i : merge g a b i = g a).symm.trans
        (joined.trans (if_neg off_j : merge g a b j = g j)))))
  | isFalse off_i, isTrue at_j =>
    (sound i a ((if_neg off_i : merge g a b i = g i).symm.trans
      (joined.trans (if_pos at_j : merge g a b j = g a)))).trans
      (same.trans (sound j b at_j).symm)
  | isFalse off_i, isFalse off_j =>
    sound i j ((if_neg off_i : merge g a b i = g i).symm.trans
      (joined.trans (if_neg off_j : merge g a b j = g j)))

/-- Merging keeps positions of one label together. -/
theorem merge_keeps {g : Nat → Nat} {a b x y : Nat} (joined : g x = g y) :
    merge g a b x = merge g a b y :=
  match Nat.decEq (g x) (g b) with
  | isTrue at_x => (if_pos at_x : merge g a b x = g a).trans
      (if_pos (joined.symm.trans at_x) : merge g a b y = g a).symm
  | isFalse off_x => (if_neg off_x : merge g a b x = g x).trans (joined.trans
      (if_neg (fun at_y => off_x (joined.trans at_y)) : merge g a b y = g y).symm)

/-- Merging joins the two positions merged. -/
theorem merge_joins (g : Nat → Nat) (a b : Nat) : merge g a b a = merge g a b b :=
  match Nat.decEq (g a) (g b) with
  | isTrue at_a => (if_pos at_a : merge g a b a = g a).trans (if_pos rfl : merge g a b b = g a).symm
  | isFalse off_a => (if_neg off_a : merge g a b a = g a).trans (if_pos rfl : merge g a b b = g a).symm

/-- The labelling that joins, pair by pair, the positions two orbits of a law on positions reach
at each of their first `k` steps. -/
def joinOrbits (f : Nat → Nat) (p p' : Nat) : Nat → Nat → Nat
  | 0 => fun i => i
  | k + 1 => merge (joinOrbits f p p' k) (Law.orbit f p k) (Law.orbit f p' k)

/-- Where the two orbits have one value at each of their first `k` steps, the labelling joining
them is sound. -/
theorem joinOrbits_sound {v : Nat → R} {f : Nat → Nat} {p p' : Nat} :
    ∀ k, (∀ n, n < k → v (Law.orbit f p n) = v (Law.orbit f p' n)) →
      SoundFor v (joinOrbits f p p' k)
  | 0, _ => fun _ _ same => congrArg v same
  | k + 1, agree => merge_sound (joinOrbits_sound k fun n lt => agree n (Nat.lt_succ_of_lt lt))
      (agree k (Nat.lt_succ_self k))

/-- The labelling joins the two orbits at each of their first `k` steps. -/
theorem joinOrbits_joins {f : Nat → Nat} {p p' : Nat} :
    ∀ k n, n < k → joinOrbits f p p' k (Law.orbit f p n) = joinOrbits f p p' k (Law.orbit f p' n)
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | k + 1, n, lt => match Nat.lt_or_ge n k with
    | .inl inside => merge_keeps (joinOrbits_joins k n inside)
    | .inr past => Eq.subst
        (motive := fun m => joinOrbits f p p' (k + 1) (Law.orbit f p m) =
          joinOrbits f p p' (k + 1) (Law.orbit f p' m))
        (Nat.le_antisymm (Nat.le_of_lt_succ lt) past).symm (merge_joins _ _ _)

theorem lt_of_le_pred : ∀ {N i j : Nat}, j < N → i ≤ N - 1 → i < N
  | 0, _, _, lt, _ => absurd lt (Nat.not_lt_zero _)
  | _ + 1, _, _, _, le => Nat.lt_succ_of_le le

/-- **Moore's bound with no premise: one world's configurations are told apart within `N - 1`
steps.** Under a determined law, two members of a list of `N` members closed under the law have
the same future through the map exactly where their futures through the map agree for `N - 1`
steps. No
value is compared decidedly. The law is read on the positions of the list, where equality is
decided (`orbit_memberAt`); the positions the agreements join are joined, pair by pair, into a
labelling of positions, each label of one value (`joinOrbits_sound`); and Moore's bound for the
labelling (`sameFuture_iff_classes`) carries over to the values. -/
theorem sameFuture_iff_within {l : List S} (closed : ∀ s, s ∈ l → next s ∈ l) {s s' : S}
    (mem : s ∈ l) (mem' : s' ∈ l) :
    Law.SameFuture next o s s' ↔
      ∀ n, n < l.length - 1 → o (Law.orbit next s n) = o (Law.orbit next s' n) :=
  ⟨fun same n _ => same n, fun agree =>
    match choose_below (P := fun i k => k < l.length ∧ next (memberAt s l i) = memberAt s l k)
        l.length (fun _ lt => match position_of_mem s (closed _ (memberAt_mem s lt)) with
          | ⟨k, inside, at_k⟩ => ⟨k, inside, Eq.symm at_k⟩),
      position_of_mem s mem, position_of_mem s mem' with
    | ⟨f, follows⟩, ⟨p, inp, at_p⟩, ⟨p', inp', at_p'⟩ =>
      have along : ∀ n, o (Law.orbit next s n) = o (memberAt s l (Law.orbit f p n)) := fun n =>
        congrArg o ((congrArg (fun x => Law.orbit next x n) at_p).symm.trans
          (orbit_memberAt follows inp n).2)
      have along' : ∀ n, o (Law.orbit next s' n) = o (memberAt s l (Law.orbit f p' n)) := fun n =>
        congrArg o ((congrArg (fun x => Law.orbit next x n) at_p').symm.trans
          (orbit_memberAt follows inp' n).2)
      have sound : SoundFor (fun i => o (memberAt s l i)) (joinOrbits f p p' (l.length - 1)) :=
        joinOrbits_sound _ fun n lt => (along n).symm.trans ((agree n lt).trans (along' n))
      have positions : ∀ i, i ∈ downFrom (l.length - 1) → f i ∈ downFrom (l.length - 1) :=
        fun i inside => mem_downFrom
          (le_pred_of_succ_le (follows i (lt_of_le_pred inp (le_of_mem_downFrom inside))).1)
      have labelled := (sameFuture_iff_classes (next := f) (o := joinOrbits f p p' (l.length - 1))
        positions (fun i j _ _ => match Nat.decEq (joinOrbits f p p' (l.length - 1) i)
          (joinOrbits f p p' (l.length - 1) j) with
          | isTrue same => .inl same
          | isFalse differ => .inr differ)
        (mem_downFrom (le_pred_of_succ_le inp)) (mem_downFrom (le_pred_of_succ_le inp'))).mpr
        fun n early => joinOrbits_joins (l.length - 1) n
          (Eq.subst (motive := fun L => n < L - 1) (upto_length (l.length - 1)) early :
            n < l.length - 1 + 1 - 1)
      fun n => (along n).trans ((sound _ _ (labelled n)).trans (along' n).symm)⟩

end Positions

end Law

namespace Identification

variable {O : Type u}

/-- **Moore's bound for one history: two moments are one state where they agree for `N - 1`
steps.** On a history with at most `N` states whose values are compared decidedly, two moments
are one state exactly where the courses from them agree for `N - 1` steps. The history is
the course of its lasso world (`Learning.lasso_realized`), whose positions are at most `N`. -/
theorem sameAhead_iff_classes {o : Nat → O} {N : Nat} (bound : StatesBelow o N)
    (values : ∀ n m, Decided (o n = o m)) {t t' : Nat} :
    SameAhead o t t' ↔ ∀ n, n < N - 1 → o (t + n) = o (t' + n) :=
  ⟨fun same n _ => same n, fun agree =>
    match statesBelow_iff_lasso.mp bound with
    | ⟨i, q, within, lasso⟩ =>
      let next := Learning.lassoNext i q
      have closed : ∀ p, p ∈ downFrom (i + q) → next p ∈ downFrom (i + q) := fun p _ =>
        match Nat.lt_or_ge p (i + q) with
        | .inl inside => Eq.subst (motive := fun v => v ∈ downFrom (i + q))
            (if_pos inside : next p = p + 1).symm (mem_downFrom inside)
        | .inr last => Eq.subst (motive := fun v => v ∈ downFrom (i + q))
            (if_neg (fun inside => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le inside last)) : next p = i).symm
            (mem_downFrom (Nat.le_add_right i q))
      have ahead : ∀ u k, o (Law.orbit next (Law.orbit next 0 u) k) = o (u + k) := fun u k =>
        (congrArg o (Law.orbit_add next 0 u k).symm).trans ((Learning.lasso_realized lasso).2 (u + k))
      have same := (Law.sameFuture_iff_classes (o := o) closed (fun p p' _ _ => values p p')
        ((Learning.lasso_realized lasso).1 t) ((Learning.lasso_realized lasso).1 t')).mpr
        fun n early =>
          have early' : n < i + q :=
            Eq.subst (motive := fun L => n < L - 1) (Law.upto_length (i + q)) early
          (ahead t n).trans ((agree n (Nat.lt_of_lt_of_le early' (le_pred_of_succ_le within))).trans
            (ahead t' n).symm)
      fun n => (ahead t n).symm.trans ((same n).trans (ahead t' n))⟩

/-- **Moore's bound for one history, with no premise.** On a history with at most `N` states, two
moments are one state exactly where the courses from them agree for `N - 1` steps; no
value is compared decidedly (`Law.sameFuture_iff_within`). -/
theorem sameAhead_iff_within {o : Nat → O} {N : Nat} (bound : StatesBelow o N) {t t' : Nat} :
    SameAhead o t t' ↔ ∀ n, n < N - 1 → o (t + n) = o (t' + n) :=
  ⟨fun same n _ => same n, fun agree =>
    match statesBelow_iff_lasso.mp bound with
    | ⟨i, q, within, lasso⟩ =>
      let next := Learning.lassoNext i q
      have closed : ∀ p, p ∈ downFrom (i + q) → next p ∈ downFrom (i + q) := fun p _ =>
        match Nat.lt_or_ge p (i + q) with
        | .inl inside => Eq.subst (motive := fun v => v ∈ downFrom (i + q))
            (if_pos inside : next p = p + 1).symm (mem_downFrom inside)
        | .inr last => Eq.subst (motive := fun v => v ∈ downFrom (i + q))
            (if_neg (fun inside => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le inside last)) : next p = i).symm
            (mem_downFrom (Nat.le_add_right i q))
      have ahead : ∀ u k, o (Law.orbit next (Law.orbit next 0 u) k) = o (u + k) := fun u k =>
        (congrArg o (Law.orbit_add next 0 u k).symm).trans ((Learning.lasso_realized lasso).2 (u + k))
      have same := (Law.sameFuture_iff_within (o := o) closed
        ((Learning.lasso_realized lasso).1 t) ((Learning.lasso_realized lasso).1 t')).mpr
        fun n early =>
          have early' : n < i + q :=
            Eq.subst (motive := fun L => n < L - 1) (Law.upto_length (i + q)) early
          (ahead t n).trans ((agree n (Nat.lt_of_lt_of_le early' (le_pred_of_succ_le within))).trans
            (ahead t' n).symm)
      fun n => (ahead t n).symm.trans ((same n).trans (ahead t' n))⟩

end Identification

end Becoming
