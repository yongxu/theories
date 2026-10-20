import Becoming.DrawnBeyond
import Becoming.Ranking

/-!
# Joint draw: which dependence breaks when several formations take at once, and restraint over any number of drawers

`Becoming.DrawnBeyond` showed that a rise above the slack breaks some dependence beyond, and left
open which one when several formations take at once. `Becoming.Ranking` proved restraint ranked
above overdraw in the two-part family, and showed with a third formation sharing the condition
that the stepwise reading can lose that ranking (`Ranking.ThirdParty`), while the whole-run reading
keeps it by its law of easing. This module states, for any number of formations taking from a
condition, which dependence the joint draw breaks, how restraint by any of them keeps it, and the
restraint comparison over any number of drawers under the whole-run reading.

* **A dependence breaks exactly where its need with all that is taken exceeds the level with all
  that is given.** In a balanced flow, a dependence met at a step is broken across it exactly when
  the condition's level with what the formations give to it falls short of the need with what
  they take from it (`Flow.Balances.broken_iff`), and kept exactly otherwise
  (`Flow.Balances.kept_iff`). What breaks it is the joint draw: the total over every formation
  taking part, not any one of them.
* **Breaks go by need, whoever takes.** On one condition at one step, a dependence met at a need
  at least as high as one that breaks breaks too (`Web.Broken.of_need_le`), and one at a need no
  higher than one kept is kept (`Web.kept_of_need_le`): the highest needs break first, whichever
  formation takes and whether or not it is itself the one depending.
* **Every break lies where an active formation draws.** Where only active formations take, and
  only from what they draw on, some formation taking part takes from the condition of every
  broken dependence, active and drawing on it (`Flow.Balances.broken_drawn`); with the rise of
  `Becoming.DrawnBeyond` above the slack, the broken dependence beyond is on a condition drawn on
  by an active formation (`Flow.Balances.breaks_beyond_drawn`).
* **A break within each drawer's slack is shared.** Where each formation's own take from the
  condition is within what the level with the givings stands above the need, and the dependence
  breaks, every formation taking part takes strictly less than all that is taken
  (`Flow.Balances.broken_shared`): the break belongs to no one drawer's take.
* **Restraint by the excess, by any drawers, keeps it.** Against a second balanced flow from a
  level as high at the step, taking less by at least the excess of the need with what was taken
  over the level with what was given, and giving no less, the dependence is kept
  (`Flow.Balances.kept_of_restrained`); which formations restrain does not enter.
* **Over a run, restraint eases.** Two balanced flows from levels at least as high at the start,
  the second taking no more from each condition and giving no less at every step, hold every
  condition at least as high at every step (`Flow.Balances.level_le_of_restrained`); with
  dependences and draws no greater, the second course eases the first
  (`Flow.Balances.eases_of_restrained`).
* **The restraint comparison over any number of drawers.** Under the whole-run reading, where
  activity needs support in the overdrawing course and follows support in the restrained one,
  the restrained course extends the overdrawing one exactly when it includes some event the
  other withholds, so that every comparison satisfying C ranks it higher
  (`Ranking.restraint_extends_iff`, `Ranking.restraint_ranks_over_drawers`). No count of
  formations enters. The stepwise reading has no such law (`Ranking.ThirdParty.stepwise_not_monotone`).
* **Witness.** `TwoDrawers`: two formations each take one unit from a condition standing at two,
  on which a third depends at one; each take is within the slack, the joint draw breaks the third
  formation's dependence and it ends (`TwoDrawers.broken`, `TwoDrawers.shared`), and with one
  drawer restrained the dependence is kept (`TwoDrawers.restrained_kept`); under the whole-run
  reading the restrained course is ranked above the joint draw by every comparison satisfying C
  (`TwoDrawers.restraint_ranks`).

