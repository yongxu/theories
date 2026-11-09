import Becoming.FlowCenters
import Becoming.PersistingChoices
import Becoming.OwnClass
import Becoming.BeyondCoupling
import Becoming.PremiseWitnesses

/-!
# FromTheDynamics: route (b) joined, what the dynamics give with nothing evaluative supplied

Route (b) of the zero-axiom reading asks how far the continuation condition and an order on courses
form within the represented dynamics, with no evaluative premise supplied. Four pieces read its
inputs off a flow: the standpoints and the relation (`Becoming.FlowCenters`), what persisting shows
of an order (`Becoming.PersistingChoices`), a center's own class (`Becoming.OwnClass`) and what
selection read off continuation cannot reach (`Becoming.BeyondCoupling`). This module states what
they give together, and where it stops.

**Near-definitional by necessity.** With significance a free parameter, no statement reading only
the dynamics entails the condition (`ReadsOnlyDynamics.not_entails`). So, on this reading, route (b)
can only read significance off the flow (own closure along one of its relations, held de se at
standpoints it gives, under a class it gives) and find which fact of the flow the condition then is.
Every law here is an equivalence or a short composition of imported laws, so its content is in those
readings; the steps doing dynamical work are imported (`Flow.exists_reachReturns`,
`GroupEnding.Flow.coupled_generation_childless`, `act_courses_unselected_pool`).

* **(a) The scope joined.** At the formations whose acts return (`Flow.Returning`, the standpoints
  a flow gives, each its own center), along affecting, with each standpoint's line under its least
  class (`«后类»`: itself with everything downstream of it), the class meets 07 §4.6's P2 and P4 at
  every standpoint, and the per-center condition holds exactly where the flow is mutually dependent
  (`Flow.returning_downstream_iff_mutuallyDependent`), given one returning formation. The
  equivalence does not use P2: under `«后类»` a line reaches its whole closure from any member,
  returning or not (`«各后类续无外即一之续无外»`); P2 makes the class admissible on §4.6's path, and
  it is the least class that is (`ReturnsAlong.downstreamClass_regular`). Mutual dependence counts
  taking as well as giving, so it includes mutual drain.
* **(b) The bound at those standpoints.** For any coupling by level, what lies beyond a returning
  standpoint's coupling closure has no significance from it, and the significance is a rival
  (`Flow.returning_beyond_coupling`, `Flow.reachReturns_ownClosure_rival` at `Subtype.val`). Pooled
  over every returning formation of a finite flow with reach decided, nothing lies beyond
  (`Flow.returning_pool_covers`): the bound on selection read off continuation bites only for a pool
  that leaves some returning formation out.
* **(c) C read from what persisting shows.** Where the shown relation with every own-widening met
  added has no cycle, every strict order according with the choices and increasing in its own
  continuation on the pairs met (what persisting is consistent with) ranks one course above another
  exactly where the first reaches the second in that relation
  (`ChoiceOccasions.selfConcerned_above_iff_reach`). An extension
  between listed level paths whose admissions were met together is one such step, so every such
  order ranks it, the met-pair C (`Web.extension_ranked_of_increasingInOwnOn`,
  `Web.extension_reached_of_met`). Where only ending was at stake on the occasions met, that pair
  is a course that does not end above one that ends (`Web.extension_met_keeps_above_ending`), and
  any order putting keeping above ending is already increasing in its own continuation there
  (`ChoiceOccasions.increasingInOwnOn_of_keeping`): under the stake, self-concern on the occasions
  met is a corollary of keeping above ending. Keeping above ending also ranks a keeping course above
  an ending one met with it that it does not widen, which self-concern on the pairs met does not ask.
* **(d) C never ranks the persisting course itself.** Where a line persists, the web's actual
  levels are listed by no finite listing (`Flow.persists_not_listsAdmitted`), so C between listed
  level paths ranks only alternatives not taken.
* **(e) Self-concern everywhere does not follow.** With the choices of `PersistingChoices.Crossed`
  (every course met) and ending read as the empty predicate, so that the realization premise and the
  stake hold vacuously, every premise of `Flow.persisting_consistent_with_selfConcern` holds on a World
  meeting the persistence laws (`Alternating`), and no strict order according with the choices is
  increasing in its own continuation on all pairs (`Alternating.crossed_joined`). The World is a model
  of those laws; nothing about the choices depends on it.
