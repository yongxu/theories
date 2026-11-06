import Becoming.Reproduction
import Becoming.KeepingWidening
import Becoming.Roles
import Becoming.SelectionShift

/-!
# Lineages on the map: generations of descent read on the lineage continuation

`Becoming.SelectionTerm` lists generations of descent in a flow on `Flow X X`
(`SelectionTerm.Flow.Descended`: each listed offspring descends from its parent, giving to what
comes to stand) and `Becoming.Reproduction` bounds them (`Reproduction.Flow.lineage_ends`).
`Becoming.MapInstances` and `Becoming.KeepingWidening` read the map's regions on occurrences
`(t, f)` along a continuation. This module joins the two: it reads a lineage on the map, with
descent as the passing of `Web.withinKind` ("carry on while supported, or pass within a kind"),
the carrier as the fine class (`Web.carrierClass`, a formation's occurrences alike in activity;
read as the organism) and a kind as the
coarse class (`Web.kindClass`). Activity is read at two grains: by the web's own activity (`V := W`, the grain
of `Web.carries_iff`), and by support (`V := W.admitting W.level`, the grain of
`Flow.BeginsAlong.carries_kind_iff`). The two grains differ exactly in what makes a descent a
birth.

* **The lineage continuation.** `descent L W` reads "`f` descends from `g` across the step from
  `t`" as `g` passing to `f`; `continuation L W Q` is `W.withinKind Q (descent L W)`;
  `lineStep L W Q` is its 缘 on occurrences.
* **What a carrying renewal is on a lineage (instances, not results).** From an active parent
  occurrence, at (kind, carrier) and at either grain, a carrying renewal (`«传»`) one step on is
  exactly a step of the continuation within the kind into an active occurrence of a formation
  that did not, at the step before, both stand active and continue as itself (`carries_iff`; at
  the grain of support, `supported_carries_iff`), and such a step is a descent within the kind
  (`carrying_descends`). These are instances of `Becoming.MapInstances`' `Web.carries_iff`: for a
  reflexive kind, a carrying renewal at (kind, carrier) is one at (activity, carrier) along the
  continuation with the kind folded in (`carries_iff_via_base`, a restatement).
* **The join (J1), at the grain of activity.** Where only active formations give
  (`Flow.Acting`), a descent within the kind into a formation active after the step continues
  the lineage at the kind grain (`descent_continues`); where the offspring is embodied
  (`Web.Embodied`: active exactly while it stands as a condition) it is a carrying renewal
  (`descent_carries`), because a formation that comes to stand was not standing, so was not
  active, at the step before. So every listed offspring of a member of `Descended` generations
  born within the kind and embodied is a carrying renewal from its parent one step later
  (`descended_carries`). No premise of newness is used: at this grain a formation fallen to
  zero standing and raised by a gift begins again, and the map counts it as a beginning, since
  `«生»` reads only the step before.
* **The join, at the grain of support.** Where also activity needs support (`Web.Dependent`), a
  descent within the kind into a formation supported after the step continues the lineage
  (`descent_continues_supported`), and from a supported parent such a step is a carrying
  renewal exactly where the offspring was not supported at the step before
  (`supported_carries_iff`; `descent_carries_supported`; for every listed offspring,
  `descended_carries_supported` with `UnsupportedBefore`). First support at `t + 1` from some
  `T ≤ t` (`Web.FirstSupported`) says no more than unsupported at the one step before
  (`firstSupported_iff_step`). So at this grain too a revival of support counts as a birth;
  offspring never supported before (`FirstSupportedOffspring`, first supported from step `0`)
  are more than the join needs (`unsupportedBefore_of_first`). Where every formation is
  supported at every step nothing carries a renewal (`nothing_carries_of_always_supported`).
* **Revivals: a descent need not be a birth.** In the relay at stock one of `Reproduction.Relay`
  (`Reproduction.Relay.relay`; each formation's standing falls to zero and is raised by the
  other's gift; the relay's web counts both active at every step by definition, and both are
  supported throughout, `RelayRead.supported`) each descent continues the lineage at
  both grains and is a carrying renewal at neither (`RelayRead.descent_not_birth`). With
  activity read as standing (`StandingRelay`: the same flow and levels, every formation embodied,
  nothing required) the same course generates (`«生成»`) at the grain of activity and keeps
  (`«守»`), with no carrying renewal, at the grain of support
  (`StandingRelay.grain_decides_region`). That grain of support is vacuous: nothing is required,
  so support holds at every step whether or not a formation stands, and the keep is the keep of
  the reading in which activity never changes. At such a grain the lineage continuation carries
  a dormant formation on: the parent of `OneBirth`, at zero standing from step `1` on, goes on
  (`«延»`) as itself (`OneBirth.dormant_goes_on_at_support`). So the grain decides the
  stock-one cycle's region where support does not track standing.
* **Going on (J2).** Generation follows from a family of occurrences each carrying a renewal
  into the family (`generation_of_carrying`, any relation and classes). On a lineage: where
  every member from step `t` on has a listed offspring, every member at `t` generates at (kind,
  carrier) (`generation_of_reproducing`; at the grain of support with offspring unsupported
  before, `generation_of_reproducing_supported`); read by offspring number (`ByNumber`) with
  exact transmission at every step from `t` on, a member with an offspring at `t` generates
  (`generation_of_exact`), so a positive selection term proper at `t` puts some member of
  generation `t` in generation (`generation_of_positive_term`). That every generation is
  nonempty does not suffice at a point: in `Chain` every generation is nonempty, offspring
  number is transmitted exactly and the term is positive, one member at step `0` generates and
  the other, childless, degenerates (`Chain.chain`). Regions are properties of points.