**Reading (the AI's).** When several formations take at once, no one of them breaks a dependence:
the joint draw does, and it breaks the highest needs first, whoever takes. Restraint keeps a
dependence by the excess, whoever restrains; over a run, taking no more and giving no less keeps
every level at least as high, and under the whole-run reading this ranks restraint above overdraw
for any number of drawers. That this ranking needs the whole-run reading, and not the stepwise
one, is `Ranking.ThirdParty`: a higher level kept can be undermined later, an event the stepwise
reading counts against the restrained course.

What is not derived: how much each formation takes or gives (the flows are supplied); that the
restrained course takes no more at every step (a hypothesis, not a law of the formations); which
reading of `living` C uses. The representation commits to discrete steps and natural amounts.
No ethical predicate or axiom occurs; C occurs only as a hypothesis.
-/

namespace Becoming

variable {F C : Type}

namespace Web

variable {W : Web F C} {t : Nat} {g h : F} {c : C}

/-- **Breaks go by need.** On one condition at one step, a dependence met at a need at least as
high as one that breaks breaks too. -/
theorem Broken.of_need_le (broken : W.Broken t g c) (depends : W.requires t h c)
    (higher : W.need t g c ≤ W.need t h c) (met : W.need t h c ≤ W.level t c) :
    W.Broken t h c :=
  ⟨depends, met, Nat.lt_of_lt_of_le broken.2.2 higher⟩

/-- A dependence at a need no higher than one met after the step is met after it. -/
theorem kept_of_need_le (kept : W.need t h c ≤ W.level (t + 1) c)
    (lower : W.need t g c ≤ W.need t h c) : W.need t g c ≤ W.level (t + 1) c :=
  Nat.le_trans lower kept

end Web

namespace Flow

variable {L L' : Flow F C} {W W' : Web F C} {t : Nat} {g : F} {c : C}

/-- **A dependence breaks exactly where its need with all that is taken exceeds the level with all
that is given.** -/
theorem Balances.broken_iff (balances : L.Balances W) (depends : W.requires t g c)
    (met : W.need t g c ≤ W.level t c) :
    W.Broken t g c ↔ W.level t c + L.given t c < W.need t g c + L.taken t c :=
  ⟨fun broken => Nat.lt_of_le_of_lt (Nat.le_of_eq (balances t c).symm)
      (Nat.add_lt_add_right broken.2.2 _),
   fun short => ⟨depends, met, Nat.lt_of_add_lt_add_right
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (balances t c)) short)⟩⟩

/-- **Kept exactly otherwise:** the need is met after the step exactly where the need with all that
is taken is within the level with all that is given. -/
theorem Balances.kept_iff (balances : L.Balances W) :
    W.need t g c ≤ W.level (t + 1) c ↔ W.need t g c + L.taken t c ≤ W.level t c + L.given t c :=
  ⟨fun kept => Nat.le_trans (Nat.add_le_add_right kept _) (Nat.le_of_eq (balances t c)),
   fun within => le_of_add_le_add_right (L.taken t c)
      (Nat.le_trans within (Nat.le_of_eq (balances t c).symm))⟩

/-- **Every break lies where an active formation draws.** -/
theorem Balances.broken_drawn (balances : L.Balances W) (taking : L.Taking W)
    (broken : W.Broken t g c) :
    ∃ f, f ∈ L.present t ∧ 0 < L.take t f c ∧ W.active t f ∧ W.draws t f c :=
  balances.takenBy taking (Nat.lt_of_lt_of_le broken.2.2 broken.2.1)

/-- With the rise above the slack of `Becoming.DrawnBeyond`, the broken dependence beyond is on a
condition an active formation taking part draws on. -/
theorem Balances.breaks_beyond_drawn {dep : C → F} {ds rest : List C} (balances : L.Balances W)
    (taking : L.Taking W) (gainless : L.GainlessOn (ds ++ rest) t) (met : W.MetOn dep rest t)
    (exceeds : W.stock ds t + W.slack dep rest t < W.stock ds (t + 1) + L.lost (ds ++ rest) t) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c ∧
      ∃ f, f ∈ L.present t ∧ 0 < L.take t f c ∧ W.active t f ∧ W.draws t f c :=
  match balances.breaks_beyond gainless met exceeds with
  | ⟨c, mem, broken⟩ => ⟨c, mem, broken, balances.broken_drawn taking broken⟩

