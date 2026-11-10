import Becoming.ClosedCapture
import Becoming.RuleShaping

/-!
# The pool from the course: a selection whose readers of what lies beyond its share its own course keeps or removes

`Becoming.RuleCapture` and `Becoming.ClosedCapture` state capture on the two-level course
(`Pace.paced`): the rule read from the share locks the course (`RuleCapture.locked_stays`), a lock
outlives a loss nothing in the loop reads (`ClosedCapture.lock_outlives_loss`), and a reading of the
loss turns it (`ClosedCapture.turned_by_loss`); `ClosedCapture.Thinned` and `Becoming.ReadInTime`
let the others among the readers read the loss from a bound on. In all of them who reads is fixed by
premise: the readers of what lies beyond stand whatever the course does (thinned by the share in
`ClosedCapture.Drawn`'s pools, never removed). `Becoming.ReadingsPersist` states a selection
that removes its own readers, with persistence as the selection (`RemovesItsReaders`). This module
reads the rule through a pool whose readers of what lies beyond the share stand only where the
course leaves them, so that what the rule reads changes with the course the selection makes.

The fast configuration is a pair `A × B`: the share and what lies beyond it. A predicate
`present : A × B → Prop` says where some reader of what lies beyond the share is in the pool.

* **What the pool registers.** Where no reader of the beyond is present, the rule read is the
  share-readers' rule, read off the share alone (`ReadsThroughPresent`); two such configurations
  alike in share give one rule read, whatever lies beyond (`read_absent`).
* **Where a lock can be left.** One turn keeps a lock read off the share wherever the share does
  not fall at that step and the rule read there, if the step reads, is the share-readers'
  (`turn_locked_at`): `RuleCapture.turn_locked` applied at the two shares the step joins, ordered as
  `P` orders them (`twoShares`), so `turn_locked` stays the reason. Along a stretch whose reading
  steps read as the share-readers do and whose share falls at no step, the lock is kept and neither
  share nor rule ends below where it was (`locked_along`). Read contrapositively: a lock is left only
  along a stretch containing a reading step whose rule read is not the share-readers' (under
  `ReadsThroughPresent`, a reader of the beyond present and reading otherwise), or a step at which
  the share is not kept at or above where it was, or under another
  law; the share can fall for steps while the course stays locked (`Borne.shapers_left`). Every law
  here takes the share-readers' rule monotone in the share and favouring kept upward.
* **Closed, it stays closed.** Where the selection raises the share under every favouring rule on
  the whole configuration (`Raises` for `liftShare P`: under a favouring rule nothing from beyond
  lowers the share) and brings no reader of the beyond back once none is
  present (`NotReadmitted`), from a locked step with none present none is present again, the course
  is locked at every later step and neither share nor rule falls below where it was
  (`closed_stays_closed`).
* **Readers the loss removes** (`B = Nat`, a loss). The readers of the loss read it as `hL` while
  it lies in `[N, K)` and are gone from `K` on, their standing hanging on what the loss takes
  (`windowRead`, `Stands`). Gone, they are not readmitted where the loss accrues
  (`stands_not_readmitted`). Where `K ≤ N`, the loss removes them before they read it, the rule is
  read off the share at every configuration, and a locked start stays locked while the loss passes
  every bound (`window_never_read`). Past `K` the course is the share's own loop from the
  configuration it has reached (`window_past_course`, through `ClosedCapture.course_past` and
  `ClosedCapture.join_course`), whatever the removed readers read (`window_removed_unregistered`),
  and a step locked there stays locked for good (`window_locked_after_removal`). While they stand,
  with the rule read as the pool of readers drawn from the selected (`ClosedCapture.Drawn`), the
  window is `Thinned.lossPool` at every configuration whose readers stand
  (`window_standing_thinned`); with these pools, "gone" means that the others read as they did before
  the loss was read, their count unchanged. The laws past the bound take the share's selection
  raising it under a favouring rule.
* **The loop: the lock draws its readers out.** Let the readers read the loss from when they stand
  (`N = 0`), their own reading monotone in the share and the loss (`monoL`) and never more
  favourably than the share-readers (`against`), the selection be monotone in
  share and rule, the share-readers' reading monotone in the share, and the loss drawn at each step
  monotone in the share, the loss and the rule (a drain read off the course). Then the window's
  reading is monotone in the share, in the loss and, reversed, in the readers' bound
  (`boundRead_reads`), and two courses keep their order (`window_order_kept`, by
  `RuleCapture.order_kept` with the bound carried as a coordinate, `bound_course`): a course whose
  start share is higher, or whose readers are removed at a lower bound, has at every step a share,
  a loss and a rule not lower. So a share not lower draws no less on what lies beyond, and its
  readers of it are gone no later; and readers removed at a bound not higher leave a share not
  lower.
* **On whom the loss falls** (counts). Written as `Becoming.RuleShaping` writes a cost and a
  return, a loss borne by the shapers adds to the others' count and one borne by the others adds to
  the shapers' (`bear`, `borneStep`): on the rule after shaping, borne by the shapers it is
  `RuleShaping.shaped` with the cost `c + l`, borne by the others with `s + l`
  (`bear_shaped_shapers`, `bear_shaped_others`), so the rule favours the shapers exactly where
  `c + l ≤ s`, or `c ≤ s + l` (`borne_by_shapers_favours_iff`, `borne_by_others_favours_iff`).
  Borne by the others the joint selection raises the share under every favouring rule
  (`borne_by_others_raises`), so `closed_stays_closed` applies: a loss entering the share on the
  disfavoured side does not leave the lock. Borne by the shapers past what the rule in force gives
  them, the share falls strictly (`borne_falls`).