* **Ending (J2, J3).** Where every continuation of a member's occurrence on the coarse line is a
  member's occurrence (`ContinuationsListed`, the census holding every continuation), everything
  the line from a member reaches is a member's occurrence (`reached_listed`), so an empty
  generation at a step not before the member ends the line on every branch
  (`degeneration_of_empty`, through EL3's `Web.ends_of_ends_at`, of `Becoming.MapInstances`,
  imported through `Becoming.KeepingWidening`).
  Without the census, EL3's law read at the kind grain gives degeneration from the line's own
  reach: from an active occurrence, where nothing the line reaches at a step is active
  (EL3's `Web.kind_every_branch_ends_of_gone`, imported). At the grain of activity every continuation of a member is one
  of its listed offspring (`ContinuationsAreKids`, which gives the census by `listed_of_kids`)
  where every descent within the kind from a member is listed and no member carries on as
  itself (`kids_of_census`, `listed_of_census`). So a lineage within a family balanced and
  dissipated on across each step up to its stock, where the census holds every continuation,
  degenerates (`«退化»`) from every member of a generation up to the stock + 1
  (`degeneration_of_dissipation`, from `Reproduction.Flow.lineage_ends`), at every stock.
  `OneBirth` meets every premise: a parent spends its standing on one offspring, which spends
  its own; the line renews and still ends on every branch (`«新而尽»`, `OneBirth.one_birth`).
  The census premise cannot be dropped: in `Lasting` every premise of `lineage_ends` holds and
  the generation after the first offspring is empty, while that offspring stands on unspent and
  the line goes on (`Lasting.lasting`).
* **A whole generation degenerating is extinction (EL1 (d)), where listed offspring continue
  their parents.** Every law of this paragraph takes `KidsContinue`: each listed offspring's
  occurrence one step on continues its parent's on the coarse line (at the grain of activity
  under `Acting`, births within the kind and embodied offspring, `kids_continue`; at the grain of
  support under `Acting`, `Dependent`, births within the kind and offspring supported after their
  step, `kids_continue_supported`, which `UnsupportedBefore` gives by its first half). Under it a
  member whose occurrence degenerates has, from some depth on, no listed descendant (`line_ends`,
  a lemma of `empty_of_degenerates`, by induction on `«尽»`: each member has finitely many
  offspring, so bounds combine (`common_bound`) and no choice is made). So if every member of
  generation `t` degenerates, some generation from `t` on is empty (`empty_of_degenerates`), with
  no census premise; with the census holding every continuation the converse holds too, and a
  whole generation degenerates exactly where a later generation is empty
  (`generation_degenerates_iff`). Member by member, where every continuation of a member is one
  of its listed offspring (`ContinuationsAreKids`), a member degenerates exactly where at some
  depth it has no listed descendant (`degenerates_iff_line_ends`). These three are the new laws
  of the paragraph (`line_ends` is a lemma of the first); what follows adds the counting of `Becoming.SelectionShift`. Where listed
  offspring continue their parents, nonempty generations from `t` on leave not every member of
  generation `t` degenerating (`not_all_degenerate_of_nonempty`, the constructive half of a
  König-type statement: it puts no member in any region, only rules out that all degenerate).
  From a nonempty generation `t`, a selection term proper positive at every nonempty generation
  from `t` on keeps every later generation nonempty, so it too leaves not every member of
  generation `t` degenerating (`not_all_degenerate_while`, the form that matches (d), from
  `SelectionShift.Generations.never_empties_while`'s counting); positivity at every step from `t`
  on is the special case `not_all_degenerate_of_positive`. Both are corollaries of
  `empty_of_degenerates` with the counting. So, where listed offspring continue their parents, no
  course has a positive term at every nonempty generation while every member of a generation
  degenerates.
* **At a kind grain that separates offspring from parents, (d) as worded holds.** With each
  formation its own kind (`Q := (· = ·)`, a reflexive kind, so `kindClass` is a class), no
  listed offspring continues its parent on the coarse line. In `Courses` with reproduction always
  on, concordance of offspring number with the mark is two at every step while every member of
  every generation degenerates (`Courses.positive_and_degenerate_at_own_kind`), and in `Chain`
  every generation is nonempty while every occurrence degenerates (`Chain.kinds_apart`). So births
  within the kind cannot be dropped from `empty_of_degenerates`, and the impossibility above is a
  law of the kind grain, not of every grain.
* **The witness of evolutionary suicide at the kind grain.** It is positive at every generation
  but the last nonempty one: in `Courses` with reproduction stopping after `H`, concordance of
  offspring number with a mark is positive at every step through `H` (two, by
  `Courses.same_terms_two_fates`), generation `H + 1` is nonempty with both terms zero (as at any
  last nonempty generation, `SelectionShift.Generations.last_term_zero`), every later generation
  is empty, every member of every generation degenerates at (kind, carrier) and the lineage from
  the first marked member renews and still ends (`«新而尽»`), with every premise of the laws above
  met (`Courses.positive_but_last`). A course with the term positive at every step meets the
  premises of `not_all_degenerate_of_positive` (`Courses.positive_throughout`).
* **The same terms through a horizon, two fates (EL1 (a)).** For every horizon `H`, two
  courses of `Descended` generations on `Flow X X`, only active formations giving and every
  formation embodied, have the same families at every step through `H + 1` and the same
  selection terms proper at every step through `H` (concordance two, discordance zero); in one
  the marked line generates (`«生成»`) at (kind, carrier), in the other the lineage
  degenerates (`«退化»`) (`Courses.same_terms_two_fates`). So the terms through a horizon need
  not decide the region (one course of terms for each horizon is shown here). A term positive at
  every step, where listed offspring continue their parents, forbids only that every member of a
  generation degenerates (`not_all_degenerate_of_positive`); it decides no point's region.
* **Counting, imported.** The counting comes from EL1's `Becoming.SelectionShift` and the horizon law
  from EL3's laws in `Becoming.MapInstances` and `Becoming.KeepingWidening`, each imported, so the
  core holds each once.
  `reproducing_of_term`, `nonempty_of_positive` and `nonempty_while` are lemmas: the first reads
  `reproducing_of_selection` as list membership, the other two start `never_empties` and
  `never_empties_while` from a step `t`.

Not shown: that every generation nonempty puts some member of a generation in generation (it asks
to choose, among finitely many offspring, one whose line goes on at every later step, a
König-type choice the core does not give; exact transmission of offspring number is one premise
that makes the choice constructively, and `not_all_degenerate_of_nonempty` is the constructive
half); that a term positive at every step puts any member in any region (it rules out only
that every member of a generation degenerates); a witness of going on that meets balance and
dissipation too; EL1 (a) for every course of selection terms over a horizon on the map
(`Courses.same_terms_two_fates` is one course of terms, positive through the horizon, for each
horizon; the counting form for every course nonempty at the horizon is
`SelectionShift.Horizon.two_fates_of_nonempty`); a suicide witness whose amount draws past the family's gated
renewal (the mark here is a label, not a draw).

Modelling choices: discrete steps; natural-number levels, needs, gifts and offspring numbers;
activity Prop-valued, read either as the web's activity or as support; descent as giving to what
comes to stand on `Flow X X`; generations listed (`SelectionTerm.Generations`), so going on is
read on the listed census and ending needs the census to hold every continuation
(`ContinuationsListed`); finite families as lists, which is what makes the bound of `line_ends`
constructive; kinds supplied as a relation `Q`; formations a fixed index type. In `Courses` a
formation stands only at its own step and each requires its own standing at need one, so
support is standing. An empty axiom report says nothing of these.

Every declaration has an empty axiom report.
-/

namespace Becoming

namespace LineageRegions

universe u

/-! ## Generation from carrying renewals -/

/-- **Generation from a family that carries renewals into itself**: where each member of a family
carries a renewal into a member, every member generates (`«生成»`). Any relation and classes. -/
theorem generation_of_carrying {α : Type u} {R Lc E : «际» α} {S : α → Prop}
    (carries : ∀ z, S z → ∃ w, S w ∧ «传» R Lc E z w) {x : α} (sx : S x) : «生成» R Lc E x :=
  ⟨S, sx, fun z sz => match carries z sz with | ⟨w, sw, c⟩ => ⟨w, sw, c.1⟩,
   fun z sz => match carries z sz with | ⟨w, sw, c⟩ => ⟨z, w, sz, sw, .inl rfl, c⟩⟩

/-! ## The lineage continuation -/

variable {X : Type}

/-- **Descent read as passing**: across the step from `t`, `g` passes to `f` where `f` descends
from `g` (`Flow.DescendsAt`: `g` takes part, gives to `f`, and `f` comes to stand). -/
def descent (L : Flow X X) (W : Web X X) : Nat → X → X → Prop :=
  fun t g f => L.DescendsAt W t f g

/-- **The lineage continuation**: across the step from `t`, `f` continues `g` where `g` is
supported and carries on as `f`, or `f` descends from `g` within the kind `Q` (`Web.withinKind`
with descent as passing). -/
def continuation (L : Flow X X) (W : Web X X) (Q : X → X → Prop) : Nat → X → X → Prop :=
  W.withinKind Q (descent L W)

/-- 缘 on occurrences read off the lineage continuation. -/
abbrev lineStep (L : Flow X X) (W : Web X X) (Q : X → X → Prop) : «际» (Nat × X) :=
  Web.continuationStep (continuation L W Q)

/-- One kind holding every formation. -/
def oneKind (X : Type) : X → X → Prop := fun _ _ => True

variable {L : Flow X X} {W : Web X X} {Q : X → X → Prop}

/-! ## What a carrying renewal is on a lineage -/

/-- **A carrying renewal on a lineage**, at (kind, carrier) with activity read on any web `V`:
from an active parent occurrence, a carrying renewal one step on is a step of the continuation
within the kind into an active occurrence whose formation was not active and continued as itself
at the step before. An instance of `Becoming.MapInstances`' `Web.carries_iff`, not a new result:
for a reflexive kind it is that law along the continuation with the kind folded in
(`carries_iff_via_base`). -/
theorem carries_iff {C : Type} {V : Web X C} {t : Nat} {p k : X} (start : V.active t p) :
    «传» (lineStep L W Q) (V.kindClass Q) V.carrierClass (t, p) (t + 1, k) ↔
      continuation L W Q t p k ∧ Q p k ∧ V.active (t + 1) k ∧
        ¬ (V.active t k ∧ continuation L W Q t k k) :=
  ⟨fun ⟨⟨⟨_, r⟩, alike, q⟩, begins⟩ => ⟨r, q, alike.mp start, fun ⟨before, self⟩ =>
     begins ⟨(t, k), ⟨rfl, self⟩, ⟨fun _ => alike.mp start, fun _ => before⟩, rfl⟩⟩,
   fun ⟨r, q, after, fresh⟩ => ⟨⟨⟨rfl, r⟩, ⟨fun _ => after, fun _ => start⟩, q⟩,
     fun ⟨(s, _), ⟨next, self⟩, alike, same⟩ =>
       have at_ : t = s := Nat.succ.inj next
       fresh ⟨Eq.subst (motive := fun s' => V.active s' k) at_.symm
               (Eq.subst (motive := fun g => V.active s g) same (alike.mpr after)),
              Eq.subst (motive := fun s' => continuation L W Q s' k k) at_.symm
               (Eq.subst (motive := fun g => continuation L W Q s g k) same self)⟩⟩⟩

/-- **A carrying renewal on a lineage is a descent within the kind**: from an active parent, the
continuation's other branch, carrying on as itself, never begins a part. A corollary of
`carries_iff`, so of `Web.carries_iff`; not a new result. -/
theorem carrying_descends {C : Type} {V : Web X C} {t : Nat} {p k : X} (start : V.active t p)
    (carries : «传» (lineStep L W Q) (V.kindClass Q) V.carrierClass (t, p) (t + 1, k)) :
    L.DescendsAt W t k p ∧ Q p k ∧ V.active (t + 1) k :=
  match (carries_iff start).mp carries with
  | ⟨.inl ⟨same, supported⟩, _, _, fresh⟩ => absurd
      ⟨Eq.subst (motive := fun g => V.active t g) same start,
       .inl ⟨rfl, Eq.subst (motive := fun g => W.Supported t g) same supported⟩⟩ fresh
  | ⟨.inr ⟨descends, kind⟩, _, after, _⟩ => ⟨descends, kind, after⟩

/-- **The kind grain read through the activity grain**: for a reflexive kind, a carrying renewal on
the lineage continuation at (kind, carrier) is a carrying renewal at (activity, carrier) along
the continuation with the kind folded in. So `carries_iff` is `Web.carries_iff` read through this
equivalence (a restatement, not a result); the extra generality of `carries_iff` to a kind that
is not reflexive is empty, since only a reflexive kind makes `kindClass` a class. -/
theorem carries_iff_via_base {C : Type} {V : Web X C} (refl : ∀ f, Q f f) {t : Nat} {p k : X} :
    «传» (lineStep L W Q) (V.kindClass Q) V.carrierClass (t, p) (t + 1, k) ↔
    «传» (Web.continuationStep (fun s g f => continuation L W Q s g f ∧ Q g f)) V.activityClass
      V.carrierClass (t, p) (t + 1, k) :=
  ⟨fun ⟨⟨⟨at_, r⟩, alike, q⟩, begins⟩ => ⟨⟨⟨at_, r, q⟩, alike⟩,
     fun ⟨z, ⟨at', r', _⟩, e⟩ => begins ⟨z, ⟨at', r'⟩, e⟩⟩,
   fun ⟨⟨⟨at_, r, q⟩, alike⟩, begins⟩ => ⟨⟨⟨at_, r⟩, alike, q⟩,
     fun ⟨z, ⟨at', r'⟩, e⟩ => begins ⟨z, ⟨at', r',
       Eq.subst (motive := fun f => Q z.2 f) e.2 (refl z.2)⟩, e⟩⟩⟩

/-! ## The join at the grain of activity -/

/-- **A descent within the kind continues the lineage**: where only active formations give, a
descent within the kind into a formation active after the step is a continuation at the kind
grain one step later. -/
theorem descent_continues (acting : L.Acting W) {t : Nat} {p k : X}
    (descends : L.DescendsAt W t k p) (kind : Q p k) (after : W.active (t + 1) k) :
    «续» (lineStep L W Q) (W.kindClass Q) (t, p) (t + 1, k) :=
  ⟨⟨rfl, .inr ⟨descends, kind⟩⟩,
   ⟨fun _ => after, fun _ => Flow.DescendsAt.active acting descends⟩, kind⟩

/-- **A descent within the kind into an embodied formation is a birth**: where only active
formations give, it is a carrying renewal at (kind, carrier). An embodied formation that comes
to stand was not active before the step and is active after it; no newness is needed. -/
theorem descent_carries (acting : L.Acting W) {t : Nat} {p k : X}
    (descends : L.DescendsAt W t k p) (kind : Q p k) (embodied : W.Embodied k) :
    «传» (lineStep L W Q) (W.kindClass Q) W.carrierClass (t, p) (t + 1, k) :=
  (carries_iff (Flow.DescendsAt.active acting descends)).mpr
    ⟨.inr ⟨descends, kind⟩, kind, (embodied (t + 1)).mpr descends.2.2.2,
     fun ⟨before, _⟩ => descends.2.2.1 ((embodied t).mp before)⟩

variable {G : SelectionTerm.Generations X}

/-- Births within the kind: every listed offspring is of its parent's kind. -/
def WithinKind (G : SelectionTerm.Generations X) (Q : X → X → Prop) : Prop :=
  ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → Q p k

/-- Every listed offspring is embodied. -/
def EmbodiedOffspring (W : Web X X) (G : SelectionTerm.Generations X) : Prop :=
  ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → W.Embodied k

/-- Every listed offspring is supported after its step and was not supported at the step before
it. A formation that fell below its need and is raised again meets this: at the grain of support
the map counts a revival of support as a birth. -/
def UnsupportedBefore (W : Web X X) (G : SelectionTerm.Generations X) : Prop :=
  ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → W.Supported (t + 1) k ∧ ¬ W.Supported t k

/-- Every listed offspring is supported after its step: the first half of `UnsupportedBefore`,
what the continuation at the grain of support needs (`kids_continue_supported`). -/
def SupportedAfter (W : Web X X) (G : SelectionTerm.Generations X) : Prop :=
  ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → W.Supported (t + 1) k

/-- Unsupported at the step before includes supported after it (its first half). -/
theorem supportedAfter_of_unsupportedBefore (unsupported : UnsupportedBefore W G) :
    SupportedAfter W G :=
  fun t p k mp mk => (unsupported t p k mp mk).1

/-- Every listed offspring is first supported after its step from step `0` on: supported at no
step before (`Web.FirstSupported 0`). Newness in the sense of "never supported before". -/
def FirstSupportedOffspring (W : Web X X) (G : SelectionTerm.Generations X) : Prop :=
  ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → W.FirstSupported 0 (t + 1) k

/-- **First support from some earlier step is support at the one step only**: first supported at
`t + 1` from some `T ≤ t` says no more than supported at `t + 1` and not at `t`. -/
theorem firstSupported_iff_step {t : Nat} {k : X} :
    (∃ T, T ≤ t ∧ W.FirstSupported T (t + 1) k) ↔ W.Supported (t + 1) k ∧ ¬ W.Supported t k :=
  ⟨fun ⟨_, le, first⟩ => ⟨first.1, first.2 t le (Nat.lt_succ_self t)⟩,
   fun ⟨after, before⟩ => ⟨t, Nat.le_refl t, after, fun _ le lt sup =>
     before (Eq.subst (motive := fun s' => W.Supported s' k)
       (Nat.le_antisymm (Nat.le_of_lt_succ lt) le) sup)⟩⟩

/-- Offspring never supported before are unsupported at the step before. -/
theorem unsupportedBefore_of_first (first : FirstSupportedOffspring W G) : UnsupportedBefore W G :=
  fun t p k mp mk => firstSupported_iff_step.mp ⟨0, Nat.zero_le t, first t p k mp mk⟩

/-- **The join (J1).** In `Descended` generations, where only active formations give, every
listed offspring born within the kind and embodied is a carrying renewal from its parent one
step later at (kind, carrier). -/
theorem descended_carries (acting : L.Acting W) (descended : SelectionTerm.Flow.Descended L W G)
    (within : WithinKind G Q) (embodied : EmbodiedOffspring W G) {t : Nat} {p k : X}
    (mp : p ∈ G.family t) (mk : k ∈ G.kids t p) :
    «传» (lineStep L W Q) (W.kindClass Q) W.carrierClass (t, p) (t + 1, k) :=
  descent_carries acting (descended t p k mp mk) (within t p k mp mk) (embodied t p k mp mk)

/-! ## The join at the grain of support -/

/-- **A carrying renewal on a lineage at the grain of support**: from a supported parent, it is a
step of the continuation within the kind into a formation supported after the step and not
supported before it. `carries_iff` at `V := W.admitting W.level`, so an instance of
`Web.carries_iff`; not a new result. -/
theorem supported_carries_iff {t : Nat} {p k : X} (start : W.Supported t p) :
    «传» (lineStep L W Q) ((W.admitting W.level).kindClass Q) (W.admitting W.level).carrierClass
        (t, p) (t + 1, k) ↔
      continuation L W Q t p k ∧ Q p k ∧ W.Supported (t + 1) k ∧ ¬ W.Supported t k :=
  (carries_iff (V := W.admitting W.level) start).trans
    ⟨fun ⟨r, q, after, fresh⟩ => ⟨r, q, after, fun before => fresh ⟨before, .inl ⟨rfl, before⟩⟩⟩,
     fun ⟨r, q, after, fresh⟩ => ⟨r, q, after, fun ⟨before, _⟩ => fresh before⟩⟩

/-- **A descent within the kind continues the lineage at the grain of support**: where only
active formations give and activity needs support, a descent within the kind into a formation
supported after the step. -/
theorem descent_continues_supported (acting : L.Acting W) (dependent : W.Dependent) {t : Nat}
    {p k : X} (descends : L.DescendsAt W t k p) (kind : Q p k) (stands : W.Supported (t + 1) k) :
    «续» (lineStep L W Q) ((W.admitting W.level).kindClass Q) (t, p) (t + 1, k) :=
  ⟨⟨rfl, .inr ⟨descends, kind⟩⟩,
   ⟨fun _ => stands, fun _ => Flow.DescendsAt.supported acting dependent descends⟩, kind⟩

/-- **A descent within the kind into a formation unsupported before is a birth at the grain of
support**: where only active formations give and activity needs support, a descent within the
kind into a formation supported after the step and not at the step before is a carrying
renewal. -/
theorem descent_carries_supported (acting : L.Acting W) (dependent : W.Dependent) {t : Nat}
    {p k : X} (descends : L.DescendsAt W t k p) (kind : Q p k) (after : W.Supported (t + 1) k)
    (before : ¬ W.Supported t k) :
    «传» (lineStep L W Q) ((W.admitting W.level).kindClass Q) (W.admitting W.level).carrierClass
      (t, p) (t + 1, k) :=
  (supported_carries_iff (Flow.DescendsAt.supported acting dependent descends)).mpr
    ⟨.inr ⟨descends, kind⟩, kind, after, before⟩

/-- **The join (J1) at the grain of support**: in `Descended` generations, where only active
formations give and activity needs support, every listed offspring born within the kind and
unsupported at the step before is a carrying renewal from its parent one step later. -/
theorem descended_carries_supported (acting : L.Acting W) (dependent : W.Dependent)
    (descended : SelectionTerm.Flow.Descended L W G) (within : WithinKind G Q)
    (unsupported : UnsupportedBefore W G) {t : Nat} {p k : X} (mp : p ∈ G.family t)
    (mk : k ∈ G.kids t p) :
    «传» (lineStep L W Q) ((W.admitting W.level).kindClass Q) (W.admitting W.level).carrierClass
      (t, p) (t + 1, k) :=
  descent_carries_supported acting dependent (descended t p k mp mk) (within t p k mp mk)
    (unsupported t p k mp mk).1 (unsupported t p k mp mk).2

/-- **Where everything is always supported, nothing is born at the grain of support**: every
formation can carry on as itself, so no part begins. -/
theorem nothing_carries_of_always_supported (always : ∀ t f, W.Supported t f) (z w : Nat × X) :
    ¬ «传» (lineStep L W Q) ((W.admitting W.level).kindClass Q) (W.admitting W.level).carrierClass
      z w :=
  fun ⟨⟨step, _⟩, begins⟩ => begins ⟨(z.1, w.2), ⟨step.1, .inl ⟨rfl, always z.1 w.2⟩⟩,
    ⟨fun _ => always w.1 w.2, fun _ => always z.1 w.2⟩, rfl⟩

/-! ## Going on (J2) -/

/-- **Where every member reproduces, the lineage generates**: in `Descended` generations, where
only active formations give, offspring are born within the kind and embodied, and every member
from step `t` on has a listed offspring, every member at `t` generates at (kind, carrier). -/
theorem generation_of_reproducing (acting : L.Acting W)
    (descended : SelectionTerm.Flow.Descended L W G) (within : WithinKind G Q)
    (embodied : EmbodiedOffspring W G) {t : Nat}
    (reproduces : ∀ s q, t ≤ s → q ∈ G.family s → ∃ k, k ∈ G.kids s q) {p : X}
    (mp : p ∈ G.family t) :
    «生成» (lineStep L W Q) (W.kindClass Q) W.carrierClass (t, p) :=
  generation_of_carrying (S := fun y => t ≤ y.1 ∧ y.2 ∈ G.family y.1)
    (fun z sz => match reproduces z.1 z.2 sz.1 sz.2 with
      | ⟨k, mk⟩ => ⟨(z.1 + 1, k),
          ⟨Nat.le_succ_of_le sz.1, ListTests.mem_flatMap_iff.mpr ⟨z.2, sz.2, mk⟩⟩,
          descended_carries acting descended within embodied sz.2 mk⟩)
    ⟨Nat.le_refl t, mp⟩

/-- **The same at the grain of support**, with the offspring unsupported at the step before in
place of embodiment, and activity needing support. -/
theorem generation_of_reproducing_supported (acting : L.Acting W) (dependent : W.Dependent)
    (descended : SelectionTerm.Flow.Descended L W G) (within : WithinKind G Q)
    (unsupported : UnsupportedBefore W G) {t : Nat}
    (reproduces : ∀ s q, t ≤ s → q ∈ G.family s → ∃ k, k ∈ G.kids s q) {p : X}
    (mp : p ∈ G.family t) :
    «生成» (lineStep L W Q) ((W.admitting W.level).kindClass Q) (W.admitting W.level).carrierClass
      (t, p) :=
  generation_of_carrying (S := fun y => t ≤ y.1 ∧ y.2 ∈ G.family y.1)
    (fun z sz => match reproduces z.1 z.2 sz.1 sz.2 with
      | ⟨k, mk⟩ => ⟨(z.1 + 1, k),
          ⟨Nat.le_succ_of_le sz.1, ListTests.mem_flatMap_iff.mpr ⟨z.2, sz.2, mk⟩⟩,
          descended_carries_supported acting dependent descended within unsupported sz.2 mk⟩)
    ⟨Nat.le_refl t, mp⟩

/-- **The exception, read on the map**: read by offspring number with exact transmission at every
step from `t` on, in `Descended` generations where only active formations give and offspring are
born within the kind and embodied, a member of generation `t` with an offspring generates at
(kind, carrier): its offspring carry its offspring number, so each has one in turn. With
exactness across one step the landed `Reproduction.Generations.ByNumber.rises_exact_iff` makes the
mean rise exactly where concordance is positive; this extends exactness to every later step and
reads the consequence at a member on the map. Exactness from `t` is assumed, not derived. -/
theorem generation_of_exact (acting : L.Acting W) (descended : SelectionTerm.Flow.Descended L W G)
    (within : WithinKind G Q) (embodied : EmbodiedOffspring W G)
    (number : Reproduction.Generations.ByNumber G) {t : Nat}
    (exact : ∀ s, t ≤ s → SelectionTerm.Exact (G.family s) (G.kids s) (G.amount s)
      (G.amount (s + 1)))
    {p : X} (mp : p ∈ G.family t) (pos : 0 < G.offspringNumber t p) :
    «生成» (lineStep L W Q) (W.kindClass Q) W.carrierClass (t, p) :=
  generation_of_carrying
    (S := fun y => t ≤ y.1 ∧ y.2 ∈ G.family y.1 ∧ 0 < G.offspringNumber y.1 y.2)
    (fun z sz => match Reproduction.exists_mem_of_length_pos sz.2.2 with
      | ⟨k, mk⟩ => ⟨(z.1 + 1, k),
          ⟨Nat.le_succ_of_le sz.1, ListTests.mem_flatMap_iff.mpr ⟨z.2, sz.2.1, mk⟩,
           Nat.lt_of_lt_of_le sz.2.2 (Nat.le_of_eq ((number z.1 z.2).symm.trans
             ((exact z.1 sz.1 z.2 sz.2.1 k mk).symm.trans (number (z.1 + 1) k))))⟩,
          descended_carries acting descended within embodied sz.2.1 mk⟩)
    ⟨Nat.le_refl t, mp, pos⟩

/-- **A positive selection term proper, read on the map**: under the premises of
`generation_of_exact`, where concordance of offspring number with itself is positive at `t`,
some member of generation `t` generates at (kind, carrier). -/
theorem generation_of_positive_term (acting : L.Acting W)
    (descended : SelectionTerm.Flow.Descended L W G) (within : WithinKind G Q)
    (embodied : EmbodiedOffspring W G) (number : Reproduction.Generations.ByNumber G) {t : Nat}
    (exact : ∀ s, t ≤ s → SelectionTerm.Exact (G.family s) (G.kids s) (G.amount s)
      (G.amount (s + 1)))
    (pos : 0 < G.concordAt t) :
    ∃ p, p ∈ G.family t ∧ «生成» (lineStep L W Q) (W.kindClass Q) W.carrierClass (t, p) :=
  match SelectionShift.pos_weight_of_concord (ps := G.family t) (w := G.offspringNumber t) (a := G.amount t) pos with
  | ⟨p, mp, positive⟩ =>
    ⟨p, mp, generation_of_exact acting descended within embodied number exact mp positive⟩

/-! ## Ending (J2, J3) -/

/-- **The census holds every continuation**: every continuation, on the coarse line, of a member's
occurrence is a member's occurrence. -/
def ContinuationsListed (R Lc : «际» (Nat × X)) (G : SelectionTerm.Generations X) : Prop :=
  ∀ y z, y.2 ∈ G.family y.1 → «续» R Lc y z → z.2 ∈ G.family z.1

theorem line_listed {R Lc : «际» (Nat × X)} (listed : ContinuationsListed R Lc G) :
    ∀ {x y : Nat × X}, «及» («续» R Lc) x y → x.2 ∈ G.family x.1 → y.2 ∈ G.family y.1
  | _, _, .one c, mx => listed _ _ mx c
  | _, _, .more c rest, mx => line_listed listed rest (listed _ _ mx c)

/-- Where the census holds every continuation, what the line from a member reaches is a member's
occurrence. -/
theorem reached_listed {R Lc : «际» (Nat × X)} (listed : ContinuationsListed R Lc G)
    {x y : Nat × X} (mx : x.2 ∈ G.family x.1) (reached : «所及» R Lc x y) :
    y.2 ∈ G.family y.1 :=
  match reached with
  | .inl same => Eq.subst (motive := fun z : Nat × X => z.2 ∈ G.family z.1) same mx
  | .inr line => line_listed listed line mx

/-- **An empty generation ends the line from a member on every branch**: where the census holds
every continuation, a generation empty at a step `N` not before a member's occurrence makes the
line from it degenerate (`«退化»`), along any continuation and under any coarse class. -/
theorem degeneration_of_empty {R : Nat → X → X → Prop} {Lc : «际» (Nat × X)}
    (listed : ContinuationsListed (Web.continuationStep R) Lc G) {x : Nat × X} {N : Nat}
    (mx : x.2 ∈ G.family x.1) (le : x.1 ≤ N) (empty : G.size N = 0) :
    «退化» (Web.continuationStep R) Lc x :=
  Web.ends_of_ends_at le fun y hy at_ => absurd
    (Eq.subst (motive := fun n => y.2 ∈ G.family n) at_ (reached_listed listed mx hy))
    (fun mem => nomatch (Eq.subst (motive := fun l => y.2 ∈ l)
      (nil_of_length_zero (g := G.family N) empty) mem))

/-- What the line from an active occurrence reaches under the kind class is active: the kind class
is finer than activity. -/
theorem active_along_kind {C : Type} {V : Web X C} {R : Nat → X → X → Prop} {x y : Nat × X}
    (start : V.active x.1 x.2) (reached : «所及» (Web.continuationStep R) (V.kindClass Q) x y) :
    V.active y.1 y.2 :=
  match reached with
  | .inl same => Eq.subst (motive := fun z : Nat × X => V.active z.1 z.2) same start
  | .inr line => Web.active_along_line (W := V) start
      (.inr («及之单调» (fun _ _ k => ⟨k.1, k.2.1⟩) _ _ line))

/-- **Every continuation of a member's occurrence is one of its listed offspring**: on the coarse
line, a continuation of a member's occurrence is the occurrence of one of its listed offspring one
step later. Stronger than `ContinuationsListed` (`listed_of_kids`). -/
def ContinuationsAreKids (R Lc : «际» (Nat × X)) (G : SelectionTerm.Generations X) : Prop :=
  ∀ t p z, p ∈ G.family t → «续» R Lc (t, p) z → z.1 = t + 1 ∧ z.2 ∈ G.kids t p

theorem listed_of_kids {R Lc : «际» (Nat × X)} (only : ContinuationsAreKids R Lc G) :
    ContinuationsListed R Lc G :=
  fun y z my c => match only y.1 y.2 z my c with
    | ⟨at_, mk⟩ => Eq.subst (motive := fun n => z.2 ∈ G.family n) at_.symm
        (ListTests.mem_flatMap_iff.mpr ⟨y.2, my, mk⟩)

/-- **When every continuation of a member is one of its offspring, at the grain of activity**:
where every descent within the kind from a member is listed, and no member is supported and alike
in activity across the step (none carries on as itself), every continuation of a member's
occurrence at the kind grain is one of its listed offspring one step later. -/
theorem kids_of_census
    (complete : ∀ s q f, q ∈ G.family s → L.DescendsAt W s f q → Q q f → f ∈ G.kids s q)
    (brief : ∀ s q, q ∈ G.family s → W.Supported s q → (W.active s q ↔ W.active (s + 1) q) →
      False) :
    ContinuationsAreKids (lineStep L W Q) (W.kindClass Q) G :=
  fun t q z mq ⟨⟨at_, r⟩, alike, _⟩ => match r with
    | .inl ⟨same, supported⟩ => (brief t q mq supported
        (Eq.subst (motive := fun n => W.active t q ↔ W.active n q) at_
          (Eq.subst (motive := fun f => W.active t q ↔ W.active z.1 f) same.symm alike))).elim
    | .inr ⟨descends, kind⟩ => ⟨at_, complete t q z.2 mq descends kind⟩

/-- **When the census holds every continuation, at the grain of activity**: under the premises of
`kids_of_census`, every continuation of a member's occurrence at the kind grain is a member's
occurrence. -/
theorem listed_of_census
    (complete : ∀ s q f, q ∈ G.family s → L.DescendsAt W s f q → Q q f → f ∈ G.kids s q)
    (brief : ∀ s q, q ∈ G.family s → W.Supported s q → (W.active s q ↔ W.active (s + 1) q) →
      False) :
    ContinuationsListed (lineStep L W Q) (W.kindClass Q) G :=
  listed_of_kids (kids_of_census complete brief)

/-- **Under dissipation the lineage degenerates (J3)**: in `Descended` generations whose offspring
stand within a family balanced and dissipated on across each step up to its stock at the start,
where the census holds every continuation, the line from every member of a generation up to the
stock + 1 ends on every branch, along the lineage continuation and under any coarse class (the
kind grain or the grain of activity). -/
theorem degeneration_of_dissipation {ds : List X} (descended : SelectionTerm.Flow.Descended L W G)
    (within : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → k ∈ ds)
    (balances : ∀ t, t < W.stock ds 0 + 1 → L.BalancesOn W ds t)
    (dissipates : ∀ t, t < W.stock ds 0 + 1 → L.DissipatesOn ds t) {Lc : «际» (Nat × X)}
    (listed : ContinuationsListed (lineStep L W Q) Lc G) {t : Nat} {p : X} (mp : p ∈ G.family t)
    (le : t ≤ W.stock ds 0 + 1) :
    «退化» (lineStep L W Q) Lc (t, p) :=
  degeneration_of_empty (R := continuation L W Q) listed mp le
    (Reproduction.Flow.lineage_ends descended within balances dissipates)


/-! ## A whole generation degenerating is extinction (EL1 (d)) -/

/-- **Listed offspring continue their parents** on the coarse line: each listed offspring's
occurrence one step later continues its parent's. -/
def KidsContinue (R Lc : «际» (Nat × X)) (G : SelectionTerm.Generations X) : Prop :=
  ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → «续» R Lc (t, p) (t + 1, k)

/-- **At the grain of activity, listed offspring continue their parents**: in `Descended`
generations where only active formations give, with births within the kind and embodied
offspring. -/
theorem kids_continue (acting : L.Acting W) (descended : SelectionTerm.Flow.Descended L W G)
    (within : WithinKind G Q) (embodied : EmbodiedOffspring W G) :
    KidsContinue (lineStep L W Q) (W.kindClass Q) G :=
  fun t p k mp mk => descent_continues acting (descended t p k mp mk) (within t p k mp mk)
    ((embodied t p k mp mk (t + 1)).mpr (descended t p k mp mk).2.2.2)

/-- **At the grain of support, listed offspring continue their parents**: in `Descended`
generations where only active formations give and activity needs support, with births within the
kind and offspring supported after their step (`SupportedAfter`; `UnsupportedBefore` gives it,
`supportedAfter_of_unsupportedBefore`). No premise on the step before is used. -/
theorem kids_continue_supported (acting : L.Acting W) (dependent : W.Dependent)
    (descended : SelectionTerm.Flow.Descended L W G) (within : WithinKind G Q)
    (after : SupportedAfter W G) :
    KidsContinue (lineStep L W Q) ((W.admitting W.level).kindClass Q) G :=
  fun t p k mp mk => descent_continues_supported acting dependent (descended t p k mp mk)
    (within t p k mp mk) (after t p k mp mk)

/-- `j` is listed `d` generations after step `t` as a descendant of `p`. -/
inductive ListedDescendant (G : SelectionTerm.Generations X) : Nat → X → Nat → X → Prop
  | self (t : Nat) (p : X) : ListedDescendant G t p 0 p
  | kid {t : Nat} {p k : X} {d : Nat} {j : X} : k ∈ G.kids t p →
      ListedDescendant G (t + 1) k d j → ListedDescendant G t p (d + 1) j

/-- A listed descendant's listed offspring is a listed descendant one generation further. -/
theorem ListedDescendant.snoc : ∀ {t : Nat} {p : X} {d : Nat} {q j : X},
    ListedDescendant G t p d q → j ∈ G.kids (t + d) q → ListedDescendant G t p (d + 1) j
  | t, _, _, _, j, .self _ _, mj => .kid mj (.self (t + 1) j)
  | _, _, _, _, _, .kid mk line, mj => .kid mk (ListedDescendant.snoc line
      (Eq.subst (motive := fun n => _ ∈ G.kids n _) (Nat.succ_add _ _).symm mj))

/-- A listed descendant one generation or more after `t` is a listed descendant of an offspring. -/
theorem ListedDescendant.of_succ : ∀ {t : Nat} {p : X} {n : Nat} {j : X},
    ListedDescendant G t p n j → ∀ d, n = d + 1 → ∃ k, k ∈ G.kids t p ∧ ListedDescendant G (t + 1) k d j
  | _, _, _, _, .self _ _, _, e => Nat.noConfusion e
  | _, _, _, _, .kid mk line, _, e =>
    ⟨_, mk, Eq.subst (motive := fun n => ListedDescendant G _ _ n _) (Nat.succ.inj e) line⟩

/-- Every member of the generation `d` after `t` is a listed descendant of a member at `t`. -/
theorem family_descendant {t : Nat} :
    ∀ d {j : X}, j ∈ G.family (t + d) → ∃ p, p ∈ G.family t ∧ ListedDescendant G t p d j
  | 0, j, mj => ⟨j, mj, .self t j⟩
  | d + 1, _, mj => match ListTests.mem_flatMap_iff.mp mj with
    | ⟨_, mq, mk⟩ => match family_descendant d mq with
      | ⟨p, mp, line⟩ => ⟨p, mp, line.snoc mk⟩

/-- For finitely many members, bounds from some step on have a common bound. -/
theorem common_bound {α : Type} {P : α → Nat → Prop} :
    ∀ l : List α, (∀ a, a ∈ l → ∃ D, ∀ d, D ≤ d → P a d) → ∃ D, ∀ a, a ∈ l → ∀ d, D ≤ d → P a d
  | [], _ => ⟨0, fun _ m => nomatch m⟩
  | a :: l, each => match each a (.head l), common_bound l (fun b mb => each b (.tail a mb)) with
    | ⟨Da, pa⟩, ⟨Dl, pl⟩ => ⟨Da + Dl, fun b mb d le => match mem_cons_cases mb with
      | .inl e => Eq.subst (motive := fun c => P c d) e.symm
          (pa d (Nat.le_trans (Nat.le_add_right Da Dl) le))
      | .inr m => pl b m d (Nat.le_trans (Nat.le_add_left Dl Da) le)⟩

/-- A list with no member is empty. -/
theorem length_zero_of_no_mem {α : Type} : ∀ {l : List α}, (∀ a, a ∈ l → False) → l.length = 0
  | [], _ => rfl
  | a :: _, absent => (absent a (.head _)).elim

/-- **A member's census line ends where its occurrence ends on every branch** (a lemma of
`empty_of_degenerates`, the per-member step it combines by `common_bound`). Where listed
offspring continue their parents, a member whose occurrence degenerates has, from some depth on,
no listed descendant: the induction is on `«尽»`, each member has finitely many offspring, and no
choice is made. -/
theorem line_ends {R Lc : «际» (Nat × X)} (kc : KidsContinue R Lc G) {x : Nat × X}
    (ends : «尽» R Lc x) :
    x.2 ∈ G.family x.1 → ∃ D, ∀ d, D ≤ d → ∀ j, ¬ ListedDescendant G x.1 x.2 d j := by
  induction ends with
  | @mk x _ ih =>
    intro mx
    match common_bound (P := fun k d => ∀ j, ¬ ListedDescendant G (x.1 + 1) k d j)
        (G.kids x.1 x.2) (fun k mk => ih (x.1 + 1, k) (kc x.1 x.2 k mx mk)
          (ListTests.mem_flatMap_iff.mpr ⟨x.2, mx, mk⟩)) with
    | ⟨D, absent⟩ => exact ⟨D + 1, fun d le j line => match le_dest le with
        | ⟨e, at_⟩ => match line.of_succ (D + e) ((Nat.succ_add D e).symm.trans at_.symm).symm with
          | ⟨k, mk, line'⟩ => absent k mk (D + e) (Nat.le_add_right D e) j line'⟩

