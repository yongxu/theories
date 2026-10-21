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

A reader formed within the run is a reading of the run: nothing here supposes that what reads
stands outside what it reads, and what the loop can tell apart is settled by the one law of
lumping that settles what a learner can identify (`Learning.goAlike_iff_lumped`) and what a
selection can reach (`Web.selects_alike_iff`).

So a loop whose every level reads only the share is one two-level law of the share: no change of
the share, of the rule's value or of how the rule is read, where the share forms it again, leaves
the lock for longer where the rule read favours at every share. What leaves is a change of the law
(of `read`, `mind` or the selection), such as a level that reads beyond the share.

What is not derived: that any actual rule, or how it is read, is formed from the share; that what
lies beyond is a loss to any formation (that is a significance's to say); how fast it grows beyond
one a step; that readers are minds or institutions. The representation commits to discrete steps,
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

end ClosedCapture

end Becoming