**Witnesses.**
* `Drained`: carriers to others under `hi`, the threshold reading `threshold hi lo` read at every
  step, the readers of the loss reading `lo` from when they stand until the loss reaches 4. With the
  loss one a step, carriers eight to one are turned for good from step 4 (`Drained.clock_turned`).
  With the loss drawn by the shapers, forty more at a step at which they outnumber the others
  sixteen to one, the same start drains its readers out after two readings: the rule in force is
  `lo` at steps 1 and 2 and the course is locked in the carriers' favour for good from step 3
  (`Drained.strong_undone`); from carriers two to one, which do not outnumber the others sixteen to
  one before step 4 (by the course's values), the course is turned for good from step 4 (`Drained.weak_turned`). Every premise of
  `window_order_kept` holds there (`Drained.premises`), and the course from eight to one is at no
  step below the course from two to one (`Drained.strong_not_below`).
* `Borne`: carriers two to one under `hi`, the threshold reading, no reader of the loss at any
  step. Borne by the carriers at four a unit of loss, the share falls across each of the three
  steps from step 1 to step 4 while the rule in force is `hi`; the course is locked at steps 1 to 3 and not at step 4, and the
  rule in force is `lo` at step 5 (`Borne.shapers_turned`, `Borne.shapers_left`); borne by the others
  at the same rate, the course is locked at every step (`Borne.others_locked`).

What is not derived: that actual pools are read off courses so, that readers of what lies beyond a
share are removed by what they read, or that any drain grows with a share; how many read and which
lines (presence is one predicate); that the selection prefers the removal of its readers beyond what
`window_order_kept` orders; an optimizer choosing to remove them; noise. The representation commits
to discrete steps, a fixed schedule of reading steps and, in the witnesses, natural counts. No
ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace PoolFromCourse

open Pace RuleCapture ClosedCapture

universe u v w

/-! ## What a pool read off the course registers -/

section Presence

variable {A : Type u} {B : Type v} {R : Type w}

/-- **Where no reader of what lies beyond the share is in the pool, the rule read is the
share-readers' rule**, read off the share alone. -/
def ReadsThroughPresent (present : A × B → Prop) (hA : A → R → R) (h : A × B → R → R) : Prop :=
  ∀ p g, ¬ present p → h p g = hA p.1 g

/-- **The selection brings no reader of the beyond back** once none is in the pool. -/
def NotReadmitted (present : A × B → Prop) (f : A × B → R → A × B) : Prop :=
  ∀ p g, ¬ present p → ¬ present (f p g)

/-- The share order read on the whole configuration. -/
def liftShare (P : Ideals.Preorder A) : Ideals.Preorder (A × B) where
  le p q := P.le p.1 q.1
  refl p := P.refl p.1
  trans := P.trans

/-- The two shares one step joins, ordered as `P` orders them: `false` the share before the step,
`true` the share after it. -/
def twoShares (P : Ideals.Preorder A) (x y : A) : Ideals.Preorder Bool where
  le b b' := P.le (cond b y x) (cond b' y x)
  refl _ := P.refl _
  trans := P.trans

/-- **Two configurations with no reader of the beyond, alike in share, give one rule read**,
whatever lies beyond. -/
theorem read_absent {present : A × B → Prop} {hA : A → R → R} {h : A × B → R → R}
    (through : ReadsThroughPresent present hA h) {p q : A × B} (np : ¬ present p)
    (nq : ¬ present q) (same : p.1 = q.1) (g : R) : h p g = h q g :=
  (through p g np).trans ((congrArg (fun a => hA a g) same).trans (through q g nq).symm)

variable {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}