/-- **A whole generation degenerating empties a later generation.** Where listed offspring continue
their parents on the coarse line, if every member of generation `t` degenerates (`«退化»`), some
generation from `t` on is empty. No census premise is needed in this direction. -/
theorem empty_of_degenerates {R Lc : «际» (Nat × X)} (kc : KidsContinue R Lc G) {t : Nat}
    (all : ∀ p, p ∈ G.family t → «退化» R Lc (t, p)) : ∃ N, t ≤ N ∧ G.size N = 0 :=
  match common_bound (P := fun p d => ∀ j, ¬ ListedDescendant G t p d j) (G.family t)
      (fun p mp => line_ends kc (all p mp) mp) with
  | ⟨D, absent⟩ => ⟨t + D, Nat.le_add_right t D, length_zero_of_no_mem fun j mj =>
      match family_descendant D mj with
      | ⟨p, mp, line⟩ => absent p mp D (Nat.le_refl D) j line⟩

/-- **A whole generation degenerates exactly where a later generation is empty**: where listed
offspring continue their parents and the census holds every continuation, every member of
generation `t` degenerates if and only if some generation from `t` on is empty. The census premise
is needed for the converse (`Lasting.lasting`); births within the kind are needed for the direct
way (`Chain.kinds_apart`, `Courses.positive_and_degenerate_at_own_kind`, each formation its own
kind). -/
theorem generation_degenerates_iff {R : Nat → X → X → Prop} {Lc : «际» (Nat × X)}
    (kc : KidsContinue (Web.continuationStep R) Lc G)
    (listed : ContinuationsListed (Web.continuationStep R) Lc G) {t : Nat} :
    (∀ p, p ∈ G.family t → «退化» (Web.continuationStep R) Lc (t, p)) ↔
      ∃ N, t ≤ N ∧ G.size N = 0 :=
  ⟨empty_of_degenerates kc, fun ⟨_, le, empty⟩ _ mp => degeneration_of_empty listed mp le empty⟩

