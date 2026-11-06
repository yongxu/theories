import Becoming.RuleCapture

/-!
# Closed capture: a loop whose every level reads only the share

`Becoming.RuleCapture` states a selection whose rule is read from the share it selects: what holds
the outcome there is how the rule reads, not the rule's value (`RuleCapture.uniform_locks`,
`RuleCapture.perturbation_absorbed`). It leaves two parts of such a loop unstated: what the
selection does that the share does not carry, and how the rule comes to be read as it is. This
module states both on `Pace.paced`, with no premise beyond the hypotheses each statement names.

* **What the loop does not read does not change it.** The fast configuration is a pair: what the
  selection and the reading read (the share) and what lies beyond it (a loss, a draw on a
  condition, a record of failure). Where neither the share's next value nor the rule read reads
  what lies beyond (`Unread`), two courses from starts alike in share and rule have the same share
  and the same rule at every step, whatever lies beyond (`unread_course`). The share's own
  two-level law with a step beyond it (`join`, `joinRead`) runs the share and the rule exactly as
  the share's law alone does (`join_course`), whatever its loss at the start (`join_alike`). Conversely, courses from starts alike in share and
  rule that come apart in either read beyond the share (`reads_beyond_of_apart`). This is the
  spine's law of a part read alone (`Law.part_identifiesAlike_iff_step` of
  `Becoming.IdentificationRuns`) on the two-level step: what the loop reads, share, rule and step
  count (`loopPart`), goes alike under the step where nothing beyond the share is read
  (`goAlike_of_unread`); it makes sense by itself along every schedule exactly then
  (`identifiesAlike_iff_unread`), and courses from starts alike in share and rule stay alike
  along every schedule exactly then (`courses_alike_iff_unread`). `unread_course` is
  `Law.sameFuture_of_goAlike` read along the course.
* **A locked loop outlives its loss.** Where every step adds at least one to what lies beyond
  (`Accrues`), from a locked configuration the loss at step `t` is at least `t` above where it
  started, so it passes every bound, while the course stays locked and neither the share nor the
  rule is ever below where it started (`lock_outlives_loss`). A measure the loss refutes is kept,
  because nothing in the loop reads the refutation.
* **A reading that reads the loss leaves.** Where the rule read favours at no configuration whose
  loss is at least `N`, and the loss accrues, at the step after every reading step at which the loss
  has passed `N` the rule in force does not favour, so the course is not locked there, whatever the
  share (`turned_by_loss`). `Beyond`: carriers two to one under a rule favouring them four to one,
  read at every step, each step adding one to the loss. Read from the share alone the course is
  locked at every step and the share never falls below the start (`Beyond.closed_locked`); read
  from the loss, favouring while the loss is below one, the same selection from the same start
  favours the others from the second step on (`Beyond.open_turned`) and the share falls at the
  third (`Beyond.open_falls`), and that reading reads beyond the share (`Beyond.open_reads`).
* **The reading read from the share.** Where how the rule is read (`Q`) is itself formed from the
  share at the reading step (`mind`), and the rule is read from the share through the reading so
  formed (`read`), the rule and its reading together are one rule read from the share
  (`both_reads`, in the order of pairs `both`), so `RuleCapture`'s laws hold of the pair. Locked,
  neither the share, the rule nor the reading is ever below where it was (`readers_not_below`); a
  change of the reading, of any size and either way, with a rule that still favours, is absorbed at
  the next reading step, the rule and the reading back at least where they were before it
  (`reading_absorbed`); where the rule read favours at every reading and share, every course is
  locked from the step after its second reading step, whatever reading it starts with
  (`readers_uniform_locks`). `Proportional` meets every premise: the reading formed is the share's
  own proportion and the rule read is that reading, and a reading reversed to favour the others is
  absorbed at the next reading step (`Proportional.reform_absorbed`).

* **Readers drawn from the selected: `ReadsShare` from who reads.** Where the rule read is the pool
  of its readers' readings (`Drawn.pool`), each carrier among the readers reading the rule as `u`
  and each other as `v`, the readers counted as the population counts them, the rule read is a
  monotone function of the share alone exactly where each carrier's reading favours the carriers at
  least as much as each other's (`Drawn.pool_reads`, `Drawn.pool_reads_iff`); where it favours them
  less, the pool reads against the share (`Drawn.pool_against`), the case in which the rise the lock
  rests on does not form: along a course whose rules favour, its rule read does not rise
  (`Drawn.pool_not_rising`). Where who reads is itself formed monotonically from the share, as where
  those the selection favours hold the places from which the rule is read, the pool still reads the
  share monotonically (`Drawn.pool_through`), and where every reader reads favourably every course
  is locked from the step after its second reading step (`Drawn.through_locks`). So `ReadsShare`, a property of a function, becomes,
  within the pool, one comparison of two readings; the pool itself is the premise. The proof is one
  rearrangement of products (`Drawn.rearrange`): the larger share paired with the larger reading.
  Against a reading mirrored (the others read for the others what the carriers read for the
  carriers), the pool favours the carriers exactly where they are at least as many as the others
  and the others exactly where they are at least as many as the carriers
  (`Drawn.mirror_favours_iff`, `Drawn.mirror_disfavours_iff`).
* **The loss read by the readers the selection thins.** Where the carriers among the readers read
  only the share and the others read the loss once it reaches `N` (`Thinned.lossPool`), the reading
  reads beyond the share (in the witness, `Thinned.late_reads_loss`), yet from a step at which the
  loss has reached `N` the course is the share's own loop under the late pool
  (`Thinned.past_course`, through `course_past`: readings alike past a bound give one course past
  it). At a reading step at which the rule in force and the rule read favour alike, the course locks
  in that direction for good (`agreeing_locks`, `agreeing_stays`): read late, the lock stays while
  the loss grows by at least one a step and every other reader reads it
  (`Thinned.read_late_kept`); read in time, the course is locked the other way, the carriers' share
  never again above where it was (`Thinned.read_in_time_turns`). With the others' late reading the
  mirror of the carriers', the counts at the step the loss is read decide: the rule in force
  favouring the carriers, the lock is kept for good exactly where the carriers are at least as many
  as the others (`Thinned.kept_iff`); the rule in force favouring the others, the course is turned
  for good exactly where the others are at least as many as the carriers (`Thinned.turned_iff`).
  Witnesses: one carrier to eight others under `hi`, the carriers reading `hi`, the others one to
  one and `lo` once they read the loss; read from the start, the others still the more numerous,
  the course is locked the other way from step 2 and the carriers' share falls from step 2 to step
  3 (`Thinned.inTime_turned`); the same readers reading the same loss from step 3, the carriers by
  then the more numerous, the course is locked for good from step 4 (`Thinned.late_kept`).

A reader formed within the run is a reading of the run: nothing here supposes that what reads
stands outside what it reads, and what the loop can tell apart is settled by the one law of
lumping that settles what a learner can identify (`Learning.goAlike_iff_lumped`) and what a
selection can reach (`Web.selects_alike_iff`).

So a loop whose every level reads only the share is one two-level law of the share: no change of
the share, of the rule's value or of how the rule is read, where the share forms it again, leaves
the lock for longer where the rule read favours at every share. What leaves is a change of the law
(of `read`, `mind` or the selection), such as a level that reads beyond the share.

What is not derived: that any actual rule is the pool of readers drawn from the population it
selects, counted as it counts them, or that a carrier's reading favours the carriers at least as
much as an other's (these replace `ReadsShare` as the premise where the pool is used); that what
lies beyond is a loss to any formation (that is a significance's to say); how fast it grows beyond
one a step; that readers are minds or institutions. The pool has two kinds of reader, each reading
alike; readers of one kind reading differently, weights other than counts and the readings' own sizes (the pool
sums readings unnormalized, so a reading giving more offspring to both kinds weighs more; the
mirrored readings have equal sizes), and readings formed by argument rather than by kind are not
stated. `favours` and `disfavours` both hold of a rule giving each kind alike. The representation commits to discrete steps,
a fixed schedule of reading steps and, in `Accrues` and the witnesses, natural-number amounts. No
ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

universe u v w

namespace ClosedCapture

open Pace RuleCapture

/-! ## What lies beyond the share -/

section Beyond

variable {A : Type u} {B : Type v} {R : Type w}

/-- **Neither the share's next value nor the rule read reads what lies beyond the share.** The fast
configuration is a pair `(a, b)`: `a` the share the selection and the reading read, `b` what lies
beyond it. -/
def Unread (f : A × B → R → A × B) (h : A × B → R → R) : Prop :=
  (∀ a b b' g, (f (a, b) g).1 = (f (a, b') g).1) ∧ ∀ a b b' g, h (a, b) g = h (a, b') g