/-- **One turn keeps a lock read off the share wherever the share does not fall at that step.**
From a configuration locked under the share-readers' rule `hA`, a step to a share not lower, with
the rule after it the one `hA` reads there (a reading step) or the rule before (a step that does not
read), is locked and its rule not lower. `RuleCapture.turn_locked`, applied at the two shares the
step joins. -/
theorem turn_locked_at {hA : A → R → R} (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {x y : A} {g : R}
    (rises : P.le x y) (lock : Locked M favours hA (x, g)) (b : Bool) :
    Locked M favours hA (y, cond b (hA x g) g) ∧ M.le g (cond b (hA x g) g) := by
  have raises : Raises (twoShares P x y) favours (fun _ _ => true) := fun b' _ _ =>
    match b' with
    | false => rises
    | true => P.refl y
  have reads : ReadsShare (twoShares P x y) M (fun b' g' => hA (cond b' y x) g') :=
    fun _ _ g₁ g₂ le => monotone _ _ g₁ g₂ le
  have turned := turn_locked raises reads upper b (false, g) lock
  cases b
  · exact ⟨turned.1, turned.2.2⟩
  · exact ⟨turned.1, turned.2.2⟩

variable {f : A × B → R → A × B} {h : A × B → R → R} {hA : A → R → R} {reads : Nat → Bool}

/-- **The rule after a step**: where the rule read at a reading step is the share-readers', the
rule in force after the step is what they read there, or, where the step does not read, the rule
before. -/
theorem rule_after {c : (A × B) × R} {t : Nat}
    (agree : reads t = true → h (paced f h reads c t).1 (paced f h reads c t).2 =
      hA (paced f h reads c t).1.1 (paced f h reads c t).2) :
    (paced f h reads c (t + 1)).2 =
      cond (reads t) (hA (paced f h reads c t).1.1 (paced f h reads c t).2) (paced f h reads c t).2 := by
  rw [paced_succ c t]
  cases hb : reads t
  · rfl
  · exact agree hb

/-- **A step of the course keeps a lock read off the share** where its share does not fall and, if
it reads, the rule read is the share-readers'. -/
theorem locked_step (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : (A × B) × R} {t : Nat}
    (agree : reads t = true → h (paced f h reads c t).1 (paced f h reads c t).2 =
      hA (paced f h reads c t).1.1 (paced f h reads c t).2)
    (rises : P.le (paced f h reads c t).1.1 (paced f h reads c (t + 1)).1.1)
    (lock : Locked M favours hA ((paced f h reads c t).1.1, (paced f h reads c t).2)) :
    Locked M favours hA ((paced f h reads c (t + 1)).1.1, (paced f h reads c (t + 1)).2) ∧
      M.le (paced f h reads c t).2 (paced f h reads c (t + 1)).2 := by
  have turned := turn_locked_at monotone upper rises lock (reads t)
  rw [← rule_after agree] at turned
  exact turned

/-- **A lock read off the share is kept along any stretch whose reading steps read as the
share-readers do and whose share falls at no step**, neither share nor rule ending below where they
were. So a lock is left only along a stretch containing a reading step whose rule read is not the
share-readers', or a step at which the share is not kept at or above where it was. -/
theorem locked_along (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : (A × B) × R} {r : Nat}
    (lock : Locked M favours hA ((paced f h reads c r).1.1, (paced f h reads c r).2)) :
    ∀ k, (∀ j, j < k →
        (reads (r + j) = true → h (paced f h reads c (r + j)).1 (paced f h reads c (r + j)).2 =
          hA (paced f h reads c (r + j)).1.1 (paced f h reads c (r + j)).2) ∧
        P.le (paced f h reads c (r + j)).1.1 (paced f h reads c (r + j + 1)).1.1) →
      Locked M favours hA ((paced f h reads c (r + k)).1.1, (paced f h reads c (r + k)).2) ∧
        P.le (paced f h reads c r).1.1 (paced f h reads c (r + k)).1.1 ∧
        M.le (paced f h reads c r).2 (paced f h reads c (r + k)).2
  | 0, _ => ⟨lock, P.refl _, M.refl _⟩
  | k + 1, along =>
    have ih := locked_along monotone upper lock k (fun j lt => along j (Nat.lt_succ_of_lt lt))
    have here := along k (Nat.lt_succ_self k)
    have next := locked_step monotone upper here.1 here.2 ih.1
    ⟨next.1, P.trans ih.2.1 here.2, M.trans ih.2.2 next.2⟩

/-- **Closed, it stays closed.** Where the selection raises the share under every favouring rule
on the whole configuration and brings no reader of the beyond back, from a locked step with no
reader of the beyond present none is present again, the course is locked at every later step, and
neither share nor rule falls below where it was. -/
theorem closed_stays_closed {present : A × B → Prop} (raises : Raises (liftShare P) favours f)
    (monotone : ReadsShare P M hA) (upper : ∀ {g g'}, M.le g g' → favours g → favours g')
    (through : ReadsThroughPresent present hA h) (kept : NotReadmitted present f)
    {c : (A × B) × R} {r : Nat} (absent : ¬ present (paced f h reads c r).1)
    (lock : Locked M favours hA ((paced f h reads c r).1.1, (paced f h reads c r).2)) :
    ∀ k, ¬ present (paced f h reads c (r + k)).1 ∧
      Locked M favours hA ((paced f h reads c (r + k)).1.1, (paced f h reads c (r + k)).2) ∧
      P.le (paced f h reads c r).1.1 (paced f h reads c (r + k)).1.1 ∧
      M.le (paced f h reads c r).2 (paced f h reads c (r + k)).2
  | 0 => ⟨absent, lock, P.refl _, M.refl _⟩
  | k + 1 =>
    have ih := closed_stays_closed raises monotone upper through kept absent lock k
    have fast := paced_fast_succ (f := f) (h := h) (reads := reads) c (r + k)
    have rises : P.le (paced f h reads c (r + k)).1.1 (paced f h reads c (r + k + 1)).1.1 :=
      Eq.subst (motive := fun q : A × B => P.le (paced f h reads c (r + k)).1.1 q.1) fast.symm
        (raises _ _ ih.2.1.1)
    have next := locked_step monotone upper (fun _ => through _ _ ih.1) rises ih.2.1
    ⟨Eq.subst (motive := fun q : A × B => ¬ present q) fast.symm (kept _ _ ih.1), next.1,
      P.trans ih.2.2.1 rises, M.trans ih.2.2.2 next.2⟩

end Presence

/-! ## Readers the loss removes -/

section Window

variable {A : Type u} {R : Type w}

/-- **The readers of the loss read it as `hL` while it lies in `[N, K)`**; elsewhere the rule is read
off the share as `hA`: before `N` they have not read it, from `K` on they are gone. -/
def windowRead (hA : A → R → R) (hL : A × Nat → R → R) (N K : Nat) (p : A × Nat) (g : R) : R :=
  if N ≤ p.2 ∧ p.2 < K then hL p g else hA p.1 g

/-- **The readers of the loss stand while it is below `K`.** -/
def Stands (K : Nat) (p : A × Nat) : Prop := p.2 < K

/-- Where its readers no longer stand, the window reads off the share. -/
theorem window_through {hA : A → R → R} {hL : A × Nat → R → R} {N K : Nat} :
    ReadsThroughPresent (Stands K) hA (windowRead hA hL N K) :=
  fun _ _ gone => if_neg (fun inside => gone inside.2)

/-- Where the loss removes its readers before they read it (`K ≤ N`), the window reads off the share
at every configuration. -/
theorem window_unread {hA : A → R → R} {hL : A × Nat → R → R} {N K : Nat} (before : K ≤ N) :
    ReadsThroughPresent (fun _ : A × Nat => False) hA (windowRead hA hL N K) :=
  fun _ _ _ => if_neg (fun inside =>
    Nat.lt_irrefl _ (Nat.lt_of_lt_of_le inside.2 (Nat.le_trans before inside.1)))

/-- **Gone, the readers are not readmitted** where the loss accrues. -/
theorem stands_not_readmitted {fA : A → R → A} {fB : A × Nat → R → Nat} {K : Nat}
    (accrues : Accrues fB) : NotReadmitted (Stands K) (join fA fB) :=
  fun p g gone stands =>
    gone (Nat.lt_trans (Nat.lt_of_lt_of_le (Nat.lt_succ_self p.2) (accrues p g)) stands)

/-- A selection of the share raising it under a favouring rule raises it on the whole
configuration, whatever the loss. -/
theorem joint_raises {P : Ideals.Preorder A} {favours : R → Prop} {fA : A → R → A}
    {fB : A × Nat → R → Nat} (raises : Raises P favours fA) :
    Raises (liftShare (B := Nat) P) favours (join fA fB) :=
  fun p g fav => raises p.1 g fav

/-- Past `K` the window is the share's own reading. -/
theorem window_past {hA : A → R → R} {hL : A × Nat → R → R} {N K : Nat} :
    ∀ (p : A × Nat) (g : R), K ≤ p.2 → windowRead hA hL N K p g = joinRead hA p g :=
  fun p g past => window_through p g (Nat.not_lt_of_le past)

variable {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
  {fA : A → R → A} {fB : A × Nat → R → Nat} {hA : A → R → R} {hL : A × Nat → R → R}
  {N K : Nat} {reads : Nat → Bool}

/-- **Read off the share at every configuration, a locked start stays locked**: where the loss
removes its readers before they read it (`K ≤ N`), from a locked step the course is locked at every
later step, neither share nor rule ever below, and the loss passes every bound. -/
theorem window_never_read (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') (accrues : Accrues fB) (before : K ≤ N)
    {c : (A × Nat) × R} {r : Nat}
    (lock : Locked M favours hA ((paced (join fA fB) (windowRead hA hL N K) reads c r).1.1,
      (paced (join fA fB) (windowRead hA hL N K) reads c r).2)) (k : Nat) :
    c.1.2 + (r + k) ≤ (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.2 ∧
      Locked M favours hA ((paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.1,
        (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).2) ∧
      P.le (paced (join fA fB) (windowRead hA hL N K) reads c r).1.1
        (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.1 ∧
      M.le (paced (join fA fB) (windowRead hA hL N K) reads c r).2
        (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).2 :=
  have closed := closed_stays_closed (present := fun _ => False) (joint_raises raises) monotone upper
    (window_unread before) (fun _ _ none => none) (r := r) (fun none => none) lock k
  ⟨loss_grows accrues c (r + k), closed.2⟩

/-- **Past `K` the course is the share's own loop** from the configuration it has reached: from a
step `r` at which the loss is at least `K`, the share and the rule are those of the two-level course
of the share alone, read through `hA`. -/
theorem window_past_course (accrues : Accrues fB) {c : (A × Nat) × R} {r : Nat}
    (past : K ≤ (paced (join fA fB) (windowRead hA hL N K) reads c r).1.2) (k : Nat) :
    ((paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.1,
        (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).2) =
      paced fA hA (fun j => reads (r + j))
        ((paced (join fA fB) (windowRead hA hL N K) reads c r).1.1,
          (paced (join fA fB) (windowRead hA hL N K) reads c r).2) k :=
  have shifted := paced_shift (f := join fA fB) (h := windowRead hA hL N K) (reads := reads) c r k
  have one := course_past (fA := fA) (reads := fun j => reads (r + j)) accrues window_past
    (c := paced (join fA fB) (windowRead hA hL N K) reads c r) past k
  have joined := join_course fA fB hA (fun j => reads (r + j))
    (paced (join fA fB) (windowRead hA hL N K) reads c r) k
  have whole := shifted.trans one
  congr (congrArg Prod.mk ((congrArg (fun q => q.1.1) whole).trans joined.1))
    ((congrArg (fun q => q.2) whole).trans joined.2)

/-- **What the removed readers read changes nothing once they are gone**: from a configuration whose
loss is at least `K`, two readings of the loss give one course. -/
theorem window_removed_unregistered (accrues : Accrues fB) {hL' : A × Nat → R → R}
    {c : (A × Nat) × R} (gone : K ≤ c.1.2) :
    ∀ t, paced (join fA fB) (windowRead hA hL N K) reads c t =
      paced (join fA fB) (windowRead hA hL' N K) reads c t :=
  course_past accrues (fun p g past => (window_past p g past).trans (window_past p g past).symm) gone

/-- **Removed, a lock that forms is kept for good**: from a step at which the loss is at least `K`
and the configuration is locked under the share-readers' rule, the readers never stand again, the
course is locked at every later step, neither share nor rule ever below, and the loss passes every
bound. -/
theorem window_locked_after_removal (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') (accrues : Accrues fB)
    {c : (A × Nat) × R} {r : Nat}
    (gone : K ≤ (paced (join fA fB) (windowRead hA hL N K) reads c r).1.2)
    (lock : Locked M favours hA ((paced (join fA fB) (windowRead hA hL N K) reads c r).1.1,
      (paced (join fA fB) (windowRead hA hL N K) reads c r).2)) (k : Nat) :
    c.1.2 + (r + k) ≤ (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.2 ∧
      ¬ Stands K (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1 ∧
      Locked M favours hA ((paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.1,
        (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).2) ∧
      P.le (paced (join fA fB) (windowRead hA hL N K) reads c r).1.1
        (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).1.1 ∧
      M.le (paced (join fA fB) (windowRead hA hL N K) reads c r).2
        (paced (join fA fB) (windowRead hA hL N K) reads c (r + k)).2 :=
  ⟨loss_grows accrues c (r + k),
    closed_stays_closed (joint_raises raises) monotone upper window_through
      (stands_not_readmitted accrues) (Nat.not_lt_of_le gone) lock k⟩

end Window

/-- **While its readers stand, the window read as the pool of readers drawn from the selected is
`Thinned`'s loss pool**: the carriers among the readers read `u`, the others `v` before the loss
reaches `N` and `w` from then on, at every configuration whose readers stand. Past the bound the
others read `v` again; their count in the population is not changed. -/
theorem window_standing_thinned {u v w : CarrierCounts} {N K : Nat} {p : CarrierCounts × Nat}
    (stands : Stands K p) (g : CarrierCounts) :
    windowRead (Drawn.poolRead u v) (joinRead (Drawn.poolRead u w)) N K p g =
      Thinned.lossPool u v w N p g := by
  cases Nat.lt_or_ge p.2 N with
  | inl before =>
    have e : windowRead (Drawn.poolRead u v) (joinRead (Drawn.poolRead u w)) N K p g =
        Drawn.pool u v p.1 := if_neg (fun inside => Nat.not_le_of_gt before inside.1)
    rw [e]
    show Drawn.pool u v p.1 =
      (match Nat.ble (p.2 + 1) N with
        | true => Drawn.pool u v p.1
        | false => Drawn.pool u w p.1)
    rw [Nat.ble_eq_true_of_le (show p.2 + 1 ≤ N from before)]
  | inr past =>
    have e : windowRead (Drawn.poolRead u v) (joinRead (Drawn.poolRead u w)) N K p g =
        Drawn.pool u w p.1 := if_pos ⟨past, stands⟩
    rw [e]
    show Drawn.pool u w p.1 =
      (match Nat.ble (p.2 + 1) N with
        | true => Drawn.pool u v p.1
        | false => Drawn.pool u w p.1)
    rw [Naturals.ble_false_of_lt (Nat.lt_succ_of_le past)]

/-! ## The loop: the lock draws its readers out -/

section Loop

variable {A : Type u} {R : Type w}

/-- The configuration with the readers' bound carried along: share, loss and bound. -/
def withBound (fA : A → R → A) (fB : A × Nat → R → Nat) (p : A × Nat × Nat) (g : R) :
    A × Nat × Nat :=
  (fA p.1 g, fB (p.1, p.2.1) g, p.2.2)

/-- The window read with its bound taken from the configuration, the readers reading from when they
stand. -/
def boundRead (hA : A → R → R) (hL : A × Nat → R → R) (p : A × Nat × Nat) (g : R) : R :=
  windowRead hA hL 0 p.2.2 (p.1, p.2.1) g

/-- Share not lower, loss not lower, bound not higher. -/
def boundOrder (P : Ideals.Preorder A) : Ideals.Preorder (A × Nat × Nat) where
  le p q := P.le p.1 q.1 ∧ p.2.1 ≤ q.2.1 ∧ q.2.2 ≤ p.2.2
  refl p := ⟨P.refl p.1, Nat.le_refl _, Nat.le_refl _⟩
  trans pq qr := ⟨P.trans pq.1 qr.1, Nat.le_trans pq.2.1 qr.2.1, Nat.le_trans qr.2.2 pq.2.2⟩

variable {fA : A → R → A} {fB : A × Nat → R → Nat} {hA : A → R → R} {hL : A × Nat → R → R}
  {reads : Nat → Bool}

/-- **The course with the bound carried is the window's course**, the bound kept. -/
theorem bound_course (K : Nat) (c : (A × Nat) × R) :
    ∀ t, paced (withBound fA fB) (boundRead hA hL) reads ((c.1.1, c.1.2, K), c.2) t =
      (((paced (join fA fB) (windowRead hA hL 0 K) reads c t).1.1,
          (paced (join fA fB) (windowRead hA hL 0 K) reads c t).1.2, K),
        (paced (join fA fB) (windowRead hA hL 0 K) reads c t).2)
  | 0 => rfl
  | t + 1 => by
    rw [paced_succ, paced_succ c t, bound_course K c t]
    cases reads t <;> rfl

variable {P : Ideals.Preorder A} {M : Ideals.Preorder R}

/-- **The window's reading is monotone in the share, in the loss and, reversed, in the bound**,
where the readers read from when they stand, their own reading monotone in the share and the loss
and never more favourably than the share-readers. -/
theorem boundRead_reads (monotone : ReadsShare P M hA)
    (monoL : ∀ x y b b' g g', P.le x y → b ≤ b' → M.le (hL (x, b) g) (hL (y, b') g'))
    (against : ∀ x y b g g', P.le x y → M.le (hL (x, b) g) (hA y g')) :
    ReadsShare (boundOrder P) M (boundRead hA hL) := by
  intro p q g g' le
  cases Nat.decLt p.2.1 p.2.2 with
  | isTrue sp =>
    have e : boundRead hA hL p g = hL (p.1, p.2.1) g := if_pos ⟨Nat.zero_le _, sp⟩
    cases Nat.decLt q.2.1 q.2.2 with
    | isTrue sq =>
      have e' : boundRead hA hL q g' = hL (q.1, q.2.1) g' := if_pos ⟨Nat.zero_le _, sq⟩
      rw [e, e']
      exact monoL _ _ _ _ g g' le.1 le.2.1
    | isFalse gq =>
      have e' : boundRead hA hL q g' = hA q.1 g' := if_neg (fun i => gq i.2)
      rw [e, e']
      exact against _ _ _ g g' le.1
  | isFalse gp =>
    have e : boundRead hA hL p g = hA p.1 g := if_neg (fun i => gp i.2)
    cases Nat.decLt q.2.1 q.2.2 with
    | isTrue sq => exact absurd (Nat.lt_of_le_of_lt le.2.1 (Nat.lt_of_lt_of_le sq le.2.2)) gp
    | isFalse gq =>
      have e' : boundRead hA hL q g' = hA q.1 g' := if_neg (fun i => gq i.2)
      rw [e, e']
      exact monotone _ _ g g' le.1

/-- **Two courses of the window keep their order.** Where the readers read the loss from when they
stand, their own reading monotone in the share and the loss and never more favourably than the
share-readers, the selection is monotone in share and rule,
the share-readers' reading monotone in the share and the loss drawn at each step monotone in the
share, the loss and the rule: a course whose start has a share, a loss and a rule not lower and
whose readers' bound is not higher has, at every step, a share, a loss and a rule not lower: a share
not lower draws no less on what lies beyond and its readers are gone no later, and readers removed
at a bound not higher leave a share not lower. -/
theorem window_order_kept
    (selects : ∀ x y g g', P.le x y → M.le g g' → P.le (fA x g) (fA y g'))
    (drains : ∀ x y b b' g g', P.le x y → b ≤ b' → M.le g g' → fB (x, b) g ≤ fB (y, b') g')
    (monotone : ReadsShare P M hA)
    (monoL : ∀ x y b b' g g', P.le x y → b ≤ b' → M.le (hL (x, b) g) (hL (y, b') g'))
    (against : ∀ x y b g g', P.le x y → M.le (hL (x, b) g) (hA y g'))
    {c c' : (A × Nat) × R} {K K' : Nat} (le : P.le c.1.1 c'.1.1) (leb : c.1.2 ≤ c'.1.2)
    (leK : K' ≤ K) (leg : M.le c.2 c'.2) (t : Nat) :
    P.le (paced (join fA fB) (windowRead hA hL 0 K) reads c t).1.1
        (paced (join fA fB) (windowRead hA hL 0 K') reads c' t).1.1 ∧
      (paced (join fA fB) (windowRead hA hL 0 K) reads c t).1.2 ≤
        (paced (join fA fB) (windowRead hA hL 0 K') reads c' t).1.2 ∧
      M.le (paced (join fA fB) (windowRead hA hL 0 K) reads c t).2
        (paced (join fA fB) (windowRead hA hL 0 K') reads c' t).2 :=
  by
  have kept := order_kept (P := boundOrder P) (M := M) (f := withBound fA fB) (h := boundRead hA hL)
    (reads := reads) (c := ((c.1.1, c.1.2, K), c.2)) (c' := ((c'.1.1, c'.1.2, K'), c'.2))
    (fun _ _ _ _ le' leg' => ⟨selects _ _ _ _ le'.1 leg', drains _ _ _ _ _ _ le'.1 le'.2.1 leg', le'.2.2⟩)
    (boundRead_reads monotone monoL against) ⟨le, leb, leK⟩ leg t
  rw [bound_course K c t, bound_course K' c' t] at kept
  exact ⟨kept.1.1, kept.1.2.1, kept.2⟩

end Loop

/-! ## On whom the loss falls -/

section Borne

open CarrierCounts

/-- **The rule in force with a loss borne**, written as `Becoming.RuleShaping` writes a cost and a
return: what the loss takes from the shapers (the carriers) is added to the others' count, what it
takes from the others to the shapers'. -/
def bear (onShapers onOthers : Nat) (g : CarrierCounts) : CarrierCounts :=
  ⟨g.carrier + onOthers, g.other + onShapers,
    Nat.lt_of_lt_of_le g.other_pos (Nat.le_add_right _ _)⟩

/-- **Selection with the loss borne**, the loss one a step: each kind multiplied by what the rule in
force gives it, with what the loss at the step takes from each borne. -/
def borneStep (onShapers onOthers : Nat → Nat) (p : CarrierCounts × Nat) (g : CarrierCounts) :
    CarrierCounts × Nat :=
  (select p.1 (bear (onShapers p.2) (onOthers p.2) g), p.2 + 1)

/-- **Borne by the shapers, a loss is a cost**: on the rule after shaping it adds to `c`. -/
theorem bear_shaped_shapers {a s p c l : Nat} {pos : 0 < a} :
    bear l 0 (RuleShaping.shaped a s p c pos) = RuleShaping.shaped a s p (c + l) pos :=
  RuleShaping.eq_of_counts (Nat.add_zero _)
    ((Nat.add_right_comm (a + c) p l).trans (congrArg (· + p) (Nat.add_assoc a c l)))

/-- **Borne by the others, a loss is a return to the shapers**: on the rule after shaping it adds
to `s`. -/
theorem bear_shaped_others {a s p c l : Nat} {pos : 0 < a} :
    bear 0 l (RuleShaping.shaped a s p c pos) = RuleShaping.shaped a (s + l) p c pos :=
  RuleShaping.eq_of_counts
    ((Nat.add_right_comm (a + s) p l).trans (congrArg (· + p) (Nat.add_assoc a s l)))
    (Nat.add_zero _)

/-- **Borne by the shapers, the rule after shaping favours them exactly where the loss with the cost
is covered by what comes back to them alone.** -/
theorem borne_by_shapers_favours_iff {a s p c l : Nat} {pos : 0 < a} :
    favours (bear l 0 (RuleShaping.shaped a s p c pos)) ↔ c + l ≤ s :=
  Eq.subst (motive := fun g => favours g ↔ c + l ≤ s) bear_shaped_shapers.symm
    RuleShaping.favours_iff

/-- **Borne by the others, exactly where the cost is covered by what comes back with the loss.** -/
theorem borne_by_others_favours_iff {a s p c l : Nat} {pos : 0 < a} :
    favours (bear 0 l (RuleShaping.shaped a s p c pos)) ↔ c ≤ s + l :=
  Eq.subst (motive := fun g => favours g ↔ c ≤ s + l) bear_shaped_others.symm
    RuleShaping.favours_iff

/-- **Borne by the others, the joint selection raises the share under every favouring rule.** -/
theorem borne_by_others_raises {onOthers : Nat → Nat} :
    Raises (liftShare (B := Nat) order) favours (borneStep (fun _ => 0) onOthers) :=
  fun p g fav => CarrierCounts.raises p.1 (bear 0 (onOthers p.2) g)
    (show g.other + 0 ≤ g.carrier + onOthers p.2 from Nat.le_trans fav (Nat.le_add_right _ _))

/-- **Borne past what the rule in force gives, the share falls strictly**: where the rule in force
with the loss borne gives each carrier strictly less than each other, the carriers present. -/
theorem borne_falls {onShapers onOthers : Nat → Nat} {p : CarrierCounts × Nat} {g : CarrierCounts}
    (some : 0 < p.1.carrier)
    (lt : (bear (onShapers p.2) (onOthers p.2) g).carrier < (bear (onShapers p.2) (onOthers p.2) g).other) :
    (borneStep onShapers onOthers p g).1.carrier * p.1.other <
      p.1.carrier * (borneStep onShapers onOthers p g).1.other :=
  RuleShaping.falls_strictly some lt

end Borne

/-! ## Witness: the lock draws its readers out -/

namespace Drained

open CarrierCounts

/-- Carriers eight to one. -/
def eightToOne : CarrierCounts := ⟨8, 1, Nat.zero_lt_succ 0⟩

/-- **The loss drawn by the shapers**: one a step, and forty more at a step at which the carriers
outnumber the others sixteen to one. -/
def drain (p : CarrierCounts × Nat) (_ : CarrierCounts) : Nat :=
  p.2 + 1 + (if 16 * p.1.other ≤ p.1.carrier then 40 else 0)

/-- The readers of the loss read the rule as `lo` from when they stand. -/
def readLoss (_ : CarrierCounts × Nat) (_ : CarrierCounts) : CarrierCounts := lo

/-- The window: the threshold reading off the share, the readers of the loss reading `lo` while the
loss is below 4. -/
def window : CarrierCounts × Nat → CarrierCounts → CarrierCounts :=
  windowRead (threshold hi lo) readLoss 0 4

/-- The course with the loss one a step. -/
def clock (x : CarrierCounts) (t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  paced (join select Beyond.lossStep) window (fun _ => true) ((x, 0), hi) t

/-- The course with the loss drawn by the shapers. -/
def drained (x : CarrierCounts) (t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  paced (join select drain) window (fun _ => true) ((x, 0), hi) t

theorem drain_accrues : Accrues drain := fun _ _ => Nat.le_add_right _ _

theorem clock_accrues : Accrues Beyond.lossStep := fun _ _ => Nat.le_refl _

/-- Outnumbering by `j` is kept upward in the share order. -/
theorem outnumber_mono {j : Nat} {x y : CarrierCounts} (le : order.le x y)
    (above : j * x.other ≤ x.carrier) : j * y.other ≤ y.carrier :=
  Nat.le_of_mul_le_mul_right
    (calc j * y.other * x.other
        = j * x.other * y.other := Naturals.mul_right_comm _ _ _
      _ ≤ x.carrier * y.other := Nat.mul_le_mul_right _ above
      _ ≤ y.carrier * x.other := le) x.other_pos

/-- What the shapers draw beyond the one a step is monotone in the share. -/
theorem drawn_mono {x y : CarrierCounts} (le : order.le x y) :
    (if 16 * x.other ≤ x.carrier then 40 else 0) ≤ (if 16 * y.other ≤ y.carrier then 40 else 0) :=
  match Nat.decLe (16 * x.other) x.carrier with
  | isTrue above => by
    rw [if_pos above, if_pos (outnumber_mono le above)]
    exact Nat.le_refl 40
  | isFalse below => by
    rw [if_neg below]
    exact Nat.zero_le _

/-- **The drain is monotone in the share and the loss**, and reads no rule. -/
theorem drain_mono : ∀ x y b b' (g g' : CarrierCounts), order.le x y → b ≤ b' → order.le g g' →
    drain (x, b) g ≤ drain (y, b') g' := fun _ _ _ _ _ _ le leb _ =>
  Nat.add_le_add (Nat.add_le_add_right leb 1) (drawn_mono le)

/-- `lo` is not above any rule the threshold reading gives. -/
theorem lo_below (x : CarrierCounts) (g : CarrierCounts) : order.le lo (threshold hi lo x g) :=
  match Nat.decLe x.other x.carrier with
  | isTrue fav => by
    rw [threshold_above fav]
    exact lo_le_hi
  | isFalse dis => by
    rw [threshold_below dis]
    exact order.refl lo

/-- **Every premise of `window_order_kept` holds here**, with the loss drawn by the shapers. -/
theorem premises :
    (∀ x y g g' : CarrierCounts, order.le x y → order.le g g' → order.le (select x g) (select y g')) ∧
      (∀ x y b b' (g g' : CarrierCounts), order.le x y → b ≤ b' → order.le g g' →
        drain (x, b) g ≤ drain (y, b') g') ∧
      ReadsShare order order (threshold hi lo) ∧
      (∀ x y b b' (g g' : CarrierCounts), order.le x y → b ≤ b' →
        order.le (readLoss (x, b) g) (readLoss (y, b') g')) ∧
      (∀ x y b (g g' : CarrierCounts), order.le x y → order.le (readLoss (x, b) g) (threshold hi lo y g')) :=
  ⟨fun _ _ _ _ le le' => select_mono le le', drain_mono, threshold_reads lo_le_hi,
    fun _ _ _ _ _ _ _ _ => order.refl lo, fun _ y _ _ g' _ => lo_below y g'⟩

/-- **With the loss one a step, carriers eight to one are turned for good from step 4**: the
readers read `lo` at steps 0 to 3; at step 4 they are gone, the carriers thirty-two to sixty-four
others under `lo`, and from there the course is locked in the others' favour at every step. -/
theorem clock_turned (k : Nat) :
    (clock eightToOne 4).1.1.carrier = 32 ∧ (clock eightToOne 4).1.1.other = 64 ∧
      (clock eightToOne 4).2 = lo ∧
      Locked (reverse order) disfavours (threshold hi lo)
        ((clock eightToOne (4 + k)).1.1, (clock eightToOne (4 + k)).2) := by
  have e3 : (clock eightToOne 4).2 = lo := rfl
  have th : threshold hi lo (clock eightToOne 4).1.1 (clock eightToOne 4).2 = lo :=
    threshold_below (show ¬ (64 ≤ 32) by decide)
  have lock : Locked (reverse order) disfavours (threshold hi lo)
      ((clock eightToOne 4).1.1, (clock eightToOne 4).2) := by
    refine ⟨show 1 ≤ 4 by decide, ?_⟩
    show order.le (threshold hi lo (clock eightToOne 4).1.1 (clock eightToOne 4).2) (clock eightToOne 4).2
    rw [th, e3]
    exact order.refl lo
  exact ⟨rfl, rfl, e3,
    (window_locked_after_removal (P := reverse order) (M := reverse order) (favours := disfavours)
      (fA := select) (fB := Beyond.lossStep) (hA := threshold hi lo) (hL := readLoss) (N := 0) (K := 4)
      (reads := fun _ => true) (c := ((eightToOne, 0), hi)) (r := 4)
      lowers (threshold_reads lo_le_hi).reverse lower clock_accrues (Nat.le_refl 4) lock k).2.2.1⟩

/-- **With the loss drawn by the shapers, the same start drains its readers out after two
readings**: the rule in force is `lo` at steps 1 and 2; at step 2 the loss is 42, the readers are
gone, and at step 3, the carriers thirty-two to sixteen others under `hi`, the course is locked in
the carriers' favour at every later step. -/
theorem strong_undone (k : Nat) :
    (drained eightToOne 1).2 = lo ∧ (drained eightToOne 2).2 = lo ∧
      (drained eightToOne 2).1.2 = 42 ∧
      (drained eightToOne 3).1.1.carrier = 32 ∧ (drained eightToOne 3).1.1.other = 16 ∧
      (drained eightToOne 3).2 = hi ∧
      Locked order favours (threshold hi lo)
        ((drained eightToOne (3 + k)).1.1, (drained eightToOne (3 + k)).2) := by
  have e3 : (drained eightToOne 3).2 = hi := rfl
  have th : threshold hi lo (drained eightToOne 3).1.1 (drained eightToOne 3).2 = hi :=
    threshold_above (show 16 ≤ 32 by decide)
  have lock : Locked order favours (threshold hi lo)
      ((drained eightToOne 3).1.1, (drained eightToOne 3).2) := by
    refine ⟨show 1 ≤ 4 by decide, ?_⟩
    show order.le (drained eightToOne 3).2 (threshold hi lo (drained eightToOne 3).1.1 (drained eightToOne 3).2)
    rw [th, e3]
    exact order.refl hi
  exact ⟨rfl, rfl, rfl, rfl, rfl, e3,
    (window_locked_after_removal (P := order) (M := order) (favours := favours)
      (fA := select) (fB := drain) (hA := threshold hi lo) (hL := readLoss) (N := 0) (K := 4)
      (reads := fun _ => true) (c := ((eightToOne, 0), hi)) (r := 3)
      raises (threshold_reads lo_le_hi) upper drain_accrues (show 4 ≤ 43 by decide) lock k).2.2.1⟩

/-- **From carriers two to one, which do not outnumber the others sixteen to one before step 4 (by the
course's values), the
course is turned for good from step 4**, as with the loss one a step. -/
theorem weak_turned (k : Nat) :
    (drained twoToOne 4).1.1.carrier = 8 ∧ (drained twoToOne 4).1.1.other = 64 ∧
      (drained twoToOne 4).2 = lo ∧
      Locked (reverse order) disfavours (threshold hi lo)
        ((drained twoToOne (4 + k)).1.1, (drained twoToOne (4 + k)).2) := by
  have e3 : (drained twoToOne 4).2 = lo := rfl
  have th : threshold hi lo (drained twoToOne 4).1.1 (drained twoToOne 4).2 = lo :=
    threshold_below (show ¬ (64 ≤ 8) by decide)
  have lock : Locked (reverse order) disfavours (threshold hi lo)
      ((drained twoToOne 4).1.1, (drained twoToOne 4).2) := by
    refine ⟨show 1 ≤ 4 by decide, ?_⟩
    show order.le (threshold hi lo (drained twoToOne 4).1.1 (drained twoToOne 4).2) (drained twoToOne 4).2
    rw [th, e3]
    exact order.refl lo
  exact ⟨rfl, rfl, e3,
    (window_locked_after_removal (P := reverse order) (M := reverse order) (favours := disfavours)
      (fA := select) (fB := drain) (hA := threshold hi lo) (hL := readLoss) (N := 0) (K := 4)
      (reads := fun _ => true) (c := ((twoToOne, 0), hi)) (r := 4)
      lowers (threshold_reads lo_le_hi).reverse lower drain_accrues (Nat.le_refl 4) lock k).2.2.1⟩

/-- **The course from eight to one is at no step below the course from two to one**, in share, loss
or rule (`window_order_kept`). -/
theorem strong_not_below (t : Nat) :
    order.le (drained twoToOne t).1.1 (drained eightToOne t).1.1 ∧
      (drained twoToOne t).1.2 ≤ (drained eightToOne t).1.2 ∧
      order.le (drained twoToOne t).2 (drained eightToOne t).2 :=
  window_order_kept (reads := fun _ => true) premises.1 premises.2.1 premises.2.2.1 premises.2.2.2.1
    premises.2.2.2.2 (c := ((twoToOne, 0), hi)) (c' := ((eightToOne, 0), hi)) (K := 4) (K' := 4)
    (show 2 * 1 ≤ 8 * 1 by decide) (Nat.le_refl 0) (Nat.le_refl 4) (order.refl hi) t

end Drained

/-! ## Witness: a loss entering the share -/

namespace Borne

open CarrierCounts

/-- Four a unit of loss. -/
def toll (b : Nat) : Nat := 4 * b

/-- The course with the loss borne by the carriers, read off the share alone. -/
def onShapers (t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  paced (borneStep toll (fun _ => 0)) (joinRead (threshold hi lo)) (fun _ => true) ((twoToOne, 0), hi) t

/-- The course with the loss borne by the others. -/
def onOthers (t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  paced (borneStep (fun _ => 0) toll) (joinRead (threshold hi lo)) (fun _ => true) ((twoToOne, 0), hi) t

/-- **Borne by the carriers, the share falls while the rule in force favours them, and the rule in
force is `lo` at step 5**, with no reader of the loss at any step. -/
theorem shapers_turned :
    (onShapers 1).2 = hi ∧ ¬ order.le (onShapers 1).1.1 (onShapers 2).1.1 ∧
      (onShapers 4).2 = hi ∧ (onShapers 5).2 = lo :=
  ⟨rfl, show ¬ (8 * 5 ≤ 32 * 1) by decide, rfl, rfl⟩

/-- A configuration under `hi` whose carriers are at least the others is locked. -/
theorem locked_hi {x : CarrierCounts} (fav : favours x) :
    Locked order favours (threshold hi lo) (x, hi) := by
  refine ⟨show 1 ≤ 4 by decide, ?_⟩
  show order.le hi (threshold hi lo x hi)
  rw [threshold_above fav]
  exact order.refl hi

/-- **The share falls across three steps while the course stays locked, and the lock is left at
the end of the third**: the rule in force is `hi` at steps 2 and 3 (and, by `shapers_turned`, at 1
and 4), the share falls across the steps from 2 to 3 and from 3 to 4 (and, by `shapers_turned`, from
1 to 2), the course is locked at steps 1, 2 and 3, and at step 4 it is not. -/
theorem shapers_left :
    (onShapers 2).2 = hi ∧ (onShapers 3).2 = hi ∧
      ¬ order.le (onShapers 2).1.1 (onShapers 3).1.1 ∧ ¬ order.le (onShapers 3).1.1 (onShapers 4).1.1 ∧
      Locked order favours (threshold hi lo) ((onShapers 1).1.1, (onShapers 1).2) ∧
      Locked order favours (threshold hi lo) ((onShapers 2).1.1, (onShapers 2).2) ∧
      Locked order favours (threshold hi lo) ((onShapers 3).1.1, (onShapers 3).2) ∧
      ¬ Locked order favours (threshold hi lo) ((onShapers 4).1.1, (onShapers 4).2) := by
  have r1 : (onShapers 1).2 = hi := rfl
  have r2 : (onShapers 2).2 = hi := rfl
  have r3 : (onShapers 3).2 = hi := rfl
  have r4 : (onShapers 4).2 = hi := rfl
  have l1 : Locked order favours (threshold hi lo) ((onShapers 1).1.1, (onShapers 1).2) := by
    rw [r1]; exact locked_hi (show 1 ≤ 8 by decide)
  have l2 : Locked order favours (threshold hi lo) ((onShapers 2).1.1, (onShapers 2).2) := by
    rw [r2]; exact locked_hi (show 5 ≤ 32 by decide)
  have l3 : Locked order favours (threshold hi lo) ((onShapers 3).1.1, (onShapers 3).2) := by
    rw [r3]; exact locked_hi (show 45 ≤ 128 by decide)
  have th4 : threshold hi lo (onShapers 4).1.1 (onShapers 4).2 = lo :=
    threshold_below (show ¬ (585 ≤ 512) by decide)
  have n4 : ¬ Locked order favours (threshold hi lo) ((onShapers 4).1.1, (onShapers 4).2) := by
    intro lock
    have below : order.le (onShapers 4).2 (threshold hi lo (onShapers 4).1.1 (onShapers 4).2) := lock.2
    rw [th4, r4] at below
    exact hi_not_le_lo below
  exact ⟨r2, r3, show ¬ (32 * 45 ≤ 128 * 5) by decide, show ¬ (128 * 585 ≤ 512 * 45) by decide,
    l1, l2, l3, n4⟩

/-- **Borne by the others, the course is locked at every step**, the share and the rule never below
the start's. -/
theorem others_locked (t : Nat) :
    Locked order favours (threshold hi lo) ((onOthers t).1.1, (onOthers t).2) ∧
      order.le twoToOne (onOthers t).1.1 ∧ order.le hi (onOthers t).2 :=
  have closed := closed_stays_closed (present := fun _ => False) (P := order) (M := order)
    (favours := favours) (f := borneStep (fun _ => 0) toll) (h := joinRead (threshold hi lo))
    (hA := threshold hi lo) (reads := fun _ => true) (c := ((twoToOne, 0), hi)) (r := 0)
    borne_by_others_raises (threshold_reads lo_le_hi) upper (fun _ _ _ => rfl) (fun _ _ none => none)
    (fun none => none) Alternating.before_locked t
  Eq.subst (motive := fun n => Locked order favours (threshold hi lo) ((onOthers n).1.1, (onOthers n).2) ∧
      order.le twoToOne (onOthers n).1.1 ∧ order.le hi (onOthers n).2) (Nat.zero_add t) closed.2

end Borne

end PoolFromCourse

end Becoming
