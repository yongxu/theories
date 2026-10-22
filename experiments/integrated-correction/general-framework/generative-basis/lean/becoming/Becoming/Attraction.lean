import Becoming.Recurrence
import Becoming.Labelled
import Becoming.Witnesses

/-!
# Attraction: what is drawn in never comes back, and every law draws exactly what does not return

Ren gave the go on 12 October 2026 ("Great, let's finish all of them"), after the AI compared
the theory with a general cause–effect system (x_{t+1} = F(x_t, u_t, ε_t), with feedback,
adaptive parameters and attractors). This module states the attractor and lock-in part of that
comparison for every law of change, with no premise: no finiteness, no decidability and no
measure, except where a law names finitely many configurations or decidable equality as a local
hypothesis. A configuration and a law are as in `Becoming.Recurrence`: a determined law `next`
or a process of the spine. Merging, returning and reachability are Recurrence's
(`Law.Merges`, `Law.Returns`, `Law.Reachable`).

* **An attractor and its basin.** A region the law never leaves is absorbing
  (`Law.Absorbing`). A configuration outside it whose course enters it is drawn into it
  (`Law.DrawnInto`); the configurations so drawn are its basin, and a configuration is drawn
  where some absorbing region draws it (`Law.Drawn`). Once in, always in
  (`Law.Absorbing.orbit`). What lies ahead of a configuration from its next step is absorbing
  (`Law.absorbing_ahead`), and a configuration returns exactly where it lies ahead of itself
  (`Law.returns_iff_ahead`).
* **Lock-in.** What is drawn in never comes back: from the step at which its course enters an
  absorbing region it lay outside, no later configuration is the one it started from
  (`Law.DrawnInto.never_back`). A drawn configuration never returns (`Law.Drawn.not_returns`).
* **Every law draws exactly what does not return.** For every determined law, with no premise,
  a configuration is drawn exactly where it does not return (`Law.drawn_iff_not_returns`): what
  lies ahead of it is an absorbing region it enters at the first step (`Law.drawnInto_ahead`).
* **The future narrows.** What can be had `n` steps on is an absorbing region
  (`Law.reachable_absorbing`), and every possibility lost by step `n` is drawn into it,
  entering at step `n` (`Law.lost_drawn`, `Law.drawn_of_lost`). What returns is an absorbing
  region too (`Law.returning_absorbing`).
* **A merge draws one of the two.** Of two configurations a law merges, not both return
  (`Law.Merges.not_both_return`), with no finiteness; so not both escape being drawn
  (`Law.merge_draws`), and a law that merges draws something, in double-negation form
  (`Law.Merges.draws`). Where nothing is drawn, no two configurations merge
  (`Law.none_drawn_merges_nothing`; with decidable equality, `Law.none_drawn_lossless`).
* **Within finitely many configurations, attraction is merging.** Where a list holds every
  configuration: a drawn configuration means the law merges (`Law.Drawn.not_lossless`,
  `Law.Lossless.not_drawn`) and loses a possibility (`Law.Drawn.not_keeps`); with decidable
  equality the law merges nothing exactly where nothing is drawn
  (`Law.lossless_iff_none_drawn`). A configuration returns exactly where it can be had at every
  step (`Law.returns_iff_always_reachable`), so it is drawn exactly where it is lost at some
  step (`Law.drawn_iff_lost`). Every course enters what returns (`Law.enters_returning`), so
  every configuration that does not return is drawn into the absorbing region of what returns
  (`Law.drawnInto_returning`): the attractor of a law on finitely many configurations is what
  returns, and its basin is everything else.
* **An open world draws without merging.** Counting on draws zero and merges nothing
  (`Law.succ_drawn_lossless`); counting down draws one and keeps every possibility
  (`Law.pred_drawn_keeps`). So every law of the previous bullet needs its list.
