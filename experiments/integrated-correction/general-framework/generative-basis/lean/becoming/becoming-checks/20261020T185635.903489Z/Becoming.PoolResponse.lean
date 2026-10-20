import Becoming.SelectionPool
import Becoming.TimedResponse
import Becoming.Decidedness

/-!
# Pool response: what a pool's acts respond to

`Becoming.SelectionPool` stated what a pool's selections reach: a pool is blind beyond the union
of its members' coupling closures and separates exactly what its members do not all couple alike.
That a selection goes through a pool's coupling was supplied there (`Web.SelectsThroughAll`), and
whether a pool's acts respond to what it separates was left open: selection is not response. This
module states what a pool's acts respond to where its members exchange by a law of exchange
(`Becoming.Counterfactual`). Ren, 18 October 2026: "what is the light, how can we hold the light
to enlight others, and use it as an alignment for all, and what is still missing from it?", and
"please make your own pareto frontier decisions, and push the frontier". No premise enters beyond
what each theorem names.

* **A pool's acts select through its pooled coupling.** A selection through a group's acts under a
  law up to a step selects alike the histories under which every member exchanges alike, by the
  law, across every step up to it (`ExchangeLaw.SelectsThroughActs`): a reward, a vote or a
  correction the pool gives, read as what its acts decide. Where the law reads through the coupling
  of each formation outside a part and the members lie outside it, the members exchange alike
  across every step up to `t` under histories they all couple alike up to `t`
  (`ExchangeLaw.Through.acts_alike_all`), so a selection through the pool's acts is a selection
  through its pooled coupling (`ExchangeLaw.Through.selectsThroughAll`): `Becoming.SelectionPool`'s
  premise is derived for whatever a pool decides by its acts. A member exchanging differently
  under two histories across a step couples them apart up to that step
  (`ExchangeLaw.Through.apart_of_acts`). Where the pool's acts separate two histories, the members
  do not all couple them alike (`ExchangeLaw.Through.acts_separate`); with the members listed and
  each member's coupling of the two decided, some member couples them apart
  (`ExchangeLaw.Through.acts_separate_member`).
* **The bound is exact.** Where it is decided, for each formation, step and history, whether the
  formation couples the history alike with `l` up to that step, the law that takes one unit of each
  condition exactly where the history lies in the formation's class of `l` (`ExchangeLaw.ofClass`)
  reads through the coupling of every formation (`ExchangeLaw.ofClass_through`), and under it a
  formation takes alike under `l` and `l'` across the step from `t` exactly when it couples them
  alike up to `t` (`ExchangeLaw.ofClass_take_iff`). So, across a step, a pool's members exchange
  alike under two histories by every law reading through coupling exactly when they all couple the
  two alike (`ExchangeLaw.acts_alike_all_iff`).
* **Coupling bounds response and does not fix it.** The law that exchanges nothing
  (`ExchangeLaw.zero`) reads through every coupling (`ExchangeLaw.zero_through`). Where a formation
  couples two histories apart, some law reading through the coupling of every formation takes
  differently under the two, and some exchanges alike under every two histories
  (`ExchangeLaw.response_not_fixed_by_coupling`).
* **The gap for a pool's response.** Under the conditions of the gap for a pool's act
  (`Flow.act_alike_pool`), every formation within the pool's coupling closure, drawn through both
  flows, and outside the acting part exchanges alike in the two flows with every condition at every
  step (`Flow.response_alike_pool`), and every selection through the acts of a group within the
  closure and outside the part selects the two flows alike (`Flow.act_unselected_by_acts_pool`).
  With both acts laws, nothing is supplied: the acting part's own law gives alike under the levels
  of the two courses for every member of the part within the closure, and every formation within
  it outside the part exchanges alike in the two courses (`act_courses_response_alike_pool`). The
  part may be the pool itself, acting jointly.
