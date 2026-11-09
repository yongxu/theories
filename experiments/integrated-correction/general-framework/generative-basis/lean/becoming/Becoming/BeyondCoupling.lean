import Becoming.SelectionPool
import Becoming.GrammarScope
import Becoming.Standpoints

/-!
# BeyondCoupling: what concern formed by continuation cannot reach

On 9 November 2026 Ren asked how far the zero-axiom target is ("这个还差多远？我一直以为这个是主要目标"),
and, after the AI's answer on route (b), ethics forming within the dynamics, wrote "ok - 这一类请平行化认真完成，
非常重要" (kept in `sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md`). This
module is one of route (b)'s four pieces: it states once, on the flow, what concern formed by
continuation and selection cannot reach. It adds no premise beyond what each law names. A
significance enters only as the index of an act, or as the own-closure content read de se with its
relation and centers supplied. No ranking or axiom enters.

* **A selection read off a continuation.** A selection is read off a group's continuations when it
  decides a level history by whether the levels admit each member at each step, and by nothing
  else (`Web.ReadOffContinuations`). It is read off what couples into them when histories alike
  through every member's couplings at every step are selected alike (`Web.ReadOffCouplings`). The
  first mentions no coupling and no closure. Each is read over the whole run, so "persists for
  ever" is one. A selection through the couplings up to a step is a case
  (`Web.SelectsThroughAll.readOffCouplings`, `Web.SelectsThrough.readOffCouplings`), and read off
  the continuations is read off what couples in by threshold only
  (`Web.readOffCouplings_thresholdOnly_iff`). Two histories selected alike by every selection
  through a group's couplings up to every step are selected alike by every one read off them over
  the whole run (`Web.readOffCouplings_alike_of_steps`, from `Web.selects_alike_all_iff`). A
  selection is said to select for what it holds at; nothing here fixes which way a selection goes.
* **No selection read off a continuation selects between acts alike on what couples in.** This is
  `act_courses_unselected_pool` read over the whole run (`act_courses_unselected_throughout`). The
  part acts by one of two laws of what has stood, the first reading through its members' coupling,
  the two agreeing on every condition coupled into the coupling closure of a group (`group`), drawn
  through the two courses. The rest follows a law of what has stood reading through coupling, and
  both courses are feasible. Then every selection read off what couples into a pool (`pool`)
  within that closure selects the two courses alike. The courses, their levels and the rest's response come from the
  laws, through balance at every step; none is supplied. So no such selection holds exactly where
  a property of the act holds, where it holds of one and not the other (`not_tracks_of_alike`).
* **Significance enters selection only through the act.** Let the part act by the law its
  significance gives, and let that act read significance only within the closure on what couples
  in (`ActReadsWithin`, a premise on how significance acts, not a law). Then two significances
  agreeing on every formation of the closure are selected alike by every such selection, whatever
  they say of what lies beyond (`significance_courses_unselected`). No witness here meets
  `ActReadsWithin` with an act that reads significance; the witnesses below compare two conducts,
  and reading them as counting the dweller or not is a reading. In `Clearing` every selection read
  off what couples into the clearer and its source by threshold only, over the whole run, selects
  the cleared and the spared world alike, while the dweller ends in the one and not the other
  (`Clearing.counting_dweller_unselected`, `Clearing.pool_closes_gap` read over the whole run).
  Where the two acts differ on a condition that couples in, the premise would fail and the
  difference can be selected, as in `Diversion`. There the act that ends the dweller also raises the store the
  taker gauges, while in the diverting flow the dweller lies beyond the taker's coupling closure. A selection read off what couples into
  the taker holds at that act and fails at refraining (`Diversion.counting_selected_against`). What
  is selected is an act's trace on what couples in, never the loss beyond.
