import Becoming.SelectionGap
import Becoming.Decidedness

/-!
# Selection pool: what selection through pooled coupling reaches

A selection through a group's pooled coupling selects alike the histories every member couples
alike (`Web.SelectsThroughAll`); two histories are selected alike by every such selection exactly
when every member couples them alike (`Web.selects_alike_all_iff`). `Becoming.Selection` showed a
pool blind beyond one formation's coupling closure where all its members lie within it
(`Flow.unselected_beyond_coupling_all`), and `Clearing.selected_pooled` a pool that separates two
worlds no member's coupling alone separates. This module states what a pool's selections reach,
for any pool. Ren, 18 October 2026: "what is the light, how can we hold the light to enlight
others, and use it as an alignment for all, and what is still missing from it?", and "please make
your own pareto frontier decisions, and push the frontier". No premise enters beyond what each
theorem names.

* **A pool's coupling closure, and blindness beyond it** (stated in `Becoming.Selection`, which
  derives the single formation's case from them). The closure of a group under a relation is the
  union of the members' closures (`WithinClosureOf`, `withinClosureOf_iff`); a pool's coupling
  closure is its closure under being affected through what is coupled into
  (`Flow.WithinPoolCoupling`), and every selection through the pooled coupling of any group within
  it selects the levels with and without a part beyond it alike (`Flow.unselected_beyond_pool`).
* **What a pool separates, exactly.** Some selection through the pooled coupling holds at one
  history and fails at another exactly when the members do not all couple them alike
  (`Web.separates_all_iff`). Where a member couples them apart, its own class is such a selection
  (`Web.member_separates_all`); where a list holds the members and each member's coupling of the
  two is decided, a pool separates exactly what some member separates
  (`Web.separates_all_iff_member`). A formation whose admission at a step differs separates the
  two histories through every pool holding it, from that step on
  (`Web.admission_separates_all`).
* **What a pool adds.** The selections through the pooled coupling are exactly a member's when,
  and only when, whatever that member couples alike every member couples alike
  (`Web.pooled_iff_member`); where a member couples two histories alike and the members do not all,
  some pooled selection goes through no coupling of that member's (`Web.pool_adds`).
* **The gap for a pool's act.** Let the rest follow one law of exchange reading through coupling,
  in two balanced flows with the same formations present, starting alike, and let the part act
  alike within each member's coupling closure drawn through both flows (the plain case: it
  differs only on conditions no member of the pool's closure couples into,
  `Flow.ActsAlikeOnPoolCoupled`). Then each formation within the pool's coupling closure couples
  the two flows alike at every step (`Flow.act_alike_pool`), and every selection through the
  pooled coupling of any group within the closure selects them alike (`Flow.act_unselected_pool`),
  so a consequence of the act is a selection through no such group at any step
  (`Flow.consequence_unselected_pool`); with both acts laws, nothing is supplied
  (`act_courses_unselected_pool`). The part may be the pool itself, acting jointly.
* **What selects the act, exactly.** Under the same conditions, a formation that couples the two
  flows apart lies beyond the pool's coupling closure (`Flow.apart_beyond_pool`). A formation
  whose admission the act changes at a step is one: its admission there is a selection through
  the pooled coupling of every group holding it, from that step on, and of no group within the
  closure at any step (`Flow.act_selected_by_pool`). Conversely, where a list holds exactly a
  pool's members and each member's coupling of the two flows is decided, a pool whose selection
  separates the two flows has a member that couples them apart, lying beyond the closure
  (`Flow.separating_member_beyond`).
* **Reading another's law.** Knowing a law is no coupling. Every selection through `a`'s couplings
  is one through `o`'s exactly when whatever `o` couples alike `a` couples alike
  (`Web.anticipates_iff`); where `o` couples two histories alike and `a` does not, some selection
  through `a`'s couplings goes through none of `o`'s (`Web.anticipation_misses`); where the
  coupling is that fine and the law reads through `a`'s, `a` exchanges alike across every step
  under histories `o` couples alike (`ExchangeLaw.Through.anticipated`). Reading `a`'s couplings
  is that fine (`Web.SelectsThrough.read`). What the law does under histories not taken is not
  fixed by a run (`not_fixes_of_untaken`): it is a model.
* **Reading another's couplings.** A formation `o` reads `a`'s couplings where, beside its own,
  it is coupled by level into every condition coupled into `a` (`Web.ReadsCouplings`). Two
  histories `o` then couples alike at a step, `o` and `a` both couple alike there
  (`Web.AlikeThrough.of_reads`), so every selection through the pooled coupling of the two is one
  through `o`'s reading (`Web.SelectsThroughAll.reads`), and a law reading through a coupling
  reads through every larger one (`ExchangeLaw.Through.widen`). `o`'s coupling closure lies
  within the pool's of `o` and `a` (`Flow.withinCoupling_reads`), and is exactly that, the union
  of the two closures, where `a` exchanges with a condition coupled into it
  (`Flow.withinCoupling_reads_iff`; a closure read through another's steps,
  `WithinClosure.of_reads`, `WithinClosureOf.to_reads`). So, with the rest of the exchange
  fixed, a part beyond the pool's closure is selected alike by every selection through `o`'s
  reading (`Flow.unselected_beyond_reads`); with the rest following a law reading through `o`'s
  reading, an act differing only beyond the pool's closure, drawn through both flows, is too
  (`Flow.act_unselected_reads`). Reading another's couplings reaches no further than pooling
  with it.