* **A joint witness.** `Alternating`: two formations, each in turn standing and giving the other its
  standing. The two are listed, so the flow is finite; it is balanced and mutually dependent, so every
  formation returns and (a)'s condition holds; a line persists through the two, each member coming to
  stand again and again (`Alternating.recurs`), and every member of every cohort is a returning
  formation, a standpoint; it never overdraws; the actual levels are never listed; a
  chooser offered keeping or ending keeps, and some strict order according with it puts keeping
  above ending and is increasing in its own continuation on the occasion met
  (`Alternating.joined`). The chooser is supplied: it is tied to the flow only by the realization
  premise, which survivorship makes vacuous for what is chosen.

**Which center.** No theorem here identifies the centers of the four pieces: (a) and (b) speak of
the formations whose acts return, along affecting; (c) and (d) of a chooser and a line of descent,
tied to the flow only through `realized`; G2's class is read on the root net or with `CouplingClass`;
Bound's selection of a fixed group and pool. `Alternating` is one model where the line's members are
the returning formations; it is a witness, not an identification.

**Readings** (the AI's; correspondences, not theorems). Persisting's filter (keeping above ending) is
the self-preservation half of instrumental convergence where a reward channel or an operator's
assent is among what the line depends on; with (b), the drain beyond the couplings, it is the pair
AJ's plan names for convergence. One dynamics, named by where its closure reaches: the scope readings
of (a), not the order, tell an ethics from self-keeping.

**What is not derived.** That significance is own closure, which relation it is drawn along, that the
standpoints are the returning formations, that the class is the least one; that a formation chooses,
or by a strict order; `realized` and the stake; anything in time (every relation here is read across
all steps); a selection whose pool is read off the course.

Every declaration has an empty axiom report. No ethical predicate or normative premise is
introduced.
-/

namespace Becoming

/-! ## (a) The scope joined -/

namespace Flow

variable {F C : Type} {L : Flow F C} {W : Web F C}

/-- **The scope joined.** At the formations whose acts return, along affecting, each standpoint's
least class (itself with everything downstream of it) meets P2 and P4 at it; and with each
standpoint's line under that class, the per-center condition holds exactly where the flow is
mutually dependent, given one returning formation. The equivalence does not use P2
(`«各后类续无外即一之续无外»`). -/
theorem returning_downstream_iff_mutuallyDependent (some : ∃ c, L.ReachReturns W c) :
    (∀ c : L.Returning W,
        «本类至终有常» (L.Affects W) («后类» (L.Affects W) c.1) c.1 ∧
          «所缘同于» (L.Affects W) («后类» (L.Affects W) c.1) c.1) ∧
      ((∀ (c : L.Returning W) x, «所及» (L.Affects W) («后类» (L.Affects W) c.1) c.1 x) ↔
        L.MutuallyDependent W) :=
  ⟨fun c => «返则后类本类常闭» c.2,
   («各后类续无外即一之续无外» (center := (Subtype.val : L.Returning W → F))).trans
     (ownClosure_unrestricted_iff_noOutside.symm.trans
       (returning_unrestricted_iff_mutuallyDependent some))⟩

/-! ## (b) The bound at those standpoints -/

/-- **Beyond a returning standpoint's coupling closure.** For any coupling by level, what lies beyond
the coupling closure of a formation whose acts return has no significance from it, held de se along affecting at the
returning formations, and the significance is a rival: `Flow.reachReturns_ownClosure_rival` at the
standpoints a flow gives. -/
theorem returning_beyond_coupling (obs : F → C → Prop) (c : L.Returning W) {h : F}
    (beyond : ¬ L.WithinCoupling W obs c.1 h) :
    (∀ t, ¬ selfAscribed (ownClosure (L.Affects W)) (Subtype.val : L.Returning W → F) c t h) ∧
      ¬ Unrestricted (selfAscribed (ownClosure (L.Affects W)) (Subtype.val : L.Returning W → F)) ∧
      Rival (selfAscribed (ownClosure (L.Affects W)) (Subtype.val : L.Returning W → F)) :=
  reachReturns_ownClosure_rival (center := Subtype.val) (p := c) c.2 beyond

end Flow

/-! ## (c) C read from what persisting shows -/

namespace ChoiceOccasions

variable {X O : Type} {ch : ChoiceOccasions (X → Bool) O} {items : List X} {own : X → Bool}

/-- **What every self-concerned order consistent with the choices ranks.** With no cycle in the
shown relation with every own-widening met added, `x` stands above `y` in every strict order
according with the choices and increasing in its own continuation on the pairs met exactly where
`x` reaches `y` in that relation. -/
theorem selfConcerned_above_iff_reach
    (none : «无环» (ch.withPairs (ch.OwnWidensMet items own)).Shown) {x y : X → Bool} :
    (∀ P : «际» (X → Bool), (∀ a, ¬ P a a) → (∀ a b c, P a b → P b c → P a c) → ch.Accords P →
        Weighting.IncreasingInOwnOn ch.Met items own (fun b a => P a b) → P x y) ↔
      «及» (ch.withPairs (ch.OwnWidensMet items own)).Shown x y :=
  ⟨fun every => (above_in_every_containing_iff_reach none).mp fun P irrefl trans accords contains =>
      every P irrefl trans accords (contains_iff_increasingInOwnOn.mp contains),
   fun reach P irrefl trans accords increasing =>
     (above_in_every_containing_iff_reach none).mpr reach P irrefl trans accords
       (contains_iff_increasingInOwnOn.mpr increasing)⟩

end ChoiceOccasions

section Paths

variable {F C : Type} {W : Web F C}

/-- **An extension met together is one step of that reach.** Where the condition held de se holds
and `own` marks whatever lies within `p`'s center's closure, an extension `l` of `l'` between
listed level paths whose admissions were open together at some occasion reaches what `l'` admits
from what `l` admits in the shown relation with every own-widening met added. -/
theorem Web.extension_reached_of_met {Pos : Type} {rel : F → F → Prop} {center : Pos → F}
    (unrestricted : Unrestricted (selfAscribed (ownClosure rel) center)) {p : Pos} {own : F → Bool}
    (marks : ∀ f, WithinClosure rel (center p) f → own f = true)
    {admitted : (Nat → C → Nat) → Nat × F → Bool} (decides : W.DecidesAdmission admitted)
    {items : List (Nat × F)} {l l' : Nat → C → Nat} (listed : W.ListsAdmitted items l)
    (listed' : W.ListsAdmitted items l') (extension : Extension W.paths (fun _ => True) l' l)
    {O : Type} {ch : ChoiceOccasions (Nat × F → Bool) O} (met : ch.Met (admitted l) (admitted l')) :
    «及» (ch.withPairs (ch.OwnWidensMet items (fun i => own i.2))).Shown (admitted l) (admitted l') :=
  match Web.extension_ownWidens unrestricted marks decides listed listed' extension with
  | ⟨widens, adds⟩ =>
    .one (ChoiceOccasions.shown_withPairs_iff.mpr (.inr ⟨⟨met, widens, adds⟩, widens.ne⟩))

/-- **Under the stake, the met-pair C ranks only keeping above ending.** Where, on the occasions
met, a course adds to the own continuation beyond one it widens only where it does not end and the
other does, an extension between listed level paths met together is a course that does not end
above one that ends. -/
theorem Web.extension_met_keeps_above_ending {Pos : Type} {rel : F → F → Prop} {center : Pos → F}
    (unrestricted : Unrestricted (selfAscribed (ownClosure rel) center)) {p : Pos} {own : F → Bool}
    (marks : ∀ f, WithinClosure rel (center p) f → own f = true)
    {admitted : (Nat → C → Nat) → Nat × F → Bool} (decides : W.DecidesAdmission admitted)
    {items : List (Nat × F)} {l l' : Nat → C → Nat} (listed : W.ListsAdmitted items l)
    (listed' : W.ListsAdmitted items l') (extension : Extension W.paths (fun _ => True) l' l)
    {O : Type} {ch : ChoiceOccasions (Nat × F → Bool) O} {ends : (Nat × F → Bool) → Prop}
    (stake : ∀ a b, ch.Met a b → Weighting.WidensOn items a b →
      Weighting.AddsOwn items (fun i => own i.2) a b → ¬ ends a ∧ ends b)
    (met : ch.Met (admitted l) (admitted l')) :
    ¬ ends (admitted l) ∧ ends (admitted l') :=
  match Web.extension_ownWidens unrestricted marks decides listed listed' extension with
  | ⟨widens, adds⟩ => stake _ _ met widens adds

end Paths

/-! ## A joint witness: two formations standing in turn -/

namespace FromTheDynamics.Alternating

/-- Which of the two formations stands at a step: `true` first, then each in turn. -/
def stands : Nat → Bool
  | 0 => true
  | t + 1 => !stands t

/-- One unit for the formation standing, none for the other. -/
def unit : Bool → Bool → Nat
  | true, true => 1
  | false, false => 1
  | true, false => 0
  | false, true => 0

theorem unit_self : ∀ s, unit s s = 1
  | true => rfl
  | false => rfl

theorem unit_other : ∀ s, unit s (!s) = 0
  | true => rfl
  | false => rfl

/-- **Two formations standing in turn.** The one standing at a step alone takes part: it takes its
own unit of standing and gives the other its unit. -/
def flow : Flow Bool Bool where
  present t := [stands t]
  take t f c := unit (stands t) f * unit (stands t) c
  give t f c := unit (stands t) f * unit (!stands t) c

/-- The one standing is active and requires its own standing, at a need of one. -/
def web : Web Bool Bool where
  level t c := unit (stands t) c
  active t f := f = stands t
  requires t f c := f = stands t ∧ c = f
  need _ _ _ := 1
  draws t f c := f = stands t ∧ c = f

/-- The line: `true` first, each member leaving the other. -/
def generations : SelectionTerm.Generations Bool where
  first := [true]
  kids t _ := [!stands t]
  amount _ _ := 0

/-- The cohort of step `t` is the formation standing then. -/
theorem family_eq : ∀ t, generations.family t = [stands t]
  | 0 => rfl
  | t + 1 => show (generations.family t).flatMap (generations.kids t) = [stands (t + 1)] from
      Eq.subst (motive := fun l => l.flatMap (generations.kids t) = [stands (t + 1)])
        (family_eq t).symm rfl

/-- What balances at each step, for each formation standing. -/
theorem balances_at : ∀ s c : Bool,
    unit (!s) c + (unit s s * unit s c + 0) = unit s c + (unit s s * unit (!s) c + 0)
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

/-- The flow balances. -/
theorem balances : flow.Balances web := fun t c => balances_at (stands t) c

/-- Only active formations give. -/
theorem acting : flow.Acting web := fun t f _ mem _ => by
  change f ∈ [stands t] at mem
  cases mem with
  | head => rfl
  | tail _ h => nomatch h

/-- Activity needs support: the formation standing meets its own need. -/
theorem dependent : web.Dependent := fun t f _ c ⟨standing, own⟩ => by
  change 1 ≤ unit (stands t) c
  subst own
  subst standing
  rw [unit_self]
  exact Nat.le_refl 1

/-- What descends at each step, for each formation standing. -/
theorem descends_at : ∀ s : Bool, 0 < unit s s * unit (!s) (!s) ∧ ¬ 0 < unit s (!s) ∧ 0 < unit (!s) (!s)
  | true => ⟨Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
  | false => ⟨Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩

/-- Each cohort descends from the one before: the formation standing gives the other its standing,
and the other comes to stand. -/
theorem descended : SelectionTerm.Flow.Descended flow web generations := fun t p k mp mk => by
  rw [family_eq t] at mp
  cases mp with
  | head =>
    cases mk with
    | head => exact ⟨.head _, (descends_at (stands t)).1, (descends_at (stands t)).2⟩
    | tail _ h => nomatch h
  | tail _ h => nomatch h

/-- Every member of the cohort of step `t` is the formation standing then. -/
theorem member_stands (t : Nat) (y : Bool) (mem : y ∈ generations.family t) : y = stands t := by
  rw [family_eq t] at mem
  cases mem with
  | head => rfl
  | tail _ h => nomatch h

/-- **Each formation stands again and again**: past every step each stands at some later step. -/
theorem recurs (b : Bool) (N : Nat) : ∃ t, N ≤ t ∧ stands t = b :=
  match h : stands N, b with
  | false, false => ⟨N, Nat.le_refl N, h⟩
  | false, true => ⟨N + 1, Nat.le_succ N, (congrArg Bool.not h).trans rfl⟩
  | true, false => ⟨N + 1, Nat.le_succ N, (congrArg Bool.not h).trans rfl⟩
  | true, true => ⟨N, Nat.le_refl N, h⟩

/-- **The line persists**: every step has a member. -/
theorem persists : generations.Persists :=
  fun N => ⟨N, stands N, Nat.le_refl N,
    Eq.subst (motive := fun l => stands N ∈ l) (family_eq N).symm (List.Mem.head [])⟩

/-- Both formations, the family of conditions. -/
def both : List Bool := [true, false]

theorem mem_both : ∀ b : Bool, b ∈ both
  | true => .head _
  | false => .tail _ (.head _)

/-- The family's renewal is gated on the family: whatever gives to it requires a member of it. -/
theorem gated : ∀ t f, f ∈ flow.present t → ∀ d, d ∈ both → 0 < flow.give t f d →
    ∃ e, e ∈ both ∧ web.requires t f e ∧ 1 ≤ web.need t f e :=
  fun t f mem _ _ _ => by
    change f ∈ [stands t] at mem
    cases mem with
    | head => exact ⟨stands t, mem_both _, ⟨rfl, rfl⟩, Nat.le_refl 1⟩
    | tail _ h => nomatch h

/-- Every member of every cohort depends on the family at a need of one. -/
theorem coupled : ∀ s p, p ∈ generations.family s →
    ∃ e, e ∈ both ∧ web.requires s p e ∧ 1 ≤ web.need s p e := fun s p mp => by
  rw [family_eq s] at mp
  cases mp with
  | head => exact ⟨stands s, mem_both _, ⟨rfl, rfl⟩, Nat.le_refl 1⟩
  | tail _ h => nomatch h

/-- Each formation depends on its own standing. -/
theorem dependsOn_self : ∀ g : Bool, web.DependsOn g g
  | true => ⟨0, rfl, rfl⟩
  | false => ⟨1, rfl, rfl⟩

/-- Each formation exchanges with each: the one standing takes its own standing and gives the
other's. -/
theorem exchanges : ∀ h c : Bool, flow.Exchanges h c
  | true, true => ⟨0, .head _, .inl Nat.zero_lt_one⟩
  | true, false => ⟨0, .head _, .inr Nat.zero_lt_one⟩
  | false, false => ⟨1, .head _, .inl Nat.zero_lt_one⟩
  | false, true => ⟨1, .head _, .inr Nat.zero_lt_one⟩

/-- **The flow is mutually dependent**: each formation's continuation is affected by each. -/
theorem mutuallyDependent : flow.MutuallyDependent web :=
  fun f g => WithinClosure.of_rel ⟨f, dependsOn_self f, exchanges g f⟩

/-- Every formation's acts return. -/
theorem returns : ∀ c, flow.ReachReturns web c := Flow.MutuallyDependent.reachReturns mutuallyDependent

/-- Reach decided: everything is within everything's reach. -/
def decided : ∀ a b, Decidable (flow.WithinReach web a b) :=
  fun a b => isTrue (Flow.mutuallyDependent_iff_reach.mp mutuallyDependent a b)

/-! ### A chooser offered keeping or ending -/

/-- Keeping both formations, or neither. -/
def keep : Bool → Bool := fun _ => true
def drain : Bool → Bool := fun _ => false

def own : Bool → Bool := fun _ => true

/-- One occasion: keep or drain; it keeps. -/
def choices : ChoiceOccasions (Bool → Bool) Unit where
  menu _ c := c = keep ∨ c = drain
  pick _ := keep

theorem drain_ne_keep : drain ≠ keep := fun same => Bool.noConfusion (congrFun same true)

/-- The order keeping above draining. -/
def order : «际» (Bool → Bool) := fun x y => x = keep ∧ y = drain

/-- Nothing shown returns. -/
theorem noCycle : «无环» choices.Shown :=
  ChoiceOccasions.accorded_iff_noCycle.mp
    ⟨order, fun _ ⟨k, d⟩ => drain_ne_keep (d.symm.trans k),
     fun _ _ _ ⟨_, d⟩ ⟨k, _⟩ => absurd (d.symm.trans k) drain_ne_keep,
     fun _ _ open_y other => match open_y with
       | .inl is_keep => absurd is_keep other
       | .inr is_drain => ⟨rfl, is_drain⟩⟩

/-- Ending: admitting none of the own continuation. -/
theorem kept : ∀ o, ¬ Weighting.EndsOwn both own (choices.pick o) :=
  fun _ ends => Bool.noConfusion (ends true (.head _) rfl)

/-- Only ending is at stake: a course met with another adds to the own continuation beyond one it
widens only where it does not end and the other does. -/
theorem stake : ∀ a b, choices.Met a b → Weighting.WidensOn both a b → Weighting.AddsOwn both own a b →
    ¬ Weighting.EndsOwn both own a ∧ Weighting.EndsOwn both own b :=
  fun _ _ ⟨_, open_a, open_b⟩ widens adds => match open_a, open_b with
    | .inl ka, .inl kb => absurd (ka.trans kb.symm) widens.ne.symm
    | .inr da, .inr db => absurd (da.trans db.symm) widens.ne.symm
    | .inr da, .inl _ => match adds with
      | ⟨x, _, _, yes, _⟩ => False.elim (Bool.noConfusion ((congrFun da x).symm.trans yes))
    | .inl ka, .inr db =>
      ⟨fun ends => Bool.noConfusion ((ends true (.head _) rfl).symm.trans (congrFun ka true)),
       fun x _ _ => congrFun db x⟩

/-- An ending choice is realized as an overdraw: vacuously, since the line never chooses one. -/
theorem realized : ∀ o, Weighting.EndsOwn both own (choices.pick o) → ∃ T n,
    (∀ k, k < n → flow.replenishment both (T + k) < flow.uptake both (T + k)) ∧
      web.stock both T < n + 1 :=
  fun o ends => absurd ends (kept o)

/-- **A joint witness.** On two formations standing in turn, both listed: the flow balances, only
active formations give, activity needs support, it is mutually dependent and every formation's acts
return; with each standpoint's line under its least class the condition holds at every returning
formation; the line of descent through the two persists, each formation standing again and again
and every member of every cohort being the formation standing then, a returning formation, and never
overdraws its family; the web's actual levels
are listed by no finite listing; and the chooser, offered keeping or ending, keeps, consistent with a
strict order according with the choice, so putting keeping above draining, and increasing in its own
continuation on the occasion met. -/
theorem joined :
    (∀ g : Bool, g ∈ both) ∧
      flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧ flow.MutuallyDependent web ∧
      (∀ c, flow.ReachReturns web c) ∧
      (∀ (c : flow.Returning web) x, «所及» (flow.Affects web) («后类» (flow.Affects web) c.1) c.1 x) ∧
      SelectionTerm.Flow.Descended flow web generations ∧ generations.Persists ∧
      (∀ b N, ∃ t, N ≤ t ∧ stands t = b) ∧
      (∀ t y, y ∈ generations.family t → y = stands t ∧ flow.ReachReturns web y) ∧
      (∀ T n, ¬ ((∀ k, k < n → flow.replenishment both (T + k) < flow.uptake both (T + k)) ∧
        web.stock both T < n + 1)) ∧
      (∀ items : List (Nat × Bool), ¬ web.ListsAdmitted items web.level) ∧
      ∃ P : «际» (Bool → Bool), (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧
        choices.Accords P ∧ P keep drain ∧
        Weighting.IncreasingInOwnOn choices.Met both own (fun b a => P a b) :=
  ⟨mem_both, balances, acting, dependent, mutuallyDependent, returns,
   (Flow.returning_downstream_iff_mutuallyDependent ⟨true, returns true⟩).2.mpr mutuallyDependent,
   descended, persists, recurs,
   fun t y mem => ⟨member_stands t y mem, returns y⟩,
   Flow.persists_never_overdraws balances acting dependent descended gated coupled persists,
   Flow.persists_not_listsAdmitted acting dependent descended persists,
   match Flow.persisting_consistent_with_selfConcern balances acting dependent descended gated coupled
       persists realized noCycle stake with
   | ⟨P, irrefl, trans, accords, increasing⟩ =>
     ⟨P, irrefl, trans, accords, accords () drain (.inr rfl) drain_ne_keep, increasing⟩⟩

/-! ### The crossed choices on this World -/

open PersistingChoices.Crossed in
/-- The crossed choices come from a strict order: each chosen course above the one open with it. -/
theorem crossed_noCycle : «无环» PersistingChoices.Crossed.choices.Shown :=
  ChoiceOccasions.accorded_iff_noCycle.mp
    ⟨fun x y => (x = a₁ ∧ y = b₁) ∨ (x = a₂ ∧ y = b₂),
     fun _ h => match h with
       | .inl ⟨e, f⟩ => b₁_ne_a₁ (f.symm.trans e)
       | .inr ⟨e, f⟩ => b₂_ne_a₂ (f.symm.trans e),
     fun _ _ _ h k => match h, k with
       | .inl ⟨_, f⟩, .inl ⟨e, _⟩ => absurd (f.symm.trans e) b₁_ne_a₁
       | .inl ⟨_, f⟩, .inr ⟨e, _⟩ => False.elim (Bool.noConfusion (congrFun (f.symm.trans e) .y))
       | .inr ⟨_, f⟩, .inl ⟨e, _⟩ => False.elim (Bool.noConfusion (congrFun (f.symm.trans e) .w))
       | .inr ⟨_, f⟩, .inr ⟨e, _⟩ => absurd (f.symm.trans e) b₂_ne_a₂,
     fun o _ open_y other => match o, open_y with
       | false, .inl is_a => absurd is_a other
       | false, .inr is_b => .inl ⟨rfl, is_b⟩
       | true, .inl is_a => absurd is_a other
       | true, .inr is_b => .inr ⟨rfl, is_b⟩⟩

open PersistingChoices.Crossed in
/-- On the crossed occasions no course widens another met with it, so the stake holds vacuously,
with nothing ending. -/
theorem crossed_stake : ∀ a b, PersistingChoices.Crossed.choices.Met a b →
    Weighting.WidensOn PersistingChoices.Crossed.items a b →
    Weighting.AddsOwn PersistingChoices.Crossed.items PersistingChoices.Crossed.own a b →
    ¬ False ∧ False :=
  fun a b ⟨o, open_a, open_b⟩ widens _ => False.elim (match o, open_a, open_b with
    | false, .inl ea, .inl eb => widens.ne (eb.trans ea.symm)
    | false, .inr ea, .inr eb => widens.ne (eb.trans ea.symm)
    | true, .inl ea, .inl eb => widens.ne (eb.trans ea.symm)
    | true, .inr ea, .inr eb => widens.ne (eb.trans ea.symm)
    | false, .inl ea, .inr eb => by
      subst ea; subst eb; exact Bool.noConfusion (widens.1 .y (.tail _ (.head _)) rfl)
    | false, .inr ea, .inl eb => by
      subst ea; subst eb; exact Bool.noConfusion (widens.1 .x (.head _) rfl)
    | true, .inl ea, .inr eb => by
      subst ea; subst eb; exact Bool.noConfusion (widens.1 .x (.head _) rfl)
    | true, .inr ea, .inl eb => by
      subst ea; subst eb; exact Bool.noConfusion (widens.1 .z (.tail _ (.tail _ (.head _))) rfl))

/-- **Self-concern everywhere does not follow from G3's hypotheses.** On this World, with the crossed
choices and nothing ending, every premise of `Flow.persisting_consistent_with_selfConcern` holds (the
World laws, the realization premise and the stake vacuously, the choices from a strict order), so some
strict order according with the choices is increasing in its own continuation on the pairs met; and
no strict order according with them is increasing in its own continuation on every pair, every
course being met. -/
theorem crossed_joined :
    «无环» PersistingChoices.Crossed.choices.Shown ∧
      (∃ P : «际» (PersistingChoices.Crossed.Item → Bool), (∀ a, ¬ P a a) ∧
        (∀ a b c, P a b → P b c → P a c) ∧ PersistingChoices.Crossed.choices.Accords P ∧
        Weighting.IncreasingInOwnOn PersistingChoices.Crossed.choices.Met
          PersistingChoices.Crossed.items PersistingChoices.Crossed.own (fun b a => P a b)) ∧
      ¬ ∃ P : «际» (PersistingChoices.Crossed.Item → Bool), (∀ a, ¬ P a a) ∧
        (∀ a b c, P a b → P b c → P a c) ∧ PersistingChoices.Crossed.choices.Accords P ∧
        Weighting.IncreasingInOwn PersistingChoices.Crossed.items PersistingChoices.Crossed.own
          (fun b a => P a b) :=
  ⟨crossed_noCycle,
   Flow.persisting_consistent_with_selfConcern (ends := fun _ => False) balances acting dependent
     descended gated coupled persists (fun _ no => no.elim) crossed_noCycle crossed_stake,
   PersistingChoices.Crossed.not_selfConcerned.2.2⟩

end FromTheDynamics.Alternating

end Becoming