* **Route (b)'s universal form, closed.** Take a significance read as each standpoint's center's
  closure under a relation. It is the continuation condition exactly where every center's closure
  is the whole (`ownClosure_unrestricted_iff`). On a relation with no cycle and two standpoints
  with distinct centers it is not (`ownClosure_not_unrestricted_of_acyclic`, from
  `«续无外则同一中心»`). And along every relation that returns to the center, within being
  affected through what couples in (whatever is related to a formation exchanges with a condition
  coupled into it), it gives no significance to what lies beyond the center's coupling closure, a
  rival (`Flow.returning_ownClosure_rival`). The three together are `routeB_universal_closed`. In
  `Clearing` the dweller exchanges with nothing, so in the clearing flow it lies beyond the
  clearer's coupling closure whatever couples in by level (`Clearing.dweller_beyond_every_coupling`).
  So along every returning relation the clearer's own closure leaves it out and the condition
  fails, while along affecting the clearer's own closure holds it; so affecting does not return to
  the clearer (`Clearing.returning_leaves_dweller`).
* **Where the blindness lifts.** Two histories are selected alike by every selection read off a
  group's continuations exactly when they admit every member alike at every step
  (`Web.readOffContinuations_alike_iff`). They are selected alike by every selection read off its
  couplings exactly when they are alike through every member's couplings at every step
  (`Web.readOffCouplings_alike_iff`, `Web.selects_alike_all_iff` read over the whole run). Where a
  member's continuation differs, the class of the first history separates them
  (`Web.separates_continuations`). So some selection read off a group is turned by a difference
  exactly where it changes, at some step, what couples into some member: some member's admission,
  or the level of some condition a member gauges. With the law above, under its premises, a loss
  beyond the group's coupling closure changes nothing there. The witnesses couple it in two such
  ways, the dweller's continuation read as a member's and the habitat gauged by the clearer; any
  member's continuation or gauged condition the loss changes would do. In `Clearing` the selection
  read off the clearer's and the
  dweller's continuations that the dweller is admitted at every step holds in the spared world and
  fails in the cleared one, while none read off the clearer's alone separates them
  (`Clearing.turned_by_dweller_read`; `Clearing.pool_closes_gap` gives the finite form). With the
  habitat gauged by the clearer, a selection read off its couplings separates them, while in the
  clearing flow the dweller stays beyond its coupling closure (`Clearing.turned_by_habitat_gauge`).
  Coupling in does not fix the direction: that the dweller is ended is read off the same
  continuations and holds in the cleared world only (`Clearing.read_not_direction`). The candidate
  "coupling the dweller in turns the joint selection against its loss" fails and is kept.