* **Lock-in under every process.** A determined law's absorbing regions are the invariants of
  its process (`Law.absorbing_iff_invariant`). Once inside an invariant region, what lies
  outside cannot be had again (`Invariant.locks_out`); along a run, from a step inside it, no
  later configuration is one outside it (`Run.locked_in`). A region is invariant exactly where
  every move keeps it (`AbsorbingUnder`, `invariant_iff_every_move`): a run whose every move
  keeps it stays in it (`Run.stays`), and leaving it needs a move that does not keep it
  (`Run.leaving_needs`).
* **Witnesses.** In `Ratchet` every configuration goes to `true`: the law merges `false` and
  `true`, `false` is drawn into `{true}` and never returns, `true` returns. In `Exit`, `{true}`
  is absorbing under one move and not under the other, so not invariant; the run that only
  keeps stays locked in, and the run that leaves takes the other move.

**Readings (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D25).**
- An attractor is an absorbing region that a configuration outside it enters; its basin is
  what is drawn into it. Path dependence and lock-in are one law: what is drawn in never comes
  back, so where the course has gone decides what it can be again.
- Within finitely many configurations attraction and merging go together (classically an iff):
  something is drawn exactly where distinct configurations come to one, which is where a
  possibility is lost for good (`Law.Merges.loses`). An open world can draw without merging, by
  counting on.
- The future narrows: what can be had at step `n` is absorbing, and every possibility lost has
  been drawn into it. Read with Ren's "more future, not less" (`Becoming.Admission`), an
  attractor is the unfolding narrowing its own future.
- Capture's held rule (P62, `Captured`) reads as an absorbing region in the rule: the
  configurations with a given rule form a region the law never leaves, and within it a
  perturbed state is drawn into the configuration the rule holds, at the first step.
- The meta-attractor of winning read as an absorbing region of the course, out of which only a
  move that does not keep the region leads, is the AI's reading, not derived here.

What is not derived: which regions actual unfoldings enter; how deep or wide a basin is (no
measure on configurations occurs); and anything about escape beyond the representation: a move
or exchange from beyond is not represented in a determined law, and under a process only the
moves it admits occur. Which of two merged configurations is drawn needs deciding; only the
double-negation form is stated.

No ethical predicate, ranking or axiom occurs.
* **Entering within the count, and basins.** Within `m` listed configurations every course enters
  what returns before step `m` (`Law.enters_returning_within`). The courses of two configurations
  meeting is an equivalence under any determined law (`Law.Meet`, `Law.Meet.trans`): a course
  reaches every returning configuration of its basin (`Law.Meet.reaches_returning`), so within
  finitely many configurations each basin holds one cycle (`Law.basin_one_cycle`).
-/

namespace Becoming

open Generative

universe u v

namespace Law

variable {S : Type u}

/-! ## An attractor and its basin -/

/-- `R` is absorbing under `next`: a region the law never leaves. -/
def Absorbing (next : S → S) (R : S → Prop) : Prop := ∀ s, R s → R (next s)

/-- `s` is drawn into `R`: it lies outside `R` and its course enters `R`. Where `R` is
absorbing, the configurations drawn into it are its basin. -/
def DrawnInto (next : S → S) (R : S → Prop) (s : S) : Prop :=
  ¬ R s ∧ ∃ n, R (orbit next s n)

/-- `s` is drawn: some absorbing region draws it in, so `s` lies in the basin of an
attractor. -/
def Drawn (next : S → S) (s : S) : Prop :=
  ∃ R : S → Prop, Absorbing next R ∧ DrawnInto next R s

/-- What lies ahead of `s` on its course, from the next step on. -/
def Ahead (next : S → S) (s : S) : S → Prop := fun z => ∃ k, orbit next (next s) k = z

/-- **What lies ahead is absorbing.** -/
theorem absorbing_ahead (next : S → S) (s : S) : Absorbing next (Ahead next s) :=
  fun _ ⟨k, to⟩ => ⟨k + 1, congrArg next to⟩