theorem ends_of_line_ends {R Lc : «际» (Nat × X)} (only : ContinuationsAreKids R Lc G) :
    ∀ D t p, p ∈ G.family t → (∀ j, ¬ ListedDescendant G t p D j) → «尽» R Lc (t, p)
  | 0, t, p, _, absent => (absent p (.self t p)).elim
  | D + 1, t, p, mp, absent => .mk fun z c => match only t p z mp c with
    | ⟨at_, mk⟩ => Eq.subst (motive := fun n => «尽» R Lc (n, z.2)) at_.symm
        (ends_of_line_ends only D (t + 1) z.2 (ListTests.mem_flatMap_iff.mpr ⟨p, mp, mk⟩)
          fun j line => absent j (.kid mk line))

/-- **A member degenerates exactly where its census line ends**: where listed offspring continue
their parents and every continuation of a member is one of its listed offspring, a member's
occurrence degenerates if and only if at some depth it has no listed descendant. -/
theorem degenerates_iff_line_ends {R Lc : «际» (Nat × X)} (kc : KidsContinue R Lc G)
    (only : ContinuationsAreKids R Lc G) {t : Nat} {p : X} (mp : p ∈ G.family t) :
    «退化» R Lc (t, p) ↔ ∃ D, ∀ j, ¬ ListedDescendant G t p D j :=
  ⟨fun ends => match line_ends kc ends mp with | ⟨D, absent⟩ => ⟨D, absent D (Nat.le_refl D)⟩,
   fun ⟨D, absent⟩ => ends_of_line_ends only D t p mp absent⟩

/-- A positive selection term proper at a step has a member there with a listed offspring: the
reading as a list member of `SelectionShift.Generations.reproducing_of_selection` (a member with
positive offspring number). A lemma. -/
theorem reproducing_of_term {t : Nat} (pos : 0 < G.concordAt t ∨ 0 < G.discordAt t) :
    ∃ p, p ∈ G.family t ∧ ∃ k, k ∈ G.kids t p :=
  match SelectionShift.Generations.reproducing_of_selection (G := G) pos with
  | ⟨p, mp, positive⟩ => ⟨p, mp, Reproduction.exists_mem_of_length_pos positive⟩

/-- **Nonempty generations keep some member from degenerating.** Where listed offspring continue
their parents, if every generation from `t` on is nonempty then not every member of generation `t`
degenerates. The constructive half of a König-type statement: which member goes on is not
chosen. -/
theorem not_all_degenerate_of_nonempty {R Lc : «际» (Nat × X)} (kc : KidsContinue R Lc G)
    {t : Nat} (nonempty : ∀ N, t ≤ N → 0 < G.size N) :
    ¬ ∀ p, p ∈ G.family t → «退化» R Lc (t, p) :=
  fun all => match empty_of_degenerates kc all with
  | ⟨N, le, empty⟩ => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (nonempty N le) (Nat.le_of_eq empty))

/-- A selection term proper positive at every step from `t` on makes every generation from `t` on
nonempty: `SelectionShift.Generations.never_empties`, which starts from step 0, started from `t`.
A lemma. -/
theorem nonempty_of_positive {t : Nat} (pos : ∀ s, t ≤ s → 0 < G.concordAt s ∨ 0 < G.discordAt s)
    (N : Nat) (le : t ≤ N) : 0 < G.size N :=
  match le_dest le with
  | ⟨0, at_⟩ => match reproducing_of_term (pos t (Nat.le_refl t)) with
    | ⟨_, mp, _⟩ => Eq.subst (motive := fun n => 0 < G.size n) at_.symm (length_pos_of_mem mp)
  | ⟨e + 1, at_⟩ => match reproducing_of_term (pos (t + e) (Nat.le_add_right t e)) with
    | ⟨q, mq, _, mk⟩ => Eq.subst (motive := fun n => 0 < G.size n) at_.symm
        (length_pos_of_mem (ListTests.mem_flatMap_iff.mpr ⟨q, mq, mk⟩))

/-- **Positive while it lasts, so it lasts, from step `t`.** From a nonempty generation `t`, a
selection term proper positive at every nonempty generation from `t` on keeps every generation
`t + e` nonempty: `SelectionShift.Generations.never_empties_while`, which starts from step 0, started
from `t`. A lemma. -/
theorem nonempty_while {t : Nat} (first : 0 < G.size t)
    (pos : ∀ s, t ≤ s → 0 < G.size s → 0 < G.concordAt s ∨ 0 < G.discordAt s) :
    ∀ e, 0 < G.size (t + e)
  | 0 => first
  | e + 1 => match reproducing_of_term (pos (t + e) (Nat.le_add_right t e) (nonempty_while first pos e)) with
    | ⟨q, mq, _, mk⟩ => length_pos_of_mem (ListTests.mem_flatMap_iff.mpr ⟨q, mq, mk⟩)

/-- **No whole generation degenerates with a term positive while it lasts, where listed offspring
continue their parents.** Where listed offspring continue their parents on the coarse line
(`KidsContinue`), from a nonempty generation `t`, a selection term proper positive at every
nonempty generation from `t` on leaves not every member of generation `t` degenerating. This is
the reading of EL1 (d)'s "positive at every generation" that counts only generations that are
there. It is a corollary of `empty_of_degenerates` with the counting of `nonempty_while`; it puts
no member in any region. Where offspring do not continue their parents on the coarse line it
fails (`Courses.positive_and_degenerate_at_own_kind`). -/
theorem not_all_degenerate_while {R Lc : «际» (Nat × X)} (kc : KidsContinue R Lc G) {t : Nat}
    (first : 0 < G.size t)
    (pos : ∀ s, t ≤ s → 0 < G.size s → 0 < G.concordAt s ∨ 0 < G.discordAt s) :
    ¬ ∀ p, p ∈ G.family t → «退化» R Lc (t, p) :=
  not_all_degenerate_of_nonempty kc fun _ le => match le_dest le with
  | ⟨e, at_⟩ => Eq.subst (motive := fun n => 0 < G.size n) at_.symm (nonempty_while first pos e)