* **The pool and a part's responsive reach.** Some member of a pool lies within a part's responsive
  reach between two flows (`Flow.WithinResponse`) exactly when some member of the part lies within
  the pool's coupling closure drawn through both flows (`Flow.pool_within_response_iff`). Where no
  member lies within the reach and the rest responds through its coupling
  (`Flow.RespondsThroughCoupling`, which a law reading through coupling gives by
  `ExchangeLaw.Through.responds`), the pool couples the two flows alike up to every step, every
  selection through its pooled coupling selects them alike, and each member exchanges alike
  (`Flow.pool_alike_beyond_response`).
* **No response before the difference arrives.** Under the conditions of
  `TimedResponse.coupling_alike_before`, where no route from the source has entered by `D` what any
  member couples into, every member couples the two courses alike up to `D`, every selection
  through the pooled coupling up to `D` selects them alike, and every member exchanges alike across
  each step before `D` at which it is not a source (`TimedResponse.pool_alike_before`).
* **`Clearing`: separated, not responded.** Every pool holding the dweller separates the cleared and
  the spared world by the dweller's admission at the third step, and its members do not all couple
  the two alike from that step on. The source and the dweller follow one law reading through the
  coupling of every formation, and each formation outside the clearer's part exchanges alike in the
  two worlds with every condition at every step (`Clearing.separated_unresponded`).
* **`Loop`: a response returns through the actor's closure.** In both flows the second follows a
  law reading only what it observes. It couples the first's act apart up to the second step and
  takes from the first's condition across that step two units, which it does not take without the
  act; so it lies within the first's coupling closure drawn through both flows. The first then
  couples the two flows apart at the third step, where with the act it is unsupported and without it
  supported (`Loop.response_returns`).