/-- **Once in, always in.** Where `R` is absorbing and the course of `s` is in `R` at step `n`,
it is in `R` at every later step. -/
theorem Absorbing.orbit {next : S → S} {R : S → Prop} (absorbing : Absorbing next R) {s : S}
    {n : Nat} (enters : R (Law.orbit next s n)) : ∀ k, R (Law.orbit next s (n + k))
  | 0 => enters
  | k + 1 => absorbing _ (Absorbing.orbit absorbing enters k)

/-- **A configuration returns exactly where it lies ahead of itself.** -/
theorem returns_iff_ahead {next : S → S} {s : S} : Returns next s ↔ Ahead next s s :=
  ⟨fun returns => returns.undo,
    fun ⟨k, back⟩ => returns_iff.mpr ⟨k + 1, Nat.succ_pos k, (orbit_shift next s k).trans back⟩⟩

/-! ## Lock-in -/

/-- **What is drawn in never comes back.** Where `R` is absorbing and `s` lies outside it, from
the step at which the course of `s` enters `R`, no later configuration is `s`. -/
theorem DrawnInto.never_back {next : S → S} {R : S → Prop} (absorbing : Absorbing next R)
    {s : S} (outside : ¬ R s) {n : Nat} (enters : R (orbit next s n)) :
    ∀ k, orbit next s (n + k) ≠ s :=
  fun k back => outside (Eq.subst (motive := R) back (absorbing.orbit enters k))

/-- **A drawn configuration never returns.** -/
theorem Drawn.not_returns {next : S → S} {s : S} (drawn : Drawn next s) : ¬ Returns next s :=
  fun returns => match drawn, returns_iff.mp returns with
  | _, ⟨0, pos, _⟩ => absurd pos (Nat.lt_irrefl 0)
  | ⟨_, absorbing, outside, n, enters⟩, ⟨p + 1, _, back⟩ =>
    DrawnInto.never_back absorbing outside enters (p * n)
      ((congrArg (orbit next s) ((Nat.add_comm n (p * n)).trans (Nat.succ_mul p n).symm)).trans
        (orbit_mul back n))

/-! ## Every law draws exactly what does not return -/

/-- **What does not return is drawn into what lies ahead of it**, entering at the first
step. -/
theorem drawnInto_ahead {next : S → S} {s : S} (never : ¬ Returns next s) :
    DrawnInto next (Ahead next s) s :=
  ⟨fun ahead => never (returns_iff_ahead.mpr ahead), 1, 0, rfl⟩

/-- **Every law draws exactly what does not return.** For every determined law, with no
premise, a configuration is drawn into some absorbing region exactly where it does not
return. -/
theorem drawn_iff_not_returns {next : S → S} {s : S} : Drawn next s ↔ ¬ Returns next s :=
  ⟨Drawn.not_returns, fun never => ⟨Ahead next s, absorbing_ahead next s, drawnInto_ahead never⟩⟩

/-! ## The future narrows -/

/-- **What can be had `n` steps on is absorbing.** -/
theorem reachable_absorbing (next : S → S) (n : Nat) : Absorbing next (Reachable next n) :=
  fun _ reach => let ⟨x, to⟩ := reachable_iff.mp reach
    reachable_iff.mpr ⟨next x, (orbit_shift next x n).symm.trans (congrArg next to)⟩

/-- Every course is, at step `n`, something that can be had at step `n`. -/
theorem reachable_orbit (next : S → S) (s : S) (n : Nat) : Reachable next n (orbit next s n) :=
  reachable_iff.mpr ⟨s, rfl⟩

/-- **A lost possibility is drawn in.** A configuration that cannot be had `n` steps on is
drawn into what can be had `n` steps on, entering at step `n`. -/
theorem lost_drawn {next : S → S} {n : Nat} {s : S} (lost : ¬ Reachable next n s) :
    DrawnInto next (Reachable next n) s :=
  ⟨lost, n, reachable_orbit next s n⟩

/-- A configuration lost at some step is drawn. -/
theorem drawn_of_lost {next : S → S} {n : Nat} {s : S} (lost : ¬ Reachable next n s) :
    Drawn next s :=
  ⟨Reachable next n, reachable_absorbing next n, lost_drawn lost⟩