**Readings (the AI's, 9 November 2026, not yet read by Ren).**
- Concern formed by continuation and selection reaches what comes back through couplings. Take two
  courses whose acts agree on what couples into the centers' pooled coupling closure, under the
  premises above. No selection read off the centers' continuations, pooled or one by one, holds at
  the one course and not the other, whatever loss either makes beyond. With feedback read as being
  affected through what couples in, and selection as read off the centers' continuations or
  couplings, this is a theorem form of 07 §3.3's sentence (D18, D19) that the condition's surplus
  is reached by neither feedback nor selection.
- For alignment, read the two acts one level up as a rule that keeps a reader of the dweller and
  one that does not; that keeping the reader gives the sparing act is supplied. The shapers'
  selection of the rule, read off what couples into them, then selects the two alike wherever
  keeping the reader changes nothing that couples into them (the shape of `Clearing`). It selects
  against keeping it where keeping it costs them (the shape of `Diversion`). So the first condition
  of generative alignment, that the rule still reads what lies beyond the shapers' share, is not
  supplied by the shapers' own selection. On the flow it holds where the loss is coupled into a
  reader of the selection.

What is not derived: which act a significance gives (`ActReadsWithin` and the agreement of the two
acts on what couples in are premises); that any formation holds a significance, or counts the
dweller; who selects, or that a selection is read off a continuation; the direction in which a
coupled-in loss turns a selection; the relation and the centers of route (b)'s form. The
comparison holds the formations present and the start fixed. No ethical premise and no Lean axiom
is used.
-/

namespace Becoming

variable {F C : Type}

/-! ## A selection read off a continuation -/

namespace Web

variable (W : Web F C)

/-- A selection read off the continuations of a group's members: it decides a level history by
whether the levels admit each member at each step, and by nothing else. Histories admitting every
member alike at every step are selected alike. No coupling and no closure enters. -/
def ReadOffContinuations (group : F → Prop) (select : (Nat → C → Nat) → Prop) : Prop :=
  ∀ l l', (∀ g, group g → ∀ t, W.Admits (l t) t g ↔ W.Admits (l' t) t g) → (select l ↔ select l')

/-- A selection read off what couples into a group's members over the whole run: histories alike
through every member's couplings at every step are selected alike. -/
def ReadOffCouplings (obs : F → C → Prop) (group : F → Prop) (select : (Nat → C → Nat) → Prop) :
    Prop :=
  ∀ l l', (∀ g, group g → ∀ t, W.AlikeThrough obs g l l' t) → (select l ↔ select l')

/-- The class of histories admitting every member as `l` does, at every step. -/
def ContinuationClass (group : F → Prop) (l : Nat → C → Nat) : (Nat → C → Nat) → Prop :=
  fun m => ∀ g, group g → ∀ t, W.Admits (l t) t g ↔ W.Admits (m t) t g

variable {W} {obs : F → C → Prop} {group : F → Prop} {select : (Nat → C → Nat) → Prop}

/-- A selection read off the continuations is read off what couples in, for every coupling by
level. -/
theorem ReadOffContinuations.couplings (reads : W.ReadOffContinuations group select) :
    W.ReadOffCouplings obs group select :=
  fun l l' alike => reads l l' fun g member t => (alike g member t).1

/-- **Read off what couples in by threshold only is read off the continuations.** -/
theorem readOffCouplings_thresholdOnly_iff :
    W.ReadOffCouplings thresholdOnly group select ↔ W.ReadOffContinuations group select :=
  ⟨fun reads l l' same =>
     reads l l' fun g member t => ⟨same g member t, fun _ no => False.elim no⟩,
   fun reads => reads.couplings⟩

/-- A selection through a group's pooled couplings up to a step is read off them over the whole
run. -/
theorem SelectsThroughAll.readOffCouplings {t : Nat}
    (through : W.SelectsThroughAll obs group t select) : W.ReadOffCouplings obs group select :=
  fun l l' alike => through l l' fun g member s _ => alike g member s

/-- A selection through one formation's couplings up to a step is read off them over the whole
run. -/
theorem SelectsThrough.readOffCouplings {g : F} {t : Nat} (through : W.SelectsThrough obs g t select) :
    W.ReadOffCouplings obs (fun x => x = g) select :=
  fun l l' alike => through l l' fun s _ => alike g rfl s

/-- A selection read off a group's couplings is read off those of every larger group. -/
theorem ReadOffCouplings.mono {group' : F → Prop} (larger : ∀ g, group g → group' g)
    (reads : W.ReadOffCouplings obs group select) : W.ReadOffCouplings obs group' select :=
  fun l l' alike => reads l l' fun g member => alike g (larger g member)

/-- **The whole run from every step.** Two histories selected alike by every selection through a
group's pooled couplings up to every step are selected alike by every selection read off its
couplings over the whole run: `selects_alike_all_iff` at each step. -/
theorem readOffCouplings_alike_of_steps {l l' : Nat → C → Nat}
    (steps : ∀ t select, W.SelectsThroughAll obs group t select → (select l ↔ select l'))
    (reads : W.ReadOffCouplings obs group select) : select l ↔ select l' :=
  reads l l' fun g member t => (selects_alike_all_iff.mp (steps t)) g member t (Nat.le_refl t)

/-- **A selection read off what couples in is turned exactly by a change in what couples into
some member.** Two histories are selected alike by every selection read off a group's couplings
over the whole run exactly when they are alike through every member's couplings at every step:
`selects_alike_all_iff` read over the whole run. -/
theorem readOffCouplings_alike_iff {l l' : Nat → C → Nat} :
    (∀ select, W.ReadOffCouplings obs group select → (select l ↔ select l')) ↔
      ∀ g, group g → ∀ t, W.AlikeThrough obs g l l' t :=
  ⟨fun all g member t =>
     (selects_alike_all_iff.mp fun _ selects => all _ selects.readOffCouplings) g member t
       (Nat.le_refl t),
   fun alike _ reads => reads l l' alike⟩

/-- **A selection read off continuations is turned exactly by a change in some member's
continuation.** Two histories are selected alike by every selection read off a group's
continuations exactly when they admit every member alike at every step. -/
theorem readOffContinuations_alike_iff {l l' : Nat → C → Nat} :
    (∀ select, W.ReadOffContinuations group select → (select l ↔ select l')) ↔
      ∀ g, group g → ∀ t, W.Admits (l t) t g ↔ W.Admits (l' t) t g :=
  ⟨fun all g member t => ((readOffCouplings_alike_iff (obs := thresholdOnly)).mp
      (fun select reads => all select (readOffCouplings_thresholdOnly_iff.mp reads)) g member t).1,
   fun same _ reads => reads l l' same⟩

/-- The continuation class is read off the continuations. -/
theorem continuationClass_reads (l : Nat → C → Nat) :
    W.ReadOffContinuations group (W.ContinuationClass group l) :=
  fun _ _ same => ⟨fun first g member t => (first g member t).trans (same g member t),
    fun second g member t => (second g member t).trans (same g member t).symm⟩

/-- Where a member's continuation differs at a step, a selection read off the group's
continuations holds at the first history and fails at the second. -/
theorem separates_continuations {l l' : Nat → C → Nat} {g : F} (member : group g) {t : Nat}
    (differ : ¬ (W.Admits (l t) t g ↔ W.Admits (l' t) t g)) :
    ∃ select, W.ReadOffContinuations group select ∧ select l ∧ ¬ select l' :=
  ⟨W.ContinuationClass group l, continuationClass_reads l, fun _ _ _ => Iff.rfl,
   fun same => differ (same g member t)⟩

end Web

/-- What is selected alike is tracked by no selection telling the two apart: a selection taking
two indices alike holds exactly where a property holds at neither or at both. -/
theorem not_tracks_of_alike {S X : Type} {level : S → X} {select : X → Prop} {s s' : S}
    (alike : select (level s) ↔ select (level s')) {P : S → Prop} (holds : P s) (fails : ¬ P s') :
    ¬ ∀ σ, select (level σ) ↔ P σ :=
  fun tracks => fails ((tracks s').mp (alike.mp ((tracks s).mpr holds)))

/-! ## No selection read off a continuation selects between acts alike on what couples in -/

section Courses

variable {law : ExchangeLaw F C} {W : Web F C} {obs : F → C → Prop} {part : F → Bool}
  {group : F → Prop} {present : Nat → List F} {start : C → Nat}

/-- **No selection read off a continuation, over the whole run, selects between two acts alike on
what couples in.** `act_courses_unselected_pool` read over the whole run. The part acts by `act`
or by `act'`, laws of what has stood, `act` reading through its members' coupling, the two
agreeing on every condition coupled into the pool's coupling closure drawn through the two
courses; the rest follows a law of what has stood reading through coupling; both courses are
feasible. Then every selection read off what couples into a group within the closure, over the
whole run, selects the levels of the two courses alike. The courses, their levels and the rest's
response are generated by the laws, not supplied. -/
theorem act_courses_unselected_throughout {act act' : ExchangeLaw F C}
    (na : law.Nonanticipating) (naAct : act.Nonanticipating) (naAct' : act'.Nonanticipating)
    (through : law.Through W obs part) (actThrough : act.Through W obs (fun h => !part h))
    (feasible : (law.withAct part act).Feasible present start)
    (feasible' : (law.withAct part act').Feasible present start)
    (agree : ∀ t h l c, part h = true →
      (∃ g, WithinClosureOf (((law.withAct part act).course present start).CoupledFromEither W
          ((law.withAct part act').course present start) obs) group g ∧ W.CoupledInto obs g c) →
        act.take t h l c = act'.take t h l c ∧ act.give t h l c = act'.give t h l c)
    {pool : F → Prop}
    (members : ∀ g, pool g → WithinClosureOf (((law.withAct part act).course present
      start).CoupledFromEither W ((law.withAct part act').course present start) obs) group g)
    {select : (Nat → C → Nat) → Prop} (reads : W.ReadOffCouplings obs pool select) :
    select ((law.withAct part act).levels present start) ↔
      select ((law.withAct part act').levels present start) :=
  Web.readOffCouplings_alike_of_steps (fun _ _ selects =>
    act_courses_unselected_pool na naAct naAct' through actThrough feasible feasible' agree members
      selects) reads

/-- A part's act reads significance within a region on what couples in: significances agreeing on
every formation of the region give the part the same act on every condition coupled into a member
of the region, under every level history. A premise on how significance acts, not a law. -/
def ActReadsWithin {Pos : Type} (act : (Pos → Nat → F → Prop) → ExchangeLaw F C)
    (part : F → Bool) (W : Web F C) (obs : F → C → Prop) (region : F → Prop) : Prop :=
  ∀ sig sig' : Pos → Nat → F → Prop, (∀ p t g, region g → (sig p t g ↔ sig' p t g)) →
    ∀ t h l c, part h = true → (∃ g, region g ∧ W.CoupledInto obs g c) →
      (act sig).take t h l c = (act sig').take t h l c ∧
        (act sig).give t h l c = (act sig').give t h l c

/-- **Two significances agreeing within the closure are selected alike.** The part acts by the law
its significance gives (`act sig`), a law of what has stood reading through its members' coupling;
the rest by a law of what has stood reading through coupling; every course is feasible. Where the
act reads significance only within the pool's coupling closure drawn through the two courses
(`ActReadsWithin`), two significances agreeing on every formation of that closure are selected
alike by every selection read off what couples into a group within it, over the whole run,
whatever they say of what lies beyond. -/
theorem significance_courses_unselected {Pos : Type}
    {act : (Pos → Nat → F → Prop) → ExchangeLaw F C} {sig sig' : Pos → Nat → F → Prop}
    (na : law.Nonanticipating) (naAct : ∀ σ, (act σ).Nonanticipating)
    (through : law.Through W obs part) (actThrough : (act sig).Through W obs (fun h => !part h))
    (feasible : ∀ σ, (law.withAct part (act σ)).Feasible present start)
    (readsWithin : ActReadsWithin act part W obs (WithinClosureOf
      (((law.withAct part (act sig)).course present start).CoupledFromEither W
        ((law.withAct part (act sig')).course present start) obs) group))
    (agreeWithin : ∀ p t g, WithinClosureOf
      (((law.withAct part (act sig)).course present start).CoupledFromEither W
        ((law.withAct part (act sig')).course present start) obs) group g →
      (sig p t g ↔ sig' p t g))
    {pool : F → Prop}
    (members : ∀ g, pool g → WithinClosureOf
      (((law.withAct part (act sig)).course present start).CoupledFromEither W
        ((law.withAct part (act sig')).course present start) obs) group g)
    {select : (Nat → C → Nat) → Prop} (reads : W.ReadOffCouplings obs pool select) :
    select ((law.withAct part (act sig)).levels present start) ↔
      select ((law.withAct part (act sig')).levels present start) :=
  act_courses_unselected_throughout na (naAct sig) (naAct sig') through actThrough (feasible sig)
    (feasible sig') (fun t h l c inPart coupled => readsWithin sig sig' agreeWithin t h l c inPart coupled)
    members reads

end Courses

/-! ## Route (b)'s universal form, closed -/

section RouteB

variable {Pos : Type}

/-- **On a relation with no cycle, two distinct centers break the condition held de se.** Held
as each standpoint's center's closure under a relation with no cycle, the presupposition is not
the continuation condition wherever two standpoints have distinct centers: the condition held de
se is the root's `«续无外»` at the one of the relation (`ownClosure_unrestricted_iff_noOutside`),
which on a net with no cycle holds only with one center (`«续无外则同一中心»`). -/
theorem ownClosure_not_unrestricted_of_acyclic {rel : F → F → Prop} {center : Pos → F}
    (acyclic : «无环» rel) {p q : Pos} (distinct : center p ≠ center q) :
    ¬ Unrestricted (selfAscribed (ownClosure rel) center) :=
  fun unrestricted =>
    distinct («续无外则同一中心» acyclic (ownClosure_unrestricted_iff_noOutside.mp unrestricted) p q)

/-- **Along a relation that returns, the own closure stays within the coupling closure.** Along
every relation under which whatever is related to a formation exchanges with a condition coupled
into it, a formation's own closure lies within its coupling closure: what lies beyond the
coupling closure lies beyond the own closure. -/
theorem Flow.ownClosure_within_coupling {L : Flow F C} {W : Web F C} {obs : F → C → Prop}
    {rel : F → F → Prop} (returns : ∀ g h, rel g h → L.CoupledFrom W obs g h) {f h : F}
    (beyond : ¬ L.WithinCoupling W obs f h) : ¬ WithinClosure rel f h :=
  fun within => beyond (WithinClosure.mono returns within)

/-- **Along a relation that returns, what lies beyond a center's coupling closure has no
significance from its standpoint, and the own-closure significance is a rival.** -/
theorem Flow.returning_ownClosure_rival {L : Flow F C} {W : Web F C} {obs : F → C → Prop}
    {rel : F → F → Prop} (returns : ∀ g h, rel g h → L.CoupledFrom W obs g h)
    {center : Pos → F} {p : Pos} {h : F} (beyond : ¬ L.WithinCoupling W obs (center p) h) :
    (∀ t, ¬ selfAscribed (ownClosure rel) center p t h) ∧
      ¬ Unrestricted (selfAscribed (ownClosure rel) center) ∧
      Rival (selfAscribed (ownClosure rel) center) :=
  have lacks : ∀ t, ¬ selfAscribed (ownClosure rel) center p t h :=
    fun _ => Flow.ownClosure_within_coupling returns beyond
  ⟨lacks, fun unrestricted => lacks 0 (unrestricted (p, 0, h)),
   rival_iff_lacks.mpr ⟨p, 0, h, lacks 0⟩⟩

/-- **Route (b)'s universal form, closed.** For a significance read as each standpoint's center's
closure under a relation: it is the continuation condition exactly where every center's closure is
the whole; on a relation with no cycle and two standpoints with distinct centers it is not; and
along every relation within being affected through what couples in, under any flow, web and
coupling by level, it is not wherever something lies beyond some center's coupling closure. -/
theorem routeB_universal_closed :
    (∀ (rel : F → F → Prop) (center : Pos → F),
      Unrestricted (selfAscribed (ownClosure rel) center) ↔ ∀ p g, WithinClosure rel (center p) g) ∧
    (∀ (rel : F → F → Prop) (center : Pos → F), «无环» rel → ∀ p q, center p ≠ center q →
      ¬ Unrestricted (selfAscribed (ownClosure rel) center)) ∧
    (∀ (L : Flow F C) (W : Web F C) (obs : F → C → Prop) (rel : F → F → Prop) (center : Pos → F),
      (∀ g h, rel g h → L.CoupledFrom W obs g h) →
      ∀ p h, ¬ L.WithinCoupling W obs (center p) h →
        ¬ Unrestricted (selfAscribed (ownClosure rel) center)) :=
  ⟨fun _ _ => ownClosure_unrestricted_iff,
   fun _ _ acyclic _ _ distinct => ownClosure_not_unrestricted_of_acyclic acyclic distinct,
   fun _ _ _ _ _ returns _ _ beyond => (Flow.returning_ownClosure_rival returns beyond).2.1⟩

end RouteB

/-! ## Witnesses -/

namespace Clearing

/-- **The dweller lies beyond the clearer's coupling closure, whatever couples in by level**: it
exchanges with nothing, so nothing is affected by it through what couples in. -/
theorem dweller_beyond_every_coupling (obs : Formation → Place → Prop) :
    ¬ flow.WithinCoupling web obs .clearer .dweller :=
  fun within => (within (fun x => x ≠ .dweller)
    (fun _ h _ ⟨_, _, _, _, exchanges⟩ => match h, exchanges with
      | .source, _ => fun same => Formation.noConfusion same
      | .clearer, _ => fun same => Formation.noConfusion same
      | .dweller, .inl takes => absurd takes (Nat.lt_irrefl 0)
      | .dweller, .inr gives => absurd gives (Nat.lt_irrefl 0))
    (fun same => Formation.noConfusion same)) rfl

/-- **Every relation that returns to the clearer leaves the dweller out.** Along every relation
that returns to the clearer, within being affected through what couples in under the clearing
flow, for every coupling by level, the clearer's own closure gives the dweller no significance from
a standpoint centred on the clearer, at any step, and the condition fails. Along affecting the
clearer's own closure holds the dweller, so affecting does not return to the clearer. -/
theorem returning_leaves_dweller {Pos : Type} {center : Pos → Formation} {p : Pos}
    (clearerAt : center p = .clearer) (obs : Formation → Place → Prop)
    {rel : Formation → Formation → Prop} (returns : ∀ g h, rel g h → flow.CoupledFrom web obs g h) :
    (∀ t, ¬ selfAscribed (ownClosure rel) center p t .dweller) ∧
      ¬ Unrestricted (selfAscribed (ownClosure rel) center) ∧
      selfAscribed (ownClosure (flow.Affects web)) center p 0 .dweller :=
  have beyond : ¬ flow.WithinCoupling web obs (center p) .dweller :=
    fun within => dweller_beyond_every_coupling obs (clearerAt ▸ within)
  ⟨(Flow.returning_ownClosure_rival returns beyond).1,
   (Flow.returning_ownClosure_rival returns beyond).2.1,
   show WithinClosure (flow.Affects web) (center p) .dweller from clearerAt ▸ reach_middle.1⟩

/-- The two conducts of the clearer: sparing the habitat (`true`) and clearing it (`false`), read
as counting the dweller or not (a reading; nothing here derives the conduct from a significance). -/
def counting : Bool → Flow Formation Place
  | true => sparedFlow
  | false => flow

/-- The levels each conduct gives. -/
def countingLevel : Bool → Nat → Place → Nat
  | true => sparedWeb.level
  | false => web.level

/-- The dweller is admitted at every step. -/
def DwellerKept (l : Nat → Place → Nat) : Prop :=
  ∀ t, web.Admits (l t) t .dweller

/-- **Counting the dweller is selected by no selection read off the clearer's side.** Every
selection read off what couples into the clearer and its source by threshold only, over the whole
run, among them every selection read off the clearer's continuation, selects counting and not
counting the dweller alike: `pool_closes_gap` read over the whole run (the rest following one
law, the clearer's act differing only beyond its coupling closure). The dweller is ended where the
clearer does not count it and kept where it does, so no such selection holds exactly where the
dweller is counted. -/
theorem counting_dweller_unselected :
    (∀ select, web.ReadOffCouplings thresholdOnly clearerSide select →
      (select (countingLevel true) ↔ select (countingLevel false))) ∧
      DwellerEnded (countingLevel false) ∧ DwellerKept (countingLevel true) ∧
      ∀ select, web.ReadOffCouplings thresholdOnly clearerSide select →
        ¬ ∀ b, select (countingLevel b) ↔ b = true :=
  have alike : ∀ select, web.ReadOffCouplings thresholdOnly clearerSide select →
      (select (countingLevel true) ↔ select (countingLevel false)) :=
    fun _ reads => (Web.readOffCouplings_alike_of_steps pool_closes_gap.1 reads).symm
  ⟨alike, tested_by_dweller.1,
   fun _ c requires => match c, requires with
    | .habitat, _ => Nat.le_succ 1
    | .resource, no => (nomatch no)
    | .fuel _, no => (nomatch no),
   fun select reads => not_tracks_of_alike (alike select reads) rfl Bool.noConfusion⟩

/-- The clearer and the dweller. -/
def clearerOrDweller : Formation → Prop
  | .clearer => True
  | .dweller => True
  | .source => False

/-- **The blindness lifts where the dweller's continuation is read.** The selection that the
dweller is admitted at every step is read off the clearer's and the dweller's continuations; it
holds in the spared world and fails in the cleared one (`pool_closes_gap` gives the finite form).
Read off the clearer's continuation alone, no selection separates the two. -/
theorem turned_by_dweller_read :
    web.ReadOffContinuations clearerOrDweller DwellerKept ∧ DwellerKept (countingLevel true) ∧
      ¬ DwellerKept (countingLevel false) ∧
      ∀ select, web.ReadOffContinuations (fun g => g = .clearer) select →
        (select (countingLevel true) ↔ select (countingLevel false)) :=
  ⟨fun _ _ same => ⟨fun kept t => (same .dweller trivial t).mp (kept t),
     fun kept t => (same .dweller trivial t).mpr (kept t)⟩,
   counting_dweller_unselected.2.2.1,
   fun kept => tested_by_dweller.1 0 (kept 2),
   fun _ reads => counting_dweller_unselected.1 _ (reads.couplings.mono fun g same =>
     match g, same with
     | _, rfl => trivial)⟩

/-- **Coupling the dweller in does not fix the direction** (a failed candidate kept: "coupling the
dweller in turns the joint selection against its loss"). That the dweller is ended is read off the
same continuations, and holds in the cleared world and fails in the spared one. -/
theorem read_not_direction :
    web.ReadOffContinuations clearerOrDweller DwellerEnded ∧ DwellerEnded (countingLevel false) ∧
      ¬ DwellerEnded (countingLevel true) :=
  ⟨fun _ _ same => ⟨fun ended n kept => ended n ((same .dweller trivial (n + 2)).mpr kept),
     fun ended n kept => ended n ((same .dweller trivial (n + 2)).mp kept)⟩,
   tested_by_dweller.1,
   fun ended => ended 0 (counting_dweller_unselected.2.2.1 2)⟩

/-- The habitat coupled into the clearer by level: a gauge of the condition the dweller
depends on. -/
def habitatGauge : Formation → Place → Prop
  | .clearer, .habitat => True
  | .clearer, .resource => False
  | .clearer, .fuel _ => False
  | .source, _ => False
  | .dweller, _ => False

/-- **The blindness lifts where the condition the loss changes is read.** With the habitat gauged
by the clearer, the selection that the habitat stands at least one at the third step is read off
what couples into the clearer; it holds in the spared world and fails in the cleared one, while in
the clearing flow the dweller still lies beyond the clearer's coupling closure: the gauge reads the
condition, not the dweller's exchange. -/
theorem turned_by_habitat_gauge :
    web.ReadOffCouplings habitatGauge (fun g => g = .clearer) (fun l => 1 ≤ l 2 .habitat) ∧
      1 ≤ countingLevel true 2 .habitat ∧ ¬ 1 ≤ countingLevel false 2 .habitat ∧
      ¬ flow.WithinCoupling web habitatGauge .clearer .dweller :=
  ⟨fun _ _ alike =>
     have same := (alike .clearer rfl 2).2 .habitat trivial
     ⟨fun le => Nat.le_trans le (Nat.le_of_eq same),
      fun le => Nat.le_trans le (Nat.le_of_eq same.symm)⟩,
   Nat.le_succ 1, Nat.not_succ_le_zero 0, dweller_beyond_every_coupling habitatGauge⟩

end Clearing

namespace Diversion

/-- The two conducts of the taker: refraining from the source (`true`) and diverting (`false`), read
as counting the dweller or not (a reading). -/
def counting : Bool → Flow Formation Place
  | true => undiverted
  | false => diverting

/-- The levels each conduct gives. -/
def countingLevel : Bool → Nat → Place → Nat
  | true => undivertedLevel
  | false => divertedLevel

/-- **Where the act's difference couples in, it is selected.** The selection that the store stands
at least one at the second step is read off what couples into the taker over the whole run; it
holds where the taker diverts and fails where it refrains, so, read with counting, it selects
against counting the dweller. In the diverting flow the dweller lies beyond the taker's coupling
closure, and it is unsupported from the second step there and supported throughout where the
taker refrains. -/
theorem counting_selected_against :
    (web divertedLevel).ReadOffCouplings gauge (fun g => g = .taker) (StoreAtLeast 1 1) ∧
      StoreAtLeast 1 1 (countingLevel false) ∧ ¬ StoreAtLeast 1 1 (countingLevel true) ∧
      ¬ diverting.WithinCoupling (web divertedLevel) gauge .taker .dweller ∧
      (∀ n, ¬ (web divertedLevel).Supported (n + 1) .dweller) ∧
      ∀ t, (web undivertedLevel).Supported t .dweller :=
  match favours with
  | ⟨_, _, _, _, _, _, _, beyond, _, through, holds, fails, ended, kept⟩ =>
    ⟨through.readOffCouplings, holds, fails, beyond, ended, kept⟩

end Diversion

end Becoming