/-- **No whole generation degenerates with a term positive at every step, where listed offspring
continue their parents.** Where listed offspring continue their parents on the coarse line
(`KidsContinue`), a selection term proper positive at every step from `t` on leaves not every
member of generation `t` degenerating: a positive term at a step puts a member there and an
offspring in the next generation, so no generation from `t` on is empty. A corollary of
`empty_of_degenerates` with the counting of `nonempty_of_positive`, and the special case of
`not_all_degenerate_while` with positivity at every step; it puts no member in any region. Where
offspring do not continue their parents on the coarse line it fails
(`Courses.positive_and_degenerate_at_own_kind`). -/
theorem not_all_degenerate_of_positive {R Lc : «际» (Nat × X)} (kc : KidsContinue R Lc G)
    {t : Nat} (pos : ∀ s, t ≤ s → 0 < G.concordAt s ∨ 0 < G.discordAt s) :
    ¬ ∀ p, p ∈ G.family t → «退化» R Lc (t, p) :=
  not_all_degenerate_of_nonempty kc (nonempty_of_positive pos)

/-! ## Witnesses -/

/-! ### The stock-one relay: a descent that is not a birth -/

namespace RelayRead

theorem acting : Reproduction.Relay.flow.Acting Reproduction.Relay.web :=
  fun _ _ _ _ _ => trivial

theorem supported (t : Nat) (f : Bool) : Reproduction.Relay.web.Supported t f :=
  fun _ req => req.elim

theorem dependent : Reproduction.Relay.web.Dependent := fun t f _ => supported t f

/-- **In the stock-one relay a descent is not a birth.** The relay's generations are `Descended`;
each formation's standing falls to zero and is raised by the other's gift, so each descent
continues the lineage at (kind, carrier) at both grains, and, the offspring being active and
supported at the step before, it is a carrying renewal at neither. -/
theorem descent_not_birth (t : Nat) :
    SelectionTerm.Flow.Descended Reproduction.Relay.flow Reproduction.Relay.web
      Reproduction.Relay.generations ∧
    Reproduction.Relay.web.level t (!Reproduction.Relay.turn t) = 0 ∧
    Reproduction.Relay.web.level (t + 1) (!Reproduction.Relay.turn t) = 1 ∧
    «续» (lineStep Reproduction.Relay.flow Reproduction.Relay.web (oneKind Bool))
      (Reproduction.Relay.web.kindClass (oneKind Bool))
      (t, Reproduction.Relay.turn t) (t + 1, !Reproduction.Relay.turn t) ∧
    ¬ «传» (lineStep Reproduction.Relay.flow Reproduction.Relay.web (oneKind Bool))
      (Reproduction.Relay.web.kindClass (oneKind Bool)) Reproduction.Relay.web.carrierClass
      (t, Reproduction.Relay.turn t) (t + 1, !Reproduction.Relay.turn t) ∧
    «续» (lineStep Reproduction.Relay.flow Reproduction.Relay.web (oneKind Bool))
      ((Reproduction.Relay.web.admitting Reproduction.Relay.web.level).kindClass (oneKind Bool))
      (t, Reproduction.Relay.turn t) (t + 1, !Reproduction.Relay.turn t) ∧
    ¬ «传» (lineStep Reproduction.Relay.flow Reproduction.Relay.web (oneKind Bool))
      ((Reproduction.Relay.web.admitting Reproduction.Relay.web.level).kindClass (oneKind Bool))
      (Reproduction.Relay.web.admitting Reproduction.Relay.web.level).carrierClass
      (t, Reproduction.Relay.turn t) (t + 1, !Reproduction.Relay.turn t) :=
  ⟨Reproduction.Relay.descended,
   by
     show Reproduction.Relay.on (Reproduction.Relay.turn t) (!Reproduction.Relay.turn t) = 0
     cases Reproduction.Relay.turn t <;> rfl,
   by
     show Reproduction.Relay.on (!Reproduction.Relay.turn t) (!Reproduction.Relay.turn t) = 1
     cases Reproduction.Relay.turn t <;> rfl,
   descent_continues acting (Reproduction.Relay.descends t) trivial trivial,
   fun c => ((carries_iff (V := Reproduction.Relay.web) trivial).mp c).2.2.2
     ⟨trivial, .inl ⟨rfl, supported t _⟩⟩,
   descent_continues_supported acting dependent (Reproduction.Relay.descends t) trivial
     (supported _ _),
   nothing_carries_of_always_supported supported _ _⟩

end RelayRead

/-! ### The relay with activity read as standing: the grain decides the region -/

namespace StandingRelay

/-- The relay's levels, with a formation active exactly while it stands, and nothing required: so
every formation is supported at every step, standing or not, and support does not track standing
here. -/
def web : Web Bool Bool where
  level t x := Reproduction.Relay.on (Reproduction.Relay.turn t) x
  active t x := 0 < Reproduction.Relay.on (Reproduction.Relay.turn t) x
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

theorem embodied (x : Bool) : web.Embodied x := fun _ => Iff.rfl

theorem acting : Reproduction.Relay.flow.Acting web :=
  fun _ _ _ _ gives => SelectionTerm.pos_of_mul_pos gives

theorem supported (t : Nat) (f : Bool) : web.Supported t f := fun _ req => req.elim

theorem dependent : web.Dependent := fun t f _ => supported t f

theorem descended :
    SelectionTerm.Flow.Descended Reproduction.Relay.flow web Reproduction.Relay.generations :=
  fun t p k mp mk => Reproduction.Relay.descended t p k mp mk

/-- **The grain at which activity is read decides the stock-one cycle's region.** Every formation
embodied, only active formations giving, the generations `Descended`: at the grain of activity
the lineage generates from the first member, each descent a birth; at the grain of support it
keeps, with no carrying renewal, and does not generate. The grain of support is vacuous here:
nothing is required, so support holds at every step whether or not a formation stands, and the
keep is the keep of the reading in which activity never changes. At that grain a dormant
formation carries on as itself (`OneBirth.dormant_goes_on_at_support`). So the witness separates
the grains only where support does not track standing. -/
theorem grain_decides_region :
    (∀ x, web.Embodied x) ∧ Reproduction.Relay.flow.Acting web ∧
    SelectionTerm.Flow.Descended Reproduction.Relay.flow web Reproduction.Relay.generations ∧
    «生成» (lineStep Reproduction.Relay.flow web (oneKind Bool)) (web.kindClass (oneKind Bool))
      web.carrierClass (0, true) ∧
    «守» (lineStep Reproduction.Relay.flow web (oneKind Bool))
      ((web.admitting web.level).kindClass (oneKind Bool)) (web.admitting web.level).carrierClass
      (0, true) ∧
    ¬ «生成» (lineStep Reproduction.Relay.flow web (oneKind Bool))
      ((web.admitting web.level).kindClass (oneKind Bool)) (web.admitting web.level).carrierClass
      (0, true) :=
  ⟨embodied, acting, descended,
   generation_of_reproducing acting descended (fun _ _ _ _ _ => trivial)
     (fun _ _ k _ _ => embodied k) (t := 0) (fun _ q _ _ => ⟨!q, .head _⟩) (.head _),
   ⟨fun y => y.2 ∈ Reproduction.Relay.generations.family y.1,
    (show true ∈ Reproduction.Relay.generations.family 0 from .head _),
    fun z mz => ⟨(z.1 + 1, !z.2), ListTests.mem_flatMap_iff.mpr ⟨z.2, mz, .head _⟩,
      descent_continues_supported acting dependent (descended z.1 z.2 (!z.2) mz (.head _)) trivial
        (supported _ _)⟩,
    fun u v _ _ => nothing_carries_of_always_supported supported u v⟩,
   fun ⟨_, sx, _, ahead⟩ => match ahead _ sx with
     | ⟨u, v, _, _, _, c⟩ => nothing_carries_of_always_supported supported u v c⟩

end StandingRelay

/-! ### A chain beside a childless member -/

namespace Chain

/-- Formation `t + 1` stands at step `t`; formation `0` stands at step `0` only. -/
def level (t x : Nat) : Nat :=
  if x = t + 1 then 1 else if x = 0 then (if t = 0 then 1 else 0) else 0

/-- Each formation requires its own standing at need one: support is standing. -/
def web : Web Nat Nat where
  level := level
  active t x := 0 < level t x
  requires _ f c := f = c
  need _ _ _ := 1
  draws _ _ _ := False

/-- Formation `t + 1` gives one unit to formation `t + 2` across the step from `t`. -/
def give (t f c : Nat) : Nat := if f = t + 1 then (if c = t + 2 then 1 else 0) else 0

def flow : Flow Nat Nat where
  present t := [t + 1]
  take _ _ _ := 0
  give := give

def children (t p : Nat) : List Nat := if p = t + 1 then [t + 2] else []

/-- Generations: `1` and the childless `0` first; then the chain, read by offspring number. -/
def generations : SelectionTerm.Generations Nat where
  first := [1, 0]
  kids := children
  amount t p := (children t p).length

theorem children_self (t : Nat) : children t (t + 1) = [t + 2] := if_pos rfl

theorem children_other {t p : Nat} (other : ¬ p = t + 1) : children t p = [] := if_neg other

theorem level_self (t : Nat) : level t (t + 1) = 1 := if_pos rfl

theorem level_next (t : Nat) : level t (t + 2) = 0 :=
  (if_neg (Nat.succ_ne_self (t + 1))).trans (if_neg (Naturals.succ_ne_zero (t + 1)))

theorem give_self (t : Nat) : give t (t + 1) (t + 2) = 1 := (if_pos rfl).trans (if_pos rfl)

theorem give_other {t f c : Nat} (other : ¬ f = t + 1) : give t f c = 0 := if_neg other

theorem family_succ : ∀ t, generations.family (t + 1) = [t + 2]
  | 0 => rfl
  | t + 1 => by
    show (generations.family (t + 1)).flatMap (generations.kids (t + 1)) = [t + 1 + 2]
    rw [family_succ t]
    show children (t + 1) (t + 1 + 1) ++ [] = [t + 1 + 2]
    rw [children_self (t + 1)]
    rfl

theorem kid_eq {t p k : Nat} (mk : k ∈ generations.kids t p) : p = t + 1 ∧ k = t + 2 :=
  match Nat.decEq p (t + 1) with
  | .isTrue same => ⟨same, match mem_cons_cases (Eq.subst (motive := fun l => k ∈ l)
      ((congrArg (children t) same).trans (children_self t)) mk) with
    | .inl e => e
    | .inr m => nomatch m⟩
  | .isFalse other => nomatch (Eq.subst (motive := fun l => k ∈ l) (children_other other) mk)

theorem one_le_self (t : Nat) : 1 ≤ level t (t + 1) := Nat.le_of_eq (level_self t).symm

theorem acting : flow.Acting web := fun t f _ _ gives => match Nat.decEq f (t + 1) with
  | .isTrue same => Eq.subst (motive := fun g => 0 < level t g) same.symm (one_le_self t)
  | .isFalse other => absurd gives
      (Eq.subst (motive := fun n => ¬ 0 < n) (give_other other).symm (Nat.lt_irrefl 0))

theorem embodied (x : Nat) : web.Embodied x := fun _ => Iff.rfl

theorem dependent : web.Dependent :=
  fun t _ active _ req => Eq.subst (motive := fun c => 1 ≤ level t c) req active

theorem descends (t : Nat) : flow.DescendsAt web t (t + 2) (t + 1) :=
  ⟨.head _, Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq (give_self t).symm),
   fun pos => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (level_next t))),
   one_le_self (t + 1)⟩

theorem descended : SelectionTerm.Flow.Descended flow web generations := fun t _ k _ mk =>
  match kid_eq mk with
  | ⟨hp, hk⟩ => Eq.subst (motive := fun q => flow.DescendsAt web t k q) hp.symm
      (Eq.subst (motive := fun j => flow.DescendsAt web t j (t + 1)) hk.symm (descends t))

theorem number : Reproduction.Generations.ByNumber generations := fun _ _ => rfl

theorem exact (s : Nat) : SelectionTerm.Exact (generations.family s) (generations.kids s)
    (generations.amount s) (generations.amount (s + 1)) := fun _ _ k mk =>
  match kid_eq mk with
  | ⟨hp, hk⟩ => Eq.subst (motive := fun q => generations.amount (s + 1) k = generations.amount s q)
      hp.symm (Eq.subst (motive := fun j => generations.amount (s + 1) j =
        generations.amount s (s + 1)) hk.symm
        ((congrArg List.length (children_self (s + 1))).trans
          (congrArg List.length (children_self s)).symm))

/-- The offspring of step `t`, formation `t + 2`, is supported at no step before `t + 1`. -/
theorem first_supported_from_zero (t : Nat) : web.FirstSupported 0 (t + 1) (t + 2) :=
  ⟨fun _ req => Eq.subst (motive := fun c => 1 ≤ level (t + 1) c) req (one_le_self (t + 1)),
   fun s _ lt sup =>
     match Nat.decEq s (t + 1) with
     | .isTrue e => absurd lt (Eq.subst (motive := fun s' => ¬ s' < t + 1) e.symm (Nat.lt_irrefl _))
     | .isFalse ne =>
       have h : 1 ≤ level s (t + 2) := sup (t + 2) rfl
       have z : level s (t + 2) = 0 := by
         unfold level
         rw [if_neg (fun e => ne (Nat.succ.inj e).symm), if_neg (fun e => Nat.noConfusion e)]
       Nat.not_succ_le_zero 0 (Nat.le_trans h (Nat.le_of_eq z))⟩

/-- Every offspring of the chain is supported at no step before its birth. -/
theorem first_supported : FirstSupportedOffspring web generations := fun t _ _ _ mk =>
  match kid_eq mk with
  | ⟨_, hk⟩ => Eq.subst (motive := fun j => web.FirstSupported 0 (t + 1) j) hk.symm
      (first_supported_from_zero t)