/-- **What returns is absorbing.** -/
theorem returning_absorbing (next : S → S) : Absorbing next (Returns next) :=
  fun s returns => let ⟨p, pos, back⟩ := returns_iff.mp returns
    returns_iff.mpr ⟨p, pos, (orbit_shift next s p).symm.trans (congrArg next back)⟩

/-! ## A merge draws one of the two -/

/-- Two periods meet: `a + (a + 1) * b` and `b + (b + 1) * a` are one number. -/
theorem periods_meet (a b : Nat) : a + (a + 1) * b = b + (b + 1) * a :=
  calc a + (a + 1) * b = a + (a * b + b) := congrArg (a + ·) (Nat.succ_mul a b)
    _ = a * b + (a + b) := Nat.add_left_comm a (a * b) b
    _ = b * a + (b + a) :=
        (congrArg (· + (a + b)) (Nat.mul_comm a b)).trans (congrArg (b * a + ·) (Nat.add_comm a b))
    _ = b + (b * a + a) := (Nat.add_left_comm b (b * a) a).symm
    _ = b + (b + 1) * a := congrArg (b + ·) (Nat.succ_mul b a).symm

/-- **Of two configurations merged, not both return**, with no finiteness. Where `x` returns
after `a + 1` steps and `y` after `b + 1`, both lie on the course from their common next
configuration, which is at `x` and at `y` at one step. -/
theorem Merges.not_both_return {next : S → S} {x y : S} (apart : x ≠ y)
    (merged : next x = next y) : ¬ (Returns next x ∧ Returns next y) :=
  fun ⟨returns_x, returns_y⟩ => match returns_iff.mp returns_x, returns_iff.mp returns_y with
  | ⟨0, pos, _⟩, _ => absurd pos (Nat.lt_irrefl 0)
  | _, ⟨0, pos, _⟩ => absurd pos (Nat.lt_irrefl 0)
  | ⟨a + 1, _, back_x⟩, ⟨b + 1, _, back_y⟩ =>
    have from_x : orbit next (next x) a = x := (orbit_shift next x a).symm.trans back_x
    have from_y : orbit next (next x) b = y :=
      (congrArg (fun z => orbit next z b) merged).trans ((orbit_shift next y b).symm.trans back_y)
    apart (calc x = orbit next x ((a + 1) * b) := (orbit_mul back_x b).symm
      _ = orbit next (orbit next (next x) a) ((a + 1) * b) :=
          congrArg (fun z => orbit next z ((a + 1) * b)) from_x.symm
      _ = orbit next (next x) (a + (a + 1) * b) := (orbit_add next (next x) a ((a + 1) * b)).symm
      _ = orbit next (next x) (b + (b + 1) * a) := congrArg (orbit next (next x)) (periods_meet a b)
      _ = orbit next (orbit next (next x) b) ((b + 1) * a) :=
          orbit_add next (next x) b ((b + 1) * a)
      _ = orbit next y ((b + 1) * a) := congrArg (fun z => orbit next z ((b + 1) * a)) from_y
      _ = y := orbit_mul back_y a)

/-- **A merge draws one of the two.** Of two configurations a law merges, not both escape being
drawn. Which of them is drawn needs deciding, so only this double-negation form is stated. -/
theorem merge_draws {next : S → S} {x y : S} (apart : x ≠ y) (merged : next x = next y) :
    ¬ (¬ Drawn next x ∧ ¬ Drawn next y) :=
  fun ⟨free_x, free_y⟩ =>
    free_x (drawn_iff_not_returns.mpr fun returns_x =>
      free_y (drawn_iff_not_returns.mpr fun returns_y =>
        Merges.not_both_return apart merged ⟨returns_x, returns_y⟩))

/-- A law that merges draws something, in double-negation form. -/
theorem Merges.draws {next : S → S} (merges : Merges next) : ¬ ¬ ∃ s, Drawn next s :=
  fun undrawn => match merges_iff.mp merges with
  | ⟨x, y, apart, merged⟩ =>
    merge_draws apart merged ⟨fun drawn => undrawn ⟨x, drawn⟩, fun drawn => undrawn ⟨y, drawn⟩⟩