* **`Clearing`.** The source and the dweller follow one law in the cleared and the spared world,
  reading no level (`Clearing.restLaw`), and the clearer's act differs only on the habitat, which
  nothing within its coupling closure couples into (`Clearing.acts_alike`). So the pool of the
  clearer and its source selects the two worlds alike at every step, the dweller lies beyond the
  clearer's coupling closure, and every pool holding the dweller separates the two worlds through
  its admission at the third step (`Clearing.pool_closes_gap`). The clearer's own part lies within
  its coupling closure, and the clearer couples the levels with and without it alike at every
  step, while the dweller separates them (`Clearing.within_closure_unseparated`): lying within a
  pool's closure does not make a difference separated. The source, reading the clearer's
  couplings, selects the two worlds alike at every step (`Clearing.reading_clearer_unselected`);
  reading the dweller's, it separates them through the dweller's admission at the third step
  (`Clearing.reading_dweller_selects`).

**Readings (the AI's).**
- What a pool can select for or against is bounded by the union of its members' coupling
  closures, and within it by what its members couple apart. Pooling adds exactly the couplings of
  its members, no more: a pool of members within one formation's closure sees no further than
  that formation, and a pool reaches beyond an actor's closure only through a member whose own
  couplings reach there.
- Read for alignment across intelligences: the consequences of an act beyond its actor's coupling
  closure are selected only through a pool that holds a formation coupled into them, such as the
  formation whose support the act changes. Difference among the members is what a pool adds: a
  pool whose members all couple alike what one member couples alike selects no more than that
  member.
- Read for oversight: an overseer reading a system's internal states, read as conditions the
  system couples into, pools with the system. What the system's own act does beyond its coupling
  closure, and beyond the overseer's, no reading of the system separates; it is separated by
  reading a formation the act reaches, as reading the dweller does in `Clearing`.

What is not derived: which formations pool, how a pool forms, lasts or resists capture; which law
the rest follows, or that it reads through coupling (a hypothesis wherever it enters, as in
`Becoming.SelectionGap`); balance; that a selection goes through a pool's coupling at all
(supplied as `Web.SelectsThroughAll`); that a pool's selection corrects anything, which is
selection, not response; which conditions a reader can read, and that a system's internal states
are conditions coupled into it (a correspondence, supplied); reading a formation's law, how it
would exchange under histories not taken, rather than the levels of the conditions it couples
into. The converse direction of a pool separating only what some member
separates takes the members as listed and each member's coupling of the two histories as decided,
hypotheses named where they enter. The selections here are of level histories up to a step; no
law is stated of a claim about every later step, such as a formation's ending. The representation
commits to discrete steps and natural amounts. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}


/-! ## What a pool separates -/

namespace Web