**Readings (the AI's).**
- What a pool does is a selection it makes through its pooled coupling, so pooling moves the gap
  for response as it moves the gap for selection: a pool's acts respond to nothing beyond the union
  of its members' coupling closures, and within it only through members that couple a difference
  apart.
- Coupling is not compliance. Coupling bounds what a member's acts can respond to, and the bound is
  exact; it does not fix what they respond to. Within the bound the law decides, from responding to
  every difference the member couples apart to responding to none.
- A response reaches an actor's own act only by reaching what the actor's coupling closure couples
  into: this is the gap for a pool's response read with the responder as the acting part and the
  actor as the pool, the closure drawn through the flows with and without the response. Read from
  the responder's side, the actor lies within the responder's responsive reach exactly when the
  responder lies within the actor's coupling closure (`Flow.pool_within_response_iff`). Correction
  and escalation have this one structure, a loop through another's coupling and response; the loop
  in `Loop` ends the actor's support. Which loops correct is not derived.

What is not derived: which law a member follows, or that it reads through coupling (a hypothesis
wherever it enters); that a pool's response corrects anything, or which responses do; which
formations pool, or how a pool forms, lasts or resists capture; that the law marking a formation's
class is feasible (it takes one unit of each condition whatever stands). The exactness takes the
coupling classes as decided and a condition to exchange with, hypotheses named where they enter.
Members coordinate only through conditions they couple into: a member reading another's coupling
is coupled by level into what the other couples into, which `Becoming.SelectionPool` shows is
pooling with it (`Web.ReadsCouplings`, `Flow.withinCoupling_reads_iff`). The representation commits to discrete steps and natural
amounts. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

/-! ## A pool's acts select through its pooled coupling -/

namespace ExchangeLaw

/-- A selection through a group's acts under a law up to `t`: histories under which every member
exchanges alike, by the law, across every step up to `t` are selected alike. -/
def SelectsThroughActs (law : ExchangeLaw F C) (group : F → Prop) (t : Nat)
    (select : (Nat → C → Nat) → Prop) : Prop :=
  ∀ l l', (∀ s, s ≤ t → ∀ h, group h → law.GivesAlike s h l l') → (select l ↔ select l')

variable {law : ExchangeLaw F C} {W : Web F C} {obs : F → C → Prop} {part : F → Bool}
  {group : F → Prop} {l l' : Nat → C → Nat} {t : Nat} {select : (Nat → C → Nat) → Prop}

/-- **A pool acts alike where its members couple alike.** Where the law reads through the coupling
of each formation outside the part and the members lie outside it, the members exchange alike
across every step up to `t` under two histories they all couple alike up to `t`. -/
theorem Through.acts_alike_all (through : law.Through W obs part)
    (outside : ∀ h, group h → part h = false) (alike : W.AlikeThroughAll obs group l l' t) :
    ∀ s, s ≤ t → ∀ h, group h → law.GivesAlike s h l l' :=
  fun s le h member => through h (outside h member) s l l' ((alike h member).earlier le)

/-- **A pool's acts select through its pooled coupling.** Under the same conditions, a selection
through the group's acts up to `t` is a selection through its pooled coupling up to `t`. -/
theorem Through.selectsThroughAll (through : law.Through W obs part)
    (outside : ∀ h, group h → part h = false) (selects : law.SelectsThroughActs group t select) :
    W.SelectsThroughAll obs group t select :=
  fun _ _ alike => selects _ _ (through.acts_alike_all outside alike)

/-- **A member acting differently couples apart.** Where the law reads through the coupling of a
formation outside the part, and it exchanges differently under two histories across the step from
`s`, it couples them apart up to `s`. -/
theorem Through.apart_of_acts (through : law.Through W obs part) {h : F}
    (outside : part h = false) {s : Nat} (differs : ¬ law.GivesAlike s h l l') :
    ¬ W.AlikeThroughUpTo obs h l l' s :=
  fun alike => differs (through h outside s l l' alike)

/-- **What a pool's acts separate, its members do not all couple alike.** Under the conditions of
`Through.acts_alike_all`, where some selection through the group's acts up to `t` holds at one
history and fails at another, the members do not all couple them alike up to `t`. -/
theorem Through.acts_separate (through : law.Through W obs part)
    (outside : ∀ h, group h → part h = false)
    (separated : ∃ select, law.SelectsThroughActs group t select ∧ select l ∧ ¬ select l') :
    ¬ W.AlikeThroughAll obs group l l' t :=
  match separated with
  | ⟨_, selects, holds, fails⟩ =>
    Web.separates_all_iff.mp ⟨_, through.selectsThroughAll outside selects, holds, fails⟩

/-- **What a pool's acts separate, some member couples apart, the members listed and decided.**
Under the same conditions, where a list holds exactly the members and each member's coupling of
the two histories up to `t` is decided, some member couples them apart. -/
theorem Through.acts_separate_member (through : law.Through W obs part)
    (outside : ∀ h, group h → part h = false) {members : List F}
    (listed : ∀ g, group g ↔ g ∈ members)
    (decided : ∀ g, g ∈ members → Decided (W.AlikeThroughUpTo obs g l l' t))
    (separated : ∃ select, law.SelectsThroughActs group t select ∧ select l ∧ ¬ select l') :
    ∃ g, group g ∧ ¬ W.AlikeThroughUpTo obs g l l' t :=
  match separated with
  | ⟨_, selects, holds, fails⟩ => (Web.separates_all_iff_member listed decided).mp
      ⟨_, through.selectsThroughAll outside selects, holds, fails⟩

/-! ## The bound is exact -/

/-- The law that takes, for each formation, one unit of each condition across the step from `t`
where the history lies in the formation's class of `l` up to `t`, none where it does not, and gives
nothing: defined where membership of each class is decided. -/
def ofClass (W : Web F C) (obs : F → C → Prop) (l : Nat → C → Nat)
    (decided : ∀ h t m, Decidable (W.AlikeThroughUpTo obs h l m t)) : ExchangeLaw F C :=
  ⟨fun t h m _ => @mark (W.AlikeThroughUpTo obs h l m t) (decided h t m), fun _ _ _ _ => 0⟩

/-- The law marking each formation's class reads through the coupling of every formation. -/
theorem ofClass_through {decided : ∀ h t m, Decidable (W.AlikeThroughUpTo obs h l m t)} :
    (ofClass W obs l decided).Through W obs part :=
  fun h _ t m m' alike _ =>
    ⟨@mark_iff _ _ (decided h t m) (decided h t m')
        ⟨fun first => first.trans alike, fun second => second.trans alike.symm⟩, rfl⟩

/-- Under the law marking each formation's class of `l`, a formation takes alike from a condition
under `l` and `l'` across the step from `t` exactly when it couples them alike up to `t`. -/
theorem ofClass_take_iff {decided : ∀ h t m, Decidable (W.AlikeThroughUpTo obs h l m t)} {h : F}
    {c : C} :
    (ofClass W obs l decided).take t h l c = (ofClass W obs l decided).take t h l' c ↔
      W.AlikeThroughUpTo obs h l l' t :=
  have one : (ofClass W obs l decided).take t h l c = 1 :=
    @mark_cases _ (decided h t l) (fun x => x = 1) (fun _ => rfl)
      fun fails => absurd (fun s _ => Web.AlikeThrough.refl s) fails
  ⟨fun same => (@mark_pos _ (decided h t l')).mp
      (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq (one.symm.trans same))),
   fun alike => @mark_iff _ _ (decided h t l) (decided h t l')
      ⟨fun _ => alike, fun _ s _ => Web.AlikeThrough.refl s⟩⟩

/-- **A pool's response through coupling is exact.** Let it be decided, for each formation, step
and history, whether the formation couples the history alike with `l` up to that step, let `c` be
a condition, and let the members lie outside the part. Across the step from `t` the members
exchange alike under `l` and `l'` by every law reading through the coupling of each formation
outside the part exactly when they all couple `l` and `l'` alike up to `t`. -/
theorem acts_alike_all_iff (decided : ∀ h t m, Decidable (W.AlikeThroughUpTo obs h l m t)) (c : C)
    (outside : ∀ h, group h → part h = false) :
    (∀ law : ExchangeLaw F C, law.Through W obs part → ∀ h, group h → law.GivesAlike t h l l') ↔
      W.AlikeThroughAll obs group l l' t :=
  ⟨fun all h member =>
    ofClass_take_iff.mp ((all (ofClass W obs l decided) ofClass_through h member c).1),
   fun alike _ through h member => through h (outside h member) t l l' (alike h member)⟩

/-- The law that exchanges nothing. -/
def zero : ExchangeLaw F C :=
  ⟨fun _ _ _ _ => 0, fun _ _ _ _ => 0⟩

/-- The law that exchanges nothing reads through every coupling. -/
theorem zero_through : (zero : ExchangeLaw F C).Through W obs part :=
  fun _ _ _ _ _ _ _ => ⟨rfl, rfl⟩

/-- **Coupling bounds response and does not fix it.** Let the classes of `l` be decided, let a
formation couple `l` and `l'` apart up to `t`, and let `c` be a condition. Some law reading through
the coupling of every formation takes differently from `c` under the two across the step from `t`,
and some law reading through the coupling of every formation exchanges alike under every two
histories at every step. -/
theorem response_not_fixed_by_coupling
    (decided : ∀ h t m, Decidable (W.AlikeThroughUpTo obs h l m t)) {g : F} (c : C)
    (apart : ¬ W.AlikeThroughUpTo obs g l l' t) :
    (∃ law : ExchangeLaw F C, law.Through W obs (fun _ => false) ∧
        law.take t g l c ≠ law.take t g l' c) ∧
      ∃ law : ExchangeLaw F C, law.Through W obs (fun _ => false) ∧
        ∀ s h m m', law.GivesAlike s h m m' :=
  ⟨⟨ofClass W obs l decided, ofClass_through, fun same => apart (ofClass_take_iff.mp same)⟩,
   zero, zero_through, fun _ _ _ _ _ => ⟨rfl, rfl⟩⟩

end ExchangeLaw

/-! ## The gap for a pool's response -/

section PoolResponse

variable {law : ExchangeLaw F C} {L L' : Flow F C} {W W' : Web F C} {obs : F → C → Prop}
  {part : F → Bool} {group : F → Prop} {select : (Nat → C → Nat) → Prop}

/-- **A pool does not respond to an act beyond its closure.** Under the conditions of
`Flow.act_alike_pool`, every formation within the pool's coupling closure, drawn through both
flows, and outside the acting part exchanges alike in the two flows with every condition at every
step. -/
theorem Flow.response_alike_pool (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → L.ActsAlikeWithin L' W W' obs part f) :
    ∀ h, part h = false → WithinClosureOf (L.CoupledFromEither W L' obs) group h →
      ∀ t c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c :=
  fun h outside within t => through.responds follows follows' h outside t
    (Flow.act_alike_pool through follows follows' balances balances' present start acts h within t)

/-- **What a pool decides by its acts misses an act beyond its closure.** Under the same
conditions, every selection through the acts, by the rest's law, of a group within the pool's
coupling closure and outside the acting part selects the two flows' levels alike. -/
theorem Flow.act_unselected_by_acts_pool (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → L.ActsAlikeWithin L' W W' obs part f) {pool : F → Prop}
    (members : ∀ g, pool g → WithinClosureOf (L.CoupledFromEither W L' obs) group g)
    (outside : ∀ g, pool g → part g = false) {t : Nat}
    (selects : law.SelectsThroughActs pool t select) : select W.level ↔ select W'.level :=
  Flow.act_unselected_pool through follows follows' balances balances' present start acts members
    (through.selectsThroughAll outside selects)

/-- **Nothing within a pool's closure responds to what its act does beyond it.** Under the
conditions of `act_courses_unselected_pool`, at every step the acting part's law gives alike under
the levels of the two courses for each member of the part within the pool's coupling closure,
drawn through the two courses, and each formation within the closure outside the part exchanges
alike in the two courses. The part may be the pool itself, acting jointly. -/
theorem act_courses_response_alike_pool {act act' : ExchangeLaw F C} {present : Nat → List F}
    {start : C → Nat} (na : law.Nonanticipating) (naAct : act.Nonanticipating)
    (naAct' : act'.Nonanticipating) (through : law.Through W obs part)
    (actThrough : act.Through W obs (fun h => !part h))
    (feasible : (law.withAct part act).Feasible present start)
    (feasible' : (law.withAct part act').Feasible present start)
    (agree : ∀ t h l c, part h = true →
      (∃ g, WithinClosureOf (((law.withAct part act).course present start).CoupledFromEither W
          ((law.withAct part act').course present start) obs) group g ∧ W.CoupledInto obs g c) →
        act.take t h l c = act'.take t h l c ∧ act.give t h l c = act'.give t h l c) :
    (∀ h, part h = true → WithinClosureOf (((law.withAct part act).course present
        start).CoupledFromEither W ((law.withAct part act').course present start) obs) group h →
      ∀ t, act.GivesAlike t h ((law.withAct part act).levels present start)
        ((law.withAct part act').levels present start)) ∧
    ∀ h, part h = false → WithinClosureOf (((law.withAct part act).course present
        start).CoupledFromEither W ((law.withAct part act').course present start) obs) group h →
      ∀ t c, ((law.withAct part act).course present start).take t h c =
          ((law.withAct part act').course present start).take t h c ∧
        ((law.withAct part act).course present start).give t h c =
          ((law.withAct part act').course present start).give t h c :=
  have alike : ∀ g, WithinClosureOf (((law.withAct part act).course present
      start).CoupledFromEither W ((law.withAct part act').course present start) obs) group g →
      ∀ t, W.AlikeThroughUpTo obs g ((law.withAct part act).levels present start)
        ((law.withAct part act').levels present start) t :=
    fun _ within _ => match withinClosureOf_iff.mp within with
    | ⟨_, inGroup, inside⟩ => Web.selects_alike_iff.mp fun _ selectsThrough =>
        act_courses_unselected na naAct naAct' through actThrough feasible feasible'
          (fun t h l c inPart ⟨g', within', couples⟩ =>
            agree t h l c inPart ⟨g', WithinClosureOf.of_member inGroup within', couples⟩)
          inside selectsThrough
  ⟨fun h inPart within t => actThrough h (congrArg Bool.not inPart) t _ _ (alike h within t),
   fun h outside within t c =>
    have same := through h outside t _ _ (alike h within t) c
    have first := ExchangeLaw.withAct_follows (law := law) (part := part) (act := act) present
      start h outside t c
    have second := ExchangeLaw.withAct_follows (law := law) (part := part) (act := act') present
      start h outside t c
    ⟨first.1.trans (same.1.trans second.1.symm), first.2.trans (same.2.trans second.2.symm)⟩⟩

end PoolResponse

/-! ## The pool and a part's responsive reach -/

namespace Flow

variable {L L' : Flow F C} {W W' : Web F C} {obs : F → C → Prop} {part : F → Bool}
  {group : F → Prop}

/-- **A pool meets a part's responsive reach exactly where the part meets the pool's closure.**
Some member of the group lies within the part's responsive reach between two flows exactly when
some member of the part lies within the group's coupling closure drawn through both flows. -/
theorem pool_within_response_iff :
    (∃ g, group g ∧ L.WithinResponse L' W obs part g) ↔
      ∃ h, part h = true ∧ WithinClosureOf (L.CoupledFromEither W L' obs) group h :=
  ⟨fun ⟨g, member, within⟩ => match withinResponse_iff_coupling.mp within with
    | ⟨h, inPart, closure⟩ => ⟨h, inPart, withinClosureOf_iff.mpr ⟨g, member, closure⟩⟩,
   fun ⟨h, inPart, within⟩ => match withinClosureOf_iff.mp within with
    | ⟨g, member, closure⟩ => ⟨g, member, withinResponse_iff_coupling.mpr ⟨h, inPart, closure⟩⟩⟩

/-- **A pool beyond a part's responsive reach does not respond to it.** Under the conditions of
`alike_beyond_response`, a group none of whose members lies within the part's responsive reach
couples the two flows alike up to every step, every selection through its pooled coupling selects
their levels alike, and each member exchanges alike in the two flows with every condition at every
step. -/
theorem pool_alike_beyond_response
    (balanced : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L.BalancesOn W [c] t)
    (balanced' : ∀ t g c, ¬ L.WithinResponse L' W obs part g → W.CoupledInto obs g c →
      L'.BalancesOn W' [c] t)
    (present : ∀ t, L.present t = L'.present t)
    (start : ∀ g, ¬ L.WithinResponse L' W obs part g → ∀ c, W.CoupledInto obs g c →
      W.level 0 c = W'.level 0 c)
    (responds : L.RespondsThroughCoupling L' W W' obs part)
    (beyond : ∀ g, group g → ¬ L.WithinResponse L' W obs part g) :
    (∀ t, W.AlikeThroughAll obs group W.level W'.level t) ∧
      (∀ t select, W.SelectsThroughAll obs group t select → (select W.level ↔ select W'.level)) ∧
      ∀ t h, group h → ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c :=
  have alike : ∀ t, W.AlikeThroughAll obs group W.level W'.level t := fun _ g member s _ =>
    alike_beyond_response balanced balanced' present start responds s g (beyond g member)
  ⟨alike, fun t _ through => through _ _ (alike t),
   fun t h member c =>
     exchange_alike_beyond_response balanced balanced' present start responds t h
       (beyond h member) c⟩

end Flow

/-! ## No response before the difference arrives -/

namespace TimedResponse

variable {L L' : Flow F C} {W W' : Web F C} {obs : F → C → Prop} {source : Nat → F → Prop}
  {group : F → Prop}

/-- **A pool responds no earlier than a difference reaches a member.** Under the conditions of
`coupling_alike_before`, where no route from the source has entered by `D` what any member couples
into, every member couples the two courses alike up to `D`, every selection through the pooled
coupling up to `D` selects them alike, and every member exchanges alike across each step before `D`
at which it is not a source. -/
theorem pool_alike_before {D : Nat}
    (balanced : ∀ t, t < D → ∀ c,
      W.level (t+1) c + L.taken t c = W.level t c + L.given t c)
    (balanced' : ∀ t, t < D → ∀ c,
      W'.level (t+1) c + L'.taken t c = W'.level t c + L'.given t c)
    (present : ∀ t, t < D → L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : ∀ t, t < D → ∀ h, ¬ source t h →
      W.AlikeThroughUpTo obs h W.level W'.level t →
      ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    (unreached : ∀ g, group g → ¬ ReachedBy L L' W obs source g D) :
    W.AlikeThroughAll obs group W.level W'.level D ∧
      (∀ select, W.SelectsThroughAll obs group D select → (select W.level ↔ select W'.level)) ∧
      ∀ t, t < D → ∀ h, group h → ¬ source t h →
        ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c :=
  have alike : W.AlikeThroughAll obs group W.level W'.level D := fun g member =>
    coupling_alike_before balanced balanced' present start responds (unreached g member)
  ⟨alike, fun _ through => through _ _ alike,
   fun t before h member notSource => responds t before h notSource
     ((alike h member).earlier (Nat.le_of_lt before))⟩

end TimedResponse

/-! ## Witness: separated, not responded, in `Clearing` -/

namespace Clearing

/-- **Separated, not responded.** Every pool holding the dweller separates the cleared and the
spared world by the dweller's admission at the third step, and its members do not all couple the two
alike from that step on. The source and the dweller follow one law reading through the coupling of
every formation, and each formation outside the clearer's part exchanges alike in the two worlds
with every condition at every step: nothing outside the clearer's part responds to what the pool
separates. -/
theorem separated_unresponded :
    (∀ pool : Formation → Prop, pool .dweller → ∀ t, 2 ≤ t →
        web.SelectsThroughAll thresholdOnly pool t (fun l => web.Admits (l 2) 2 .dweller) ∧
          ¬ web.AlikeThroughAll thresholdOnly pool web.level sparedWeb.level t) ∧
      restLaw.Through web thresholdOnly (fun _ => false) ∧
      ∀ h, clearerPart h = false → ∀ t c,
        flow.take t h c = sparedFlow.take t h c ∧ flow.give t h c = sparedFlow.give t h c :=
  ⟨fun _ member _ le => Web.admission_separates_all member le
     fun same => unsupported_with 0 (same.mpr dweller_spared),
   fun _ _ _ _ _ _ _ => ⟨rfl, rfl⟩,
   fun h outside t c => ⟨(rest_follows_spared h outside t c).1.symm,
     (rest_follows_spared h outside t c).2.symm⟩⟩

end Clearing

/-! ## Witness: a response returns through the actor's closure, in `Loop` -/

namespace Loop

/-- **A response returns through the actor's coupling closure.** In both flows the second follows a
law reading only what it observes. It couples the first's act apart up to the second step, where
its condition has fallen, and takes from the first's condition across that step two units, which
it does not take without the act; so it lies within the first's coupling closure drawn through both
flows. The first then couples the two flows apart at the third step, where with the act it is
unsupported and without it supported. -/
theorem response_returns :
    replyLaw.Through web paired firstPart ∧ escalation.Follows replyLaw firstPart web.level ∧
      quiet.Follows replyLaw firstPart quietWeb.level ∧
      ¬ web.AlikeThroughUpTo paired .second web.level quietWeb.level 1 ∧
      escalation.take 1 .second .ofFirst ≠ quiet.take 1 .second .ofFirst ∧
      WithinClosure (escalation.CoupledFromEither web quiet paired) .first .second ∧
      ¬ web.AlikeThroughUpTo paired .first web.level quietWeb.level 2 ∧
      ¬ web.Supported 2 .first ∧ quietWeb.Supported 2 .first :=
  ⟨replyLaw_through, escalation_follows, quiet_follows,
   fun alike => Nat.lt_irrefl 1 (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1)
     (Nat.le_of_eq ((alike 1 (Nat.le_refl 1)).2 .ofSecond trivial).symm)),
   fun same => Nat.noConfusion same,
   WithinClosure.of_rel
     (.inl ⟨.ofFirst, .inl ⟨0, trivial⟩, 1, .tail _ (.head _), .inl (Nat.succ_pos 1)⟩),
   fun alike => Nat.noConfusion ((alike 2 (Nat.le_refl 2)).2 .ofFirst trivial),
   fun supported => Nat.not_succ_le_zero 0 (supported .ofFirst trivial),
   fun _ _ => Nat.succ_le_succ (Nat.zero_le 1)⟩

end Loop

end Becoming