/-- **Where nothing is drawn, nothing merges**, in double-negation form: two configurations
the law takes to one are not apart. -/
theorem none_drawn_merges_nothing {next : S → S} (undrawn : ∀ s, ¬ Drawn next s) :
    ∀ x y, next x = next y → ¬ x ≠ y :=
  fun x y merged apart => merge_draws apart merged ⟨undrawn x, undrawn y⟩

/-- Where nothing is drawn and equality of configurations is decidable, the law merges
nothing. -/
theorem none_drawn_lossless [DecidableEq S] {next : S → S} (undrawn : ∀ s, ¬ Drawn next s) :
    Lossless next :=
  lossless_iff.mpr fun x y merged => match decEq x y with
  | isTrue same => same
  | isFalse apart => absurd apart (none_drawn_merges_nothing undrawn x y merged)

/-! ## Finitely many configurations -/

/-- **Within finitely many configurations, a drawn configuration means a merge.** -/
theorem Drawn.not_lossless {next : S → S} {s : S} (drawn : Drawn next s) {all : List S}
    (every : ∀ x, x ∈ all) : ¬ Lossless next :=
  fun lossless => drawn.not_returns (lossless.returns every s)

/-- Within finitely many configurations, a law that merges nothing draws nothing. -/
theorem Lossless.not_drawn {next : S → S} (lossless : Lossless next) {all : List S}
    (every : ∀ x, x ∈ all) (s : S) : ¬ Drawn next s :=
  fun drawn => drawn.not_lossless every lossless

/-- Within finitely many configurations, a drawn configuration means a lost possibility. -/
theorem Drawn.not_keeps {next : S → S} {s : S} (drawn : Drawn next s) {all : List S}
    (every : ∀ x, x ∈ all) : ¬ KeepsPossibilities next :=
  fun keeps => drawn.not_returns ((returns_iff_keeps every).mpr keeps s)

/-- **Within finitely many configurations, attraction is merging.** Where a list holds every
configuration and equality of configurations is decidable, the law merges nothing exactly where
nothing is drawn. -/
theorem lossless_iff_none_drawn [DecidableEq S] {next : S → S} {all : List S}
    (every : ∀ x, x ∈ all) : Lossless next ↔ ∀ s, ¬ Drawn next s :=
  ⟨fun lossless => lossless.not_drawn every, none_drawn_lossless⟩

/-- **Within finitely many configurations, returning is being had at every step.** -/
theorem returns_iff_always_reachable {next : S → S} {all : List S} (every : ∀ x, x ∈ all)
    {s : S} : Returns next s ↔ ∀ n, Reachable next n s :=
  ⟨fun returns => returns.reachable, fun always => returns_of_reachable every (always all.length)⟩

/-- **Within finitely many configurations, what is drawn is what is lost.** A configuration is
drawn exactly where it cannot be had at every step. From right to left no finiteness is
needed. -/
theorem drawn_iff_lost {next : S → S} {all : List S} (every : ∀ x, x ∈ all) {s : S} :
    Drawn next s ↔ ¬ ∀ n, Reachable next n s :=
  ⟨fun drawn always => drawn.not_returns ((returns_iff_always_reachable every).mpr always),
    fun lost => drawn_iff_not_returns.mpr fun returns => lost returns.reachable⟩

/-- **Within finitely many configurations, every course enters what returns, before as many
steps as there are configurations.** With `m` configurations listed, the course is at a returning
configuration at some step below `m`. -/
theorem enters_returning_within {next : S → S} {all : List S} (every : ∀ x, x ∈ all) (s : S) :
    ∃ n, n < all.length ∧ Returns next (orbit next s n) :=
  let ⟨i, _, lt, le, same⟩ := revisits_within all (orbit next s) (fun _ _ => every _)
  let ⟨d, gap⟩ := gap_of_lt lt
  ⟨i, Nat.lt_of_lt_of_le lt le, returns_iff.mpr ⟨d + 1, Nat.succ_pos d,
    (orbit_add next s i (d + 1)).symm.trans ((congrArg (orbit next s) gap.symm).trans same.symm)⟩⟩