/-- **A break within each drawer's slack is shared.** Where each formation's own take is within
what the level with the givings stands above the need, and the dependence breaks, every formation
taking part takes strictly less than all that is taken. -/
theorem Balances.broken_shared (balances : L.Balances W) (broken : W.Broken t g c)
    (within : ∀ f, f ∈ L.present t → L.take t f c + W.need t g c ≤ W.level t c + L.given t c) :
    ∀ f, f ∈ L.present t → L.take t f c < L.taken t c :=
  fun f mem => Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt (within f mem)
    (Nat.lt_of_lt_of_le ((balances.broken_iff broken.1 broken.2.1).mp broken)
      (Nat.le_of_eq (Nat.add_comm _ _))))

/-- **Restraint by the excess, by any drawers, keeps it.** Where a balanced flow, from a level as
high at the step as another's, takes less than the other by at least the excess of the need with
what the other takes over the level with what it gives, and gives no less, the need is met after
the step. -/
theorem Balances.kept_of_restrained (balances' : L'.Balances W')
    {n e : Nat} (higher : W.level t c ≤ W'.level t c)
    (restrained : L'.taken t c + e ≤ L.taken t c) (renewing : L.given t c ≤ L'.given t c)
    (excess : n + L.taken t c ≤ W.level t c + L.given t c + e) :
    n ≤ W'.level (t + 1) c :=
  le_of_add_le_add_right (L'.taken t c) (le_of_add_le_add_right e
    (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc _ _ _))
      (Nat.le_trans (Nat.add_le_add_left restrained n)
        (Nat.le_trans excess (Nat.le_trans
          (Nat.add_le_add_right (Nat.add_le_add higher renewing) e)
          (Nat.le_of_eq (congrArg (· + e) (balances' t c).symm)))))))

/-- One step of restraint: from a level as high, taking no more and giving no less keeps the level
as high after the step. -/
theorem Balances.level_succ_le (balances : L.Balances W) (balances' : L'.Balances W')
    (higher : W.level t c ≤ W'.level t c) (restrained : L'.taken t c ≤ L.taken t c)
    (renewing : L.given t c ≤ L'.given t c) : W.level (t + 1) c ≤ W'.level (t + 1) c :=
  balances'.kept_of_restrained (e := 0) higher restrained renewing
    (Nat.le_of_eq (balances t c))

/-- **Over a run, restraint holds every condition at least as high.** -/
theorem Balances.level_le_of_restrained (balances : L.Balances W) (balances' : L'.Balances W')
    (start : ∀ c, W.level 0 c ≤ W'.level 0 c)
    (restrained : ∀ t c, L'.taken t c ≤ L.taken t c)
    (renewing : ∀ t c, L.given t c ≤ L'.given t c) : ∀ t c, W.level t c ≤ W'.level t c
  | 0, c => start c
  | t + 1, c => balances.level_succ_le balances'
      (balances.level_le_of_restrained balances' start restrained renewing t c)
      (restrained t c) (renewing t c)

/-- **Restraint eases.** With dependences, needs and draws no greater, the restrained course eases
the other. -/
theorem Balances.eases_of_restrained (balances : L.Balances W) (balances' : L'.Balances W')
    (start : ∀ c, W.level 0 c ≤ W'.level 0 c)
    (restrained : ∀ t c, L'.taken t c ≤ L.taken t c)
    (renewing : ∀ t c, L.given t c ≤ L'.given t c)
    (asks : ∀ t f c, W'.requires t f c → W.requires t f c)
    (needs : ∀ t f c, W'.need t f c ≤ W.need t f c)
    (drawsLess : ∀ t f c, W'.draws t f c → W.draws t f c) : Ranking.Eases W W' :=
  ⟨asks, needs, balances.level_le_of_restrained balances' start restrained renewing, drawsLess⟩

end Flow

namespace Ranking

variable {X : Type} {U : X → Web F C} {L L' : Flow F C} {w w' : X}

/-- **The restraint comparison over any number of drawers.** Under the whole-run reading, where the
restrained course's flow takes no more and gives no less at every step from levels as high, asks
no more and draws on nothing more, activity needs support in the other course and follows support
in it, the restrained course extends the other exactly when it includes some event the other
withholds. -/
theorem restraint_extends_iff (balances : L.Balances (U w)) (balances' : L'.Balances (U w'))
    (start : ∀ c, (U w).level 0 c ≤ (U w').level 0 c)
    (restrained : ∀ t c, L'.taken t c ≤ L.taken t c)
    (renewing : ∀ t c, L.given t c ≤ L'.given t c)
    (asks : ∀ t f c, (U w').requires t f c → (U w).requires t f c)
    (needs : ∀ t f c, (U w').need t f c ≤ (U w).need t f c)
    (drawsLess : ∀ t f c, (U w').draws t f c → (U w).draws t f c)
    (dependent : (U w).Dependent) (gated : ActiveWhereSupported (U w')) :
    ExtendsUnder (wholeRun U) w w' ↔ ∃ e, wholeRun U w' e ∧ ¬ wholeRun U w e :=
  wholeRun_extends_iff_of_eases dependent gated
    (balances.eases_of_restrained balances' start restrained renewing asks needs drawsLess)

/-- Every comparison satisfying C under the whole-run reading then ranks the restrained course
higher, for any number of drawers, as soon as it includes one event the other withholds. -/
theorem restraint_ranks_over_drawers (balances : L.Balances (U w)) (balances' : L'.Balances (U w'))
    (start : ∀ c, (U w).level 0 c ≤ (U w').level 0 c)
    (restrained : ∀ t c, L'.taken t c ≤ L.taken t c)
    (renewing : ∀ t c, L.given t c ≤ L'.given t c)
    (asks : ∀ t f c, (U w').requires t f c → (U w).requires t f c)
    (needs : ∀ t f c, (U w').need t f c ≤ (U w).need t f c)
    (drawsLess : ∀ t f c, (U w').draws t f c → (U w).draws t f c)
    (dependent : (U w).Dependent) (gated : ActiveWhereSupported (U w'))
    {e : F × Nat} (included : wholeRun U w' e) (withheld : ¬ wholeRun U w e)
    {Better : X → X → Prop} (ranks : ComparisonUnder (wholeRun U) Better) : Better w w' :=
  ranks _ _ ((restraint_extends_iff balances balances' start restrained renewing asks needs
    drawsLess dependent gated).mpr ⟨e, included, withheld⟩)

end Ranking

/-! ## Two drawers -/

namespace TwoDrawers

/-- Two drawers, and a third formation depending on the condition they draw from. -/
inductive Formation where
  | first
  | second
  | held

/-- Both draw, or the second is restrained. -/
inductive Draw where
  | joint
  | restrained

/-- At the first step each drawer takes one unit; restrained, the second takes nothing. -/
def take : Draw → Nat → Formation → Unit → Nat
  | _, 0, .first, _ => 1
  | .joint, 0, .second, _ => 1
  | .restrained, 0, .second, _ => 0
  | _, 0, .held, _ => 0
  | _, _ + 1, _, _ => 0

def flow (d : Draw) : Flow Formation Unit where
  present _ := [.first, .second, .held]
  take := take d
  give _ _ _ := 0

/-- From two, the joint draw leaves nothing; the restrained draw leaves one. -/
def level : Draw → Nat → Nat
  | _, 0 => 2
  | .joint, _ + 1 => 0
  | .restrained, _ + 1 => 1

/-- The drawers are always active and draw; the third formation needs one and is active where
supported. -/
def web (d : Draw) : Web Formation Unit where
  level t _ := level d t
  active t f := match f with
    | .first => True
    | .second => True
    | .held => 1 ≤ level d t
  requires _ f _ := match f with
    | .first => False
    | .second => False
    | .held => True
  need _ f _ := match f with
    | .first => 0
    | .second => 0
    | .held => 1
  draws _ f _ := match f with
    | .first => True
    | .second => True
    | .held => False

theorem balances : ∀ d, (flow d).Balances (web d)
  | .joint, 0, _ => rfl
  | .restrained, 0, _ => rfl
  | .joint, _ + 1, _ => rfl
  | .restrained, _ + 1, _ => rfl

/-- The joint draw breaks the third formation's dependence, and it ends. -/
theorem broken : (web .joint).Broken 0 .held () ∧ ¬ (web .joint).active 1 .held :=
  ⟨⟨trivial, Nat.le_succ 1, Nat.zero_lt_one⟩, Nat.not_succ_le_zero 0⟩

/-- Each drawer's take is within the slack, and each takes less than all that is taken. -/
theorem shared :
    (∀ f, f ∈ (flow .joint).present 0 →
      (flow .joint).take 0 f () + (web .joint).need 0 .held () ≤
        (web .joint).level 0 () + (flow .joint).given 0 ()) ∧
    ∀ f, f ∈ (flow .joint).present 0 → (flow .joint).take 0 f () < (flow .joint).taken 0 () :=
  have within : ∀ f, f ∈ (flow .joint).present 0 →
      (flow .joint).take 0 f () + (web .joint).need 0 .held () ≤
        (web .joint).level 0 () + (flow .joint).given 0 () :=
    fun f _ => match f with
      | .first => Nat.le_refl 2
      | .second => Nat.le_refl 2
      | .held => Nat.le_succ 1
  ⟨within, (balances .joint).broken_shared broken.1 within⟩

/-- With the second drawer restrained, the dependence is kept. -/
theorem restrained_kept : (web .restrained).Kept 0 .held () :=
  ⟨Nat.le_succ 1, Nat.le_refl 1⟩

theorem dependent : (web .joint).Dependent :=
  fun _ f active _ depends => match f, active, depends with
  | .held, active, _ => active

theorem gated : Ranking.ActiveWhereSupported (web .restrained) :=
  fun _ f supported => match f with
  | .first => trivial
  | .second => trivial
  | .held => supported () trivial

theorem start : ∀ c, (web .joint).level 0 c ≤ (web .restrained).level 0 c :=
  fun _ => Nat.le_refl 2

theorem restrained_less : ∀ t c, (flow .restrained).taken t c ≤ (flow .joint).taken t c
  | 0, _ => Nat.le_succ 1
  | _ + 1, _ => Nat.le_refl 0

/-- **Under the whole-run reading every comparison satisfying C ranks the restrained course above
the joint draw.** -/
theorem restraint_ranks {Better : Draw → Draw → Prop}
    (ranks : Ranking.ComparisonUnder (Ranking.wholeRun web) Better) :
    Better .joint .restrained :=
  Ranking.restraint_ranks_over_drawers (L := flow .joint) (L' := flow .restrained)
    (balances .joint) (balances .restrained) start restrained_less
    (fun _ _ => Nat.le_refl 0) (fun _ _ _ asked => asked) (fun _ _ _ => Nat.le_refl _)
    (fun _ _ _ drawn => drawn) dependent gated (e := (.held, 1))
    ⟨Nat.le_refl 1, fun ⟨_, _, drawn, _⟩ => drawn⟩ (fun included => broken.2 included.1) ranks

end TwoDrawers

end Becoming