theorem reproduces_from_one : ∀ s q, 1 ≤ s → q ∈ generations.family s →
    ∃ k, k ∈ generations.kids s q
  | 0, _, le, _ => absurd le (Nat.not_succ_le_zero 0)
  | s + 1, q, _, mq =>
    have hq : q = s + 2 := match mem_cons_cases (Eq.subst (motive := fun l => q ∈ l)
        (family_succ s) mq) with
      | .inl e => e
      | .inr m => nomatch m
    ⟨s + 1 + 2, Eq.subst (motive := fun j => s + 1 + 2 ∈ children (s + 1) j) hq.symm
      (Eq.subst (motive := fun l => s + 1 + 2 ∈ l) (children_self (s + 1)).symm (.head _))⟩

/-- The childless member's line ends at once: at step `1` it is not standing, and nothing descends
from it. -/
theorem childless_degenerates :
    «退化» (lineStep flow web (oneKind Nat)) (web.kindClass (oneKind Nat)) (0, 0) :=
  .mk fun y ⟨⟨at_, r⟩, alike, _⟩ => False.elim (match r with
    | .inl ⟨same, _⟩ =>
      have now : web.active y.1 y.2 := alike.mp (Nat.succ_pos 0)
      Nat.lt_irrefl 0 (Eq.subst (motive := fun n => 0 < level n 0) at_
        (Eq.subst (motive := fun f => 0 < level y.1 f) same.symm now))
    | .inr ⟨d, _⟩ => match mem_cons_cases d.1 with
      | .inl e => Naturals.succ_ne_zero 0 e.symm
      | .inr m => nomatch m)

/-- **Every generation nonempty, a positive term with exact transmission, and the regions at
points.** Every generation of the chain is nonempty; read by offspring number with exact
transmission at every step, the term is positive at step `0`; the member `1` generates at (kind,
carrier) at the grain of activity, and the member `2` at step `1` at the grain of support,
every offspring supported at no step before its birth; the childless member `0` degenerates. -/
theorem chain :
    flow.Acting web ∧ web.Dependent ∧ (∀ x, web.Embodied x) ∧
    SelectionTerm.Flow.Descended flow web generations ∧ FirstSupportedOffspring web generations ∧
    Reproduction.Generations.ByNumber generations ∧
    (∀ s, SelectionTerm.Exact (generations.family s) (generations.kids s) (generations.amount s)
      (generations.amount (s + 1))) ∧
    (∀ t, 0 < generations.size t) ∧ generations.concordAt 0 = 1 ∧
    «生成» (lineStep flow web (oneKind Nat)) (web.kindClass (oneKind Nat)) web.carrierClass (0, 1) ∧
    «生成» (lineStep flow web (oneKind Nat)) ((web.admitting web.level).kindClass (oneKind Nat))
      (web.admitting web.level).carrierClass (1, 2) ∧
    «退化» (lineStep flow web (oneKind Nat)) (web.kindClass (oneKind Nat)) (0, 0) :=
  ⟨acting, dependent, embodied, descended, first_supported, number, exact,
   fun t => match t with
     | 0 => Nat.succ_pos 1
     | t + 1 => Nat.lt_of_lt_of_le (Nat.succ_pos 0)
         (Nat.le_of_eq (congrArg List.length (family_succ t)).symm),
   rfl,
   (match generation_of_positive_term (Q := oneKind Nat) acting descended (fun _ _ _ _ _ => trivial)
       (fun _ _ k _ _ => embodied k) number (t := 0) (fun s _ => exact s) (Nat.succ_pos 0) with
   | ⟨_, mp, generates⟩ => match mem_cons_cases mp with
     | .inl e => Eq.subst (motive := fun q => «生成» (lineStep flow web (oneKind Nat))
         (web.kindClass (oneKind Nat)) web.carrierClass (0, q)) e generates
     | .inr m => match mem_cons_cases m with
       | .inl e => absurd (Eq.subst (motive := fun q => «生成» (lineStep flow web (oneKind Nat))
             (web.kindClass (oneKind Nat)) web.carrierClass (0, q)) e generates)
           fun g => «延尽不并» childless_degenerates («生成则延» g)
       | .inr m' => nomatch m'),
   generation_of_reproducing_supported acting dependent descended (fun _ _ _ _ _ => trivial)
     (unsupportedBefore_of_first first_supported)
     (t := 1) reproduces_from_one
     (Eq.subst (motive := fun l => 2 ∈ l) (family_succ 0).symm (.head _)),
   childless_degenerates⟩

/-- A formation of the chain stands at no two consecutive steps. -/
theorem stands_once {t x : Nat} (now : 0 < level t x) (next : 0 < level (t + 1) x) : False :=
  match Nat.decEq x (t + 1) with
  | .isTrue e =>
    have z : level (t + 1) x = 0 :=
      (if_neg (fun h : x = t + 1 + 1 => Nat.succ_ne_self (t + 1) (h.symm.trans e))).trans
        (if_neg (fun h : x = 0 => Naturals.succ_ne_zero t (e.symm.trans h)))
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le next (Nat.le_of_eq z))
  | .isFalse ne => match Nat.decEq x 0 with
    | .isTrue z0 =>
      have z : level (t + 1) x = 0 :=
        (if_neg (fun h : x = t + 1 + 1 => Naturals.succ_ne_zero (t + 1) (h.symm.trans z0))).trans
          ((if_pos z0).trans (if_neg (Naturals.succ_ne_zero t)))
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le next (Nat.le_of_eq z))
    | .isFalse n0 =>
      have z : level t x = 0 := (if_neg ne).trans (if_neg n0)
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le now (Nat.le_of_eq z))

/-- **Births within the kind cannot be dropped from `empty_of_degenerates`.** With each formation
its own kind (`Q := (· = ·)`, reflexive, so `kindClass` is a class), every occurrence of the chain
degenerates at the kind grain while every generation is nonempty: no formation stands at two
consecutive steps, so none carries on as itself, and no offspring is of its parent's kind. -/
theorem kinds_apart :
    (∀ t, 0 < generations.size t) ∧
    ∀ t p, «退化» (lineStep flow web (fun a b : Nat => a = b))
      (web.kindClass (fun a b : Nat => a = b)) (t, p) :=
  ⟨fun t => match t with
     | 0 => Nat.succ_pos 1
     | t + 1 => Nat.lt_of_lt_of_le (Nat.succ_pos 0)
         (Nat.le_of_eq (congrArg List.length (family_succ t)).symm),
   fun t p => .mk fun y ⟨⟨at_, r⟩, alike, q⟩ => False.elim (match r with
     | .inl ⟨same, sup⟩ =>
       have h1 : 1 ≤ level t p := sup p rfl
       have h2 : 0 < level y.1 y.2 := alike.mp h1
       stands_once h1 (Eq.subst (motive := fun n => 0 < level n p) at_
         (Eq.subst (motive := fun f => 0 < level y.1 f) same.symm h2))
     | .inr ⟨d, _⟩ => d.2.2.1 (Eq.subst (motive := fun f => 0 < level t f) q
         (Flow.DescendsAt.active acting d)))⟩

end Chain

/-! ### One birth, then the end -/

namespace OneBirth

/-- The parent `true` stands at two at step `0`; the offspring `false` stands at one at step `1`;
nothing stands from step `2`. -/
def level : Nat → Bool → Nat
  | 0, true => 2
  | 0, false => 0
  | 1, true => 0
  | 1, false => 1
  | _ + 2, _ => 0

def web : Web Bool Bool where
  level := level
  active t x := 0 < level t x
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def present : Nat → List Bool
  | 0 => [true]
  | 1 => [false]
  | _ + 2 => []

/-- The parent spends its two units, giving one to the offspring; the offspring spends its one. -/
def take : Nat → Bool → Bool → Nat
  | 0, true, true => 2
  | 0, true, false => 0
  | 0, false, _ => 0
  | 1, false, false => 1
  | 1, false, true => 0
  | 1, true, _ => 0
  | _ + 2, _, _ => 0

def give : Nat → Bool → Bool → Nat
  | 0, true, false => 1
  | 0, true, true => 0
  | 0, false, _ => 0
  | _ + 1, _, _ => 0

def flow : Flow Bool Bool := ⟨present, take, give⟩

def family : List Bool := [true, false]

def kids : Nat → Bool → List Bool
  | 0, true => [false]
  | 0, false => []
  | _ + 1, _ => []

def generations : SelectionTerm.Generations Bool where
  first := [true]
  kids := kids
  amount _ _ := 0

theorem family_two : ∀ t, generations.family (t + 2) = []
  | 0 => rfl
  | t + 1 => by
    show (generations.family (t + 2)).flatMap (generations.kids (t + 2)) = []
    rw [family_two t]
    rfl

theorem descends : flow.DescendsAt web 0 false true := ⟨.head _, Nat.succ_pos 0, Nat.lt_irrefl 0,
  Nat.succ_pos 0⟩

/-- Every listed descent is the one birth. -/
theorem listed_birth : ∀ {t : Nat} {p k : Bool}, p ∈ generations.family t →
    k ∈ generations.kids t p → t = 0 ∧ p = true ∧ k = false
  | 0, true, _, _, mk => ⟨rfl, rfl, match mem_cons_cases mk with
      | .inl e => e
      | .inr m => nomatch m⟩
  | 0, false, _, mp, _ => match mem_cons_cases mp with
      | .inl e => Bool.noConfusion e
      | .inr m => nomatch m
  | 1, _, _, _, mk => nomatch mk
  | t + 2, _, _, mp, _ => nomatch (Eq.subst (motive := fun l => _ ∈ l) (family_two t) mp)

theorem descended : SelectionTerm.Flow.Descended flow web generations := fun t p k mp mk =>
  match t, p, k, listed_birth mp mk with
  | _, _, _, ⟨rfl, rfl, rfl⟩ => descends

theorem acting : flow.Acting web
  | 0, true, _, _, _ => Nat.succ_pos 1
  | 0, false, _, _, gives => absurd gives (Nat.lt_irrefl 0)
  | _ + 1, _, _, _, gives => absurd gives (Nat.lt_irrefl 0)

theorem embodied (x : Bool) : web.Embodied x := fun _ => Iff.rfl

theorem balances : ∀ t, flow.BalancesOn web family t
  | 0 => fun c _ => match c with | true => rfl | false => rfl
  | 1 => fun c _ => match c with | true => rfl | false => rfl
  | _ + 2 => fun c _ => match c with | true => rfl | false => rfl

theorem dissipates : ∀ t, flow.DissipatesOn family t
  | 0 => fun f mf => match mem_cons_cases mf with
    | .inl e => Eq.subst (motive := fun g => total family (give 0 g) +
        sign (total family (take 0 g)) ≤ total family (take 0 g)) e.symm (by decide)
    | .inr m => nomatch m
  | 1 => fun f mf => match mem_cons_cases mf with
    | .inl e => Eq.subst (motive := fun g => total family (give 1 g) +
        sign (total family (take 1 g)) ≤ total family (take 1 g)) e.symm (by decide)
    | .inr m => nomatch m
  | _ + 2 => fun _ mf => nomatch mf

theorem stock : web.stock family 0 = 2 := rfl

theorem listed :
    ContinuationsListed (lineStep flow web (oneKind Bool)) (web.kindClass (oneKind Bool))
      generations :=
  listed_of_census
    (fun s q f mq d _ => match s, q, mq, d with
      | 0, true, _, d => match f, d with
        | false, _ => .head _
        | true, d => absurd d.2.1 (Nat.lt_irrefl 0)
      | 0, false, mq, _ => match mem_cons_cases mq with
        | .inl e => Bool.noConfusion e
        | .inr m => nomatch m
      | 1, _, _, d => absurd d.2.1 (Nat.lt_irrefl 0)
      | t + 2, _, mq, _ => nomatch (Eq.subst (motive := fun l => _ ∈ l) (family_two t) mq))
    (fun s q mq _ alike => match s, q, mq with
      | 0, true, _ => Nat.lt_irrefl 0 (alike.mp (Nat.succ_pos 1))
      | 0, false, mq => match mem_cons_cases mq with
        | .inl e => Bool.noConfusion e
        | .inr m => nomatch m
      | 1, false, _ => Nat.lt_irrefl 0 (alike.mp (Nat.succ_pos 0))
      | 1, true, mq => match mem_cons_cases mq with
        | .inl e => Bool.noConfusion e
        | .inr m => nomatch m
      | t + 2, _, mq => nomatch (Eq.subst (motive := fun l => _ ∈ l) (family_two t) mq))

/-- **One birth, then the end on every branch.** Every premise of `degeneration_of_dissipation`
holds (a family of stock two, balanced and dissipated on at every step, the census holding every
continuation), together with `Acting`, embodiment and `Descended`: the lineage from the parent
renews and still ends on every branch at (kind, carrier) (`«新而尽»`). -/
theorem one_birth :
    flow.Acting web ∧ (∀ x, web.Embodied x) ∧ SelectionTerm.Flow.Descended flow web generations ∧
    (∀ t, flow.BalancesOn web family t) ∧ (∀ t, flow.DissipatesOn family t) ∧
    web.stock family 0 = 2 ∧
    ContinuationsListed (lineStep flow web (oneKind Bool)) (web.kindClass (oneKind Bool))
      generations ∧
    «新而尽» (lineStep flow web (oneKind Bool)) (web.kindClass (oneKind Bool)) web.carrierClass
      (0, true) :=
  ⟨acting, embodied, descended, balances, dissipates, stock, listed,
   degeneration_of_dissipation (ds := family) descended
     (fun t p k mp mk => match t, p, k, listed_birth mp mk with
       | _, _, _, ⟨_, _, rfl⟩ => .tail _ (.head _))
     (fun t _ => balances t) (fun t _ => dissipates t) listed (t := 0) (.head _) (Nat.zero_le _),
   (0, true), (1, false), .inl rfl,
   descended_carries acting descended (fun _ _ _ _ _ => trivial) (fun _ _ k _ _ => embodied k)
     (.head _) (.head _)⟩