variable {W : Web F C} {obs : F → C → Prop} {group : F → Prop} {g x : F}
  {l l' : Nat → C → Nat} {t : Nat}

/-- The histories every member couples alike with `l` up to `t` form a selection through the
pooled coupling. -/
theorem pooledClass_selects :
    W.SelectsThroughAll obs group t (fun m => W.AlikeThroughAll obs group l m t) :=
  fun _ _ alike => ⟨fun first => first.trans alike, fun second => second.trans alike.symm⟩

/-- **A pool separates exactly what its members do not all couple alike.** Some selection through
the pooled coupling up to `t` holds at `l` and fails at `l'` exactly when not every member couples
them alike up to `t`. -/
theorem separates_all_iff :
    (∃ select, W.SelectsThroughAll obs group t select ∧ select l ∧ ¬ select l') ↔
      ¬ W.AlikeThroughAll obs group l l' t :=
  ⟨fun ⟨_, through, holds, fails⟩ alike => fails ((through l l' alike).mp holds),
   separates_all⟩

/-- **A member's separation is the pool's.** Where a member couples two histories apart up to `t`,
its class, a selection through its own coupling, is a selection through the pooled coupling that
holds at the first and fails at the second. -/
theorem member_separates_all (member : group g) (differ : ¬ W.AlikeThroughUpTo obs g l l' t) :
    ∃ select, W.SelectsThrough obs g t select ∧ W.SelectsThroughAll obs group t select ∧
      select l ∧ ¬ select l' :=
  ⟨W.ClassThrough obs g l t, class_selects, SelectsThrough.all member class_selects,
   fun s _ => AlikeThrough.refl s, differ⟩

/-- **A pool separates exactly what some member separates, the members listed and decided.**
Where a list holds exactly the members, and whether each couples `l` and `l'` alike up to `t` is
decided, some selection through the pooled coupling separates them exactly when some member
couples them apart. -/
theorem separates_all_iff_member {members : List F} (listed : ∀ g, group g ↔ g ∈ members)
    (decided : ∀ g, g ∈ members → Decided (W.AlikeThroughUpTo obs g l l' t)) :
    (∃ select, W.SelectsThroughAll obs group t select ∧ select l ∧ ¬ select l') ↔
      ∃ g, group g ∧ ¬ W.AlikeThroughUpTo obs g l l' t :=
  ⟨fun separated =>
    match Decided.exists_not_in decided (fun all => separates_all_iff.mp separated
        fun g member => all g ((listed g).mp member)) with
    | ⟨g, mem, differ⟩ => ⟨g, (listed g).mpr mem, differ⟩,
   fun ⟨_, member, differ⟩ => match member_separates_all member differ with
    | ⟨select, _, through, holds, fails⟩ => ⟨select, through, holds, fails⟩⟩

/-- **A formation whose admission differs separates through every pool holding it.** Where `x` is
admitted at step `s` under one history and not under the other, its admission at `s` is a
selection through the pooled coupling of every group holding it, at every step from `s` on, and
the members do not all couple the two histories alike. -/
theorem admission_separates_all (member : group x) {s : Nat} (le : s ≤ t)
    (differs : ¬ (W.Admits (l s) s x ↔ W.Admits (l' s) s x)) :
    W.SelectsThroughAll obs group t (fun m => W.Admits (m s) s x) ∧
      ¬ W.AlikeThroughAll obs group l l' t :=
  ⟨SelectsThrough.all member (admits_through le), fun alike => differs (alike x member s le).1⟩

/-- **When one member's couplings are the pool's.** For a member `g`, the selections through the
pooled coupling up to `t` are exactly those through `g`'s coupling when, and only when, whatever
`g` couples alike up to `t` every member couples alike. -/
theorem pooled_iff_member (member : group g) :
    (∀ select, W.SelectsThroughAll obs group t select ↔ W.SelectsThrough obs g t select) ↔
      ∀ l l', W.AlikeThroughUpTo obs g l l' t → W.AlikeThroughAll obs group l l' t :=
  ⟨fun same l l' alike =>
    ((same _).mp (pooledClass_selects (l := l)) l l' alike).mp (AlikeThroughAll.refl t),
   fun finest _ => ⟨fun through l l' alike => through l l' (finest l l' alike),
     SelectsThrough.all member⟩⟩

/-- **Difference is what a pool adds.** Where `g` couples two histories alike up to `t` and the
members do not all, some selection through the pooled coupling is through no coupling of `g`'s up
to `t`. -/
theorem pool_adds (alike : W.AlikeThroughUpTo obs g l l' t)
    (differ : ¬ W.AlikeThroughAll obs group l l' t) :
    ∃ select, W.SelectsThroughAll obs group t select ∧ ¬ W.SelectsThrough obs g t select :=
  ⟨fun m => W.AlikeThroughAll obs group l m t, pooledClass_selects,
   fun through => differ ((through l l' alike).mp (AlikeThroughAll.refl t))⟩

end Web

/-! ## Blind beyond a pool's coupling closure -/

namespace Flow

variable {L L' : Flow F C} {W W' : Web F C} {obs : F → C → Prop} {part : F → Bool}
  {group : F → Prop} {select : (Nat → C → Nat) → Prop}

/-- **The act differs only beyond a pool's coupling closure.** In the two flows the part
exchanges alike with every condition a member of the pool's coupling closure, drawn through both
flows, couples into. -/
def ActsAlikeOnPoolCoupled (L L' : Flow F C) (W : Web F C) (obs : F → C → Prop)
    (part : F → Bool) (group : F → Prop) : Prop :=
  ∀ h, part h = true → ∀ t c,
    (∃ g, WithinClosureOf (L.CoupledFromEither W L' obs) group g ∧ W.CoupledInto obs g c) →
      L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c

/-- An act differing only beyond a pool's coupling closure acts alike within each member's. -/
theorem ActsAlikeOnPoolCoupled.within (acts : L.ActsAlikeOnPoolCoupled L' W obs part group)
    {f : F} (member : group f) : L.ActsAlikeWithin L' W W' obs part f :=
  ActsAlikeOnCoupled.within fun h inPart t c ⟨g, within, couples⟩ =>
    acts h inPart t c ⟨g, WithinClosureOf.of_member member within, couples⟩

end Flow

/-! ## The gap for a pool's act -/

section PoolGap

variable {law : ExchangeLaw F C} {L L' : Flow F C} {W W' : Web F C} {obs : F → C → Prop}
  {part : F → Bool} {group : F → Prop} {select : (Nat → C → Nat) → Prop}

/-- **Within a pool's coupling closure the act makes no difference.** The rest follows one law of
exchange reading through coupling in two balanced flows with the same formations present,
starting alike, and the part acts alike within each member's coupling closure drawn through both
flows. Then each formation within the pool's coupling closure couples the two flows' levels
alike at every step: `Flow.act_unselected` for the member whose closure holds it. -/
theorem Flow.act_alike_pool (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → L.ActsAlikeWithin L' W W' obs part f) :
    ∀ g, WithinClosureOf (L.CoupledFromEither W L' obs) group g →
      ∀ t, W.AlikeThroughUpTo obs g W.level W'.level t :=
  fun _ within _ => match withinClosureOf_iff.mp within with
  | ⟨f, inGroup, inside⟩ => Web.selects_alike_iff.mp fun _ selectsThrough =>
      Flow.act_unselected through follows follows' balances balances' present start
        (acts f inGroup) inside selectsThrough

/-- **The gap for a pool's act.** Under the conditions of `Flow.act_alike_pool`, every selection
through the pooled coupling of any group within the pool's coupling closure, the pool among them,
selects the two flows' levels alike. The part may be the pool itself, acting jointly. -/
theorem Flow.act_unselected_pool (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → L.ActsAlikeWithin L' W W' obs part f) {pool : F → Prop}
    (members : ∀ g, pool g → WithinClosureOf (L.CoupledFromEither W L' obs) group g) {t : Nat}
    (selects : W.SelectsThroughAll obs pool t select) : select W.level ↔ select W'.level :=
  selects _ _ fun g member => Flow.act_alike_pool through follows follows' balances balances'
    present start acts g (members g member) t

/-- **A consequence of a pool's act is selected through no group within its closure.** Under the
conditions of `Flow.act_unselected_pool`, a selection holding with the act and failing without it
is, at no step, a selection through the pooled coupling of any group within the pool's coupling
closure. -/
theorem Flow.consequence_unselected_pool (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → L.ActsAlikeWithin L' W W' obs part f)
    (holds : select W.level) (fails : ¬ select W'.level) {pool : F → Prop}
    (members : ∀ g, pool g → WithinClosureOf (L.CoupledFromEither W L' obs) group g) (t : Nat) :
    ¬ W.SelectsThroughAll obs pool t select :=
  fun selects => fails ((Flow.act_unselected_pool through follows follows' balances balances'
    present start acts members selects).mp holds)

/-- **Only a formation beyond the pool's closure couples the act apart.** Under the conditions of
`Flow.act_alike_pool`, a formation that couples the two flows apart up to some step lies beyond
the pool's coupling closure drawn through both flows. -/
theorem Flow.apart_beyond_pool (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → L.ActsAlikeWithin L' W W' obs part f) {g : F} {t : Nat}
    (apart : ¬ W.AlikeThroughUpTo obs g W.level W'.level t) :
    ¬ WithinClosureOf (L.CoupledFromEither W L' obs) group g :=
  fun within => apart (Flow.act_alike_pool through follows follows' balances balances' present
    start acts g within t)

/-- **A pool selects the act only through a member beyond the closure.** Under the conditions of
`Flow.act_alike_pool`, let a list hold exactly the members of a pool, and let it be decided
whether each couples the two flows alike up to `t`. Where some selection through the pool's
pooled coupling up to `t` holds at one flow and fails at the other, some member couples the two
apart, and that member lies beyond the acting pool's coupling closure drawn through both flows. -/
theorem Flow.separating_member_beyond (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → L.ActsAlikeWithin L' W W' obs part f) {pool : F → Prop}
    {members : List F} (listed : ∀ g, pool g ↔ g ∈ members) {t : Nat}
    (decided : ∀ g, g ∈ members → Decided (W.AlikeThroughUpTo obs g W.level W'.level t))
    (separated : ∃ select, W.SelectsThroughAll obs pool t select ∧ select W.level ∧
      ¬ select W'.level) :
    ∃ g, pool g ∧ ¬ W.AlikeThroughUpTo obs g W.level W'.level t ∧
      ¬ WithinClosureOf (L.CoupledFromEither W L' obs) group g :=
  match (Web.separates_all_iff_member listed decided).mp separated with
  | ⟨g, member, apart⟩ => ⟨g, member, apart, Flow.apart_beyond_pool through follows follows'
      balances balances' present start acts apart⟩

/-- **Pooling with the formation whose admission an act changes selects the act.** Under the
conditions of `Flow.act_unselected_pool`, let the act change `x`'s admission at step `s`. Then
`x` lies beyond the pool's coupling closure drawn through both flows; its admission at `s` is a
selection through the pooled coupling of every group holding `x`, at every step from `s` on; and
it is a selection through the pooled coupling of no group within the pool's closure, at any
step. -/
theorem Flow.act_selected_by_pool (through : law.Through W obs part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : ∀ f, group f → L.ActsAlikeWithin L' W W' obs part f) {x : F} {s : Nat}
    (differs : ¬ (W.Admits (W.level s) s x ↔ W.Admits (W'.level s) s x)) :
    ¬ WithinClosureOf (L.CoupledFromEither W L' obs) group x ∧
      (∀ pool : F → Prop, pool x → ∀ t, s ≤ t →
        W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x)) ∧
      ∀ pool : F → Prop,
        (∀ g, pool g → WithinClosureOf (L.CoupledFromEither W L' obs) group g) →
        ∀ t, ¬ W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x) :=
  have unselected : ∀ pool : F → Prop,
      (∀ g, pool g → WithinClosureOf (L.CoupledFromEither W L' obs) group g) →
      ∀ t, ¬ W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x) :=
    fun _ members _ selects => differs (Flow.act_unselected_pool through follows follows' balances
      balances' present start acts members selects)
  ⟨Flow.apart_beyond_pool through follows follows' balances balances' present start acts
      (t := s) fun alike => differs (alike s (Nat.le_refl s)).1,
   fun _ member _ le => Web.SelectsThrough.all member (Web.admits_through le),
   unselected⟩

/-- **With both acts laws, nothing is supplied, for a pool.** The part acts by `act` or by `act'`,
laws of what has stood, `act` reading through its members' coupling, the two agreeing on every
condition coupled into the pool's coupling closure drawn through the two courses; the rest
follows a law of what has stood reading through coupling; both courses are feasible. Then every
selection through the pooled coupling of any group within the pool's closure selects the levels
of the two courses alike. -/
theorem act_courses_unselected_pool {act act' : ExchangeLaw F C} {present : Nat → List F}
    {start : C → Nat} (na : law.Nonanticipating) (naAct : act.Nonanticipating)
    (naAct' : act'.Nonanticipating) (through : law.Through W obs part)
    (actThrough : act.Through W obs (fun h => !part h))
    (feasible : (law.withAct part act).Feasible present start)
    (feasible' : (law.withAct part act').Feasible present start)
    (agree : ∀ t h l c, part h = true →
      (∃ g, WithinClosureOf (((law.withAct part act).course present start).CoupledFromEither W
          ((law.withAct part act').course present start) obs) group g ∧ W.CoupledInto obs g c) →
        act.take t h l c = act'.take t h l c ∧ act.give t h l c = act'.give t h l c)
    {pool : F → Prop}
    (members : ∀ g, pool g → WithinClosureOf (((law.withAct part act).course present
      start).CoupledFromEither W ((law.withAct part act').course present start) obs) group g)
    {t : Nat} (selects : W.SelectsThroughAll obs pool t select) :
    select ((law.withAct part act).levels present start) ↔
      select ((law.withAct part act').levels present start) :=
  have alike : ∀ g, pool g →
      W.AlikeThroughUpTo obs g ((law.withAct part act).levels present start)
        ((law.withAct part act').levels present start) t :=
    fun g member => match withinClosureOf_iff.mp (members g member) with
    | ⟨_, inGroup, within⟩ => Web.selects_alike_iff.mp fun _ selectsThrough =>
        act_courses_unselected na naAct naAct' through actThrough feasible feasible'
          (fun t h l c inPart ⟨g', within', couples⟩ =>
            agree t h l c inPart ⟨g', WithinClosureOf.of_member inGroup within', couples⟩)
          within selectsThrough
  selects _ _ alike

end PoolGap

/-! ## Reading another's couplings -/

namespace Web

/-- `o` reads `a`'s couplings: beside the coupling by level `obs`, `o` is coupled by level into
every condition coupled into `a`, by threshold or by level. -/
def ReadsCouplings (W : Web F C) (obs : F → C → Prop) (o a : F) : F → C → Prop :=
  fun g c => obs g c ∨ (g = o ∧ W.CoupledInto obs a c)

variable {W : Web F C} {obs : F → C → Prop} {o a : F} {l l' : Nat → C → Nat} {t : Nat}
  {select : (Nat → C → Nat) → Prop}

/-- **What the reader couples alike, both couple alike.** Two histories alike at a step through
`o`'s couplings, `o` reading `a`'s, are alike there through `o`'s own couplings and through `a`'s:
`a`'s admission is fixed by the levels of what it requires, which `o` reads. -/
theorem AlikeThrough.of_reads (alike : W.AlikeThrough (W.ReadsCouplings obs o a) o l l' t) :
    W.AlikeThrough obs o l l' t ∧ W.AlikeThrough obs a l l' t :=
  have same : ∀ c, W.CoupledInto obs a c → l t c = l' t c :=
    fun c couples => alike.2 c (.inr ⟨rfl, couples⟩)
  ⟨⟨alike.1, fun c observed => alike.2 c (.inl observed)⟩,
   ⟨⟨fun admits c requires => Nat.le_trans (admits c requires)
       (Nat.le_of_eq (same c (.inl ⟨t, requires⟩))),
     fun admits c requires => Nat.le_trans (admits c requires)
       (Nat.le_of_eq (same c (.inl ⟨t, requires⟩)).symm)⟩,
    fun c observed => same c (.inr observed)⟩⟩

/-- **Reading another's couplings pools them.** Every selection through the pooled coupling of `o`
and `a` is a selection through `o`'s couplings with `o` reading `a`'s: what the pool separates,
the reader separates. -/
theorem SelectsThroughAll.reads
    (through : W.SelectsThroughAll obs (fun x => x = o ∨ x = a) t select) :
    W.SelectsThrough (W.ReadsCouplings obs o a) o t select :=
  fun l l' alike => through l l' fun _ member s le => match member with
    | .inl same => same ▸ (AlikeThrough.of_reads (alike s le)).1
    | .inr same => same ▸ (AlikeThrough.of_reads (alike s le)).2

/-- **Anticipating another's selections is coupling as finely.** Every selection through `a`'s
couplings up to `t` is one through `o`'s, under any coupling by level `obs'` for `o`, exactly when
whatever `o` couples alike up to `t` `a` couples alike. Knowing a law is no coupling: what `o` can
anticipate of `a`, under any law reading through `a`'s couplings, is fixed by this
(`Revision.web_keeps_iff` is the case of one formation at two steps). -/
theorem anticipates_iff {obs' : F → C → Prop} :
    (∀ select, W.SelectsThrough obs a t select → W.SelectsThrough obs' o t select) ↔
      ∀ l l', W.AlikeThroughUpTo obs' o l l' t → W.AlikeThroughUpTo obs a l l' t :=
  ⟨fun every l l' alike =>
    ((every (W.ClassThrough obs a l t) class_selects) l l' alike).mp fun s _ => AlikeThrough.refl s,
   fun finer _ through l l' alike => through l l' (finer l l' alike)⟩

/-- **A coarser reader misses one of the other's selections.** Where `o` couples two histories
alike up to `t` and `a` does not, the class alike through `a` is a selection through `a`'s
couplings and through no coupling of `o`'s up to `t`, whatever `o` knows of `a`'s law. -/
theorem anticipation_misses {obs' : F → C → Prop} (alike : W.AlikeThroughUpTo obs' o l l' t)
    (differ : ¬ W.AlikeThroughUpTo obs a l l' t) :
    ∃ select, W.SelectsThrough obs a t select ∧ ¬ W.SelectsThrough obs' o t select :=
  ⟨W.ClassThrough obs a l t, class_selects,
   fun through => differ ((through l l' alike).mp fun s _ => AlikeThrough.refl s)⟩

/-- **Reading another's couplings anticipates every selection through them.** -/
theorem SelectsThrough.read (through : W.SelectsThrough obs a t select) :
    W.SelectsThrough (W.ReadsCouplings obs o a) o t select :=
  anticipates_iff.mpr (fun _ _ alike s le => (AlikeThrough.of_reads (alike s le)).2) select
    through

end Web

/-- A law reading through a coupling reads through every coupling holding it. -/
theorem ExchangeLaw.Through.widen {law : ExchangeLaw F C} {W : Web F C}
    {obs obs' : F → C → Prop} {part : F → Bool} (larger : ∀ g c, obs g c → obs' g c)
    (through : law.Through W obs part) : law.Through W obs' part :=
  fun h outside t l l' alike => through h outside t l l' (alike.of_obs larger)

/-- **Another's acts are anticipated where its coupling is.** Where the law reads through the
coupling of `a`, outside the part, and whatever `o` couples alike up to `t` `a` couples alike,
`a` exchanges alike across every step up to `t` under two histories `o` couples alike up to `t`:
with the law, `o` anticipates `a`'s acts. -/
theorem ExchangeLaw.Through.anticipated {law : ExchangeLaw F C} {W : Web F C}
    {obs obs' : F → C → Prop} {part : F → Bool} {o a : F} {l l' : Nat → C → Nat} {t : Nat}
    (through : law.Through W obs part) (outside : part a = false)
    (finer : ∀ m m', W.AlikeThroughUpTo obs' o m m' t → W.AlikeThroughUpTo obs a m m' t)
    (alike : W.AlikeThroughUpTo obs' o l l' t) : ∀ s, s ≤ t → law.GivesAlike s a l l' :=
  fun _ le => through a outside _ l l' ((finer l l' alike).earlier le)

/-- **A closure read through another's steps is the pool's.** Where every step of `rel'` is a step
of `rel`, or a step of `rel` from `a` taken at `o`, what lies within `o`'s closure under `rel'`
lies within the closure of `o` and `a` under `rel`. -/
theorem WithinClosure.of_reads {rel rel' : F → F → Prop} {o a g : F}
    (split : ∀ g h, rel' g h → rel g h ∨ (g = o ∧ rel a h))
    (within : WithinClosure rel' o g) : WithinClosureOf rel (fun x => x = o ∨ x = a) g :=
  within _ (fun g h inside related => match split g h related with
      | .inl step => closedUnder_withinClosureOf g h inside step
      | .inr ⟨_, step⟩ => closedUnder_withinClosureOf a h
          (WithinClosureOf.of_member (.inr rfl) (WithinClosure.refl a)) step)
    (WithinClosureOf.of_member (.inl rfl) (WithinClosure.refl o))

/-- Conversely, where `rel'` holds `rel` and `o` reaches `a` under it, the closure of `o` and `a`
under `rel` lies within `o`'s under `rel'`. -/
theorem WithinClosureOf.to_reads {rel rel' : F → F → Prop} {o a g : F}
    (larger : ∀ g h, rel g h → rel' g h) (reaches : WithinClosure rel' o a)
    (within : WithinClosureOf rel (fun x => x = o ∨ x = a) g) : WithinClosure rel' o g :=
  match withinClosureOf_iff.mp within with
  | ⟨_, .inl same, inside⟩ => same ▸ WithinClosure.mono larger inside
  | ⟨_, .inr same, inside⟩ => reaches.trans (same ▸ WithinClosure.mono larger inside)

namespace Flow

variable {L L' : Flow F C} {W W' : Web F C} {obs : F → C → Prop} {o a : F}

/-- What affects `g` through its couplings, `o` reading `a`'s, affects `g` through its own, or `g`
is `o` and it affects `a` through `a`'s. -/
theorem CoupledFrom.of_reads {g h : F}
    (related : L.CoupledFrom W (W.ReadsCouplings obs o a) g h) :
    L.CoupledFrom W obs g h ∨ (g = o ∧ L.CoupledFrom W obs a h) :=
  match related with
  | ⟨c, .inl depends, exchanges⟩ => .inl ⟨c, .inl depends, exchanges⟩
  | ⟨c, .inr (.inl observed), exchanges⟩ => .inl ⟨c, .inr observed, exchanges⟩
  | ⟨c, .inr (.inr ⟨same, couples⟩), exchanges⟩ => .inr ⟨same, c, couples, exchanges⟩

/-- `o`'s coupling closure, `o` reading `a`'s couplings, lies within the pool's of `o` and `a`. -/
theorem withinCoupling_reads {g : F}
    (within : L.WithinCoupling W (W.ReadsCouplings obs o a) o g) :
    L.WithinPoolCoupling W obs (fun x => x = o ∨ x = a) g :=
  WithinClosure.of_reads (fun _ _ related => CoupledFrom.of_reads related) within

/-- **Reading another's couplings joins its coupling closure.** Where `a` exchanges with a
condition coupled into it, `o`'s coupling closure with `o` reading `a`'s couplings is exactly the
pool's coupling closure of `o` and `a`, the union of their closures. -/
theorem withinCoupling_reads_iff (acts : ∃ c, W.CoupledInto obs a c ∧ L.Exchanges a c) {g : F} :
    L.WithinCoupling W (W.ReadsCouplings obs o a) o g ↔
      L.WithinPoolCoupling W obs (fun x => x = o ∨ x = a) g :=
  ⟨withinCoupling_reads,
   WithinClosureOf.to_reads
    (fun _ _ ⟨c, couples, exchanges⟩ => ⟨c, couples.imp id .inl, exchanges⟩)
    (match acts with
      | ⟨c, couples, exchanges⟩ => WithinClosure.of_rel ⟨c, .inr (.inr ⟨rfl, couples⟩), exchanges⟩)⟩

/-- **A reader is blind beyond the pool's closure.** With the rest of the exchange fixed, where
every member of a part lies beyond the pool's coupling closure of `o` and `a`, every selection
through `o`'s couplings, `o` reading `a`'s, selects the levels with and without the part alike:
reading `a`'s couplings reaches no further than pooling with `a`. -/
theorem unselected_beyond_reads {part : F → Bool} {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l)
    (balanced : ∀ t g c, L.WithinPoolCoupling W obs (fun x => x = o ∨ x = a) g →
      W.CoupledInto obs g c → L.BalancesOn W [c] t)
    (beyond : ∀ h, part h = true → ¬ L.WithinPoolCoupling W obs (fun x => x = o ∨ x = a) h)
    {t : Nat} {select : (Nat → C → Nat) → Prop}
    (through : W.SelectsThrough (W.ReadsCouplings obs o a) o t select) :
    select W.level ↔ select l :=
  unselected_beyond_coupling without
    (fun t g c within couples => match couples with
      | .inl depends => balanced t g c (withinCoupling_reads within) (.inl depends)
      | .inr (.inl observed) => balanced t g c (withinCoupling_reads within) (.inr observed)
      | .inr (.inr ⟨_, coupled⟩) => balanced t a c
          (WithinClosureOf.of_member (.inr rfl) (WithinClosure.refl a)) coupled)
    (fun h inPart within => beyond h inPart (withinCoupling_reads within))
    (WithinClosure.refl o) through

end Flow

section Reading

variable {law : ExchangeLaw F C} {L L' : Flow F C} {W W' : Web F C} {obs : F → C → Prop}
  {part : F → Bool} {o a : F} {select : (Nat → C → Nat) → Prop}

/-- **A reader misses an act beyond both closures.** Let the rest follow one law reading through
the couplings with `o` reading `a`'s (a law reading through `obs` does, `ExchangeLaw.Through.widen`),
in two balanced flows with the same formations present, starting alike, and let the part's act
differ only beyond the pool's coupling closure of `o` and `a`, drawn through both flows. Then every
selection through `o`'s couplings, `o` reading `a`'s, selects the two flows alike. -/
theorem Flow.act_unselected_reads (through : law.Through W (W.ReadsCouplings obs o a) part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (start : ∀ c, W.level 0 c = W'.level 0 c)
    (acts : L.ActsAlikeOnPoolCoupled L' W obs part (fun x => x = o ∨ x = a))
    {t : Nat} (selects : W.SelectsThrough (W.ReadsCouplings obs o a) o t select) :
    select W.level ↔ select W'.level :=
  Flow.act_unselected_of_coupled through follows follows' balances balances' present start
    (fun h inPart t c ⟨g, within, couples⟩ =>
      have pooled : WithinClosureOf (L.CoupledFromEither W L' obs) (fun x => x = o ∨ x = a) g :=
        WithinClosure.of_reads (fun _ _ related => match related with
          | .inl step => (Flow.CoupledFrom.of_reads step).imp .inl fun ⟨same, s⟩ => ⟨same, .inl s⟩
          | .inr step => (Flow.CoupledFrom.of_reads step).imp .inr fun ⟨same, s⟩ => ⟨same, .inr s⟩)
          within
      match couples with
      | .inl depends => acts h inPart t c ⟨g, pooled, .inl depends⟩
      | .inr (.inl observed) => acts h inPart t c ⟨g, pooled, .inr observed⟩
      | .inr (.inr ⟨_, coupled⟩) => acts h inPart t c
          ⟨a, WithinClosureOf.of_member (.inr rfl) (WithinClosure.refl a), coupled⟩)
    (WithinClosure.refl o) selects

end Reading

/-! ## Witness: pooling with the dweller in `Clearing` -/

namespace Clearing

/-- The law the source and the dweller follow in the cleared and the spared world: each exchanges
as in the clearing flow, reading no level. -/
def restLaw : ExchangeLaw Formation Place :=
  ⟨fun t f _ c => flow.take t f c, fun t f _ c => flow.give t f c⟩

/-- The rest's law reads no level, so it reads through every coupling. -/
theorem restLaw_through : restLaw.Through web thresholdOnly clearerPart :=
  fun _ _ _ _ _ _ _ => ⟨rfl, rfl⟩

/-- In the cleared world the source and the dweller follow the rest's law. -/
theorem rest_follows : flow.Follows restLaw clearerPart web.level :=
  fun _ _ _ _ => ⟨rfl, rfl⟩

/-- In the spared world they follow it too. -/
theorem rest_follows_spared : sparedFlow.Follows restLaw clearerPart sparedWeb.level
  | .source, _, _, _ => ⟨rfl, rfl⟩
  | .dweller, _, _, _ => ⟨rfl, rfl⟩
  | .clearer, no, _, _ => nomatch no

/-- The two worlds start alike. -/
theorem start_alike : ∀ c, web.level 0 c = sparedWeb.level 0 c
  | .resource => rfl
  | .habitat => rfl
  | .fuel _ => rfl

/-- The clearer's side is closed under being affected through what is coupled into, in either
world. -/
theorem clearerSide_closed_either :
    ClosedUnder (flow.CoupledFromEither web sparedFlow thresholdOnly) clearerSide :=
  fun g h member related => match related with
  | .inl coupled => clearerSide_closed flow (fun _ => ⟨rfl, rfl⟩) g h member coupled
  | .inr coupled => clearerSide_closed sparedFlow (fun _ => ⟨rfl, rfl⟩) g h member coupled

/-- The clearer's act differs only beyond its coupling closure, drawn through both worlds: within
the closure only the resource is coupled into, and the clearer takes it alike in both. -/
theorem acts_alike : flow.ActsAlikeOnCoupled sparedFlow web thresholdOnly clearerPart .clearer
  | .clearer, _, _, c, ⟨_, within, couples⟩ =>
    match c, couples_resource (within clearerSide clearerSide_closed_either trivial) couples with
    | _, rfl => ⟨rfl, rfl⟩
  | .source, no, _, _, _ => nomatch no
  | .dweller, no, _, _, _ => nomatch no

/-- The source lies within the clearer's coupling closure, drawn through both worlds: it gives to
the resource the clearer depends on. -/
theorem source_within :
    WithinClosure (flow.CoupledFromEither web sparedFlow thresholdOnly) .clearer .source :=
  WithinClosure.of_rel
    (.inl ⟨.resource, .inl ⟨0, trivial⟩, 0, .head _, .inr Nat.zero_lt_one⟩)

/-- **Pooling with the dweller closes the gap.** The source and the dweller follow one law in the
cleared and the spared world, reading no level, and the clearer's act differs only beyond its
coupling closure. So every selection through the pooled coupling of the clearer and its source
selects the two worlds alike at every step (`Flow.act_unselected_pool`). The dweller, whose
admission the act changes at the third step, lies beyond the clearer's coupling closure; its
admission there is a selection through the pooled coupling of every group holding it, from the
third step on, holding in the spared world and failing in the cleared one, and through the pooled
coupling of no group within the clearer's closure (`Flow.act_selected_by_pool`). -/
theorem pool_closes_gap :
    (∀ t select, web.SelectsThroughAll thresholdOnly clearerSide t select →
        (select web.level ↔ select sparedWeb.level)) ∧
      ¬ WithinClosure (flow.CoupledFromEither web sparedFlow thresholdOnly) .clearer .dweller ∧
      (∀ pool : Formation → Prop, pool .dweller → ∀ t, 2 ≤ t →
        web.SelectsThroughAll thresholdOnly pool t (fun l => web.Admits (l 2) 2 .dweller)) ∧
      web.Admits (sparedWeb.level 2) 2 .dweller ∧ ¬ web.Admits (web.level 2) 2 .dweller ∧
      ∀ pool : Formation → Prop,
        (∀ g, pool g → WithinClosure (flow.CoupledFromEither web sparedFlow thresholdOnly)
          .clearer g) →
        ∀ t, ¬ web.SelectsThroughAll thresholdOnly pool t
          (fun l => web.Admits (l 2) 2 .dweller) :=
  have acts : ∀ f, (fun x => x = Formation.clearer) f →
      flow.ActsAlikeWithin sparedFlow web sparedWeb thresholdOnly clearerPart f :=
    fun f same => match f, same with
    | _, rfl => acts_alike.within
  have selected := Flow.act_selected_by_pool restLaw_through rest_follows rest_follows_spared
    balances spared_balances (fun _ => rfl) start_alike acts (x := .dweller) (s := 2)
    (fun same => unsupported_with 0 (same.mpr dweller_spared))
  ⟨fun _ _ selects => Flow.act_unselected_pool restLaw_through rest_follows rest_follows_spared
      balances spared_balances (fun _ => rfl) start_alike acts
      (fun g member => match g, member with
        | .source, _ => WithinClosureOf.of_member rfl source_within
        | .clearer, _ => WithinClosureOf.of_member rfl (WithinClosure.refl _)
        | .dweller, no => nomatch no)
      selects,
   fun within => selected.1 (withinClosureOf_single.mpr within),
   selected.2.1, dweller_spared, unsupported_with 0,
   fun pool members => selected.2.2 pool fun g member =>
     withinClosureOf_single.mpr (members g member)⟩

/-- The clearer couples the levels with and without its own part alike at every step: its
resource stands at its need or above in both. -/
theorem withheld_alike_for_clearer (t : Nat) :
    web.AlikeThroughUpTo thresholdOnly .clearer web.level withheldLevel t :=
  fun s _ => ⟨⟨fun _ c requires => (match c, requires with
      | .resource, _ => Nat.le_add_left 1 s
      | .habitat, no => (nomatch no)
      | .fuel _, no => (nomatch no)),
    fun _ c requires => (match c, requires with
      | .resource, _ => Nat.le_refl 1
      | .habitat, no => (nomatch no)
      | .fuel _, no => (nomatch no))⟩, fun _ no => False.elim no⟩

/-- **Within the closure, not thereby separated.** The clearer's part lies within the clearer's
coupling closure, and every selection through the clearer's coupling selects the levels with and
without the part alike at every step. The dweller's admission at the third step separates them:
it is a selection through the pooled coupling of every group holding the dweller, from the third
step on, whose members do not all couple the two alike. A pool is blind beyond its coupling
closure (`Flow.unselected_beyond_pool`), and within it wherever its members couple alike. -/
theorem within_closure_unseparated :
    (∀ h, clearerPart h = true → flow.WithinCoupling web thresholdOnly .clearer h) ∧
      (∀ t select, web.SelectsThrough thresholdOnly .clearer t select →
        (select web.level ↔ select withheldLevel)) ∧
      ∀ pool : Formation → Prop, pool .dweller → ∀ t, 2 ≤ t →
        web.SelectsThroughAll thresholdOnly pool t (fun l => web.Admits (l 2) 2 .dweller) ∧
          ¬ web.AlikeThroughAll thresholdOnly pool web.level withheldLevel t :=
  ⟨fun h inPart => (match h, inPart with
    | .clearer, _ => WithinClosure.refl _
    | .source, no => (nomatch no)
    | .dweller, no => (nomatch no)),
   fun t _ through => through _ _ (withheld_alike_for_clearer t),
   fun _ member _ le => Web.admission_separates_all member le
     fun same => unsupported_with 0 (same.mpr (admitted_without withheld 2))⟩

/-- **Reading the actor does not reach what it misses.** The source, reading the clearer's
couplings, follows with the dweller the rest's law, which reads no level, and the clearer's act
differs only on the habitat, which no member of the pool of the source and the clearer couples
into. So every selection through the source's couplings, the source reading the clearer's,
selects the cleared and the spared world alike at every step (`Flow.act_unselected_reads`), while
the dweller is admitted at the third step in the spared world and not in the cleared one. -/
theorem reading_clearer_unselected :
    (∀ t select,
        web.SelectsThrough (web.ReadsCouplings thresholdOnly .source .clearer) .source t select →
          (select web.level ↔ select sparedWeb.level)) ∧
      web.Admits (sparedWeb.level 2) 2 .dweller ∧ ¬ web.Admits (web.level 2) 2 .dweller :=
  ⟨fun _ _ selects => Flow.act_unselected_reads (law := restLaw) (o := .source) (a := .clearer)
      (fun _ _ _ _ _ _ _ => ⟨rfl, rfl⟩)
      rest_follows rest_follows_spared balances spared_balances (fun _ => rfl) start_alike
      (fun h inPart _ c ⟨_, within, couples⟩ => match h, inPart with
        | .clearer, _ =>
          match c, couples_resource (within clearerSide clearerSide_closed_either
              (fun f member => match f, member with
                | .source, _ => trivial
                | .clearer, _ => trivial
                | .dweller, .inl no => (nomatch no)
                | .dweller, .inr no => (nomatch no))) couples with
          | _, rfl => ⟨rfl, rfl⟩
        | .source, no => (nomatch no)
        | .dweller, no => (nomatch no))
      selects,
   dweller_spared, unsupported_with 0⟩

/-- **Reading the formation the act ends separates.** The dweller's admission at the third step is
a selection through the source's couplings with the source reading the dweller's
(`Web.SelectsThroughAll.reads`); it holds in the spared world and fails in the cleared one. -/
theorem reading_dweller_selects :
    web.SelectsThrough (web.ReadsCouplings thresholdOnly .source .dweller) .source 2
        (fun l => web.Admits (l 2) 2 .dweller) ∧
      web.Admits (sparedWeb.level 2) 2 .dweller ∧ ¬ web.Admits (web.level 2) 2 .dweller :=
  ⟨Web.SelectsThroughAll.reads
      (Web.SelectsThrough.all (g := Formation.dweller) (.inr rfl)
        (Web.admits_through (Nat.le_refl 2))),
   dweller_spared, unsupported_with 0⟩

end Clearing

end Becoming