/-- One turn from configurations alike in share and rule stays alike in both. -/
theorem turn_unread {f : A × B → R → A × B} {h : A × B → R → R} (unread : Unread f h) :
    ∀ (r : Bool) (p q : (A × B) × R), p.1.1 = q.1.1 → p.2 = q.2 →
      (turn f h r p).1.1 = (turn f h r q).1.1 ∧ (turn f h r p).2 = (turn f h r q).2
  | true, ((a, b), g), ((_, b'), _), rfl, rfl => ⟨unread.1 a b b' g, unread.2 a b b' g⟩
  | false, ((a, b), g), ((_, b'), _), rfl, rfl => ⟨unread.1 a b b' g, rfl⟩

/-- **What the loop reads**: of a configuration of the two-level step, the share, the rule and the
step count, leaving out what lies beyond the share. -/
def loopPart (p : (A × B) × R × Nat) : A × R × Nat := (p.1.1, p.2.1, p.2.2)

/-- **Unread, the two-level step goes alike by what the loop reads**, under every schedule of
reading steps. -/
theorem goAlike_of_unread {f : A × B → R → A × B} {h : A × B → R → R} (unread : Unread f h)
    (reads : Nat → Bool) : GoAlike (Law.process (Pace.step f h reads)) (loopPart (A := A) (B := B) (R := R)) := by
  apply Learning.goAlike_iff_lumped.mpr
  intro p p' same
  obtain ⟨⟨a, b⟩, g, n⟩ := p
  obtain ⟨⟨a', b'⟩, g', n'⟩ := p'
  cases same
  have now := turn_unread unread (reads n) ((a, b), g) ((a, b'), g) rfl rfl
  show ((turn f h (reads n) ((a, b), g)).1.1, (turn f h (reads n) ((a, b), g)).2, n + 1) =
    ((turn f h (reads n) ((a, b'), g)).1.1, (turn f h (reads n) ((a, b'), g)).2, n + 1)
  rw [now.1, now.2]

/-- **The loop reads only the share exactly where what it reads makes sense by itself.** Share,
rule and step count, read through themselves, identify exactly the configurations alike under the
two-level step along every schedule (`IdentifiesAlike`, `Becoming.Unfolding`) exactly where
neither the next share nor the rule read reads what lies beyond the share. This is
`Law.now_identifiesAlike_iff_goAlike` read on the two-level step: a part read alone makes sense
exactly where the rest makes no difference to its next value
(`Law.part_identifiesAlike_iff_step`). -/
theorem identifiesAlike_iff_unread {f : A × B → R → A × B} {h : A × B → R → R} :
    (∀ reads : Nat → Bool,
      IdentifiesAlike (Law.frameBy (Pace.step f h reads) (loopPart (A := A) (B := B) (R := R))) loopPart) ↔
      Unread f h := by
  constructor
  · intro sense
    have lumped := Learning.goAlike_iff_lumped.mp
      (Law.now_identifiesAlike_iff_goAlike.mp (sense fun _ => true))
    have next : ∀ (a : A) (b b' : B) (g : R),
        ((f (a, b) g).1, h (a, b) g, 1) = ((f (a, b') g).1, h (a, b') g, 1) :=
      fun a b b' g => lumped ((a, b), g, 0) ((a, b'), g, 0) rfl
    exact ⟨fun a b b' g => congrArg (fun q : A × R × Nat => q.1) (next a b b' g),
      fun a b b' g => congrArg (fun q : A × R × Nat => q.2.1) (next a b b' g)⟩
  · intro unread reads
    exact Law.now_identifiesAlike_iff_goAlike.mpr (goAlike_of_unread unread reads)

/-- **What the loop does not read does not change it.** Two courses from starts alike in share and
rule have the same share and the same rule at every step, whatever lies beyond: the future through
what the loop reads is fixed by it (`Law.sameFuture_of_goAlike`), read along the two-level course
(`Pace.paced_run`). -/
theorem unread_course {f : A × B → R → A × B} {h : A × B → R → R} (unread : Unread f h)
    (reads : Nat → Bool) {c c' : (A × B) × R} (same : c.1.1 = c'.1.1) (same' : c.2 = c'.2) (t : Nat) :
    (paced f h reads c t).1.1 = (paced f h reads c' t).1.1 ∧
      (paced f h reads c t).2 = (paced f h reads c' t).2 := by
  have start : loopPart ((c.1, c.2, 0) : (A × B) × R × Nat) = loopPart (c'.1, c'.2, 0) := by
    show (c.1.1, c.2, 0) = (c'.1.1, c'.2, 0)
    rw [same, same']
  have ahead : loopPart ((Law.run (Pace.step f h reads) (c.1, c.2, 0)).state t) =
      loopPart ((Law.run (Pace.step f h reads) (c'.1, c'.2, 0)).state t) :=
    Law.sameFuture_of_goAlike (goAlike_of_unread unread reads) _ _ start t
  rw [paced_run, paced_run] at ahead
  exact ⟨congrArg (fun q : A × R × Nat => q.1) ahead, congrArg (fun q : A × R × Nat => q.2.1) ahead⟩

/-- **Courses alike in share and rule from every start alike in both, along every schedule,
exactly where nothing beyond the share is read.** One direction is `unread_course`; the other reads
the first step of the course that reads at every step. -/
theorem courses_alike_iff_unread {f : A × B → R → A × B} {h : A × B → R → R} :
    (∀ (reads : Nat → Bool) (c c' : (A × B) × R), c.1.1 = c'.1.1 → c.2 = c'.2 → ∀ t,
      (paced f h reads c t).1.1 = (paced f h reads c' t).1.1 ∧
        (paced f h reads c t).2 = (paced f h reads c' t).2) ↔ Unread f h :=
  ⟨fun alike => ⟨fun a b b' g => (alike (fun _ => true) ((a, b), g) ((a, b'), g) rfl rfl 1).1,
      fun a b b' g => (alike (fun _ => true) ((a, b), g) ((a, b'), g) rfl rfl 1).2⟩,
   fun unread reads _ _ same same' t => unread_course unread reads same same' t⟩

/-- **Courses that come apart in share or rule read beyond the share.** From starts alike in share
and rule, a step at which the shares or the rules differ refutes `Unread`. -/
theorem reads_beyond_of_apart {f : A × B → R → A × B} {h : A × B → R → R} {reads : Nat → Bool}
    {c c' : (A × B) × R} (same : c.1.1 = c'.1.1) (same' : c.2 = c'.2) {t : Nat}
    (apart : ¬ ((paced f h reads c t).1.1 = (paced f h reads c' t).1.1 ∧
      (paced f h reads c t).2 = (paced f h reads c' t).2)) : ¬ Unread f h :=
  fun unread => apart (unread_course unread reads same same' t)

/-- **The share's own law, with a step beyond the share**: the share steps by `fA`, reading the
share and the rule; what lies beyond steps by `fB`, reading everything. -/
def join (fA : A → R → A) (fB : A × B → R → B) (p : A × B) (g : R) : A × B := (fA p.1 g, fB p g)

/-- The share's reading, read on the pair. -/
def joinRead (hA : A → R → R) (p : A × B) (g : R) : R := hA p.1 g

theorem join_unread (fA : A → R → A) (fB : A × B → R → B) (hA : A → R → R) :
    Unread (join fA fB) (joinRead hA) :=
  ⟨fun _ _ _ _ => rfl, fun _ _ _ _ => rfl⟩

/-- **The loss's start changes nothing in the joined loop**: joined courses from starts differing only
in what lies beyond have the same share and the same rule at every step. -/
theorem join_alike (fA : A → R → A) (fB : A × B → R → B) (hA : A → R → R) (reads : Nat → Bool) (a : A)
    (b b' : B) (g : R) (t : Nat) :
    (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).1.1 =
        (paced (join fA fB) (joinRead hA) reads ((a, b'), g) t).1.1 ∧
      (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).2 =
        (paced (join fA fB) (joinRead hA) reads ((a, b'), g) t).2 :=
  unread_course (c := ((a, b), g)) (c' := ((a, b'), g)) (join_unread fA fB hA) reads rfl rfl t

/-- One joined turn is the share's own turn on the share and the rule. -/
theorem turn_join (fA : A → R → A) (fB : A × B → R → B) (hA : A → R → R) :
    ∀ (r : Bool) (p : (A × B) × R) (q : A × R), p.1.1 = q.1 → p.2 = q.2 →
      (turn (join fA fB) (joinRead hA) r p).1.1 = (turn fA hA r q).1 ∧
        (turn (join fA fB) (joinRead hA) r p).2 = (turn fA hA r q).2
  | true, ((_, _), _), (_, _), rfl, rfl => ⟨rfl, rfl⟩
  | false, ((_, _), _), (_, _), rfl, rfl => ⟨rfl, rfl⟩

/-- **The joined law runs the share and the rule exactly as the share's law alone.** -/
theorem join_course (fA : A → R → A) (fB : A × B → R → B) (hA : A → R → R) (reads : Nat → Bool)
    (c : (A × B) × R) :
    ∀ t, (paced (join fA fB) (joinRead hA) reads c t).1.1 = (paced fA hA reads (c.1.1, c.2) t).1 ∧
      (paced (join fA fB) (joinRead hA) reads c t).2 = (paced fA hA reads (c.1.1, c.2) t).2
  | 0 => ⟨rfl, rfl⟩
  | t + 1 =>
    have now := join_course fA fB hA reads c t
    Eq.subst (motive := fun p : (A × B) × R => p.1.1 = (paced fA hA reads (c.1.1, c.2) (t + 1)).1 ∧
        p.2 = (paced fA hA reads (c.1.1, c.2) (t + 1)).2) (paced_succ c t).symm
      (Eq.subst (motive := fun q : A × R =>
          (turn (join fA fB) (joinRead hA) (reads t) (paced (join fA fB) (joinRead hA) reads c t)).1.1 =
              q.1 ∧
            (turn (join fA fB) (joinRead hA) (reads t) (paced (join fA fB) (joinRead hA) reads c t)).2 =
              q.2) (paced_succ (c.1.1, c.2) t).symm
        (turn_join fA fB hA (reads t) _ _ now.1 now.2))

end Beyond

/-! ## A locked loop outlives its loss -/

section Outlives

variable {A : Type u} {R : Type w}

/-- **Every step adds at least one to what lies beyond.** -/
def Accrues (fB : A × Nat → R → Nat) : Prop := ∀ p g, p.2 + 1 ≤ fB p g

/-- Where every step adds at least one, what lies beyond at step `t` is at least `t` above where it
started. -/
theorem loss_grows {fA : A → R → A} {fB : A × Nat → R → Nat} {h : A × Nat → R → R} {reads : Nat → Bool}
    (accrues : Accrues fB) (c : (A × Nat) × R) :
    ∀ t, c.1.2 + t ≤ (paced (join fA fB) h reads c t).1.2
  | 0 => Nat.le_refl _
  | t + 1 =>
    have step : (paced (join fA fB) h reads c t).1.2 + 1 ≤ (paced (join fA fB) h reads c (t + 1)).1.2 :=
      Eq.subst (motive := fun x : A × Nat => (paced (join fA fB) h reads c t).1.2 + 1 ≤ x.2)
        (paced_fast_succ c t).symm (accrues _ _)
    Nat.le_trans (Nat.succ_le_succ (loss_grows accrues c t)) step

/-- **A reading that reads the loss turns once the loss passes its bound.** Where the rule read
favours at no configuration whose loss is at least `N`, and every step adds at least one to the
loss, at the step after every reading step `r` with `N ≤ b + r` the rule in force does not favour:
the course is not locked there, whatever the share. -/
theorem turned_by_loss {fA : A → R → A} {fB : A × Nat → R → Nat} {h : A × Nat → R → R}
    {reads : Nat → Bool} {favours : R → Prop} (accrues : Accrues fB)
    {N : Nat} (turns : ∀ p g, N ≤ p.2 → ¬ favours (h p g)) {a : A} {b : Nat} {g : R} {r : Nat}
    (at_r : reads r = true) (past : N ≤ b + r) :
    ¬ favours (paced (join fA fB) h reads ((a, b), g) (r + 1)).2 :=
  have at_next : paced (join fA fB) h reads ((a, b), g) (r + 1) =
      (join fA fB (paced (join fA fB) h reads ((a, b), g) r).1 (paced (join fA fB) h reads ((a, b), g) r).2,
        h (paced (join fA fB) h reads ((a, b), g) r).1 (paced (join fA fB) h reads ((a, b), g) r).2) :=
    (paced_succ ((a, b), g) r).trans (congrArg (fun q => turn (join fA fB) h q _) at_r)
  Eq.subst (motive := fun p : (A × Nat) × R => ¬ favours p.2) at_next.symm
    (turns _ _ (Nat.le_trans past (loss_grows accrues ((a, b), g) r)))

/-- **A locked loop outlives its loss.** The share's law locked at the start, what lies beyond
growing by at least one a step and read by neither the selection nor the reading: at every step the
loss is at least `t` above where it started, the course is locked, and neither the share nor the
rule is below where it started. -/
theorem lock_outlives_loss {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {fB : A × Nat → R → Nat} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') (accrues : Accrues fB)
    {a : A} {b : Nat} {g : R} (locked : Locked M favours hA (a, g)) (t : Nat) :
    b + t ≤ (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).1.2 ∧
      Locked M favours hA ((paced (join fA fB) (joinRead hA) reads ((a, b), g) t).1.1,
        (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).2) ∧
      P.le a (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).1.1 ∧
      M.le g (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).2 :=
  have joined := join_course fA fB hA reads ((a, b), g) t
  have pair : ((paced (join fA fB) (joinRead hA) reads ((a, b), g) t).1.1,
      (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).2) = paced fA hA reads (a, g) t :=
    congr (congrArg Prod.mk joined.1) joined.2
  have stays : Locked M favours hA (paced fA hA reads (a, g) t) :=
    Eq.subst (motive := fun n => Locked M favours hA (paced fA hA reads (a, g) n)) (Nat.zero_add t)
      (locked_stays (reads := reads) (c := (a, g)) (t := 0) raises monotone upper locked t)
  have below := locked_not_below (reads := reads) (c := (a, g)) (t := 0) raises monotone upper locked t
  have below' : P.le a (paced fA hA reads (a, g) t).1 ∧ M.le g (paced fA hA reads (a, g) t).2 :=
    Eq.subst (motive := fun n => P.le a (paced fA hA reads (a, g) n).1 ∧
      M.le g (paced fA hA reads (a, g) n).2) (Nat.zero_add t) below
  ⟨loss_grows accrues ((a, b), g) t, pair.symm ▸ stays,
    Eq.subst (motive := fun x : A => P.le a x) joined.1.symm below'.1,
    Eq.subst (motive := fun x : R => M.le g x) joined.2.symm below'.2⟩

end Outlives

/-! ## Witness: a reading that reads the loss leaves

Carriers two to one under the rule `hi` (each carrier four offspring to each other's one), read at
every step, each step adding one to the loss. -/

namespace Beyond

open CarrierCounts

/-- Each step adds one to the loss. -/
def lossStep (p : CarrierCounts × Nat) (_ : CarrierCounts) : Nat := p.2 + 1

/-- Read from the share alone: favouring the carriers four to one at every share. -/
def closedRead (_ _ : CarrierCounts) : CarrierCounts := hi

/-- Read from the loss: favouring the carriers while the loss is below one, the others after. -/
def lossRead (p : CarrierCounts × Nat) (_ : CarrierCounts) : CarrierCounts :=
  match Nat.blt p.2 1 with
  | true => hi
  | false => lo

/-- The course read from the share alone. -/
def closed (t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  paced (join select lossStep) (joinRead closedRead) (fun _ => true) ((twoToOne, 0), hi) t

/-- The course read from the loss. -/
def opened (t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  paced (join select lossStep) lossRead (fun _ => true) ((twoToOne, 0), hi) t

/-- **Read from the share alone, the course is locked at every step**, the loss at step `t` is at
least `t`, and the share is never below the start's. -/
theorem closed_locked (t : Nat) :
    t ≤ (closed t).1.2 ∧ Locked order favours closedRead ((closed t).1.1, (closed t).2) ∧
      order.le twoToOne (closed t).1.1 :=
  have outlives := lock_outlives_loss (reads := fun _ => true) (b := 0) raises
    (fun _ _ _ _ _ => order.refl hi) upper (fun _ _ => Nat.le_refl _)
    (show Locked order favours closedRead (twoToOne, hi) from ⟨show 1 ≤ 4 by decide, order.refl hi⟩) t
  ⟨Eq.subst (motive := fun n => n ≤ (closed t).1.2) (Nat.zero_add t) outlives.1, outlives.2.1,
    outlives.2.2.1⟩

/-- **Read from the loss, the rule turns at the second step and the share falls at the third.** -/
theorem open_falls : (opened 1).2 = hi ∧ (opened 2).2 = lo ∧ ¬ order.le (opened 2).1.1 (opened 3).1.1 :=
  ⟨rfl, rfl, show ¬ 32 * 4 ≤ 32 * 1 by decide⟩

/-- From a loss of one on, the reading from the loss favours the others. -/
theorem lossRead_turns : ∀ (p : CarrierCounts × Nat) (g : CarrierCounts), 1 ≤ p.2 → ¬ favours (lossRead p g)
  | (_, 0), _, past => absurd past (Nat.not_succ_le_zero 0)
  | (_, _ + 1), _, _ => show ¬ 4 ≤ 1 by decide

/-- **Read from the loss, the rule favours the others at every step after the first**, by
`turned_by_loss`, while the course read from the share alone is locked at every step. -/
theorem open_turned {r : Nat} (pos : 1 ≤ r) : ¬ favours (opened (r + 1)).2 :=
  turned_by_loss (reads := fun _ => true) (fun _ _ => Nat.le_refl _) (N := 1) lossRead_turns rfl
    (Eq.subst (motive := fun n => 1 ≤ n) (Nat.zero_add r).symm pos)

/-- **The reading from the loss reads beyond the share**: from starts alike in share and rule, one
loss zero and the other one, the rules read at the first step differ. -/
theorem open_reads : ¬ Unread (join select lossStep) lossRead :=
  reads_beyond_of_apart (reads := fun _ => true) (c := ((twoToOne, 0), hi)) (c' := ((twoToOne, 1), hi))
    rfl rfl (t := 1) (fun same => hi_not_le_lo (Eq.subst (motive := fun g => order.le hi g) same.2 (order.refl hi)))

end Beyond

/-! ## The reading read from the share -/

section Readers

variable {S : Type u} {G : Type v} {Q : Type w}

/-- **The order of pairs**: a rule and a reading are not lower than another pair where each is not
lower. -/
def both (MG : Ideals.Preorder G) (MQ : Ideals.Preorder Q) : Ideals.Preorder (G × Q) where
  le p q := MG.le p.1 q.1 ∧ MQ.le p.2 q.2
  refl p := ⟨MG.refl p.1, MQ.refl p.2⟩
  trans pq qr := ⟨MG.trans pq.1 qr.1, MQ.trans pq.2 qr.2⟩

/-- **The reading read from the share**: at a reading step the reading is formed from the share
(`mind`), and the rule is read from the share through the reading so formed (`read`). -/
def readers (read : Q → S → G → G) (mind : S → Q → Q) (x : S) (p : G × Q) : G × Q :=
  (read (mind x p.2) x p.1, mind x p.2)

/-- The selection reads the rule, not the reading. -/
def byRule (f : S → G → S) (x : S) (p : G × Q) : S := f x p.1

variable {P : Ideals.Preorder S} {MG : Ideals.Preorder G} {MQ : Ideals.Preorder Q}
  {favours : G → Prop} {f : S → G → S} {read : Q → S → G → G} {mind : S → Q → Q}
  {reads : Nat → Bool}

/-- **The rule and its reading together are one rule read from the share**, where the reading is
formed monotonically from the share and the rule is read monotonically from the reading and the
share. -/
theorem both_reads (readMono : ∀ q q' x y g g', MQ.le q q' → P.le x y → MG.le (read q x g) (read q' y g'))
    (formed : ReadsShare P MQ mind) : ReadsShare P (both MG MQ) (readers read mind) :=
  fun x y p p' le => ⟨readMono _ _ _ _ _ _ (formed x y p.2 p'.2 le) le, formed x y p.2 p'.2 le⟩

theorem byRule_raises (raises : Raises P favours f) :
    Raises P (fun p : G × Q => favours p.1) (byRule (Q := Q) f) :=
  fun x p fav => raises x p.1 fav

theorem both_upper (upper : ∀ {g g'}, MG.le g g' → favours g → favours g') {p p' : G × Q}
    (le : (both MG MQ).le p p') (fav : favours p.1) : favours p'.1 :=
  upper le.1 fav

/-- **Locked, neither the share, the rule nor the reading is ever below where it was.** -/
theorem readers_not_below (raises : Raises P favours f) (upper : ∀ {g g'}, MG.le g g' → favours g → favours g')
    (readMono : ∀ q q' x y g g', MQ.le q q' → P.le x y → MG.le (read q x g) (read q' y g'))
    (formed : ReadsShare P MQ mind) {c : S × (G × Q)} {t : Nat}
    (locked : Locked (both MG MQ) (fun p : G × Q => favours p.1) (readers read mind)
      (paced (byRule f) (readers read mind) reads c t)) (k : Nat) :
    P.le (paced (byRule f) (readers read mind) reads c t).1 (paced (byRule f) (readers read mind) reads c (t + k)).1 ∧
      MG.le (paced (byRule f) (readers read mind) reads c t).2.1
        (paced (byRule f) (readers read mind) reads c (t + k)).2.1 ∧
      MQ.le (paced (byRule f) (readers read mind) reads c t).2.2
        (paced (byRule f) (readers read mind) reads c (t + k)).2.2 :=
  have below := locked_not_below (byRule_raises raises) (both_reads readMono formed) (both_upper upper) locked k
  ⟨below.1, below.2.1, below.2.2⟩

/-- **A change of the reading is absorbed at the next reading step.** From a locked configuration
`(x, (g, q))`, the rule replaced by any `g'` that still favours and the reading by any `q'`, above or
below: at the step after every reading step the rule is at least `g`, the reading at least `q`, and
the course is locked again. -/
theorem reading_absorbed (raises : Raises P favours f) (upper : ∀ {g g'}, MG.le g g' → favours g → favours g')
    (readMono : ∀ q q' x y g g', MQ.le q q' → P.le x y → MG.le (read q x g) (read q' y g'))
    (formed : ReadsShare P MQ mind) {x : S} {g g' : G} {q q' : Q}
    (before : Locked (both MG MQ) (fun p : G × Q => favours p.1) (readers read mind) (x, (g, q)))
    (keeps : favours g') {r : Nat} (at_r : reads r = true) :
    MG.le g (paced (byRule f) (readers read mind) reads (x, (g', q')) (r + 1)).2.1 ∧
      MQ.le q (paced (byRule f) (readers read mind) reads (x, (g', q')) (r + 1)).2.2 ∧
      Locked (both MG MQ) (fun p : G × Q => favours p.1) (readers read mind)
        (paced (byRule f) (readers read mind) reads (x, (g', q')) (r + 1)) :=
  have absorbed := perturbation_absorbed (g' := (g', q')) (byRule_raises raises) (both_reads readMono formed)
    (both_upper upper) before keeps at_r
  ⟨absorbed.1.1, absorbed.1.2, absorbed.2⟩

/-- **Where the rule read favours at every reading and share, every course is locked from the step
after its second reading step**, whatever rule and reading it starts with. -/
theorem readers_uniform_locks (raises : Raises P favours f)
    (readMono : ∀ q q' x y g g', MQ.le q q' → P.le x y → MG.le (read q x g) (read q' y g'))
    (formed : ReadsShare P MQ mind) (uniform : ∀ q x g, favours (read q x g)) {c : S × (G × Q)}
    {r r' : Nat} (first : reads r = true) (second : reads r' = true) (lt : r < r') :
    Locked (both MG MQ) (fun p : G × Q => favours p.1) (readers read mind)
      (paced (byRule f) (readers read mind) reads c (r' + 1)) :=
  uniform_locks (byRule_raises raises) (both_reads readMono formed)
    (fun x p => uniform (mind x p.2) x p.1) first second lt

end Readers

/-! ## Witness: the reading formed as the share's own proportion

The reading formed at a reading step is the share's own proportion, and the rule read is that
reading: each kind leaves offspring in proportion to how many of its kind there are. -/

namespace Proportional

open CarrierCounts

/-- The reading formed is the share's own proportion. -/
def mind (x _ : CarrierCounts) : CarrierCounts := x

/-- The rule read is the reading. -/
def read (q _ _ : CarrierCounts) : CarrierCounts := q

theorem readMono : ∀ q q' x y g g' : CarrierCounts, order.le q q' → order.le x y →
    order.le (read q x g) (read q' y g') :=
  fun _ _ _ _ _ _ le _ => le

theorem formed : ReadsShare order order mind := fun _ _ _ _ le => le

/-- Carriers two to one, under the rule and the reading two to one, is locked. -/
theorem start_locked :
    Locked (both order order) (fun p : CarrierCounts × CarrierCounts => favours p.1) (readers read mind)
      (twoToOne, (twoToOne, twoToOne)) :=
  ⟨show 1 ≤ 2 by decide, order.refl twoToOne, order.refl twoToOne⟩

/-- **A reading reversed to favour the others is absorbed at the next reading step**: the rule and
the reading are back at least at two to one, and the course is locked again. -/
theorem reform_absorbed {reads : Nat → Bool} {r : Nat} (at_r : reads r = true) :
    order.le twoToOne (paced (byRule select) (readers read mind) reads (twoToOne, (twoToOne, lo)) (r + 1)).2.1 ∧
      order.le twoToOne (paced (byRule select) (readers read mind) reads (twoToOne, (twoToOne, lo)) (r + 1)).2.2 ∧
      Locked (both order order) (fun p : CarrierCounts × CarrierCounts => favours p.1) (readers read mind)
        (paced (byRule select) (readers read mind) reads (twoToOne, (twoToOne, lo)) (r + 1)) :=
  reading_absorbed (g' := twoToOne) raises upper readMono formed start_locked
    (show favours twoToOne from show 1 ≤ 2 by decide) at_r

end Proportional

/-! ## Readers drawn from the selected

The rule read at a reading step is the pool of its readers' readings: each carrier among the
readers reads the rule as `u`, each other as `v`, and the readers are counted as the population
counts them. -/

namespace Drawn

open CarrierCounts

/-- **A product rearranged, exactly**: `(A + p) * (C + q) + A * C` exceeds
`A * (C + q) + (A + p) * C` by `p * q`. -/
theorem rearrange_eq (A p C q : Nat) :
    (A + p) * (C + q) + A * C = A * (C + q) + (A + p) * C + p * q := by
  rw [add_mul_split A p (C + q), Nat.mul_add p C q, add_mul_split A p C,
    Nat.add_assoc (A * (C + q)) (A * C + p * C), Nat.add_assoc (A * (C + q)) (p * C + p * q),
    Nat.add_right_comm (p * C) (p * q) (A * C), Nat.add_comm (p * C) (A * C)]

/-- **The larger paired with the larger gives at least as much**: where `A ≤ B` and `C ≤ D`. -/
theorem rearrange {A B C D : Nat} (ab : A ≤ B) (cd : C ≤ D) : A * D + B * C ≤ B * D + A * C :=
  match Nat.le.dest ab, Nat.le.dest cd with
  | ⟨p, hp⟩, ⟨q, hq⟩ => by
    subst hp; subst hq
    rw [rearrange_eq A p C q]
    exact Nat.le_add_right _ _

/-- **Strictly, where both are strict.** -/
theorem rearrange_lt {A B C D : Nat} (ab : A < B) (cd : C < D) : A * D + B * C < B * D + A * C :=
  match Nat.le.dest ab, Nat.le.dest cd with
  | ⟨p, hp⟩, ⟨q, hq⟩ => by
    subst hp; subst hq
    rw [Nat.succ_add A p, Nat.succ_add C q]
    show A * (C + (q + 1)) + (A + (p + 1)) * C < (A + (p + 1)) * (C + (q + 1)) + A * C
    rw [rearrange_eq A (p + 1) C (q + 1)]
    exact Nat.lt_add_of_pos_right (Nat.mul_pos (Nat.succ_pos p) (Nat.succ_pos q))

/-- **The pool of readings**: each carrier among the readers reads the rule as `u`, each other as
`v`, and the rule read is their sum, each kind counted as the population `x` counts it. -/
def pool (u v x : CarrierCounts) : CarrierCounts :=
  ⟨x.carrier * u.carrier + x.other * v.carrier, x.carrier * u.other + x.other * v.other,
    Nat.lt_of_lt_of_le (Nat.mul_pos x.other_pos v.other_pos) (Nat.le_add_left _ _)⟩

/-- The comparison of two pools, expanded: a part alike on both sides of the share order and a
part in which the populations and the readings are paired crosswise. -/
theorem cross (u v x y : CarrierCounts) :
    (pool u v x).carrier * (pool u v y).other =
      (x.carrier * y.carrier * (u.carrier * u.other) + x.other * y.other * (v.carrier * v.other)) +
        (x.carrier * y.other * (u.carrier * v.other) + x.other * y.carrier * (v.carrier * u.other)) := by
  show (x.carrier * u.carrier + x.other * v.carrier) * (y.carrier * u.other + y.other * v.other) = _
  rw [add_mul_split, Nat.mul_add, Nat.mul_add,
    Naturals.mul_mul_mul_comm x.carrier u.carrier y.carrier u.other,
    Naturals.mul_mul_mul_comm x.carrier u.carrier y.other v.other,
    Naturals.mul_mul_mul_comm x.other v.carrier y.carrier u.other,
    Naturals.mul_mul_mul_comm x.other v.carrier y.other v.other]
  exact Naturals.add_regroup _ _ _ _

/-- **Read through a pool, a share not lower gives a rule not lower**, where each carrier's
reading favours the carriers at least as much as each other's. -/
theorem pool_mono {u v x y : CarrierCounts} (readers : order.le v u) (le : order.le x y) :
    order.le (pool u v x) (pool u v y) := by
  show (pool u v x).carrier * (pool u v y).other ≤ (pool u v y).carrier * (pool u v x).other
  rw [cross u v x y, cross u v y x, Nat.mul_comm y.carrier x.carrier, Nat.mul_comm y.other x.other,
    Nat.mul_comm y.carrier x.other, Nat.mul_comm y.other x.carrier]
  exact Nat.add_le_add_left
    (rearrange (Eq.subst (motive := fun n => x.carrier * y.other ≤ n) (Nat.mul_comm y.carrier x.other) le)
      readers) _

/-- **Read through a pool whose carriers favour the carriers less, a share not lower gives a rule
not higher.** -/
theorem pool_mono_against {u v x y : CarrierCounts} (readers : order.le u v) (le : order.le x y) :
    order.le (pool u v y) (pool u v x) := by
  show (pool u v y).carrier * (pool u v x).other ≤ (pool u v x).carrier * (pool u v y).other
  rw [cross u v x y, cross u v y x, Nat.mul_comm y.carrier x.carrier, Nat.mul_comm y.other x.other,
    Nat.mul_comm y.carrier x.other, Nat.mul_comm y.other x.carrier,
    Nat.add_comm (x.other * y.carrier * (u.carrier * v.other)),
    Nat.add_comm (x.carrier * y.other * (u.carrier * v.other))]
  exact Nat.add_le_add_left
    (rearrange (Eq.subst (motive := fun n => x.carrier * y.other ≤ n) (Nat.mul_comm y.carrier x.other) le)
      readers) _

/-- The pool read at a reading step, from the population alone. -/
def poolRead (u v x _ : CarrierCounts) : CarrierCounts := pool u v x

/-- **Where each carrier's reading favours the carriers less than each other's, the pool reads
against the share.** -/
theorem pool_against {u v : CarrierCounts} (readers : order.le u v) :
    ReadsShare order (reverse order) (poolRead u v) :=
  fun _ _ _ _ le => pool_mono_against readers le

/-- **Within the pool, reading the share monotonically is exactly the one comparison of the two
readings**: the pool reads the share monotonically where, and only where, each carrier's reading
favours the carriers at least as much as each other's. -/
theorem pool_reads_iff {u v : CarrierCounts} : ReadsShare order order (poolRead u v) ↔ order.le v u := by
  constructor
  · intro monotone
    have m := monotone ⟨0, 1, Nat.zero_lt_succ 0⟩ ⟨1, 1, Nat.zero_lt_succ 0⟩ u u (show 0 * 1 ≤ 1 * 1 by decide)
    have m' : (0 * u.carrier + 1 * v.carrier) * (1 * u.other + 1 * v.other) ≤
        (1 * u.carrier + 1 * v.carrier) * (0 * u.other + 1 * v.other) := m
    rw [Nat.zero_mul, Nat.zero_mul, Nat.one_mul, Nat.one_mul, Nat.one_mul, Nat.one_mul, Nat.zero_add,
      Nat.zero_add, Nat.mul_add, add_mul_split] at m'
    exact le_of_add_le_add_right (v.carrier * v.other) m'
  · exact fun readers _ _ _ _ le => pool_mono readers le

/-- **The pool reads the share: `ReadsShare` from who reads.** Where the rule read is the pool of its
readers' readings, the readers counted as the population counts them, and each carrier's reading
favours the carriers at least as much as each other's, the rule read is a monotone function of the
share alone. -/
theorem pool_reads {u v : CarrierCounts} (readers : order.le v u) : ReadsShare order order (poolRead u v) :=
  pool_reads_iff.mpr readers

/-- **Readers counted through a reading of the share**: where who reads is itself formed
monotonically from the share (`mind`), as where those the selection favours hold the places from
which the rule is read, the pool still reads the share monotonically. -/
theorem pool_through {u v : CarrierCounts} {mind : CarrierCounts → CarrierCounts} (readers : order.le v u)
    (formed : ∀ x y, order.le x y → order.le (mind x) (mind y)) :
    ReadsShare order order (fun x (_ : CarrierCounts) => pool u v (mind x)) :=
  fun x y _ _ le => pool_mono readers (formed x y le)

/-- Where every reader reads favourably, the pool favours at every share. -/
theorem pool_favours {u v : CarrierCounts} (fu : favours u) (fv : favours v) (x : CarrierCounts) :
    favours (pool u v x) :=
  Nat.add_le_add (Nat.mul_le_mul_left _ fu) (Nat.mul_le_mul_left _ fv)

/-- **Readers counted through the share, every one reading favourably: every course is locked from
the step after its second reading step**, whatever its start (`uniform_locks`). Counted as the
population counts them (`mind` the identity), this is the pool itself. -/
theorem through_locks {u v : CarrierCounts} {mind : CarrierCounts → CarrierCounts} {reads : Nat → Bool}
    (readers : order.le v u) (formed : ∀ x y, order.le x y → order.le (mind x) (mind y))
    (fu : favours u) (fv : favours v) {c : CarrierCounts × CarrierCounts} {r r' : Nat}
    (first : reads r = true) (second : reads r' = true) (lt : r < r') :
    Locked order favours (fun x (_ : CarrierCounts) => pool u v (mind x))
      (paced select (fun x (_ : CarrierCounts) => pool u v (mind x)) reads c (r' + 1)) :=
  uniform_locks raises (pool_through readers formed) (fun x _ => pool_favours fu fv (mind x)) first second lt

/-- **A pool whose carriers read less favourably for the carriers does not ratchet**: along a course
whose rules favour, the rule read at a later reading step is not above the rule read at an earlier
one (`against_not_rising`). -/
theorem pool_not_rising {u v : CarrierCounts} {reads : Nat → Bool} (readers : order.le u v)
    {c : CarrierCounts × CarrierCounts} (favouring : ∀ t, favours (paced select (poolRead u v) reads c t).2)
    {r r' : Nat} (first : reads r = true) (second : reads r' = true) (le : r ≤ r') :
    order.le (paced select (poolRead u v) reads c (r' + 1)).2 (paced select (poolRead u v) reads c (r + 1)).2 :=
  against_not_rising raises (pool_against readers) favouring first second le

/-- A rule that favours the others is not above one that favours the carriers. -/
theorem le_of_disfavours {w u : CarrierCounts} (dis : disfavours w) (fav : favours u) : order.le w u :=
  calc w.carrier * u.other
      ≤ w.other * u.other := Nat.mul_le_mul_right _ dis
    _ ≤ w.other * u.carrier := Nat.mul_le_mul_left _ fav
    _ = u.carrier * w.other := Nat.mul_comm _ _

/-- **Against a mirrored reading the majority decides.** Where the others read the rule as the
carriers' reading mirrored (`w` gives the others what `u` gives the carriers), and `u` favours the
carriers strictly, the pool favours the carriers exactly where they are at least as many as the
others. -/
theorem mirror_favours_iff {u w x : CarrierCounts} (hc : w.carrier = u.other) (ho : w.other = u.carrier)
    (strict : u.other < u.carrier) : favours (pool u w x) ↔ x.other ≤ x.carrier := by
  show x.carrier * u.other + x.other * w.other ≤ x.carrier * u.carrier + x.other * w.carrier ↔ _
  rw [hc, ho]
  constructor
  · intro fav
    match Nat.lt_or_ge x.carrier x.other with
    | .inl lt =>
      have s := rearrange_lt lt strict
      have f' : x.other * u.carrier + x.carrier * u.other ≤ x.carrier * u.carrier + x.other * u.other :=
        Eq.subst (motive := fun n => n ≤ x.carrier * u.carrier + x.other * u.other)
          (Nat.add_comm (x.carrier * u.other) (x.other * u.carrier)) fav
      exact absurd (Nat.lt_of_lt_of_le s f') (Nat.lt_irrefl _)
    | .inr ge => exact ge
  · intro ge
    exact Eq.subst (motive := fun n => n ≤ _) (Nat.add_comm (x.other * u.carrier) (x.carrier * u.other))
      (rearrange ge (Nat.le_of_lt strict))

/-- **The same, the other way**: against a mirrored reading the pool favours the others exactly
where they are at least as many as the carriers. -/
theorem mirror_disfavours_iff {u w x : CarrierCounts} (hc : w.carrier = u.other) (ho : w.other = u.carrier)
    (strict : u.other < u.carrier) : disfavours (pool u w x) ↔ x.carrier ≤ x.other := by
  show x.carrier * u.carrier + x.other * w.carrier ≤ x.carrier * u.other + x.other * w.other ↔ _
  rw [hc, ho]
  constructor
  · intro dis
    match Nat.lt_or_ge x.other x.carrier with
    | .inl lt =>
      have s := rearrange_lt lt strict
      have d' : x.carrier * u.carrier + x.other * u.other ≤ x.other * u.carrier + x.carrier * u.other :=
        Eq.subst (motive := fun n => x.carrier * u.carrier + x.other * u.other ≤ n)
          (Nat.add_comm (x.carrier * u.other) (x.other * u.carrier)) dis
      exact absurd (Nat.lt_of_le_of_lt d' s) (Nat.lt_irrefl _)
    | .inr ge => exact ge
  · intro le
    exact Eq.subst (motive := fun n => _ ≤ n) (Nat.add_comm (x.other * u.carrier) (x.carrier * u.other))
      (rearrange le (Nat.le_of_lt strict))

/-- A mirrored reading of a reading favouring the carriers strictly favours the others, so it is
not above it. -/
theorem mirror_le {u w : CarrierCounts} (hc : w.carrier = u.other) (ho : w.other = u.carrier)
    (strict : u.other < u.carrier) : order.le w u :=
  le_of_disfavours (show w.carrier ≤ w.other from hc ▸ ho ▸ Nat.le_of_lt strict) (Nat.le_of_lt strict)

end Drawn

/-! ## A loss read by part of the pool -/

section Part

variable {A : Type u} {R : Type w}

theorem turn_agree {f : A × Nat → R → A × Nat} {h h' : A × Nat → R → R} {N : Nat}
    (agree : ∀ p g, N ≤ p.2 → h p g = h' p g) :
    ∀ (b : Bool) (p : (A × Nat) × R), N ≤ p.1.2 → turn f h b p = turn f h' b p
  | true, p, past => congrArg (Prod.mk (f p.1 p.2)) (agree p.1 p.2 past)
  | false, _, _ => rfl

/-- **Readings alike past a bound give one course past it.** Where every step adds at least one to
what lies beyond and two readings agree at every configuration whose loss is at least `N`, the two
joined courses from a start whose loss is at least `N` are one. -/
theorem course_past {fA : A → R → A} {fB : A × Nat → R → Nat} {h h' : A × Nat → R → R}
    {reads : Nat → Bool} (accrues : Accrues fB) {N : Nat} (agree : ∀ p g, N ≤ p.2 → h p g = h' p g)
    {c : (A × Nat) × R} (past : N ≤ c.1.2) :
    ∀ t, paced (join fA fB) h reads c t = paced (join fA fB) h' reads c t
  | 0 => rfl
  | t + 1 =>
    (paced_succ c t).trans
      ((turn_agree agree (reads t) _
          (Nat.le_trans past (Nat.le_trans (Nat.le_add_right _ t) (loss_grows accrues c t)))).trans
        ((congrArg (turn (join fA fB) h' (reads t)) (course_past accrues agree past t)).trans
          (paced_succ c t).symm))

end Part

section Agrees

variable {S : Type u} {R : Type w} {P : Ideals.Preorder S} {M : Ideals.Preorder R} {favours : R → Prop}
  {f : S → R → S} {h : S → R → R} {reads : Nat → Bool}

/-- **A reading step at which the rule in force and the rule read both favour locks the course.** -/
theorem agreeing_locks (raises : Raises P favours f) (monotone : ReadsShare P M h) {c : S × R} {r : Nat}
    (at_r : reads r = true) (fav : favours (paced f h reads c r).2)
    (fav' : favours (h (paced f h reads c r).1 (paced f h reads c r).2)) :
    Locked M favours h (paced f h reads c (r + 1)) :=
  Eq.subst (motive := Locked M favours h)
    ((paced_succ c r).trans (congrArg (fun b => turn f h b _) at_r)).symm
    ⟨fav', monotone _ _ _ _ (raises _ _ fav)⟩

/-- **From there it stays locked**, neither the share nor the rule ever below where they were at the
step after the reading. -/
theorem agreeing_stays (raises : Raises P favours f) (monotone : ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : S × R} {r : Nat}
    (at_r : reads r = true) (fav : favours (paced f h reads c r).2)
    (fav' : favours (h (paced f h reads c r).1 (paced f h reads c r).2)) (k : Nat) :
    Locked M favours h (paced f h reads c (r + 1 + k)) ∧
      P.le (paced f h reads c (r + 1)).1 (paced f h reads c (r + 1 + k)).1 ∧
      M.le (paced f h reads c (r + 1)).2 (paced f h reads c (r + 1 + k)).2 :=
  have locked := agreeing_locks raises monotone at_r fav fav'
  ⟨locked_stays raises monotone upper locked k, locked_not_below raises monotone upper locked k⟩

end Agrees

/-! ## The loss read by the readers the selection thins -/

namespace Thinned

open CarrierCounts Drawn

/-- **The loss read by the others alone**: the carriers among the readers read the rule as `u`
whatever the loss; the others read it as `v` while the loss is below `N` and as `w` from then on. -/
def lossPool (u v w : CarrierCounts) (N : Nat) (p : CarrierCounts × Nat) (_ : CarrierCounts) :
    CarrierCounts :=
  match Nat.blt p.2 N with
  | true => pool u v p.1
  | false => pool u w p.1

/-- Past the bound, the pool is the carriers' reading and the others' late reading, read from the
share alone. -/
theorem lossPool_past {u v w : CarrierCounts} {N : Nat} :
    ∀ (p : CarrierCounts × Nat) (g : CarrierCounts), N ≤ p.2 →
      lossPool u v w N p g = joinRead (poolRead u w) p g := fun p _ past =>
  show (match Nat.ble (p.2 + 1) N with | true => pool u v p.1 | false => pool u w p.1) = pool u w p.1 by
    rw [Naturals.ble_false_of_lt (Nat.lt_succ_of_le past)]

variable {fB : CarrierCounts × Nat → CarrierCounts → Nat} {u v w : CarrierCounts} {N : Nat}
  {reads : Nat → Bool}

/-- The course of the share and the rule from `((x, b), g)`, the loss read by the others alone. -/
def course (fB : CarrierCounts × Nat → CarrierCounts → Nat) (u v w : CarrierCounts) (N : Nat)
    (reads : Nat → Bool) (c : (CarrierCounts × Nat) × CarrierCounts) (t : Nat) :
    (CarrierCounts × Nat) × CarrierCounts :=
  paced (join select fB) (lossPool u v w N) reads c t

/-- **Once the loss has passed its bound, the course is the share's own loop under the late pool**:
from step `r` with the loss at least `N`, the share and the rule are those of the two-level course of
the share alone, read through the carriers' reading and the others' late one. -/
theorem past_course (accrues : Accrues fB) {c : (CarrierCounts × Nat) × CarrierCounts} {r : Nat}
    (past : N ≤ (course fB u v w N reads c r).1.2) (k : Nat) :
    ((course fB u v w N reads c (r + k)).1.1, (course fB u v w N reads c (r + k)).2) =
      paced select (poolRead u w) (fun j => reads (r + j))
        ((course fB u v w N reads c r).1.1, (course fB u v w N reads c r).2) k :=
  have shifted := paced_shift (f := join select fB) (h := lossPool u v w N) (reads := reads) c r k
  have one := course_past (fA := select) (reads := fun j => reads (r + j)) accrues lossPool_past
    (c := course fB u v w N reads c r) past k
  have joined := join_course select fB (poolRead u w) (fun j => reads (r + j))
    (course fB u v w N reads c r) k
  have whole := shifted.trans one
  congr (congrArg Prod.mk ((congrArg (fun q => q.1.1) whole).trans joined.1))
    ((congrArg (fun q => q.2) whole).trans joined.2)

/-- **Read late, the loss leaves the lock in place for good.** At a reading step `r` at which the loss
has reached its bound, the others' late reading not above the carriers' (`readers`), the rule in
force and the late pool at the share there both favouring the carriers: the course is locked under
the late pool at every step from `r + 1`, neither its share nor its rule ever below where they were
at `r + 1`, while the loss, read by every other reader, grows by at least one a step. -/
theorem read_late_kept (accrues : Accrues fB) (readers : order.le w u)
    {c : (CarrierCounts × Nat) × CarrierCounts} {r : Nat} (at_r : reads r = true) (past : N ≤ (course fB u v w N reads c r).1.2)
    (fav : favours (course fB u v w N reads c r).2)
    (pfav : favours (pool u w (course fB u v w N reads c r).1.1)) (k : Nat) :
    c.1.2 + (r + (1 + k)) ≤ (course fB u v w N reads c (r + (1 + k))).1.2 ∧
      Locked order favours (poolRead u w)
        ((course fB u v w N reads c (r + (1 + k))).1.1, (course fB u v w N reads c (r + (1 + k))).2) ∧
      order.le (course fB u v w N reads c (r + 1)).1.1 (course fB u v w N reads c (r + (1 + k))).1.1 ∧
      order.le (course fB u v w N reads c (r + 1)).2 (course fB u v w N reads c (r + (1 + k))).2 :=
  have here := past_course (u := u) (v := v) (w := w) (reads := reads) accrues past
  have z := here 0
  have kept := agreeing_stays (c := ((course fB u v w N reads c r).1.1, (course fB u v w N reads c r).2))
    (reads := fun j => reads (r + j)) raises (pool_reads readers) upper (r := 0) at_r
    (Eq.subst (motive := fun q : CarrierCounts × CarrierCounts => favours q.2) z fav)
    (Eq.subst (motive := fun q : CarrierCounts × CarrierCounts => favours (pool u w q.1)) z pfav) k
  have hk := here (1 + k)
  have h1 := here 1
  ⟨loss_grows accrues c (r + (1 + k)),
    Eq.subst (motive := Locked order favours (poolRead u w)) hk.symm kept.1,
    Eq.subst (motive := fun a => order.le a _) (congrArg Prod.fst h1).symm
      (Eq.subst (motive := fun b => order.le _ b) (congrArg Prod.fst hk).symm kept.2.1),
    Eq.subst (motive := fun a => order.le a _) (congrArg Prod.snd h1).symm
      (Eq.subst (motive := fun b => order.le _ b) (congrArg Prod.snd hk).symm kept.2.2)⟩

/-- **Read in time, the loss turns the course for good.** At a reading step `r` at which the loss has
reached its bound, the others' late reading not above the carriers' (`readers`), the rule in force
and the late pool at the share there both favouring the others at least as much as the carriers
(`disfavours`, ties included): the course is locked the other way under the late pool at every step
from `r + 1`, neither the carriers' share nor the rule ever again above where they were at `r + 1`.
Where both favour the others strictly, the share falls strictly at the step (`rises_strictly`, read
the other way); the witness shows it. -/
theorem read_in_time_turns (accrues : Accrues fB) (readers : order.le w u)
    {c : (CarrierCounts × Nat) × CarrierCounts} {r : Nat} (at_r : reads r = true) (past : N ≤ (course fB u v w N reads c r).1.2)
    (dis : disfavours (course fB u v w N reads c r).2)
    (pdis : disfavours (pool u w (course fB u v w N reads c r).1.1)) (k : Nat) :
    Locked (reverse order) disfavours (poolRead u w)
        ((course fB u v w N reads c (r + (1 + k))).1.1, (course fB u v w N reads c (r + (1 + k))).2) ∧
      order.le (course fB u v w N reads c (r + (1 + k))).1.1 (course fB u v w N reads c (r + 1)).1.1 ∧
      order.le (course fB u v w N reads c (r + (1 + k))).2 (course fB u v w N reads c (r + 1)).2 :=
  have here := past_course (u := u) (v := v) (w := w) (reads := reads) accrues past
  have z := here 0
  have turned := agreeing_stays (P := reverse order) (M := reverse order)
    (c := ((course fB u v w N reads c r).1.1, (course fB u v w N reads c r).2))
    (reads := fun j => reads (r + j)) lowers (pool_reads readers).reverse lower (r := 0) at_r
    (Eq.subst (motive := fun q : CarrierCounts × CarrierCounts => disfavours q.2) z dis)
    (Eq.subst (motive := fun q : CarrierCounts × CarrierCounts => disfavours (pool u w q.1)) z pdis) k
  have hk := here (1 + k)
  have h1 := here 1
  ⟨Eq.subst (motive := Locked (reverse order) disfavours (poolRead u w)) hk.symm turned.1,
    Eq.subst (motive := fun a => order.le _ a) (congrArg Prod.fst h1).symm
      (Eq.subst (motive := fun b => order.le b _) (congrArg Prod.fst hk).symm turned.2.1),
    Eq.subst (motive := fun a => order.le _ a) (congrArg Prod.snd h1).symm
      (Eq.subst (motive := fun b => order.le b _) (congrArg Prod.snd hk).symm turned.2.2)⟩

/-- At a reading step at which the loss has reached its bound, the rule read is the late pool at the
share there. -/
theorem rule_read (accrues : Accrues fB) {c : (CarrierCounts × Nat) × CarrierCounts} {r : Nat}
    (at_r : reads r = true) (past : N ≤ (course fB u v w N reads c r).1.2) :
    (course fB u v w N reads c (r + 1)).2 = pool u w (course fB u v w N reads c r).1.1 :=
  have one := congrArg Prod.snd (past_course (u := u) (v := v) (w := w) (reads := reads) accrues past 1)
  one.trans (congrArg Prod.snd ((paced_succ (f := select) (h := poolRead u w) (reads := fun j => reads (r + j))
    ((course fB u v w N reads c r).1.1, (course fB u v w N reads c r).2) 0).trans
      (congrArg (fun b => turn select (poolRead u w) b _) at_r)))

/-- **The counts when the loss is read decide, where the rule in force favours the carriers.** Where
the others, once they read the loss, read the rule as the carriers' reading mirrored, and the
carriers' reading favours them strictly: at a reading step at which the loss has reached its bound
and the rule in force favours the carriers, the course is locked under the pool at every later
step exactly where the carriers are at least as many as the others at that step; where they are
fewer, it is not locked at the next step. -/
theorem kept_iff (accrues : Accrues fB) (hc : w.carrier = u.other) (ho : w.other = u.carrier)
    (strict : u.other < u.carrier) {c : (CarrierCounts × Nat) × CarrierCounts} {r : Nat}
    (at_r : reads r = true) (past : N ≤ (course fB u v w N reads c r).1.2)
    (fav : favours (course fB u v w N reads c r).2) :
    (∀ k, Locked order favours (poolRead u w)
        ((course fB u v w N reads c (r + (1 + k))).1.1, (course fB u v w N reads c (r + (1 + k))).2)) ↔
      (course fB u v w N reads c r).1.1.other ≤ (course fB u v w N reads c r).1.1.carrier :=
  ⟨fun locked => (mirror_favours_iff hc ho strict).mp
      (Eq.subst (motive := favours) (rule_read accrues at_r past) (locked 0).1),
   fun more k => (read_late_kept accrues (mirror_le hc ho strict) at_r past fav
      ((mirror_favours_iff hc ho strict).mpr more) k).2.1⟩

/-- **The counts when the loss is read decide, where the rule in force favours the others.** With the
same mirrored readings, at a reading step at which the loss has reached its bound and the rule in
force favours the others at least as much as the carriers, the course is locked the other way at
every later step exactly where the others are at least as many as the carriers at that step. So a
loss read only by those the selection disfavours turns the course for good where they are not yet
the fewer when they read it, and keeps it for good where the carriers are the more. -/
theorem turned_iff (accrues : Accrues fB) (hc : w.carrier = u.other) (ho : w.other = u.carrier)
    (strict : u.other < u.carrier) {c : (CarrierCounts × Nat) × CarrierCounts} {r : Nat}
    (at_r : reads r = true) (past : N ≤ (course fB u v w N reads c r).1.2)
    (dis : disfavours (course fB u v w N reads c r).2) :
    (∀ k, Locked (reverse order) disfavours (poolRead u w)
        ((course fB u v w N reads c (r + (1 + k))).1.1, (course fB u v w N reads c (r + (1 + k))).2)) ↔
      (course fB u v w N reads c r).1.1.carrier ≤ (course fB u v w N reads c r).1.1.other :=
  ⟨fun turned => (mirror_disfavours_iff hc ho strict).mp
      (Eq.subst (motive := disfavours) (rule_read accrues at_r past) (turned 0).1),
   fun more k => (read_in_time_turns accrues (mirror_le hc ho strict) at_r past dis
      ((mirror_disfavours_iff hc ho strict).mpr more) k).1⟩

/-! ### Witnesses: one loss, the same readers, read in time and read late

Carriers one to eight others, under the rule `hi` in force, read at every step, each step adding one
to the loss. The carriers among the readers read the rule as `hi` (four to one for the carriers);
the others read it as one to one until they read the loss and as `lo` (four to one for the others)
from then on. -/

/-- One carrier to eight others. -/
def fewCarriers : CarrierCounts := ⟨1, 8, Nat.zero_lt_succ 7⟩

/-- The loss read by the others from the start. -/
def inTime (t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  course Beyond.lossStep hi Second.oneToOne lo 0 (fun _ => true) ((fewCarriers, 0), hi) t

/-- The same readers reading the same loss once it has reached three. -/
def late (t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  course Beyond.lossStep hi Second.oneToOne lo 3 (fun _ => true) ((fewCarriers, 0), hi) t

theorem lossStep_accrues : Accrues Beyond.lossStep := fun _ _ => Nat.le_refl _

/-- Read in time, the others are still the more numerous at step 1, when they read the loss again,
and the rule in force and the pool read there both favour them. -/
theorem inTime_majority :
    (inTime 1).1.1.carrier < (inTime 1).1.1.other ∧ disfavours (inTime 1).2 ∧
      disfavours (pool hi lo (inTime 1).1.1) :=
  ⟨show 4 < 8 by decide, show 12 ≤ 33 by decide, show 24 ≤ 36 by decide⟩

/-- **Read in time, the course is turned for good**: at every step from step 2 it is locked the other
way, neither the carriers' share nor the rule ever again above where they were at step 2, and the
carriers' share falls from step 2 to step 3. -/
theorem inTime_turned (k : Nat) :
    Locked (reverse order) disfavours (poolRead hi lo) ((inTime (1 + (1 + k))).1.1, (inTime (1 + (1 + k))).2) ∧
      order.le (inTime (1 + (1 + k))).1.1 (inTime 2).1.1 ∧ ¬ order.le (inTime 2).1.1 (inTime 3).1.1 :=
  have turned := read_in_time_turns (fB := Beyond.lossStep) (u := hi) (v := Second.oneToOne) (w := lo)
    (N := 0) (reads := fun _ => true) (c := ((fewCarriers, 0), hi)) (r := 1) lossStep_accrues lo_le_hi rfl
    (Nat.zero_le _) inTime_majority.2.1 inTime_majority.2.2 k
  ⟨turned.1, turned.2.1, show ¬ 48 * 9504 ≤ 1152 * 264 by decide⟩

/-- Read late, the carriers are the more numerous at step 3, when the others first read the loss, and
the rule in force and the pool read there both favour the carriers. -/
theorem late_majority :
    (late 3).1.1.other < (late 3).1.1.carrier ∧ favours (late 3).2 ∧ favours (pool hi lo (late 3).1.1) :=
  ⟨show 864 < 1152 by decide, show 120 ≤ 264 by decide, show 4608 ≤ 5472 by decide⟩

/-- **Read late, the loss leaves the lock in place for good**: at every step from step 4 the course is
locked under the pool, neither the carriers' share nor the rule ever below where they were at step
4, while the loss at step `t` is at least `t` and every other reader reads it. -/
theorem late_kept (k : Nat) :
    0 + (3 + (1 + k)) ≤ (late (3 + (1 + k))).1.2 ∧
      Locked order favours (poolRead hi lo) ((late (3 + (1 + k))).1.1, (late (3 + (1 + k))).2) ∧
      order.le (late 4).1.1 (late (3 + (1 + k))).1.1 ∧ order.le (late 4).2 (late (3 + (1 + k))).2 :=
  read_late_kept (fB := Beyond.lossStep) (u := hi) (v := Second.oneToOne) (w := lo)
    (N := 3) (reads := fun _ => true) (c := ((fewCarriers, 0), hi)) (r := 3) lossStep_accrues lo_le_hi rfl
    (show 3 ≤ 3 from Nat.le_refl 3) late_majority.2.1 late_majority.2.2 k

/-- **The late reading of the witness reads the loss**: from starts alike in share and rule, one loss
zero and the other three, the rules read at step 1 differ. -/
theorem late_reads_loss : ¬ Unread (join select Beyond.lossStep) (lossPool hi Second.oneToOne lo 3) :=
  reads_beyond_of_apart (reads := fun _ => true) (c := ((fewCarriers, 0), hi)) (c' := ((fewCarriers, 3), hi))
    rfl rfl (t := 1) (fun same => absurd (congrArg CarrierCounts.other same.2) (by decide))

end Thinned

end ClosedCapture

end Becoming
