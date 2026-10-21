import Becoming.Settling

/-!
# The last change: how often a run changes, and what it takes to know it has stopped

`Becoming.Settling` states when a run keeps changing: in a world a list holds, exactly where a
reachable change can be undone (`Settling.keeps_changing_iff`). That no run keeps changing does
not give that every run settles: already for two configurations, every run settling is the
limited principle of omniscience (`Settling.OneWay.lpo_of_settles`). This module states how often
a run with no change within a loop changes, what its settling is, and the exact strength of the
step from not changing for ever to settling.

* **At most `N - 1` changes.** Along a run whose configurations a list of `N` holds, with no change
  within a loop, there are fewer than `N` changes (`LastChange.changes_lt`): `m + 1` changes leave
  `m + 2` configurations, at the changes and after the last, pairwise apart. No premise beyond the
  list.
* **Settling is deciding whether it changes again.** A run of decidable configurations settles
  exactly where, at every step, whether it changes again is decided (`LastChange.settles_iff_decided`;
  the second direction for a run a list holds with no change within a loop).
* **Not not settled.** With decidable configurations and no further premise, a run a list holds
  with no change within a loop is not not settled (`LastChange.not_not_settles`): whether it
  changes again from a step is not not decided, and fewer than `N` changes leave nothing to search.
* **Exactly the limited principle of omniscience.** With the limited principle of omniscience,
  such a run settles (`LastChange.settles_of_lpo`), and in a world a list holds every run from a
  configuration with no reachable change that can be undone settles
  (`LastChange.settles_of_no_undoable`). Conversely, that this holds for every process of
  decidable configurations in a world a list holds is the limited principle of omniscience
  (`LastChange.lpo_iff_settles`, through `Settling.OneWay`).
* **Assured enough on the process.** With the limited principle of omniscience, every run from a
  configuration comes to rest with its target met exactly where every reachable configuration
  with a step that stays meets the target and no reachable change can be undone
  (`LastChange.assured_iff_of_lpo`); with no premise but decided configurations, each run from it
  then does not not rest (`LastChange.not_not_rests`).
* **A law's run with a bounded mark comes to rest, decided.** A run of a law is fixed by its law,
  so whether it changes at a step is whether the law leaves the configuration there as it is,
  which is decided. Where a quantity never falls along a law's run, rises at every change, and
  stays at most `d` above where it started, the run is still from some step at most `d`
  (`LastChange.still_within`), with no omniscience: each change uses up at least one of the `d`.

So in a finite world the process decides whether its runs keep changing, and bounds how often they
change; where a run has stopped is decided only by deciding, from each step, whether it will change
again, which is a question about the whole future of the run, unless a bounded quantity counts its
changes, as for a law's run with a bounded mark. No ethical predicate, ranking or axiom
occurs.
-/

namespace Becoming

open Generative

universe u v

namespace LastChange

section AnyProcess

variable {S : Type u} {A : Type v} {P : Process S A}

/-- Rising positions of `m + 1` changes of a run: positions rising up to `m`, the run changing
across a step at each. -/
def Changes (r : Run P) (f : Nat → Nat) (m : Nat) : Prop :=
  (∀ n, n < m → f n < f (n + 1)) ∧ ∀ n, n ≤ m → r.state (f n + 1) ≠ r.state (f n)

/-- The run changes again from step `T`. -/
def ChangesAgain (r : Run P) (T : Nat) : Prop := ∃ k, r.state (T + k + 1) ≠ r.state (T + k)

/-- From step `T` on the run does not change. -/
def StillFrom (r : Run P) (T : Nat) : Prop := ∀ k, r.state (T + k + 1) = r.state (T + k)

theorem settles_of_still {r : Run P} {T : Nat} (still : StillFrom r T) : Enough.Settles r :=
  ⟨T, fun _ late => match le_dest late with
    | ⟨k, gap⟩ => Eq.subst (motive := fun x => r.state (x + 1) = r.state x) gap.symm (still k)⟩