/-- **Within finitely many configurations, every course enters what returns.** -/
theorem enters_returning {next : S → S} {all : List S} (every : ∀ x, x ∈ all) (s : S) :
    ∃ n, Returns next (orbit next s n) :=
  match enters_returning_within every s with
  | ⟨n, _, returns⟩ => ⟨n, returns⟩

/-- **Within finitely many configurations, what returns is the attractor.** Every
configuration that does not return is drawn into the absorbing region of what returns. -/
theorem drawnInto_returning {next : S → S} {all : List S} (every : ∀ x, x ∈ all) {s : S}
    (never : ¬ Returns next s) : DrawnInto next (Returns next) s :=
  ⟨never, enters_returning every s⟩

/-! ## Where courses meet: basins -/

/-- The courses of `x` and `y` *meet*: at some steps they are at one configuration. -/
def Meet (next : S → S) (x y : S) : Prop :=
  ∃ n m, orbit next x n = orbit next y m

theorem Meet.refl (next : S → S) (x : S) : Meet next x x := ⟨0, 0, rfl⟩

theorem Meet.symm {next : S → S} {x y : S} : Meet next x y → Meet next y x
  | ⟨n, m, same⟩ => ⟨m, n, same.symm⟩

/-- After meeting, two courses run together. -/
theorem Meet.later {next : S → S} {x y : S} {n m : Nat} (meet : orbit next x n = orbit next y m) :
    ∀ j, orbit next x (n + j) = orbit next y (m + j) :=
  fun j => (orbit_add next x n j).trans
    ((congrArg (fun z => orbit next z j) meet).trans (orbit_add next y m j).symm)

/-- **Meeting is an equivalence**, under any determined law and with no finiteness: the basins
where courses come together partition the configurations. -/
theorem Meet.trans {next : S → S} {x y z : S} : Meet next x y → Meet next y z → Meet next x z
  | ⟨n, m, first⟩, ⟨m', k, second⟩ => match Nat.le_total m m' with
    | .inl le => match le_dest le with
      | ⟨j, same⟩ => ⟨n + j, k, (Meet.later first j).trans
          ((congrArg (orbit next y) same.symm).trans second)⟩
    | .inr le => match le_dest le with
      | ⟨j, same⟩ => ⟨n, k + j, first.trans ((congrArg (orbit next y) same).trans
          (Meet.later second j))⟩

/-- **A course reaches every returning configuration of its basin.** Where the courses of `x` and
`b` meet and `b` returns, the course of `x` is at `b` at some step. -/
theorem Meet.reaches_returning {next : S → S} {x b : S} (meet : Meet next x b)
    (returns : Returns next b) : ∃ j, orbit next x j = b :=
  match meet, returns_iff.mp returns with
  | _, ⟨0, pos, _⟩ => absurd pos (Nat.lt_irrefl 0)
  | ⟨n, m, same⟩, ⟨q + 1, _, back⟩ => ⟨n + q * m, (Meet.later same (q * m)).trans
      ((congrArg (orbit next b) ((Nat.add_comm m (q * m)).trans (Nat.succ_mul q m).symm)).trans
        (orbit_mul back m))⟩

/-- **Within finitely many configurations, every basin holds one cycle.** Every course enters a
returning configuration, and every two returning configurations of one basin reach each other:
all ways come to one return. -/
theorem basin_one_cycle {next : S → S} {all : List S} (every : ∀ x, x ∈ all) (x : S) :
    (∃ n, Returns next (orbit next x n)) ∧
      ∀ a b, Meet next x a → Meet next x b → Returns next a → Returns next b →
        ∃ j, orbit next a j = b :=
  ⟨enters_returning every x,
   fun _ _ ma mb _ rb => (ma.symm.trans mb).reaches_returning rb⟩