/-- **At a grain of support where nothing is required, a dormant formation goes on.** The parent,
at zero standing from step `1` on, carries on as itself at the grain of support, every step: the
lineage continuation links a dormant formation where support does not need standing. -/
theorem dormant_goes_on_at_support :
    (∀ s, web.level (s + 1) true = 0) ∧
    «延» (lineStep flow web (oneKind Bool)) ((web.admitting web.level).kindClass (oneKind Bool))
      (1, true) :=
  ⟨fun s => match s with | 0 => rfl | _ + 1 => rfl,
   ⟨fun y => y.2 = true, rfl, fun z hz => ⟨(z.1 + 1, true), rfl,
     ⟨⟨rfl, .inl ⟨hz, fun _ req => req.elim⟩⟩,
      ⟨fun _ _ req => req.elim, fun _ _ req => req.elim⟩, trivial⟩⟩⟩⟩

end OneBirth

/-! ### An offspring that stands on: the census ends, the line goes on -/

namespace Lasting

/-- As in `OneBirth`, except that the offspring keeps its one unit from step `1` on. -/
def level : Nat → Bool → Nat
  | 0, true => 2
  | 0, false => 0
  | _ + 1, true => 0
  | _ + 1, false => 1

def web : Web Bool Bool where
  level := level
  active t x := 0 < level t x
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def present : Nat → List Bool
  | 0 => [true]
  | _ + 1 => []

def flow : Flow Bool Bool := ⟨present, OneBirth.take, OneBirth.give⟩

theorem acting : flow.Acting web
  | 0, true, _, _, _ => Nat.succ_pos 1
  | 0, false, _, _, gives => absurd gives (Nat.lt_irrefl 0)
  | _ + 1, _, _, _, gives => absurd gives (Nat.lt_irrefl 0)

theorem descended : SelectionTerm.Flow.Descended flow web OneBirth.generations :=
  fun t p k mp mk => match t, p, k, OneBirth.listed_birth mp mk with
  | _, _, _, ⟨rfl, rfl, rfl⟩ => ⟨.head _, Nat.succ_pos 0, Nat.lt_irrefl 0, Nat.succ_pos 0⟩

theorem balances : ∀ t, flow.BalancesOn web OneBirth.family t
  | 0 => fun c _ => match c with | true => rfl | false => rfl
  | _ + 1 => fun c _ => match c with | true => rfl | false => rfl

theorem dissipates : ∀ t, flow.DissipatesOn OneBirth.family t
  | 0 => fun f mf => match mem_cons_cases mf with
    | .inl e => Eq.subst (motive := fun g => total OneBirth.family (OneBirth.give 0 g) +
        sign (total OneBirth.family (OneBirth.take 0 g)) ≤
          total OneBirth.family (OneBirth.take 0 g)) e.symm (by decide)
    | .inr m => nomatch m
  | _ + 1 => fun _ mf => nomatch mf

/-- The line from the parent goes on along one branch: the birth, then the offspring carrying on
as itself, supported and standing. -/
theorem goes_on :
    «延» (lineStep flow web (oneKind Bool)) (web.kindClass (oneKind Bool)) (0, true) :=
  ⟨fun y => y = (0, true) ∨ (0 < y.1 ∧ y.2 = false), .inl rfl, fun z sz => match sz with
    | .inl e => ⟨(1, false), .inr ⟨Nat.succ_pos 0, rfl⟩,
        Eq.subst (motive := fun x => «续» (lineStep flow web (oneKind Bool))
          (web.kindClass (oneKind Bool)) x (1, false)) e.symm
          (descent_continues acting ⟨.head _, Nat.succ_pos 0, Nat.lt_irrefl 0, Nat.succ_pos 0⟩
            trivial (Nat.succ_pos 0))⟩
    | .inr ⟨pos, same⟩ => ⟨(z.1 + 1, false), .inr ⟨Nat.succ_pos _, rfl⟩,
        match z, pos, same with
        | (_ + 1, _), _, rfl => ⟨⟨rfl, .inl ⟨rfl, fun _ req => req.elim⟩⟩,
            ⟨fun _ => Nat.succ_pos 0, fun _ => Nat.succ_pos 0⟩, trivial⟩⟩⟩

/-- **The listing premise of `degeneration_of_dissipation` cannot be dropped.** Every premise of
`Reproduction.Flow.lineage_ends` holds, with only active formations giving and the generations
`Descended`, and the generation after the stock is empty; yet the offspring carries on as itself,
outside the census, and the line from the parent does not degenerate. So the census does not
hold every continuation. -/
theorem lasting :
    flow.Acting web ∧ SelectionTerm.Flow.Descended flow web OneBirth.generations ∧
    (∀ t, flow.BalancesOn web OneBirth.family t) ∧ (∀ t, flow.DissipatesOn OneBirth.family t) ∧
    OneBirth.generations.size (web.stock OneBirth.family 0 + 1) = 0 ∧
    ¬ «退化» (lineStep flow web (oneKind Bool)) (web.kindClass (oneKind Bool)) (0, true) ∧
    ¬ ContinuationsListed (lineStep flow web (oneKind Bool)) (web.kindClass (oneKind Bool))
      OneBirth.generations :=
  have within : ∀ t p k, p ∈ OneBirth.generations.family t → k ∈ OneBirth.generations.kids t p →
      k ∈ OneBirth.family := fun t p k mp mk => match t, p, k, OneBirth.listed_birth mp mk with
    | _, _, _, ⟨_, _, rfl⟩ => .tail _ (.head _)
  have not_degenerates : ¬ «退化» (lineStep flow web (oneKind Bool))
      (web.kindClass (oneKind Bool)) (0, true) := fun d => «延尽不并» d goes_on
  ⟨acting, descended, balances, dissipates,
   Reproduction.Flow.lineage_ends descended within (fun t _ => balances t)
     (fun t _ => dissipates t),
   not_degenerates,
   fun listed => not_degenerates (degeneration_of_dissipation (ds := OneBirth.family) descended
     within (fun t _ => balances t) (fun t _ => dissipates t) listed (t := 0) (.head _)
     (Nat.zero_le _))⟩

end Lasting

/-! ### Two courses with the same terms, and a course positive but for its last generation -/

namespace Courses

/-- Formations: the marked `(t, true)` and the unmarked `(t, false)` of each step `t`. -/
abbrev Formation := Nat × Bool

/-- Across the step from `t`, where reproduction is on at `t`, the marked formation has two
offspring, the marked and the unmarked of `t + 1`; nothing else has any. -/
def kids (on : Nat → Bool) (t : Nat) (p : Formation) : List Formation :=
  cond (p.2 && on t) [(t + 1, true), (t + 1, false)] []

/-- The marked formation gives one unit to each formation of the next step where reproduction is
on. -/
def give (on : Nat → Bool) (t : Nat) (p k : Formation) : Nat :=
  cond (p.2 && on t) (if k.1 = t + 1 then 1 else 0) 0

/-- What the formations of a step stand at: one at step `0`, and one at `s + 1` where reproduction
was on at `s`. -/
def born (on : Nat → Bool) : Nat → Nat
  | 0 => 1
  | s + 1 => cond (on s) 1 0

/-- A formation stands only at its own step. -/
def level (on : Nat → Bool) (t : Nat) (x : Formation) : Nat := if x.1 = t then born on t else 0

/-- Activity is standing; each formation requires its own standing at need one, so support is
standing too. -/
def web (on : Nat → Bool) : Web Formation Formation where
  level := level on
  active t x := 0 < level on t x
  requires _ f c := f = c
  need _ _ _ := 1
  draws _ _ _ := False

def flow (on : Nat → Bool) : Flow Formation Formation where
  present t := [(t, true), (t, false)]
  take _ _ _ := 0
  give := give on

/-- The amount: the mark. -/
def mark (p : Formation) : Nat := cond p.2 1 0

def generations (on : Nat → Bool) : SelectionTerm.Generations Formation where
  first := [(0, true), (0, false)]
  kids := kids on
  amount _ := mark

/-- Reproduction on at every step. -/
def always : Nat → Bool := fun _ => true

/-- Reproduction on at every step up to `H`, and off after. -/
def upTo (H : Nat) : Nat → Bool := fun t => decide (t ≤ H)

theorem mem_cond : ∀ {b : Bool} {l : List Formation} {k : Formation}, k ∈ cond b l [] →
    b = true ∧ k ∈ l
  | true, _, _, mk => ⟨rfl, mk⟩
  | false, _, _, mk => nomatch mk

theorem fst_of_mem {n : Nat} {k : Formation} (mk : k ∈ [(n, true), (n, false)]) : k.1 = n :=
  match mem_cons_cases mk with
  | .inl e => congrArg Prod.fst e
  | .inr m => match mem_cons_cases m with
    | .inl e => congrArg Prod.fst e
    | .inr m' => nomatch m'

theorem mem_of_fst {n : Nat} : ∀ {k : Formation}, k.1 = n → k ∈ [(n, true), (n, false)]
  | (_, true), e => Eq.subst (motive := fun m => (m, true) ∈ [(n, true), (n, false)]) e.symm
      (.head _)
  | (_, false), e => Eq.subst (motive := fun m => (m, false) ∈ [(n, true), (n, false)]) e.symm
      (.tail _ (.head _))

theorem kids_marked {on : Nat → Bool} {t : Nat} (h : on t = true) (s : Nat) :
    kids on t (s, true) = [(t + 1, true), (t + 1, false)] := by
  show cond (on t) [(t + 1, true), (t + 1, false)] [] = _
  rw [h]
  rfl

theorem kids_off {on : Nat → Bool} {t : Nat} (h : on t = false) : ∀ p, kids on t p = []
  | (_, true) => by
    show cond (on t) [(t + 1, true), (t + 1, false)] [] = _
    rw [h]
    rfl
  | (_, false) => rfl

theorem give_pos {on : Nat → Bool} {t : Nat} {p k : Formation} (pos : 0 < give on t p k) :
    p.2 = true ∧ on t = true ∧ k.1 = t + 1 :=
  match Thresholds.cond_pos pos with
  | ⟨both, positive⟩ => ⟨(bool_of_and_true both).1, (bool_of_and_true both).2,
      match Nat.decEq k.1 (t + 1) with
      | .isTrue e => e
      | .isFalse n => absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq (if_neg n)))
          (Nat.lt_irrefl 0)⟩

theorem level_own (on : Nat → Bool) {t : Nat} {x : Formation} (e : x.1 = t) :
    level on t x = born on t := if_pos e

theorem level_other (on : Nat → Bool) {t : Nat} {x : Formation} (n : ¬ x.1 = t) :
    level on t x = 0 := if_neg n

theorem born_on {on : Nat → Bool} {s : Nat} (h : on s = true) : born on (s + 1) = 1 := by
  show cond (on s) 1 0 = 1
  rw [h]
  rfl

theorem born_off {on : Nat → Bool} {s : Nat} (h : on s = false) : born on (s + 1) = 0 := by
  show cond (on s) 1 0 = 0
  rw [h]
  rfl

/-- The family at a step before which reproduction was on throughout: the two formations of the
step. -/
theorem family_of (on : Nat → Bool) :
    ∀ t, (∀ s, s < t → on s = true) → (generations on).family t = [(t, true), (t, false)]
  | 0, _ => rfl
  | t + 1, h => by
    show ((generations on).family t).flatMap (kids on t) = _
    rw [family_of on t (fun s lt => h s (Nat.lt_succ_of_lt lt))]
    show kids on t (t, true) ++ (kids on t (t, false) ++ []) = _
    rw [kids_marked (h t (Nat.lt_succ_self t))]
    rfl

/-- A member of a family is a formation of its step, standing there. -/
theorem member_of {on : Nat → Bool} : ∀ {t : Nat} {p : Formation},
    p ∈ (generations on).family t → p.1 = t ∧ 0 < born on t
  | 0, _, mp => ⟨fst_of_mem mp, Nat.succ_pos 0⟩
  | _ + 1, _, mp => match ListTests.mem_flatMap_iff.mp mp with
    | ⟨_, _, mk⟩ => match mem_cond mk with
      | ⟨both, ml⟩ => ⟨fst_of_mem ml, Nat.lt_of_lt_of_le (Nat.succ_pos 0)
          (Nat.le_of_eq (born_on (bool_of_and_true both).2).symm)⟩

theorem descends {on : Nat → Bool} {t : Nat} (h : on t = true) {k : Formation} (e : k.1 = t + 1) :
    (flow on).DescendsAt (web on) t k (t, true) :=
  ⟨.head _,
   (show 0 < cond (on t) (if k.1 = t + 1 then 1 else 0) 0 by rw [h, if_pos e]; exact Nat.succ_pos 0),
   fun pos => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
     (level_other on (fun same => Nat.succ_ne_self t (e.symm.trans same))))),
   Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq
     ((level_own on e).trans (born_on h)).symm)⟩

/-- Reproduction on at a step was on at the step before: what gives stands. -/
def DownClosed (on : Nat → Bool) : Prop := ∀ s, on (s + 1) = true → on s = true

theorem acting {on : Nat → Bool} (down : DownClosed on) : (flow on).Acting (web on) :=
  fun t _ _ mf gives => match give_pos gives with
  | ⟨_, h, _⟩ =>
    have stands : 0 < born on t := match t, h with
      | 0, _ => Nat.succ_pos 0
      | s + 1, h => Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq (born_on (down s h)).symm)
    Nat.lt_of_lt_of_le stands (Nat.le_of_eq (level_own on (fst_of_mem mf)).symm)

theorem embodied (on : Nat → Bool) (x : Formation) : (web on).Embodied x := fun _ => Iff.rfl