/-- Rising positions of changes, with one more change later. -/
theorem Changes.add {r : Run P} {f : Nat → Nat} {m k : Nat} (changes : Changes r f m)
    (later : f m < k) (at_k : r.state (k + 1) ≠ r.state k) : Changes r (Settling.extend f m k) (m + 1) :=
  ⟨fun n lt => match Decidable.em (n < m) with
    | .inl lt' => Eq.subst (motive := fun x => x < Settling.extend f m k (n + 1))
        (Settling.extend_le (Nat.le_of_lt lt')).symm
        (Eq.subst (motive := fun y => f n < y) (Settling.extend_le (Nat.succ_le_of_lt lt')).symm
          (changes.1 n lt'))
    | .inr nlt =>
      have at_m : m = n := Nat.le_antisymm (Nat.ge_of_not_lt nlt) (Nat.le_of_lt_succ lt)
      Eq.subst (motive := fun x => Settling.extend f m k x < Settling.extend f m k (x + 1)) at_m
        (Eq.subst (motive := fun x => x < Settling.extend f m k (m + 1)) (Settling.extend_le (Nat.le_refl m)).symm
          (Eq.subst (motive := fun y => f m < y) (Settling.extend_gt (Nat.not_succ_le_self m)).symm later)),
   fun n _ => match Decidable.em (n ≤ m) with
    | .inl le => Eq.subst (motive := fun x => r.state (x + 1) ≠ r.state x) (Settling.extend_le le).symm
        (changes.2 n le)
    | .inr gt => Eq.subst (motive := fun x => r.state (x + 1) ≠ r.state x) (Settling.extend_gt gt).symm at_k⟩

/-- The configurations at rising positions up to `m`, and after the last. -/
def atChanges (r : Run P) (f : Nat → Nat) (m n : Nat) : S :=
  if n ≤ m then r.state (f n) else r.state (f m + 1)

theorem atChanges_le {r : Run P} {f : Nat → Nat} {m n : Nat} (le : n ≤ m) :
    atChanges r f m n = r.state (f n) := if_pos le

theorem atChanges_gt {r : Run P} {f : Nat → Nat} {m n : Nat} (gt : ¬ n ≤ m) :
    atChanges r f m n = r.state (f m + 1) := if_neg gt

/-- **At most `N - 1` changes.** Along a run whose configurations a list holds, with no change
within a loop, rising positions of `m + 1` changes have `m + 1` less than the list's length: the
configurations at the changes and after the last, `m + 2` of them, are pairwise apart. -/
theorem changes_lt {r : Run P} {l : List S} (held : ∀ n, r.state n ∈ l)
    (noLoop : ¬ Settling.ChangesInLoop r) {f : Nat → Nat} {m : Nat} (changes : Changes r f m) :
    m + 1 < l.length :=
  match Nat.lt_or_ge (m + 1) l.length with
  | .inl lt => lt
  | .inr ge => absurd (
      match revisits_within l (atChanges r f m) (fun n _ =>
          match Decidable.em (n ≤ m) with
          | .inl le => Eq.subst (motive := fun x => x ∈ l) (atChanges_le le).symm (held _)
          | .inr gt => Eq.subst (motive := fun x => x ∈ l) (atChanges_gt gt).symm (held _)) with
      | ⟨i, j, lt, le, same⟩ =>
        have i_le : i ≤ m := Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt (Nat.le_trans le ge))
        have at_i : atChanges r f m i = r.state (f i) := atChanges_le i_le
        match Decidable.em (j ≤ m) with
        | .inl j_le =>
          match gap_of_lt (Settling.rising changes.1 i j lt j_le) with
          | ⟨d, gap⟩ => ⟨f i, d, 0,
              (congrArg r.state gap).symm.trans ((atChanges_le j_le).symm.trans (same.symm.trans at_i)),
              Nat.zero_le d, changes.2 i i_le⟩
        | .inr j_gt =>
          have below : f i ≤ f m := match Decidable.em (i < m) with
            | .inl i_lt => Nat.le_of_lt (Settling.rising changes.1 i m i_lt (Nat.le_refl m))
            | .inr nlt => Nat.le_of_eq (congrArg f (Nat.le_antisymm i_le (Nat.ge_of_not_lt nlt)))
          match le_dest below with
          | ⟨d, gap⟩ => ⟨f i, d, 0,
              (congrArg (fun x => r.state (x + 1)) gap).symm.trans
                ((atChanges_gt j_gt).symm.trans (same.symm.trans at_i)),
              Nat.zero_le d, changes.2 i i_le⟩) noLoop

/-- Where whether it changes again is decided at every step, a run a list holds with no change
within a loop has, for every `m`, settled or made `m + 1` changes. -/
theorem settles_or_changes {r : Run P}
    (decides : ∀ T, ChangesAgain r T ∨ StillFrom r T) :
    ∀ m, Enough.Settles r ∨ ∃ f, Changes r f m
  | 0 => match decides 0 with
    | .inl ⟨k, ne⟩ => .inr ⟨fun _ => 0 + k, fun _ lt => absurd lt (Nat.not_lt_zero _), fun _ _ => ne⟩
    | .inr still => .inl (settles_of_still still)
  | m + 1 => match settles_or_changes decides m with
    | .inl settles => .inl settles
    | .inr ⟨f, changes⟩ => match decides (f m + 1) with
      | .inl ⟨k, ne⟩ => .inr ⟨_, changes.add
          (Nat.lt_of_lt_of_le (Nat.lt_succ_self (f m)) (Nat.le_add_right (f m + 1) k)) ne⟩
      | .inr still => .inl (settles_of_still still)

/-- **Deciding whether it changes again settles it.** A run a list holds with no change within a
loop, where at every step it is decided whether the run changes again, settles. -/
theorem settles_of_decided {r : Run P} {l : List S} (held : ∀ n, r.state n ∈ l)
    (noLoop : ¬ Settling.ChangesInLoop r) (decides : ∀ T, ChangesAgain r T ∨ StillFrom r T) :
    Enough.Settles r :=
  match settles_or_changes decides l.length with
  | .inl settles => settles
  | .inr ⟨_, changes⟩ =>
    absurd (Nat.lt_trans (Nat.lt_succ_self _) (changes_lt held noLoop changes)) (Nat.lt_irrefl _)

/-- With decidable configurations, whether a run changes within `n` steps from `T` is decided. -/
theorem decided_within [DecidableEq S] (r : Run P) (T : Nat) :
    ∀ n, (∃ k, k < n ∧ r.state (T + k + 1) ≠ r.state (T + k)) ∨
      ∀ k, k < n → r.state (T + k + 1) = r.state (T + k)
  | 0 => .inr fun _ lt => absurd lt (Nat.not_lt_zero _)
  | n + 1 => match decided_within r T n with
    | .inl ⟨k, lt, ne⟩ => .inl ⟨k, Nat.lt_succ_of_lt lt, ne⟩
    | .inr still => match decEq (r.state (T + n + 1)) (r.state (T + n)) with
      | .isTrue eq => .inr fun k lt => match Decidable.em (k < n) with
        | .inl lt' => still k lt'
        | .inr nlt => Eq.subst (motive := fun x => r.state (T + x + 1) = r.state (T + x))
            (Nat.le_antisymm (Nat.ge_of_not_lt nlt) (Nat.le_of_lt_succ lt)) eq
      | .isFalse ne => .inl ⟨n, Nat.lt_succ_self n, ne⟩

/-- **Settling is deciding whether it changes again.** A run of decidable configurations settles
exactly where at every step it is decided whether it changes again; the second direction for a run
a list holds with no change within a loop. -/
theorem settles_iff_decided [DecidableEq S] {r : Run P} {l : List S} (held : ∀ n, r.state n ∈ l)
    (noLoop : ¬ Settling.ChangesInLoop r) :
    Enough.Settles r ↔ ∀ T, ChangesAgain r T ∨ StillFrom r T :=
  ⟨fun ⟨T₀, stays⟩ T => match decided_within r T T₀ with
    | .inl ⟨k, _, ne⟩ => .inl ⟨k, ne⟩
    | .inr still => .inr fun k => match Decidable.em (k < T₀) with
      | .inl lt => still k lt
      | .inr nlt => stays (T + k) (Nat.le_trans (Nat.ge_of_not_lt nlt) (Nat.le_add_left k T)),
   settles_of_decided held noLoop⟩

/-- With decidable configurations, whether a run changes again from a step is not not decided. -/
theorem not_not_decided [DecidableEq S] (r : Run P) (T : Nat) :
    ¬ ¬ (ChangesAgain r T ∨ StillFrom r T) :=
  fun no => no (.inr fun k => Decidable.byContradiction fun ne => no (.inl ⟨k, ne⟩))

/-- With decidable configurations, a run has, for every `m`, not not settled or made `m + 1`
changes. -/
theorem not_not_settles_or_changes [DecidableEq S] (r : Run P) :
    ∀ m, ¬ ¬ (Enough.Settles r ∨ ∃ f, Changes r f m)
  | 0 => fun no => not_not_decided r 0 fun d => match d with
    | .inl ⟨k, ne⟩ => no (.inr ⟨fun _ => 0 + k, fun _ lt => absurd lt (Nat.not_lt_zero _), fun _ _ => ne⟩)
    | .inr still => no (.inl (settles_of_still still))
  | m + 1 => fun no => not_not_settles_or_changes r m fun d => match d with
    | .inl settles => no (.inl settles)
    | .inr ⟨f, changes⟩ => not_not_decided r (f m + 1) fun e => match e with
      | .inl ⟨k, ne⟩ => no (.inr ⟨_, changes.add
          (Nat.lt_of_lt_of_le (Nat.lt_succ_self (f m)) (Nat.le_add_right (f m + 1) k)) ne⟩)
      | .inr still => no (.inl (settles_of_still still))

/-- **Not not settled.** With decidable configurations and no further premise, a run a list holds
with no change within a loop is not not settled. -/
theorem not_not_settles [DecidableEq S] {r : Run P} {l : List S} (held : ∀ n, r.state n ∈ l)
    (noLoop : ¬ Settling.ChangesInLoop r) : ¬ ¬ Enough.Settles r :=
  fun unsettled => not_not_settles_or_changes r l.length fun d => match d with
    | .inl settles => unsettled settles
    | .inr ⟨_, changes⟩ =>
      Nat.lt_irrefl _ (Nat.lt_trans (Nat.lt_succ_self _) (changes_lt held noLoop changes))

/-- The limited principle of omniscience decides, at every step, whether a run of decidable
configurations changes again. -/
theorem decided_of_lpo [DecidableEq S] (lpo : LPO) (r : Run P) (T : Nat) :
    ChangesAgain r T ∨ StillFrom r T :=
  match lpo fun k => decide (r.state (T + k + 1) ≠ r.state (T + k)) with
  | .inl ⟨k, yes⟩ => .inl ⟨k, of_decide_eq_true yes⟩
  | .inr quiet => .inr fun k => Decidable.of_not_not (of_decide_eq_false (quiet k))

/-- **With the limited principle of omniscience, a run with no change within a loop settles.** -/
theorem settles_of_lpo [DecidableEq S] (lpo : LPO) {r : Run P} {l : List S} (held : ∀ n, r.state n ∈ l)
    (noLoop : ¬ Settling.ChangesInLoop r) : Enough.Settles r :=
  settles_of_decided held noLoop (decided_of_lpo lpo r)

/-- A run of a process from `s` has no change within a loop where no configuration reachable from
`s` has a step to another configuration from which it can be reached again. -/
theorem noLoop_of_no_undoable {s : S} (noUndo : ¬ ∃ x a y, Reach P s x ∧ P.step x a y ∧ y ≠ x ∧ Reach P y x)
    {r : Run P} (start : r.state 0 = s) : ¬ Settling.ChangesInLoop r :=
  fun loop => noUndo (Eq.subst (motive := fun z => ∃ x a y, Reach P z x ∧ P.step x a y ∧ y ≠ x ∧ Reach P y x)
    start (Settling.undoable_of_loop loop))

/-- **With the limited principle of omniscience, no reachable change that can be undone settles
every run.** In a world a list holds, of decidable configurations, where no configuration reachable
from `s` has a step to another configuration from which it can be reached again, every run from `s`
settles. -/
theorem settles_of_no_undoable [DecidableEq S] (lpo : LPO) {l : List S} (world : ∀ x, x ∈ l) {s : S}
    (noUndo : ¬ ∃ x a y, Reach P s x ∧ P.step x a y ∧ y ≠ x ∧ Reach P y x) :
    ∀ r : Run P, r.state 0 = s → Enough.Settles r :=
  fun _ start => settles_of_lpo lpo (fun _ => world _) (noLoop_of_no_undoable noUndo start)

/-- A run from `s` that settles rests with the target met where every configuration reachable from
`s` with a step that stays meets the target. -/
theorem rests_of_settles {s : S} {target : S → Prop}
    (meet : ∀ u, Reach P s u → Enough.Stays P u → target u) {r : Run P} (start : r.state 0 = s)
    (settles : Enough.Settles r) : Enough.Rests target r :=
  match settles with
  | ⟨T, stays⟩ =>
    have meets : target (r.state T) :=
      meet _ (Eq.subst (motive := fun x => Reach P x (r.state T)) start
          (Eq.subst (motive := fun k => Reach P (r.state 0) (r.state k)) (Nat.zero_add T) (r.reach 0 T)))
        ⟨r.act T, Eq.subst (motive := fun x => P.step (r.state T) (r.act T) x)
          (stays T (Nat.le_refl T)) (r.step T)⟩
    ⟨T, fun n late => match le_dest late with
      | ⟨d, gap⟩ => ⟨stays n late,
          (congrArg target ((congrArg r.state gap).trans (Enough.settled_at stays d))).mpr meets⟩⟩

/-- **Assured enough on the process.** With the limited principle of omniscience, in a world a list
holds of decidable configurations, every run from `s` comes to rest with its target met exactly
where every configuration reachable from `s` with a step that stays meets the target and no
configuration reachable from `s` has a step to another from which it can be reached again. The
first direction needs neither the principle nor the list. -/
theorem assured_iff_of_lpo [DecidableEq S] (lpo : LPO) {l : List S} (world : ∀ x, x ∈ l) {s : S}
    {target : S → Prop} :
    (∀ r : Run P, r.state 0 = s → Enough.Rests target r) ↔
      (∀ u, Reach P s u → Enough.Stays P u → target u) ∧
        ¬ ∃ x a y, Reach P s x ∧ P.step x a y ∧ y ≠ x ∧ Reach P y x :=
  ⟨fun assured => ⟨Enough.assured_stays_meet assured, Settling.assured_no_undoable assured⟩,
   fun ⟨meet, noUndo⟩ r start => rests_of_settles meet start (settles_of_no_undoable lpo world noUndo r start)⟩

/-- **Not not resting.** In a world a list holds of decidable configurations, where every
configuration reachable from `s` with a step that stays meets the target and no reachable change
can be undone, every run from `s` does not not come to rest with its target met. No principle of
omniscience is needed. -/
theorem not_not_rests [DecidableEq S] {l : List S} (world : ∀ x, x ∈ l) {s : S} {target : S → Prop}
    (meet : ∀ u, Reach P s u → Enough.Stays P u → target u)
    (noUndo : ¬ ∃ x a y, Reach P s x ∧ P.step x a y ∧ y ≠ x ∧ Reach P y x) :
    ∀ r : Run P, r.state 0 = s → ¬ ¬ Enough.Rests target r :=
  fun _ start unrest => not_not_settles (fun _ => world _) (noLoop_of_no_undoable noUndo start)
    fun settles => unrest (rests_of_settles meet start settles)

end AnyProcess

/-- **Exactly the limited principle of omniscience.** The limited principle of omniscience holds
exactly where, for every process of decidable configurations in a world a list holds, every run
from a configuration with no reachable change that can be undone settles. The second direction
needs only `Settling.OneWay`. -/
theorem lpo_iff_settles :
    LPO ↔ ∀ (S : Type) [DecidableEq S] (l : List S), (∀ x, x ∈ l) → ∀ (A : Type) (P : Process S A) (s : S),
      (¬ ∃ x a y, Reach P s x ∧ P.step x a y ∧ y ≠ x ∧ Reach P y x) →
        ∀ r : Run P, r.state 0 = s → Enough.Settles r :=
  ⟨fun lpo _ _ _ world _ _ _ noUndo => settles_of_no_undoable lpo world noUndo,
   fun every => Settling.OneWay.lpo_of_settles
    (every Bool [false, true] (fun x => match x with
        | false => List.Mem.head _
        | true => List.Mem.tail _ (List.Mem.head _))
      Unit Settling.OneWay.process false fun ⟨x, a, y, _, step, moves, undo⟩ =>
        Settling.OneWay.no_undoable ⟨x, a, y, Reach.refl _ x, step, moves, undo⟩)⟩

/-! ### A law's run with a bounded mark

`settles_of_lpo` needs the limited principle of omniscience because a run of a process may change
again after any step. A run of a law is fixed by its law: where the law leaves a configuration as it
is, the run stays there, and whether it does is decided at each step. So where a quantity marks the
changes of the run and is bounded along it, the run comes to rest within the bound, with no
omniscience. -/

section LawRuns

variable {S : Type u} {next : S → S}

/-- Where the law leaves a configuration as it is, the run from it stays there. -/
theorem still_of_fixed {s : S} (fixed : next s = s) : StillFrom (Law.run next s) 0 :=
  have stays : ∀ n, Law.orbit next s n = s := fun n =>
    (congrArg (Law.orbit next s) (Nat.one_mul n)).symm.trans
      (Law.orbit_mul (next := next) (s := s) (p := 1) fixed n)
  fun k => (stays (0 + k + 1)).trans (stays (0 + k)).symm

/-- **A law's run with a bounded mark comes to rest within the bound.** Where a quantity `q` marks
the changes of a law's run (it never falls along the run and rises wherever the configuration
changes) and stays at most `B` along it, and `B` is at most `d` above the mark at the start, the run
is still from some step at most `d`. Whether the law leaves a configuration as it is is decided at
each step, so no omniscience is needed: each change raises the mark by at least one, and the mark
has at most `d` to rise. -/
theorem still_within [DecidableEq S] {q : S → Nat} {B : Nat} :
    ∀ (d : Nat) (s : S), B ≤ d + q s → Marks q (Law.orbit next s) →
      (∀ n, q (Law.orbit next s n) ≤ B) → ∃ N, N ≤ d ∧ StillFrom (Law.run next s) N := by
  intro d
  induction d with
  | zero =>
    intro s fuel marks bounded
    refine ⟨0, Nat.le_refl 0, still_of_fixed ?_⟩
    exact Decidable.byContradiction fun moves =>
      have rises : q s < q (next s) := (marks 0).2 moves
      have top : B ≤ q s := Nat.le_trans fuel (Nat.le_of_eq (Nat.zero_add (q s)))
      Nat.lt_irrefl _ (Nat.lt_of_lt_of_le rises (Nat.le_trans (bounded 1) top))
  | succ d ih =>
    intro s fuel marks bounded
    exact if fixed : next s = s then ⟨0, Nat.zero_le _, still_of_fixed fixed⟩ else
      have rises : q s + 1 ≤ q (next s) := (marks 0).2 fixed
      have fuel' : B ≤ d + q (next s) :=
        Nat.le_trans fuel (Nat.le_trans
          (Nat.le_of_eq ((Nat.add_right_comm d 1 (q s)).trans (Nat.add_assoc d (q s) 1)))
          (Nat.add_le_add_left rises d))
      have shifted : ∀ n, Law.orbit next (next s) n = Law.orbit next s (n + 1) :=
        fun n => (Law.orbit_shift next s n).symm
      have marks' : Marks q (Law.orbit next (next s)) := fun n => by
        rw [shifted n, shifted (n + 1)]
        exact marks (n + 1)
      have ⟨N, le, still⟩ :=
        ih (next s) fuel' marks' (fun n => by rw [shifted n]; exact bounded (n + 1))
      ⟨N + 1, Nat.succ_le_succ le, fun k => by
        show Law.orbit next s (N + 1 + k + 1) = Law.orbit next s (N + 1 + k)
        rw [Nat.add_right_comm N 1 k, ← shifted (N + k + 1), ← shifted (N + k)]
        exact still k⟩

end LawRuns

end LastChange

end Becoming