/-! ## An open world draws without merging -/

/-- **Counting on draws without merging.** Under `Nat.succ` zero is drawn and nothing
merges. -/
theorem succ_drawn_lossless : Drawn Nat.succ 0 ∧ Lossless Nat.succ :=
  ⟨drawn_iff_not_returns.mpr (succ_open.2.1 0), succ_open.1⟩

/-- Counting down from zero stays at zero. -/
theorem pred_orbit_zero : ∀ k, orbit Nat.pred 0 k = 0
  | 0 => rfl
  | k + 1 => congrArg Nat.pred (pred_orbit_zero k)

/-- **Counting down draws while keeping every possibility.** Under `Nat.pred` one is drawn,
yet every number can be had at every step. -/
theorem pred_drawn_keeps : Drawn Nat.pred 1 ∧ KeepsPossibilities Nat.pred :=
  ⟨drawn_iff_not_returns.mpr fun returns => match returns_iff.mp returns with
    | ⟨0, pos, _⟩ => absurd pos (Nat.lt_irrefl 0)
    | ⟨k + 1, _, back⟩ =>
      Nat.noConfusion ((pred_orbit_zero k).symm.trans ((orbit_shift Nat.pred 1 k).symm.trans back)),
    pred_open.2⟩

end Law

/-! ## Lock-in under every process -/

section Processes

variable {S : Type u} {A : Type v} {P : Process S A}

/-- **A determined law's absorbing regions are the invariants of its process.** -/
theorem Law.absorbing_iff_invariant {next : S → S} {R : S → Prop} :
    Law.Absorbing next R ↔ Invariant (Law.process next) R :=
  ⟨fun absorbing s _ _ step inside => Eq.subst (motive := R) step.symm (absorbing s inside),
    fun invariant s inside => invariant s () (next s) rfl inside⟩

/-- `R` is absorbing under the move `a`: every step by `a` from inside `R` stays inside. -/
def AbsorbingUnder (P : Process S A) (R : S → Prop) (a : A) : Prop :=
  ∀ s t, R s → P.step s a t → R t

/-- **Lock-in is a region every move keeps.** A region is invariant exactly where it is
absorbing under every move. -/
theorem invariant_iff_every_move {R : S → Prop} : Invariant P R ↔ ∀ a, AbsorbingUnder P R a :=
  ⟨fun invariant a s t inside step => invariant s a t step inside,
    fun every s a t step inside => every a s t inside step⟩

/-- **Once inside an invariant region, what lies outside cannot be had again.** -/
theorem Invariant.locks_out {R : S → Prop} (invariant : Invariant P R) {t s : S}
    (inside : R t) (outside : ¬ R s) : ¬ Reach P t s :=
  fun reach => outside (invariant.reach reach inside)

/-- **Locked in along a run.** From a step at which the run is inside an invariant region, no
later configuration is one at which it was outside. -/
theorem Run.locked_in (r : Run P) {R : S → Prop} (invariant : Invariant P R) {n m : Nat}
    (inside : R (r.state n)) (outside : ¬ R (r.state m)) : ∀ k, r.state (n + k) ≠ r.state m :=
  fun k same => outside (Eq.subst (motive := R) same (invariant.reach (r.reach n k) inside))

/-- **A run whose every move keeps a region stays in it.** -/
theorem Run.stays (r : Run P) {R : S → Prop} {n : Nat}
    (keeps : ∀ k, AbsorbingUnder P R (r.act (n + k))) (inside : R (r.state n)) :
    ∀ k, R (r.state (n + k))
  | 0 => inside
  | k + 1 => keeps k _ _ (Run.stays r keeps inside k) (r.step (n + k))

/-- **Leaving needs a move that does not keep the region.** -/
theorem Run.leaving_needs (r : Run P) {R : S → Prop} {n : Nat} (inside : R (r.state n))
    (leaves : ¬ R (r.state (n + 1))) : ¬ AbsorbingUnder P R (r.act n) :=
  fun keeps => leaves (keeps _ _ inside (r.step n))