theorem descended (on : Nat → Bool) :
    SelectionTerm.Flow.Descended (flow on) (web on) (generations on) :=
  fun t p k mp mk => match p, mp, mk with
  | (_, true), mp, mk => match mem_cond mk with
    | ⟨both, ml⟩ => Eq.subst (motive := fun n => (flow on).DescendsAt (web on) t k (n, true))
        (member_of mp).1.symm (descends (bool_of_and_true both).2 (fst_of_mem ml))
  | (_, false), _, mk => nomatch mk

/-- Every continuation of a member's occurrence at the kind grain is one of its listed offspring:
every descent from a member is listed, and no member carries on as itself, standing only at its
own step. -/
theorem only_kids (on : Nat → Bool) {Q : Formation → Formation → Prop} :
    ContinuationsAreKids (lineStep (flow on) (web on) Q) ((web on).kindClass Q)
      (generations on) :=
  kids_of_census
    (fun _ q f _ d _ => match q, d with
      | (r, true), d => match give_pos d.2.1 with
        | ⟨_, h, e⟩ => Eq.subst (motive := fun l => f ∈ l) (kids_marked h r).symm (mem_of_fst e)
      | (_, false), d => absurd d.2.1 (Nat.lt_irrefl 0))
    (fun s _ mq _ alike => match member_of mq with
      | ⟨e, stands⟩ => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
          (alike.mp (Nat.lt_of_lt_of_le stands (Nat.le_of_eq (level_own on e).symm)))
          (Nat.le_of_eq (level_other on (fun same => Nat.succ_ne_self s (same.symm.trans e))))))

/-- The terms where reproduction is on at the step and was on before: concordance of offspring
number with the mark two, discordance zero. -/
theorem terms_on {on : Nat → Bool} {t : Nat} (h : ∀ s, s ≤ t → on s = true) :
    (generations on).concordAt t = 2 ∧ (generations on).discordAt t = 0 := by
  have fam := family_of on t (fun s lt => h s (Nat.le_of_lt lt))
  have now := h t (Nat.le_refl t)
  constructor
  · show SelectionTerm.concord ((generations on).family t)
        (fun p => (cond (p.2 && on t) [(t + 1, true), (t + 1, false)] []).length) mark = 2
    rw [fam, now]
    rfl
  · show SelectionTerm.discord ((generations on).family t)
        (fun p => (cond (p.2 && on t) [(t + 1, true), (t + 1, false)] []).length) mark = 0
    rw [fam, now]
    rfl

/-- Where reproduction is off at a step, both terms are zero there. -/
theorem terms_off {on : Nat → Bool} {t : Nat} (h : on t = false) :
    (generations on).concordAt t = 0 ∧ (generations on).discordAt t = 0 :=
  ⟨SelectionTerm.concord_uniform (k := 0) (fun p _ => congrArg List.length (kids_off h p)) _,
   SelectionTerm.discord_uniform (k := 0) (fun p _ => congrArg List.length (kids_off h p)) _⟩

theorem always_down : DownClosed always := fun _ _ => rfl

theorem upTo_down (H : Nat) : DownClosed (upTo H) :=
  fun s h => decide_eq_true (Nat.le_trans (Nat.le_succ s) (of_decide_eq_true h))

theorem upTo_on {H t : Nat} (le : t ≤ H) : upTo H t = true := decide_eq_true le

theorem upTo_off {H t : Nat} (gt : ¬ t ≤ H) : upTo H t = false := decide_eq_false gt

/-- **The marked line generates where reproduction is always on**: at (kind, carrier), with one
kind, each marked formation's descent to the next marked one is a birth. -/
theorem marked_generates :
    «生成» (lineStep (flow always) (web always) (oneKind Formation))
      ((web always).kindClass (oneKind Formation)) (web always).carrierClass (0, (0, true)) :=
  generation_of_carrying (S := fun y => y.2 = (y.1, true))
    (fun z sz => ⟨(z.1 + 1, (z.1 + 1, true)), rfl,
      descent_carries (acting always_down)
        (Eq.subst (motive := fun g => (flow always).DescendsAt (web always) z.1 (z.1 + 1, true) g)
          sz.symm (descends rfl rfl))
        trivial (embodied always _)⟩)
    rfl

/-- Where reproduction stops after `H`, no member stands from step `H + 2` on. -/
theorem upTo_empty {H N : Nat} (le : H + 2 ≤ N) : (generations (upTo H)).size N = 0 :=
  length_zero_of_no_mem fun _ mp => match N, le, member_of mp with
  | _ + 1, le, ⟨_, stands⟩ => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands (Nat.le_of_eq
      (born_off (upTo_off (fun le' => Nat.not_succ_le_self H
        (Nat.le_trans (Nat.le_of_succ_le_succ le) le'))))))

/-- Where reproduction stops after `H`, every member of every generation degenerates at the kind
grain. -/
theorem upTo_degenerates (H : Nat) {Q : Formation → Formation → Prop} {t : Nat} {p : Formation}
    (mp : p ∈ (generations (upTo H)).family t) :
    «退化» (lineStep (flow (upTo H)) (web (upTo H)) Q) ((web (upTo H)).kindClass Q) (t, p) :=
  degeneration_of_empty (listed_of_kids (only_kids (upTo H))) (x := (t, p)) mp
    (Nat.le_add_left t (H + 2)) (upTo_empty (Nat.le_add_right (H + 2) t))

/-- **A term positive at every step, as `not_all_degenerate_of_positive` asks**: where reproduction
is always on, listed offspring continue their parents at (kind, carrier) and the concordance of
offspring number with the mark is two at every step. -/
theorem positive_throughout :
    KidsContinue (lineStep (flow always) (web always) (oneKind Formation))
      ((web always).kindClass (oneKind Formation)) (generations always) ∧
    ∀ s, (generations always).concordAt s = 2 :=
  ⟨kids_continue (acting always_down) (descended always) (fun _ _ _ _ _ => trivial)
     (fun _ _ k _ _ => embodied always k),
   fun _ => (terms_on (on := always) fun _ _ => rfl).1⟩

/-- **At the grain where each formation is its own kind, (d) as worded holds.** With `Q := (· = ·)`,
a reflexive kind and so a class, and reproduction always on, concordance of offspring number with
the mark is two at every step while every member of every generation degenerates at the kind
grain: no listed offspring is of its parent's kind, so none continues it on the coarse line, and
`KidsContinue` fails. At `Q := (· = ·)` the kind class is the carrier class, and the line from a
member takes no step. So `not_all_degenerate_of_positive` and `not_all_degenerate_while` are laws
of a kind grain at which listed offspring continue their parents, not of every grain. -/
theorem positive_and_degenerate_at_own_kind :
    (∀ s, (generations always).concordAt s = 2) ∧
    ∀ t p, p ∈ (generations always).family t →
      «退化» (lineStep (flow always) (web always) (fun a b : Formation => a = b))
        ((web always).kindClass (fun a b : Formation => a = b)) (t, p) :=
  ⟨positive_throughout.2, fun t p mp => .mk fun z c =>
    match only_kids always (Q := fun a b : Formation => a = b) t p z mp c with
    | ⟨_, mk⟩ => False.elim (match mem_cond mk with
      | ⟨_, ml⟩ =>
        have e1 : z.2.1 = t + 1 := fst_of_mem ml
        have e2 : p.1 = t := (member_of mp).1
        have same : p = z.2 := c.2.2
        Nat.succ_ne_self t (e1.symm.trans ((congrArg Prod.fst same).symm.trans e2)))⟩

/-- **EL1 (a) on the map: the same selection terms through any horizon, two fates.** For every
horizon `H` there are two courses of `Descended` generations on `Flow X X`, only active
formations giving and every formation embodied, with the same families at every step through
`H + 1` and the same selection terms proper at every step through `H` (concordance of offspring
number with the mark two, discordance zero: positive at every step). In the first, reproduction
goes on, and the marked line generates (`«生成»`) at (kind, carrier) from the first marked
member; in the second, reproduction stops after `H`, and the lineage degenerates (`«退化»`)
from it. So the terms through a horizon need not decide the region (one course of terms for each
horizon is shown here); after `H` the terms differ (the second's are zero at `H + 1`, as at any
last nonempty generation). -/
theorem same_terms_two_fates (H : Nat) :
    (flow always).Acting (web always) ∧ (flow (upTo H)).Acting (web (upTo H)) ∧
    (∀ x, (web always).Embodied x) ∧ (∀ x, (web (upTo H)).Embodied x) ∧
    SelectionTerm.Flow.Descended (flow always) (web always) (generations always) ∧
    SelectionTerm.Flow.Descended (flow (upTo H)) (web (upTo H)) (generations (upTo H)) ∧
    (∀ t, t ≤ H + 1 → (generations always).family t = (generations (upTo H)).family t) ∧
    (∀ t, t ≤ H → (generations always).concordAt t = 2 ∧ (generations (upTo H)).concordAt t = 2 ∧
      (generations always).discordAt t = 0 ∧ (generations (upTo H)).discordAt t = 0) ∧
    «生成» (lineStep (flow always) (web always) (oneKind Formation))
      ((web always).kindClass (oneKind Formation)) (web always).carrierClass (0, (0, true)) ∧
    «退化» (lineStep (flow (upTo H)) (web (upTo H)) (oneKind Formation))
      ((web (upTo H)).kindClass (oneKind Formation)) (0, (0, true)) :=
  ⟨acting always_down, acting (upTo_down H), embodied always, embodied (upTo H),
   descended always, descended (upTo H),
   fun t le => (family_of always t (fun _ _ => rfl)).trans
     (family_of (upTo H) t (fun _ lt => upTo_on (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt le)))).symm,
   fun t le =>
     have on : ∀ s, s ≤ t → upTo H s = true := fun _ le' => upTo_on (Nat.le_trans le' le)
     ⟨(terms_on (on := always) fun _ _ => rfl).1, (terms_on on).1,
      (terms_on (on := always) fun _ _ => rfl).2, (terms_on on).2⟩,
   marked_generates,
   upTo_degenerates H (.head _)⟩

/-- **EL1 (d), the evolutionary-suicide witness, as it can hold.** Where reproduction stops after
`H`: the generations are `Descended`, only active formations give, every formation is embodied
and every continuation of a member is one of its listed offspring; concordance of offspring number
with the mark is positive at every step through `H`; generation `H + 1` is nonempty, the last
nonempty one, and both terms are zero there; every generation from `H + 2` on is empty; every
member of every generation degenerates at (kind, carrier), and the lineage from the first marked
member renews and still ends on every branch (`«新而尽»`). Concordance is two through `H`
(`same_terms_two_fates`); this statement carries only that it is positive. Selection favours the
marked member at every generation but the last nonempty one; positive at that one too it cannot
be where listed offspring continue their parents, as here (`not_all_degenerate_while`). The zero
term at a last nonempty generation comes from counting alone
(`SelectionShift.Generations.last_term_zero`). Every
premise of `generation_degenerates_iff` and
`degenerates_iff_line_ends` holds here. -/
theorem positive_but_last (H : Nat) :
    (flow (upTo H)).Acting (web (upTo H)) ∧ (∀ x, (web (upTo H)).Embodied x) ∧
    SelectionTerm.Flow.Descended (flow (upTo H)) (web (upTo H)) (generations (upTo H)) ∧
    KidsContinue (lineStep (flow (upTo H)) (web (upTo H)) (oneKind Formation))
      ((web (upTo H)).kindClass (oneKind Formation)) (generations (upTo H)) ∧
    ContinuationsAreKids (lineStep (flow (upTo H)) (web (upTo H)) (oneKind Formation))
      ((web (upTo H)).kindClass (oneKind Formation)) (generations (upTo H)) ∧
    (∀ t, t ≤ H → 0 < (generations (upTo H)).concordAt t) ∧
    0 < (generations (upTo H)).size (H + 1) ∧
    (generations (upTo H)).concordAt (H + 1) = 0 ∧ (generations (upTo H)).discordAt (H + 1) = 0 ∧
    (∀ N, H + 2 ≤ N → (generations (upTo H)).size N = 0) ∧
    (∀ t p, p ∈ (generations (upTo H)).family t →
      «退化» (lineStep (flow (upTo H)) (web (upTo H)) (oneKind Formation))
        ((web (upTo H)).kindClass (oneKind Formation)) (t, p)) ∧
    «新而尽» (lineStep (flow (upTo H)) (web (upTo H)) (oneKind Formation))
      ((web (upTo H)).kindClass (oneKind Formation)) (web (upTo H)).carrierClass (0, (0, true)) :=
  have off : upTo H (H + 1) = false := upTo_off (Nat.not_succ_le_self H)
  ⟨acting (upTo_down H), embodied (upTo H), descended (upTo H),
   kids_continue (acting (upTo_down H)) (descended (upTo H)) (fun _ _ _ _ _ => trivial)
     (fun _ _ k _ _ => embodied (upTo H) k),
   only_kids (upTo H),
   fun _ le => Nat.lt_of_lt_of_le (Nat.succ_pos 1) (Nat.le_of_eq
     (terms_on (fun _ le' => upTo_on (Nat.le_trans le' le))).1.symm),
   Nat.lt_of_lt_of_le (Nat.succ_pos 1) (Nat.le_of_eq (congrArg List.length
     (family_of (upTo H) (H + 1) (fun _ lt => upTo_on (Nat.le_of_lt_succ lt)))).symm),
   (terms_off off).1, (terms_off off).2,
   fun _ le => upTo_empty le,
   fun _ _ mp => upTo_degenerates H mp,
   upTo_degenerates H (.head _), (0, (0, true)), (1, (1, true)), .inl rfl,
   descent_carries (acting (upTo_down H)) (descends (upTo_on (Nat.zero_le H)) rfl) trivial
     (embodied (upTo H) _)⟩

end Courses

end LineageRegions

end Becoming