end Processes

/-! ## A ratchet

Every configuration goes to `true`. -/

namespace Ratchet

/-- Every configuration goes to `true`. -/
def next (_ : Bool) : Bool := true

/-- The region `{true}`. -/
def atTrue (s : Bool) : Prop := s = true

/-- The law merges `false` and `true`. -/
theorem merges : Law.Merges next := Law.merges_iff.mpr ⟨false, true, fun same => Bool.noConfusion same, rfl⟩

/-- `{true}` is absorbing. -/
theorem absorbing : Law.Absorbing next atTrue := fun _ _ => rfl

/-- `false` is drawn into `{true}`, entering at the first step. -/
theorem false_drawn : Law.DrawnInto next atTrue false :=
  ⟨fun same => Bool.noConfusion same, 1, rfl⟩

/-- **`false` never returns.** -/
theorem false_never_returns : ¬ Law.Returns next false :=
  Law.Drawn.not_returns ⟨atTrue, absorbing, false_drawn⟩

/-- `true` returns at once. -/
theorem true_returns : Law.Returns next true := Law.returns_iff.mpr ⟨1, Nat.succ_pos 0, rfl⟩

/-- `true` is not drawn. -/
theorem true_not_drawn : ¬ Law.Drawn next true :=
  fun drawn => drawn.not_returns true_returns

/-- `false` cannot be had one step on. -/
theorem false_lost : ¬ Law.Reachable next 1 false :=
  fun reach => let ⟨_, to⟩ := Law.reachable_iff.mp reach; Bool.noConfusion to

end Ratchet

/-! ## An exit

A configuration is a bit and a move is a bit: the move `false` keeps the configuration, the
move `true` flips it. -/

namespace Exit

/-- The move `false` keeps the configuration; the move `true` flips it. -/
def move : Bool → Bool → Bool
  | false, s => s
  | true, s => !s

/-- The step by `a` from `s` goes to `move a s`. -/
def process : Process Bool Bool := ⟨fun s a t => t = move a s⟩

/-- The region `{true}`. -/
def atTrue (s : Bool) : Prop := s = true

/-- `{true}` is absorbing under the move `false`. -/
theorem keeps : AbsorbingUnder process atTrue false :=
  fun _ _ inside step => step.trans inside

/-- `{true}` is not absorbing under the move `true`. -/
theorem leaves : ¬ AbsorbingUnder process atTrue true :=
  fun keeps => Bool.noConfusion (keeps true false rfl rfl)

/-- **`{true}` is not invariant.** -/
theorem not_invariant : ¬ Invariant process atTrue :=
  fun invariant => leaves (invariant_iff_every_move.mp invariant true)

/-- The run that moves only `false`, from `true`. -/
def staying : Run process := ⟨fun _ => true, fun _ => false, fun _ => rfl⟩

/-- **The run that only keeps stays locked in**, from every step on. -/
theorem locked_in (n : Nat) : ∀ k, atTrue (staying.state (n + k)) :=
  staying.stays (fun _ => keeps) rfl

/-- The configurations of the run that leaves: `true`, then `false`. -/
def path : Nat → Bool := Witnesses.profile [true] false

/-- The moves of the run that leaves: `true`, then `false`. -/
def moves : Nat → Bool := Witnesses.profile [true] false

/-- The run that leaves `{true}` at the first step. -/
def leaving : Run process :=
  ⟨path, moves, fun n => match n with
    | 0 => rfl
    | _ + 1 => rfl⟩

/-- **Leaving takes the move that does not keep.** The run is in `{true}` at the start and out
of it after one step, and the move it takes there does not keep `{true}`. -/
theorem leaving_takes :
    atTrue (leaving.state 0) ∧ ¬ atTrue (leaving.state 1) ∧
      ¬ AbsorbingUnder process atTrue (leaving.act 0) :=
  ⟨rfl, fun same => Bool.noConfusion same,
    leaving.leaving_needs (n := 0) rfl fun same => Bool.noConfusion same⟩

end Exit

end Becoming
