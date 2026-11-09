import Becoming.PersistingChoices
import Becoming.BeyondCoupling

/-!
# ReadingsPersist: which readings persist (所续之读)

On 9 November 2026 Ren said of route (b), ethics forming within the dynamics, "ok - 这一类请平行化认真完成，
非常重要" (kept in `sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md`), and on 8
November that "it doesn't need to be ranking/comparison", that "there is no 'permeant self'", and that
for life which does not create more future "it simply 'cease to exist'"
(`sources/15-codex-theory-conversations/2026-11-08-within-becoming-no-should.md`). This module is route
(b)'s piece J2: it asks which readings persist, not which order forms. A self here is a line of relata
that come to stand, each carrying the reading it inherits and acting by the act that reading gives; the
course is what those acts generate; the standpoints at a step are the lines alive then, and the pool of a
selection is read off the course. No ranking, no ethical premise and no axiom enters.

* **A world acting by its readings, on the course the acts generate.** Each relatum carries a reading and
  exchanges as the act that reading gives (`ExchangeLaw.byReading`). Where every member of a part carries
  `sig`, that world is Bound's `law.withAct part (act sig)`, by construction (`byReading_withAct`). A
  balanced flow in which every formation exchanges as a law of what has stood gives, under the flow's own
  levels, has the levels the law generates (`ExchangeLaw.levels_of_follows`), and the course is feasible
  (`ExchangeLaw.feasible_of_follows`): balance gives the feasibility `ExchangeLaw.course_unique` takes as a
  premise. So whatever such a world shows is the course its acts generate, nothing supplied beyond the
  acts, the start and the relata present.
* **The line read off the course.** From founders and a listing of the relata, a member's offspring
  across a step are the listed relata descending from it then (`Flow.lineOf`); the line is G3's
  `Descended` by construction (`Flow.lineOf_descended`). Where readings are inherited along descent
  (`Flow.Inherits`), every member of every cohort carries the founders' reading (`Flow.lineOf_carries`).
  G3's premise `realized`, that an ending choice is realized as an overdraw, holds with nothing supplied
  where every occasion picks the reading the line carries and the world is the course that reading's world
  generates, and G3's keeping-above-ending law follows for the line read off it
  (`Flow.carried_keeping_above_ending`); with several occasions picking differently a run made of the
  picks would be needed, and is not built here. What does not hold by construction: Bound's
  `ActReadsWithin` is a property of how an act reads its index, and carrying the index changes nothing in
  it; it stays a premise (`line_standing_unselected_of_reads`), and the laws below are stated with the
  agreement of the two acts on what couples in, which the witness meets.
* **Standpoints in time.** A line is alive at a step where its cohort then has a member
  (`Flow.LineAlive`). A line reaches a relatum before a step where a member of one of its cohorts, at an
  earlier step and a member then, exchanged with a condition the relatum requires at the step
  (`Flow.LineReachesBefore`, `Flow.ReachesBefore` lifted to lines with membership dated). It is
  `ReachesBefore` for every part holding the line's members (`LineReachesBefore.reachesBefore`), and lies
  within affecting, which is blind to time (`LineReachesBefore.affects`).
* **Persistence selects no reading beyond the line's coupling closure.** Let the line carry `sig` or
  `sig'`, the rest acting by a law of what has stood reading through coupling, the two acts laws of what has
  stood agreeing on everything coupled into the line's coupling closure drawn through the two courses, both
  courses feasible, and each slot's own standing coupled into it. Then the line's slots stand at
  arbitrarily late steps in one course exactly when in the other (`line_standing_unselected`; with the act
  indexed by significance under `ActReadsWithin`, `line_standing_unselected_of_reads`). This is
  `act_courses_unselected_throughout` with standing late as the selection (`Web.standsLate_readOffCouplings`):
  near-definitional. A persisting line read off a flow stands late within any group holding its cohorts
  (`Flow.lineOf_standsLate`).
* **The pool read off the course, and a selection removing its own readers.** Among listed lines, the pool
  a course gives at a step is the lines alive in it then (`AliveIn`). Selection by persistence read off that
  pool holds where, from some step on, every line alive persists (`SurvivorsPersist`); read off a fixed
  pool, where every line persists (`AllPersist`). A course removes a line from its pool where the line is
  alive at the start and not from some step on (`RemovesLine`), and a selection removes its own readers
  where it holds at a course removing a line of readers (`RemovesItsReaders`), stateable now that the pool
  is read off the course. Read off the course's pool, selection by persistence is not turned by removal:
  every course in which, from some step on, each line persists or is not alive passes it
  (`survivorsPersist_of_settled`); read off a fixed pool it is turned by every removal
  (`not_allPersist_of_removes`). A reader lying within a group's coupling closure drawn through two courses
  whose acts agree on everything coupled into that closure stands at every step in the one exactly when in
  the other (`reader_kept_alike`): no selection between those acts removes it. All near-definitional.
* **Witnesses** (`ReadingsPersist.Habitat`, every course generated by the acts, `Habitat.generated`). A
  line of two slots passing its standing on at every step draws on a source; a dweller's line of two slots
  depends on a habitat. The line's reading is its own line only (draws two from the source, clears the
  habitat), the line and its source (draws one, clears the habitat) or everything (draws one, spares it).
  Where the source renews itself and nothing comes back from the dweller: the first reading's line
  overdraws and ends; the second's persists and the dweller's line ends; the third's persists and so does
  the dweller's (`Habitat.beyond_which_persist`). There `line_standing_unselected` holds with every premise
  met by the model, so the line's persistence cannot tell the reading that clears from the one that spares
  (`Habitat.beyond_standing_unselected`): a model meeting every premise of
  `act_courses_unselected_throughout`, with the acts indexed by what the line carries. Where the dweller's line renews the source: the second reading's line ends with the dweller's,
  and the third's persists with it (`Habitat.back_which_persist`). In the course of the second reading with
  nothing coming back, selection by persistence read off the pool the course gives holds while the course
  removes the dweller's line, whose continuation reads the habitat, from that pool; read off the fixed pool
  it fails there (`Habitat.cleared_removes_its_readers`); where the dweller renews the source the course
  removing it removes the line too (`Habitat.clearedBack_removes_both`). The line reaches the dweller's line
  before the second step by clearing the habitat (`Habitat.cleared_reaches_dweller`); with nothing coming
  back the dweller's line reaches nothing (`Habitat.cleared_dweller_reaches_nothing`), and where it renews
  the source it reaches the line (`Habitat.clearedBack_dweller_reaches_line`).

**Readings (the AI's, 9 November 2026, not yet read by Ren).**
- What persistence selects is an act's trace on what returns to the line, not a scope. Where something
  lies beyond the line's coupling closure, a reading counting it and one leaving it out persist alike: the
  critic's expectation holds, as a law and with a witness. Where the dweller's loss returns, the reading
  whose act keeps it is the one that persists, because its act keeps what returns, not because it is wider;
  a narrow reading whose act left the dweller alone would persist as well (the law, read the other way).
- Read with Ren's 8 November words, a reading that does not keep what returns to its line ceases with it;
  nothing here forms a reading wider than what returns, and nothing ranks the readings that persist. The
  cascade a narrow reading brings beyond (the dweller's line ending) is not registered by the narrow line's
  own persistence.
- Read for alignment: survivorship read off the survivors cannot be turned by removing members, so a
  selection read off the pool its own course gives can remove its readers without trace; it is turned only
  where the removal returns to the selectors (the second world), or where the readers lie where the
  selection's alternatives do not reach. That is GOALS' first condition put on the flow: keep the readers
  coupled in, or out of the selection's reach.

What is not derived: how a reading arises or changes (readings here are carried and filtered, never varied
or learned); the act a reading gives (supplied, with `ActReadsWithin` a premise); several lines competing
for a share (selection here is persistence, all or nothing, not RuleShaping's share); a reading in time
before a loss passes its point of no return (GOALS' second condition); which relata are listed and which
founders start a line. Every declaration has an empty axiom report.
-/

namespace Becoming

variable {X Sig : Type}

/-! ## A world whose relata act by the readings they carry -/

namespace ExchangeLaw

/-- **Each relatum acts by its reading.** Every relatum carries a reading (`read`), and across each
step exchanges as the act that reading gives (`act`, Bound's act indexed by what is carried). -/
def byReading (act : Sig → ExchangeLaw X X) (read : X → Sig) : ExchangeLaw X X :=
  ⟨fun t h l c => (act (read h)).take t h l c, fun t h l c => (act (read h)).give t h l c⟩

/-- Each relatum's act, whatever reading it carries, reads only what couples into that relatum. -/
def ReadsThroughOwn (act : Sig → ExchangeLaw X X) (W : Web X X) (obs : X → X → Prop) : Prop :=
  ∀ σ h t l l', W.AlikeThroughUpTo obs h l l' t → (act σ).GivesAlike t h l l'

variable {act : Sig → ExchangeLaw X X} {read : X → Sig}

/-- **The part carrying a reading acts by its act, by construction.** Where every member of the part
carries `sig`, the world acting by its readings is the world in which the part acts by `act sig` and
the rest by its readings: Bound's `law.withAct part (act sig)`, with no premise. -/
theorem byReading_withAct {part : X → Bool} {sig : Sig}
    (carries : ∀ h, part h = true → read h = sig) (t : Nat) (h : X) (l : Nat → X → Nat) (c : X) :
    (byReading act read).take t h l c = ((byReading act read).withAct part (act sig)).take t h l c ∧
      (byReading act read).give t h l c =
        ((byReading act read).withAct part (act sig)).give t h l c := by
  show (act (read h)).take t h l c =
      (bif part h then (act sig).take t h l c else (act (read h)).take t h l c) ∧
    (act (read h)).give t h l c =
      (bif part h then (act sig).give t h l c else (act (read h)).give t h l c)
  cases inPart : part h with
  | false => exact ⟨rfl, rfl⟩
  | true => exact carries h inPart ▸ ⟨rfl, rfl⟩

/-- Acts that read what has stood give a world that reads what has stood. -/
theorem byReading_nonanticipating (na : ∀ σ, (act σ).Nonanticipating) (read : X → Sig) :
    (byReading act read).Nonanticipating :=
  fun t h l l' agree c => na (read h) t h l l' agree c

/-- Acts reading only what couples into their relatum give a world reading through coupling, for
every part. -/
theorem byReading_through {W : Web X X} {obs : X → X → Prop} (reads : ReadsThroughOwn act W obs)
    (read : X → Sig) (part : X → Bool) : (byReading act read).Through W obs part :=
  fun h _ t l l' alike => reads (read h) h t l l' alike

/-- And each reading's act reads through the coupling of every member of every part. -/
theorem ReadsThroughOwn.through_act {W : Web X X} {obs : X → X → Prop} (reads : ReadsThroughOwn act W obs)
    (σ : Sig) (part : X → Bool) : (act σ).Through W obs part :=
  fun h _ t l l' alike => reads σ h t l l' alike

end ExchangeLaw

/-! ## The course a law generates is any balanced flow following it -/

section Generated

variable {F C : Type} {law : ExchangeLaw F C} {L : Flow F C} {W : Web F C}
  {present : Nat → List F} {start : C → Nat}

/-- Where a flow follows a law of what has stood under levels agreeing with the generated levels up to
`t`, it takes and gives in total across the step from `t` what the generated course does. -/
theorem Flow.totals_of_follows (na : law.Nonanticipating) (onPresent : ∀ t, L.present t = present t)
    (follows : L.Follows law (fun _ => false) W.level) {t : Nat}
    (agree : AgreeUpTo W.level (law.levels present start) t) (c : C) :
    L.taken t c = (law.course present start).taken t c ∧
      L.given t c = (law.course present start).given t c :=
  Flow.totals_alike_of_each (onPresent t) (fun h c =>
    ⟨(follows h rfl t c).1.trans (na t h _ _ agree c).1,
     (follows h rfl t c).2.trans (na t h _ _ agree c).2⟩) c

/-- **A balanced flow following a law of what has stood has the generated levels.** Let a flow, with
the given formations present, balance on a web, every formation exchanging as the law gives under the
web's own levels, starting at the given levels. Then its levels are the levels the law generates, at
every step. No feasibility is supplied: balance gives it. -/
theorem ExchangeLaw.levels_of_follows (na : law.Nonanticipating) (balances : L.Balances W)
    (onPresent : ∀ t, L.present t = present t) (follows : L.Follows law (fun _ => false) W.level)
    (begins : ∀ c, W.level 0 c = start c) :
    ∀ t, AgreeUpTo W.level (law.levels present start) t
  | 0 => fun s le c => match s, le with
    | 0, _ => begins c
  | t + 1 => fun s le c =>
    have agree := ExchangeLaw.levels_of_follows na balances onPresent follows begins t
    match le_succ_cases le with
    | .inl before => agree s before c
    | .inr now =>
      have totals := Flow.totals_of_follows na onPresent follows agree c
      have step := (ExchangeLaw.levels_succ (law := law) (present := present) (start := start) t c).trans
        (congrArg (fun k => law.levels present start t c +
            law.givenUnder present (law.history present start t) t c - k)
          (ExchangeLaw.totals_under na t c).1)
      have step' := step.trans (congrArg (fun g => law.levels present start t c + g -
          (law.course present start).taken t c) (ExchangeLaw.totals_under na t c).2)
      now ▸ ((Naturals.add_sub_cancel (W.level (t + 1) c) (L.taken t c)).symm.trans
        (congrArg (· - L.taken t c) ((balances t c).trans
          (congrArg (· + L.given t c) (agree t (Nat.le_refl t) c))))).trans
          ((congrArg (fun g => law.levels present start t c + g - L.taken t c) totals.2).trans
            ((congrArg (fun k => law.levels present start t c +
                (law.course present start).given t c - k) totals.1).trans step'.symm))

/-- **And the course it generates is feasible.** Under the same hypotheses the law never takes more
from a condition than stands on it and is given to it. -/
theorem ExchangeLaw.feasible_of_follows (na : law.Nonanticipating) (balances : L.Balances W)
    (onPresent : ∀ t, L.present t = present t) (follows : L.Follows law (fun _ => false) W.level)
    (begins : ∀ c, W.level 0 c = start c) : law.Feasible present start :=
  fun t c =>
    have agree := ExchangeLaw.levels_of_follows na balances onPresent follows begins t
    have totals := Flow.totals_of_follows na onPresent follows agree c
    totals.1 ▸ totals.2 ▸ agree t (Nat.le_refl t) c ▸
      (Nat.le_trans (Nat.le_add_left (L.taken t c) (W.level (t + 1) c))
        (Nat.le_of_eq (balances t c)))

end Generated

/-! ## The line read off a flow -/

namespace Flow

variable [DecidableEq X] (L : Flow X X) (W : Web X X)

/-- Whether `x` descends from `g` across the step from `t`, decided. -/
def descendsB (t : Nat) (x g : X) : Bool :=
  (L.present t).contains g &&
    (decide (0 < L.give t g x) && (decide (¬ 0 < W.level t x) && decide (0 < W.level (t + 1) x)))

variable {L W}

theorem descendsB_iff {t : Nat} {x g : X} : L.descendsB W t x g = true ↔ L.DescendsAt W t x g :=
  ⟨fun d =>
    have d1 := ListTests.and_true_iff.mp d
    have d2 := ListTests.and_true_iff.mp d1.2
    have d3 := ListTests.and_true_iff.mp d2.2
    ⟨ListTests.contains_true_iff.mp d1.1, ListTests.decide_true_iff.mp d2.1,
     ListTests.decide_true_iff.mp d3.1, ListTests.decide_true_iff.mp d3.2⟩,
   fun ⟨present, gives, comes⟩ => ListTests.and_true_iff.mpr ⟨ListTests.contains_true_iff.mpr present,
     ListTests.and_true_iff.mpr ⟨ListTests.decide_true_iff.mpr gives,
       ListTests.and_true_iff.mpr ⟨ListTests.decide_true_iff.mpr comes.1,
         ListTests.decide_true_iff.mpr comes.2⟩⟩⟩⟩

variable (L W)

/-- **The line read off a flow.** From the founders, a member's offspring across a step are the listed
relata that descend from it across that step: the lineage the flow shows, nothing supplied beyond the
founders and the listing. No amount is read (`amount` is zero). -/
def lineOf (members first : List X) : SelectionTerm.Generations X :=
  ⟨first, fun t p => members.filter (fun x => L.descendsB W t x p), fun _ _ => 0⟩

variable {L W} {members first : List X}

/-- A line's offspring are exactly the listed relata descending from the parent. -/
theorem mem_lineOf_kids {t : Nat} {p k : X} :
    k ∈ (L.lineOf W members first).kids t p ↔ k ∈ members ∧ L.DescendsAt W t k p :=
  ListTests.mem_filter_iff.trans ⟨fun ⟨m, d⟩ => ⟨m, descendsB_iff.mp d⟩,
    fun ⟨m, d⟩ => ⟨m, descendsB_iff.mpr d⟩⟩

/-- **The line read off a flow is descended in it, by construction** (G3's `Descended`). -/
theorem lineOf_descended : SelectionTerm.Flow.Descended L W (L.lineOf W members first) :=
  fun _ _ _ _ kid => (mem_lineOf_kids.mp kid).2

/-- A member of a later cohort came to stand across the step before, so stands then. -/
theorem lineOf_stands {t : Nat} {x : X} (member : x ∈ (L.lineOf W members first).family (t + 1)) :
    0 < W.level (t + 1) x :=
  match ListTests.mem_flatMap_iff.mp member with
  | ⟨_, _, kid⟩ => (mem_lineOf_kids.mp kid).2.2.2.2

variable (L W) in
/-- Readings are inherited along descent in the flow: whoever descends from a relatum carries its
reading. -/
def Inherits (read : X → Sig) : Prop :=
  ∀ t x g, L.DescendsAt W t x g → read x = read g

/-- **A line carries its founders' reading.** Where readings are inherited along descent and every
founder carries `sig`, every member of every cohort of the line read off the flow carries `sig`. -/
theorem lineOf_carries {read : X → Sig} {sig : Sig} (inherits : L.Inherits W read)
    (founders : ∀ x, x ∈ first → read x = sig) :
    ∀ t x, x ∈ (L.lineOf W members first).family t → read x = sig
  | 0, x, member => founders x member
  | t + 1, x, member => match ListTests.mem_flatMap_iff.mp member with
    | ⟨p, parent, kid⟩ => (inherits t x p (mem_lineOf_kids.mp kid).2).trans
        (lineOf_carries inherits founders t p parent)

end Flow

/-! ## Standpoints in time: the lines alive at a step, and reach before it -/

namespace Flow

variable {L : Flow X X} {W : Web X X}

/-- A line is alive at a step: its cohort then has a member. The standpoints at a step are read as the
lines alive then. -/
def LineAlive (G : SelectionTerm.Generations X) (t : Nat) : Prop :=
  ∃ x, x ∈ G.family t

variable (L W) in
/-- **A line reaches a relatum before a step** (`Flow.ReachesBefore` lifted to lines): a member of one of
the line's cohorts, at an earlier step, took part in it and took from or gave to a condition the relatum
requires at the step. Membership is dated: the member belonged to the line at the step it exchanged. -/
def LineReachesBefore (G : SelectionTerm.Generations X) (t : Nat) (g : X) : Prop :=
  ∃ h c s, h ∈ G.family s ∧ W.requires t g c ∧ s < t ∧ h ∈ L.present s ∧
    (0 < L.take s h c ∨ 0 < L.give s h c)

variable (L W) in
/-- One line reaches another before a step: it reaches a member of the other's cohort then. -/
def LinesReachBefore (G G' : SelectionTerm.Generations X) (t : Nat) : Prop :=
  ∃ g, g ∈ G'.family t ∧ L.LineReachesBefore W G t g

/-- A line reaching a relatum before a step reaches it as `Flow.ReachesBefore` does, for every part
holding every member of every cohort. -/
theorem LineReachesBefore.reachesBefore {G : SelectionTerm.Generations X} {t : Nat} {g : X}
    {part : X → Bool} (holds : ∀ s h, h ∈ G.family s → part h = true)
    (reaches : L.LineReachesBefore W G t g) : L.ReachesBefore W part t g :=
  match reaches with
  | ⟨h, c, s, member, requires, before, present, exchanges⟩ =>
    ⟨h, c, s, holds s h member, requires, before, present, exchanges⟩

/-- **Reach before a step lies within affecting.** A line reaching a relatum before a step has a member,
at some step, that affects it (`Flow.Affects`, blind to time). -/
theorem LineReachesBefore.affects {G : SelectionTerm.Generations X} {t : Nat} {g : X}
    (reaches : L.LineReachesBefore W G t g) : ∃ s h, h ∈ G.family s ∧ L.Affects W h g :=
  match reaches with
  | ⟨h, c, s, member, requires, _, present, exchanges⟩ =>
    ⟨s, h, member, c, ⟨t, requires⟩, s, present, exchanges⟩

/-- A line is reached at a step only while it is alive then. -/
theorem LinesReachBefore.alive {G G' : SelectionTerm.Generations X} {t : Nat}
    (reaches : L.LinesReachBefore W G G' t) : LineAlive G' t :=
  match reaches with
  | ⟨g, member, _⟩ => ⟨g, member⟩

end Flow

/-! ## Persistence read off a course -/

/-- A group of relata stands at arbitrarily late steps under a level history. -/
def StandsLate (group : X → Prop) (l : Nat → X → Nat) : Prop :=
  ∀ N, ∃ t x, N ≤ t ∧ group x ∧ 0 < l t x

/-- **Standing late is read off the group's couplings** wherever each member's own standing is coupled
into it (`ownStanding`, or any coupling holding it). -/
theorem Web.standsLate_readOffCouplings {W : Web X X} {obs : X → X → Prop} {group : X → Prop}
    (own : ∀ x, group x → obs x x) : W.ReadOffCouplings obs group (StandsLate group) :=
  fun _ _ alike => ⟨fun late N => match late N with
      | ⟨t, x, le, member, stands⟩ =>
        ⟨t, x, le, member, (alike x member t).2 x (own x member) ▸ stands⟩,
    fun late N => match late N with
      | ⟨t, x, le, member, stands⟩ =>
        ⟨t, x, le, member, ((alike x member t).2 x (own x member)).symm ▸ stands⟩⟩

/-- A persisting line whose cohorts lie within a group stands late within it. -/
theorem Flow.lineOf_standsLate [DecidableEq X] {L : Flow X X} {W : Web X X} {members first : List X}
    {group : X → Prop} (within : ∀ t x, x ∈ (L.lineOf W members first).family t → group x)
    (persists : (L.lineOf W members first).Persists) : StandsLate group W.level :=
  fun N => match persists (N + 1) with
    | ⟨0, _, late, _⟩ => absurd late (Nat.not_succ_le_zero N)
    | ⟨s + 1, y, late, member⟩ =>
      ⟨s + 1, y, Nat.le_trans (Nat.le_succ N) late, within (s + 1) y member, Flow.lineOf_stands member⟩

/-! ## Which readings persist: blind beyond the line's coupling closure -/

section Unselected

variable {law : ExchangeLaw X X} {W : Web X X} {obs : X → X → Prop} {part : X → Bool}
  {group : X → Prop} {present : Nat → List X} {start : X → Nat}

/-- **Persistence selects no reading beyond the line's coupling closure.** The rest acts by a law of what
has stood reading through coupling; the line (`part`) carries `sig` or `sig'` and acts by the act each
gives (`act`), laws of what has stood, `act sig` reading through its members' coupling, the two acts
agreeing on every condition coupled into the coupling closure of `group` drawn through the two courses;
both courses are feasible. Let each slot of the line lie within that closure and its own standing be
coupled into it. Then the line's slots stand at arbitrarily late steps in the one course exactly when in
the other, whatever the two readings say of what lies beyond. `act_courses_unselected_throughout` with
standing late as the selection. -/
theorem line_standing_unselected {act : Sig → ExchangeLaw X X} {sig sig' : Sig}
    (na : law.Nonanticipating) (naAct : ∀ σ, (act σ).Nonanticipating)
    (through : law.Through W obs part) (actThrough : (act sig).Through W obs (fun h => !part h))
    (feasible : (law.withAct part (act sig)).Feasible present start)
    (feasible' : (law.withAct part (act sig')).Feasible present start)
    (agree : ∀ t h l c, part h = true →
      (∃ g, WithinClosureOf (((law.withAct part (act sig)).course present start).CoupledFromEither W
          ((law.withAct part (act sig')).course present start) obs) group g ∧ W.CoupledInto obs g c) →
        (act sig).take t h l c = (act sig').take t h l c ∧
          (act sig).give t h l c = (act sig').give t h l c)
    {slots : X → Prop} (own : ∀ x, slots x → obs x x)
    (inside : ∀ x, slots x → WithinClosureOf (((law.withAct part (act sig)).course present
      start).CoupledFromEither W ((law.withAct part (act sig')).course present start) obs) group x) :
    StandsLate slots ((law.withAct part (act sig)).levels present start) ↔
      StandsLate slots ((law.withAct part (act sig')).levels present start) :=
  act_courses_unselected_throughout na (naAct sig) (naAct sig') through actThrough feasible feasible'
    agree inside (Web.standsLate_readOffCouplings own)

/-- **The same, with the act indexed by significance** (Bound's `ActReadsWithin`, a premise on how the
act reads its index, not given by the line's carrying it): two significances agreeing within the closure
leave the line's standing late alike. -/
theorem line_standing_unselected_of_reads {Pos : Type}
    {act : (Pos → Nat → X → Prop) → ExchangeLaw X X} {sig sig' : Pos → Nat → X → Prop}
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
    {slots : X → Prop} (own : ∀ x, slots x → obs x x)
    (inside : ∀ x, slots x → WithinClosureOf (((law.withAct part (act sig)).course present
      start).CoupledFromEither W ((law.withAct part (act sig')).course present start) obs) group x) :
    StandsLate slots ((law.withAct part (act sig)).levels present start) ↔
      StandsLate slots ((law.withAct part (act sig')).levels present start) :=
  significance_courses_unselected na naAct through actThrough feasible readsWithin agreeWithin inside
    (Web.standsLate_readOffCouplings own)

/-- **A reader the alternatives do not reach is kept alike.** Under the premises of
`act_courses_unselected_throughout` for two acts of the selecting part, let a reader lie within the
coupling closure of `group` drawn through the two courses, and its own standing be coupled into it. Then
at every step it stands in the one course exactly when in the other: no selection between the two acts
removes it from the pool a course gives while the other keeps it. -/
theorem reader_kept_alike {act act' : ExchangeLaw X X}
    (na : law.Nonanticipating) (naAct : act.Nonanticipating) (naAct' : act'.Nonanticipating)
    (through : law.Through W obs part) (actThrough : act.Through W obs (fun h => !part h))
    (feasible : (law.withAct part act).Feasible present start)
    (feasible' : (law.withAct part act').Feasible present start)
    (agree : ∀ t h l c, part h = true →
      (∃ g, WithinClosureOf (((law.withAct part act).course present start).CoupledFromEither W
          ((law.withAct part act').course present start) obs) group g ∧ W.CoupledInto obs g c) →
        act.take t h l c = act'.take t h l c ∧ act.give t h l c = act'.give t h l c)
    {r : X} (own : obs r r)
    (inside : WithinClosureOf (((law.withAct part act).course present start).CoupledFromEither W
      ((law.withAct part act').course present start) obs) group r) (t : Nat) :
    0 < (law.withAct part act).levels present start t r ↔
      0 < (law.withAct part act').levels present start t r :=
  act_courses_unselected_throughout (pool := fun x => x = r) (select := fun l => 0 < l t r) na naAct
    naAct' through actThrough feasible feasible' agree (fun _ same => same ▸ inside)
    fun _ _ alike => have same := (alike r rfl t).2 r own
      ⟨fun stands => Nat.lt_of_lt_of_le stands (Nat.le_of_eq same),
       fun stands => Nat.lt_of_lt_of_le stands (Nat.le_of_eq same.symm)⟩

end Unselected

/-! ## The pool read off the course, and a selection removing its own readers -/

section Pool

variable {I : Type} {slotsOf : I → X → Prop} {l : Nat → X → Nat}

/-- A line, among lines indexed by `I` with their slots, is alive in a course at a step where one of its
slots stands then. The pool a course gives at a step is the lines alive then. -/
def AliveIn (slotsOf : I → X → Prop) (l : Nat → X → Nat) (t : Nat) (i : I) : Prop :=
  ∃ x, slotsOf i x ∧ 0 < l t x

/-- **Selection by persistence, read off the pool a course gives**: from some step on, every line alive
in the course persists. -/
def SurvivorsPersist (slotsOf : I → X → Prop) (l : Nat → X → Nat) : Prop :=
  ∃ T, ∀ i, (∃ t, T ≤ t ∧ AliveIn slotsOf l t i) → StandsLate (slotsOf i) l

/-- **Selection by persistence, read off a fixed pool**: every listed line persists. -/
def AllPersist (slotsOf : I → X → Prop) (l : Nat → X → Nat) : Prop :=
  ∀ i, StandsLate (slotsOf i) l

/-- **A course removes a line from the pool it gives**: the line is alive at the start and, from some step
on, is not. -/
def RemovesLine (slotsOf : I → X → Prop) (l : Nat → X → Nat) (i : I) : Prop :=
  AliveIn slotsOf l 0 i ∧ ∃ T, ∀ t, T ≤ t → ¬ AliveIn slotsOf l t i

/-- **A selection removing its own readers** (the meta-attractor's shape, stated with the pool read off
the course): the selection holds at a course that removes a line of readers from the pool that course
gives. -/
def RemovesItsReaders (select : (Nat → X → Nat) → Prop) (slotsOf : I → X → Prop) (readers : I → Prop)
    (l : Nat → X → Nat) : Prop :=
  select l ∧ ∃ i, readers i ∧ RemovesLine slotsOf l i

/-- A removed line does not persist. -/
theorem RemovesLine.not_standsLate {i : I} (removes : RemovesLine slotsOf l i) :
    ¬ StandsLate (slotsOf i) l :=
  match removes with
  | ⟨_, T, gone⟩ => fun late => match late T with
    | ⟨t, x, le, slot, stands⟩ => gone t le ⟨x, slot, stands⟩

/-- **Read off the pool a course gives, selection by persistence is not turned by removal.** Where, from
some step on, every line either persists or is not alive, the course passes it, whatever lines it
removed. -/
theorem survivorsPersist_of_settled
    (settled : ∃ T, ∀ i, StandsLate (slotsOf i) l ∨ ∀ t, T ≤ t → ¬ AliveIn slotsOf l t i) :
    SurvivorsPersist slotsOf l :=
  match settled with
  | ⟨T, each⟩ => ⟨T, fun i ⟨t, le, alive⟩ => match each i with
    | .inl late => late
    | .inr gone => absurd alive (gone t le)⟩

/-- **Read off a fixed pool, it is turned by every removal.** -/
theorem not_allPersist_of_removes {i : I} (removes : RemovesLine slotsOf l i) :
    ¬ AllPersist slotsOf l :=
  fun all => removes.not_standsLate (all i)

/-- Passing it read off a fixed pool, a course passes it read off the pool it gives. -/
theorem AllPersist.survivors (all : AllPersist slotsOf l) : SurvivorsPersist slotsOf l :=
  ⟨0, fun i _ => all i⟩

end Pool

/-! ## What persisting shows, on the course a reading generates -/

/-- G3's overdraw of a family of conditions: across `n` steps from `T` its uptake exceeds its
replenishment, from a stock below `n + m`. -/
def Flow.Overdraws (L : Flow X X) (W : Web X X) (ds : List X) (m : Nat) : Prop :=
  ∃ T n, (∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k)) ∧ W.stock ds T < n + m

/-- **The line read off a flow never persists through an overdraw.** G3's `persists_never_overdraws`
for the line read off the flow, its descent given by construction (`Flow.lineOf_descended`). -/
theorem Flow.lineOf_persists_never_overdraws [DecidableEq X] {L : Flow X X} {W : Web X X}
    {members first : List X} (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    (coupled : ∀ s p, p ∈ (L.lineOf W members first).family s →
      ∃ e, e ∈ ds ∧ W.requires s p e ∧ m ≤ W.need s p e)
    (persists : (L.lineOf W members first).Persists) : ¬ L.Overdraws W ds m :=
  fun ⟨T, n, overdraw⟩ => Flow.persists_never_overdraws balances acting dependent
    Flow.lineOf_descended gated coupled persists T n overdraw

/-- **G3's `realized`, by construction.** Let the alternatives be readings, each giving a world law
(`world`), and let a reading end where the course its world generates overdraws. Where every occasion
picks the reading the line carries, `sig`, and the world is the course `world sig` generates, every ending
pick is realized as an overdraw of that course: G3's premise `realized` holds with nothing supplied, and
its keeping-above-ending law follows for the line read off the course. -/
theorem Flow.carried_keeping_above_ending [DecidableEq X] {O : Type} {world : Sig → ExchangeLaw X X}
    {present : Nat → List X} {start : X → Nat} {W : Web X X} {sig : Sig}
    (na : (world sig).Nonanticipating) (feasible : (world sig).Feasible present start)
    (acting : ((world sig).course present start).Acting (W.withLevel ((world sig).levels present start)))
    (dependent : (W.withLevel ((world sig).levels present start)).Dependent)
    {members first ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ ((world sig).course present start).present t → ∀ d, d ∈ ds →
      0 < ((world sig).course present start).give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    (coupled : ∀ s p, p ∈ (((world sig).course present start).lineOf
      (W.withLevel ((world sig).levels present start)) members first).family s →
      ∃ e, e ∈ ds ∧ W.requires s p e ∧ m ≤ W.need s p e)
    (persists : (((world sig).course present start).lineOf
      (W.withLevel ((world sig).levels present start)) members first).Persists)
    {ch : ChoiceOccasions Sig O} (picks : ∀ o, ch.pick o = sig) (none : «无环» ch.Shown) :
    ∃ P : «际» Sig, (∀ x, ¬ P x x) ∧ (∀ x y z, P x y → P y z → P x z) ∧ ch.Accords P ∧
      ∀ x y, ch.Met x y →
        ¬ ((world x).course present start).Overdraws (W.withLevel ((world x).levels present start)) ds m →
        ((world y).course present start).Overdraws (W.withLevel ((world y).levels present start)) ds m →
        P x y :=
  Flow.persisting_keeping_above_ending ((ExchangeLaw.course_balances_iff na W).mpr feasible) acting
    dependent Flow.lineOf_descended gated coupled persists
    (fun o ends => match picks o ▸ ends with | ⟨T, n, overdraw⟩ => ⟨T, n, overdraw⟩) none

/-! ## Lines that end -/

namespace SelectionTerm.Generations

variable {α : Type} {G : SelectionTerm.Generations α}

/-- An empty cohort leaves every later one empty. -/
theorem family_nil_from {T : Nat} (nil : G.family T = []) : ∀ k, G.family (T + k) = []
  | 0 => nil
  | k + 1 => (congrArg (fun F => F.flatMap (G.kids (T + k))) (family_nil_from nil k)).trans rfl

/-- A line with an empty cohort does not persist. -/
theorem not_persists_of_nil {T : Nat} (nil : G.family T = []) : ¬ G.Persists :=
  fun persists => match persists T with
  | ⟨_, y, le, member⟩ => match Nat.le.dest le with
    | ⟨k, at_⟩ => ListTests.not_mem_nil ((congrArg (y ∈ ·)
        ((congrArg G.family at_).symm.trans (family_nil_from nil k))).mp member)

/-- A line with a member in every cohort persists. -/
theorem persists_of_alive (alive : ∀ t, ∃ y, y ∈ G.family t) : G.Persists :=
  fun N => match alive N with
  | ⟨y, member⟩ => ⟨N, y, Nat.le_refl N, member⟩

end SelectionTerm.Generations

/-! ## Witness: a line, its source, a habitat and a dweller -/

namespace ReadingsPersist.Habitat

/-- The line's two slots `a0` and `a1`, the source `s` it draws on, the habitat `h`, and the dweller's
line's two slots `d0` and `d1`. -/
inductive Rel where
  | a0 | a1 | s | h | d0 | d1
  deriving DecidableEq

/-- What the line's members count: their own line only, the line and the source it draws on, or
everything, the dweller included. -/
inductive Reading where
  | own | source | whole

/-- A relatum stands under the levels at a step: its level is at least one. -/
def stands (l : Nat → Rel → Nat) (t : Nat) (x : Rel) : Bool := Nat.ble 1 (l t x)

/-- A relatum is fed at a step: the line's slots where the source stands at two or more, the dweller's
where the habitat stands at one or more; the source and the habitat need nothing. -/
def fed (l : Nat → Rel → Nat) (t : Nat) : Rel → Bool
  | .a0 | .a1 => Nat.ble 2 (l t .s)
  | .d0 | .d1 => Nat.ble 1 (l t .h)
  | .s | .h => true

/-- What a member draws from the source each step: two where it does not count the source, one where
it does. -/
def draw : Reading → Nat
  | .own => 2
  | .source => 1
  | .whole => 1

/-- Whether a member clears the habitat: where it does not count the dweller. -/
def clears : Reading → Bool
  | .own => true
  | .source => true
  | .whole => false

/-- The step at which a clearing act clears: the first. -/
def first : Nat → Nat := Witnesses.profile [1] 0

/-- What each relatum takes from and gives to each condition across a step, given whether it stands
(`st`) and is fed (`fd`). A standing member takes its own unit (each lasts one step) and, fed, passes
one to the other slot of its line; the line's members draw from the source as their reading gives and,
reading the dweller out, clear the habitat at the first step. Where the dweller renews the source
(`back`), each fed member of the dweller's line gives it one; otherwise the source renews itself by
one. -/
def conduct (back : Bool) (σ : Reading) (t : Nat) (st fd : Bool) : Rel → Rel → Nat × Nat
  | .a0, .a0 => (bif st then 1 else 0, 0)
  | .a0, .a1 => (0, bif st && fd then 1 else 0)
  | .a0, .s => (bif st && fd then draw σ else 0, 0)
  | .a0, .h => (bif clears σ && st then first t else 0, 0)
  | .a0, .d0 => (0, 0)
  | .a0, .d1 => (0, 0)
  | .a1, .a0 => (0, bif st && fd then 1 else 0)
  | .a1, .a1 => (bif st then 1 else 0, 0)
  | .a1, .s => (bif st && fd then draw σ else 0, 0)
  | .a1, .h => (bif clears σ && st then first t else 0, 0)
  | .a1, .d0 => (0, 0)
  | .a1, .d1 => (0, 0)
  | .s, .a0 => (0, 0)
  | .s, .a1 => (0, 0)
  | .s, .s => (0, bif back then 0 else 1)
  | .s, .h => (0, 0)
  | .s, .d0 => (0, 0)
  | .s, .d1 => (0, 0)
  | .h, .a0 => (0, 0)
  | .h, .a1 => (0, 0)
  | .h, .s => (0, 0)
  | .h, .h => (0, 0)
  | .h, .d0 => (0, 0)
  | .h, .d1 => (0, 0)
  | .d0, .a0 => (0, 0)
  | .d0, .a1 => (0, 0)
  | .d0, .s => (0, bif back && (st && fd) then 1 else 0)
  | .d0, .h => (0, 0)
  | .d0, .d0 => (bif st then 1 else 0, 0)
  | .d0, .d1 => (0, bif st && fd then 1 else 0)
  | .d1, .a0 => (0, 0)
  | .d1, .a1 => (0, 0)
  | .d1, .s => (0, bif back && (st && fd) then 1 else 0)
  | .d1, .h => (0, 0)
  | .d1, .d0 => (0, bif st && fd then 1 else 0)
  | .d1, .d1 => (bif st then 1 else 0, 0)

/-- **The act a reading gives**: each relatum's conduct read off its own standing and whether it is
fed. -/
def act (back : Bool) (σ : Reading) : ExchangeLaw Rel Rel :=
  ⟨fun t x l c => (conduct back σ t (stands l t x) (fed l t x) x c).1,
   fun t x l c => (conduct back σ t (stands l t x) (fed l t x) x c).2⟩

/-- The line's slots. -/
def isA : Rel → Bool
  | .a0 => true
  | .a1 => true
  | .s => false
  | .h => false
  | .d0 => false
  | .d1 => false

/-- The readings carried when the line carries `σ`: the line `σ`, every other relatum everything (the
others' conduct does not depend on it). -/
def readOf (σ : Reading) (x : Rel) : Reading := bif isA x then σ else .whole

/-- The rest acting by its readings. -/
def restLaw (back : Bool) : ExchangeLaw Rel Rel := ExchangeLaw.byReading (act back) fun _ => .whole

/-- The world in which the line carries `σ`: Bound's `law.withAct part (act σ)`. -/
def world (back : Bool) (σ : Reading) : ExchangeLaw Rel Rel := (restLaw back).withAct isA (act back σ)

/-- **Each relatum acts by the reading it carries.** -/
theorem world_byReading (back : Bool) (σ : Reading) (t : Nat) (x : Rel) (l : Nat → Rel → Nat) (c : Rel) :
    (ExchangeLaw.byReading (act back) (readOf σ)).take t x l c = (world back σ).take t x l c ∧
      (ExchangeLaw.byReading (act back) (readOf σ)).give t x l c = (world back σ).give t x l c := by
  cases x <;> exact ⟨rfl, rfl⟩

def members : List Rel := [.a0, .a1, .s, .h, .d0, .d1]

/-- Every relatum is listed. -/
theorem listed : ∀ x, x ∈ members
  | .a0 => .head _
  | .a1 => .tail _ (.head _)
  | .s => .tail _ (.tail _ (.head _))
  | .h => .tail _ (.tail _ (.tail _ (.head _)))
  | .d0 => .tail _ (.tail _ (.tail _ (.tail _ (.head _))))
  | .d1 => .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))

/-- The line's slots require the source at two, the dweller's the habitat at one. -/
def requires : Rel → Rel → Prop
  | .a0, .s => True
  | .a0, .a0 => False
  | .a0, .a1 => False
  | .a0, .h => False
  | .a0, .d0 => False
  | .a0, .d1 => False
  | .a1, .s => True
  | .a1, .a0 => False
  | .a1, .a1 => False
  | .a1, .h => False
  | .a1, .d0 => False
  | .a1, .d1 => False
  | .d0, .h => True
  | .d0, .a0 => False
  | .d0, .a1 => False
  | .d0, .s => False
  | .d0, .d0 => False
  | .d0, .d1 => False
  | .d1, .h => True
  | .d1, .a0 => False
  | .d1, .a1 => False
  | .d1, .s => False
  | .d1, .d0 => False
  | .d1, .d1 => False
  | .s, _ => False
  | .h, _ => False

def need : Rel → Rel → Nat
  | .a0, _ => 2
  | .a1, _ => 2
  | .s, _ => 1
  | .h, _ => 1
  | .d0, _ => 1
  | .d1, _ => 1

/-- The web with levels `lev`: a relatum is active while it stands. -/
def webOf (lev : Nat → Rel → Nat) : Web Rel Rel :=
  ⟨lev, fun t x => 0 < lev t x, fun _ => requires, fun _ => need, fun _ => requires⟩

/-- The flow in which every relatum exchanges as the world gives under the levels `lev`. -/
def flowOf (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) : Flow Rel Rel :=
  ⟨fun _ => members, fun t x c => (world back σ).take t x lev c,
   fun t x c => (world back σ).give t x lev c⟩

/-- The flow follows the world's law under its own levels, by construction. -/
theorem flowOf_follows (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) :
    (flowOf back σ lev).Follows (world back σ) (fun _ => false) (webOf lev).level :=
  fun _ _ _ _ => ⟨rfl, rfl⟩

/-! ### The acts read only what couples in, and what has stood -/

theorem ble_congr {n a b : Nat} (same : n ≤ a ↔ n ≤ b) : Nat.ble n a = Nat.ble n b := by
  cases ha : Nat.ble n a <;> cases hb : Nat.ble n b
  · rfl
  · exact Bool.noConfusion ((Nat.ble_eq_true_of_le (same.mpr (Nat.le_of_ble_eq_true hb))).symm.trans ha)
  · exact Bool.noConfusion ((Nat.ble_eq_true_of_le (same.mp (Nat.le_of_ble_eq_true ha))).symm.trans hb)
  · rfl

/-- Where two histories agree at a step, every relatum stands and is fed alike then. -/
theorem fed_of_agree {l l' : Nat → Rel → Nat} {t : Nat} (same : ∀ c, l t c = l' t c) :
    ∀ x, fed l t x = fed l' t x
  | .a0 | .a1 => congrArg (Nat.ble 2) (same .s)
  | .d0 | .d1 => congrArg (Nat.ble 1) (same .h)
  | .s | .h => rfl

/-- Admission of the line's slots is the source at two or more; of the dweller's, the habitat at one or
more. -/
theorem admits_iff {lev : Nat → Rel → Nat} {m : Rel → Nat} {t : Nat} :
    ∀ x, (webOf lev).Admits m t x ↔ (fed (fun _ => m) 0 x = true)
  | .a0 => ⟨fun adm => Nat.ble_eq_true_of_le (adm .s trivial),
      fun le c => match c with
        | .s => fun _ => Nat.le_of_ble_eq_true le
        | .a0 | .a1 | .h | .d0 | .d1 => False.elim⟩
  | .a1 => ⟨fun adm => Nat.ble_eq_true_of_le (adm .s trivial),
      fun le c => match c with
        | .s => fun _ => Nat.le_of_ble_eq_true le
        | .a0 | .a1 | .h | .d0 | .d1 => False.elim⟩
  | .d0 => ⟨fun adm => Nat.ble_eq_true_of_le (adm .h trivial),
      fun le c => match c with
        | .h => fun _ => Nat.le_of_ble_eq_true le
        | .a0 | .a1 | .s | .d0 | .d1 => False.elim⟩
  | .d1 => ⟨fun adm => Nat.ble_eq_true_of_le (adm .h trivial),
      fun le c => match c with
        | .h => fun _ => Nat.le_of_ble_eq_true le
        | .a0 | .a1 | .s | .d0 | .d1 => False.elim⟩
  | .s => ⟨fun _ => rfl, fun _ c => match c with
        | .a0 | .a1 | .s | .h | .d0 | .d1 => False.elim⟩
  | .h => ⟨fun _ => rfl, fun _ c => match c with
        | .a0 | .a1 | .s | .h | .d0 | .d1 => False.elim⟩

/-- Fed alike wherever admitted alike. -/
theorem fed_of_admits {lev : Nat → Rel → Nat} {l l' : Nat → Rel → Nat} {t : Nat} {x : Rel}
    (same : (webOf lev).Admits (l t) t x ↔ (webOf lev).Admits (l' t) t x) : fed l t x = fed l' t x :=
  match x, same with
  | .a0, same => (admits_iff .a0).symm.trans (same.trans (admits_iff .a0)) |> fun e =>
      match ha : fed l t .a0, hb : fed l' t .a0 with
      | true, true => rfl
      | false, false => rfl
      | true, false => Bool.noConfusion (hb.symm.trans (e.mp ha))
      | false, true => Bool.noConfusion (ha.symm.trans (e.mpr hb))
  | .a1, same => (admits_iff .a1).symm.trans (same.trans (admits_iff .a1)) |> fun e =>
      match ha : fed l t .a1, hb : fed l' t .a1 with
      | true, true => rfl
      | false, false => rfl
      | true, false => Bool.noConfusion (hb.symm.trans (e.mp ha))
      | false, true => Bool.noConfusion (ha.symm.trans (e.mpr hb))
  | .d0, same => (admits_iff .d0).symm.trans (same.trans (admits_iff .d0)) |> fun e =>
      match ha : fed l t .d0, hb : fed l' t .d0 with
      | true, true => rfl
      | false, false => rfl
      | true, false => Bool.noConfusion (hb.symm.trans (e.mp ha))
      | false, true => Bool.noConfusion (ha.symm.trans (e.mpr hb))
  | .d1, same => (admits_iff .d1).symm.trans (same.trans (admits_iff .d1)) |> fun e =>
      match ha : fed l t .d1, hb : fed l' t .d1 with
      | true, true => rfl
      | false, false => rfl
      | true, false => Bool.noConfusion (hb.symm.trans (e.mp ha))
      | false, true => Bool.noConfusion (ha.symm.trans (e.mpr hb))
  | .s, _ => rfl
  | .h, _ => rfl

/-- The act's conduct is fixed by standing and being fed. -/
theorem act_alike {back : Bool} {σ : Reading} {t : Nat} {x : Rel} {l l' : Nat → Rel → Nat}
    (st : stands l t x = stands l' t x) (fd : fed l t x = fed l' t x) :
    (act back σ).GivesAlike t x l l' := fun c => by
  show (conduct back σ t (stands l t x) (fed l t x) x c).1 =
      (conduct back σ t (stands l' t x) (fed l' t x) x c).1 ∧
    (conduct back σ t (stands l t x) (fed l t x) x c).2 =
      (conduct back σ t (stands l' t x) (fed l' t x) x c).2
  rw [st, fd]
  exact ⟨rfl, rfl⟩

/-- **The acts read what has stood.** -/
theorem act_nonanticipating (back : Bool) (σ : Reading) : (act back σ).Nonanticipating :=
  fun t x _ _ agree => act_alike (congrArg (Nat.ble 1) (agree t (Nat.le_refl t) x))
    (fed_of_agree (agree t (Nat.le_refl t)) x)

/-- **Each act reads only what couples into its relatum**: its own standing (`ownStanding`) and its
admission. -/
theorem act_readsThroughOwn (back : Bool) (lev : Nat → Rel → Nat) :
    ExchangeLaw.ReadsThroughOwn (act back) (webOf lev) ownStanding :=
  fun _ x t _ _ alike => act_alike (congrArg (Nat.ble 1) ((alike t (Nat.le_refl t)).2 x rfl))
    (fed_of_admits (alike t (Nat.le_refl t)).1)

theorem world_nonanticipating (back : Bool) (σ : Reading) : (world back σ).Nonanticipating :=
  ExchangeLaw.withAct_nonanticipating
    (ExchangeLaw.byReading_nonanticipating (act_nonanticipating back) _) (act_nonanticipating back σ)

/-! ### The courses: levels, balance, and the course the acts generate -/

/-- One at even steps, none at odd. -/
def alt : Nat → Nat
  | 0 => 1
  | 1 => 0
  | t + 2 => alt t

/-- One at odd steps, none at even. -/
def alt' : Nat → Nat
  | 0 => 0
  | 1 => 1
  | t + 2 => alt' t

theorem alt_or : ∀ t, 0 < alt t ∨ 0 < alt' t
  | 0 => .inl (Nat.zero_lt_one)
  | 1 => .inr (Nat.zero_lt_one)
  | t + 2 => alt_or t

/-- One at the second step only. -/
def second : Nat → Nat := Witnesses.profile [0, 1] 0

/-- **Kept**: both lines pass their standing on at every step; the source stays at two, the habitat at
one. -/
def keep (t : Nat) : Rel → Nat
  | .a0 => alt t
  | .a1 => alt' t
  | .s => 2
  | .h => 1
  | .d0 => alt t
  | .d1 => alt' t

/-- **Cleared, nothing coming back**: the line clears the habitat at the first step and passes on at
every step; the dweller's line ends after the second step. -/
def cleared (t : Nat) : Rel → Nat
  | .a0 => alt t
  | .a1 => alt' t
  | .s => 2
  | .h => first t
  | .d0 => first t
  | .d1 => second t

/-- The source after an overdraw: two, then one, then rising by one at each step. -/
def overSource : Nat → Nat
  | 0 => 2
  | t + 1 => t + 1

/-- **Overdrawn**: the line draws two where one is renewed, and ends after the second step; it clears
the habitat. -/
def overdrawn (t : Nat) : Rel → Nat
  | .a0 => first t
  | .a1 => second t
  | .s => overSource t
  | .h => first t
  | .d0 => first t
  | .d1 => second t

/-- **Cleared, the dweller renewing the source**: the dweller's line ends after the second step, the
source is no longer renewed, and the line ends after the third. -/
def clearedBack (t : Nat) : Rel → Nat
  | .a0 => Witnesses.profile [1, 0, 1] 0 t
  | .a1 => second t
  | .s => Witnesses.profile [2, 2] 1 t
  | .h => first t
  | .d0 => first t
  | .d1 => second t

/-- The starting levels, common to every course. -/
def start : Rel → Nat := keep 0

def present : Nat → List Rel := fun _ => members

theorem keep_balances : ∀ (back : Bool) (t : Nat) (c : Rel),
    (webOf keep).level (t + 1) c + (flowOf back .whole keep).taken t c =
      (webOf keep).level t c + (flowOf back .whole keep).given t c
  | false, 0, c => by cases c <;> rfl
  | false, 1, c => by cases c <;> rfl
  | false, t + 2, c => keep_balances false t c
  | true, 0, c => by cases c <;> rfl
  | true, 1, c => by cases c <;> rfl
  | true, t + 2, c => keep_balances true t c

theorem cleared_balances_late : ∀ (t : Nat) (c : Rel),
    (webOf cleared).level (t + 3) c + (flowOf false .source cleared).taken (t + 2) c =
      (webOf cleared).level (t + 2) c + (flowOf false .source cleared).given (t + 2) c
  | 0, c => by cases c <;> rfl
  | 1, c => by cases c <;> rfl
  | t + 2, c => cleared_balances_late t c

theorem cleared_balances : (flowOf false .source cleared).Balances (webOf cleared)
  | 0, c => by cases c <;> rfl
  | 1, c => by cases c <;> rfl
  | t + 2, c => cleared_balances_late t c

theorem overdrawn_balances : (flowOf false .own overdrawn).Balances (webOf overdrawn)
  | 0, c => by cases c <;> rfl
  | 1, c => by cases c <;> rfl
  | _ + 2, c => by cases c <;> rfl

theorem clearedBack_balances : (flowOf true .source clearedBack).Balances (webOf clearedBack)
  | 0, c => by cases c <;> rfl
  | 1, c => by cases c <;> rfl
  | 2, c => by cases c <;> rfl
  | _ + 3, c => by cases c <;> rfl

/-- **Each is the course the acts generate.** The levels of each flow are the levels the world's law
generates from the starting levels (`ExchangeLaw.levels_of_follows`): nothing about the courses is
supplied beyond the acts, the starting levels and the relata present. -/
theorem generated :
    (∀ back t c, keep t c = (world back .whole).levels present start t c) ∧
    (∀ t c, cleared t c = (world false .source).levels present start t c) ∧
    (∀ t c, overdrawn t c = (world false .own).levels present start t c) ∧
    (∀ t c, clearedBack t c = (world true .source).levels present start t c) :=
  ⟨fun back t c => ExchangeLaw.levels_of_follows (world_nonanticipating back .whole) (keep_balances back)
      (fun _ => rfl) (flowOf_follows back .whole keep) (fun _ => rfl) t t (Nat.le_refl t) c,
   fun t c => ExchangeLaw.levels_of_follows (world_nonanticipating false .source) cleared_balances
      (fun _ => rfl) (flowOf_follows false .source cleared) (fun c => by cases c <;> rfl) t t
      (Nat.le_refl t) c,
   fun t c => ExchangeLaw.levels_of_follows (world_nonanticipating false .own) overdrawn_balances
      (fun _ => rfl) (flowOf_follows false .own overdrawn) (fun c => by cases c <;> rfl) t t
      (Nat.le_refl t) c,
   fun t c => ExchangeLaw.levels_of_follows (world_nonanticipating true .source) clearedBack_balances
      (fun _ => rfl) (flowOf_follows true .source clearedBack) (fun c => by cases c <;> rfl) t t
      (Nat.le_refl t) c⟩

/-! ### The lines read off the courses -/

/-- The line from `a0`, read off a course. -/
def lineA (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) : SelectionTerm.Generations Rel :=
  (flowOf back σ lev).lineOf (webOf lev) members [.a0]

/-- The dweller's line from `d0`, read off a course. -/
def lineD (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) : SelectionTerm.Generations Rel :=
  (flowOf back σ lev).lineOf (webOf lev) members [.d0]

/-- **Readings are inherited along descent**, in every course of every world: whatever a relatum gives
to carries its reading. -/
theorem inherits (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) :
    (flowOf back σ lev).Inherits (webOf lev) (readOf σ) := by
  intro t x g descends
  have gives := descends.2.1
  cases g <;> cases x <;> first | rfl | exact absurd gives (Nat.lt_irrefl 0)

/-- **The line carries its reading**: every member of every cohort of the line read off a course
carries the reading `σ`. -/
theorem lineA_carries (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) :
    ∀ t x, x ∈ (lineA back σ lev).family t → readOf σ x = σ :=
  Flow.lineOf_carries (inherits back σ lev) fun x member =>
    match x, member with
    | _, .head _ => rfl

theorem keep_lineA_shift : ∀ (back : Bool) (t : Nat),
    (lineA back .whole keep).family (t + 2) = (lineA back .whole keep).family t
  | false, 0 => rfl
  | true, 0 => rfl
  | back, t + 1 => (congrArg (fun F => F.flatMap ((lineA back .whole keep).kids (t + 2)))
      (keep_lineA_shift back t)).trans rfl

theorem keep_lineD_shift : ∀ (back : Bool) (t : Nat),
    (lineD back .whole keep).family (t + 2) = (lineD back .whole keep).family t
  | false, 0 => rfl
  | true, 0 => rfl
  | back, t + 1 => (congrArg (fun F => F.flatMap ((lineD back .whole keep).kids (t + 2)))
      (keep_lineD_shift back t)).trans rfl

theorem cleared_lineA_shift : ∀ t,
    (lineA false .source cleared).family (t + 4) = (lineA false .source cleared).family (t + 2)
  | 0 => rfl
  | t + 1 => (congrArg (fun F => F.flatMap ((lineA false .source cleared).kids (t + 4)))
      (cleared_lineA_shift t)).trans rfl

theorem keep_lineA_alive (back : Bool) : ∀ t, ∃ y, y ∈ (lineA back .whole keep).family t
  | 0 => ⟨.a0, .head _⟩
  | 1 => ⟨.a1, by cases back <;> exact .head _⟩
  | t + 2 => match keep_lineA_alive back t with
    | ⟨y, m⟩ => ⟨y, (congrArg (y ∈ ·) (keep_lineA_shift back t)).mpr m⟩

theorem keep_lineD_alive (back : Bool) : ∀ t, ∃ y, y ∈ (lineD back .whole keep).family t
  | 0 => ⟨.d0, .head _⟩
  | 1 => ⟨.d1, by cases back <;> exact .head _⟩
  | t + 2 => match keep_lineD_alive back t with
    | ⟨y, m⟩ => ⟨y, (congrArg (y ∈ ·) (keep_lineD_shift back t)).mpr m⟩

theorem cleared_lineA_alive : ∀ t, ∃ y, y ∈ (lineA false .source cleared).family t
  | 0 => ⟨.a0, .head _⟩
  | 1 => ⟨.a1, .head _⟩
  | 2 => ⟨.a0, .head _⟩
  | 3 => ⟨.a1, .head _⟩
  | t + 4 => match cleared_lineA_alive (t + 2) with
    | ⟨y, m⟩ => ⟨y, (congrArg (y ∈ ·) (cleared_lineA_shift t)).mpr m⟩

/-- **Kept: both lines persist**, in either world. -/
theorem keep_persists (back : Bool) :
    (lineA back .whole keep).Persists ∧ (lineD back .whole keep).Persists :=
  ⟨SelectionTerm.Generations.persists_of_alive (keep_lineA_alive back),
   SelectionTerm.Generations.persists_of_alive (keep_lineD_alive back)⟩

/-- **Cleared with nothing coming back: the line persists, the dweller's line ends.** -/
theorem cleared_persists :
    (lineA false .source cleared).Persists ∧ ¬ (lineD false .source cleared).Persists :=
  ⟨SelectionTerm.Generations.persists_of_alive cleared_lineA_alive,
   SelectionTerm.Generations.not_persists_of_nil (T := 2) rfl⟩

/-- **Overdrawn: the line ends**, and so does the dweller's. -/
theorem overdrawn_ends :
    ¬ (lineA false .own overdrawn).Persists ∧ ¬ (lineD false .own overdrawn).Persists :=
  ⟨SelectionTerm.Generations.not_persists_of_nil (T := 2) rfl,
   SelectionTerm.Generations.not_persists_of_nil (T := 2) rfl⟩

/-- **Cleared where the dweller renews the source: both lines end.** -/
theorem clearedBack_ends :
    ¬ (lineA true .source clearedBack).Persists ∧ ¬ (lineD true .source clearedBack).Persists :=
  ⟨SelectionTerm.Generations.not_persists_of_nil (T := 3) rfl,
   SelectionTerm.Generations.not_persists_of_nil (T := 2) rfl⟩

/-! ### Persistence blind beyond the line's coupling closure: Bound's law met by the model -/

/-- The line's slots and the source: where nothing comes back, the region holding the line's coupling
closure. -/
def inR : Rel → Bool
  | .a0 => true
  | .a1 => true
  | .s => true
  | .h => false
  | .d0 => false
  | .d1 => false

/-- Where nothing comes back, the habitat and the dweller's slots take from and give to nothing in the
region, whatever the levels. -/
theorem quiet (σ : Reading) (t : Nat) (l : Nat → Rel → Nat) :
    ∀ y c, inR y = false → inR c = true →
      (world false σ).take t y l c = 0 ∧ (world false σ).give t y l c = 0 := by
  intro y c hy hc
  cases y <;> cases c <;> first | exact ⟨rfl, rfl⟩ | exact Bool.noConfusion hy | exact Bool.noConfusion hc

/-- What couples into a member of the region lies in it: the line's slots require the source, and each
relatum's own standing couples into it. -/
theorem coupled_in_region {lev : Nat → Rel → Nat} {g c : Rel} (inG : inR g = true)
    (coupled : (webOf lev).CoupledInto ownStanding g c) : inR c = true :=
  match coupled with
  | .inr own => (congrArg inR own).trans inG
  | .inl ⟨_, req⟩ => by
    cases g <;> cases c <;> first | rfl | exact Bool.noConfusion inG | exact False.elim req

/-- Nothing outside the region exchanges with what lies in it, in either course. -/
theorem not_exchanges (σ : Reading) {y c : Rel} (hy : inR y = false) (hc : inR c = true) :
    ¬ ((world false σ).course present start).Exchanges y c :=
  fun ⟨t, _, exch⟩ => exch.elim
    (fun p => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le p (Nat.le_of_eq (quiet σ t _ y c hy hc).1)))
    (fun p => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le p (Nat.le_of_eq (quiet σ t _ y c hy hc).2)))

/-- **Where nothing comes back, the region is closed** under being affected through what couples in,
drawn through any two of the world's courses. -/
theorem region_closed (σ σ' : Reading) (lev : Nat → Rel → Nat) :
    «闭» (((world false σ).course present start).CoupledFromEither (webOf lev)
      ((world false σ').course present start) ownStanding) (fun g => inR g = true) :=
  fun _ y inG related => show inR y = true from match hy : inR y with
    | true => rfl
    | false => absurd related fun related => match related with
      | .inl ⟨_, coupled, exchanges⟩ => not_exchanges σ hy (coupled_in_region inG coupled) exchanges
      | .inr ⟨_, coupled, exchanges⟩ => not_exchanges σ' hy (coupled_in_region inG coupled) exchanges

/-- So the line's coupling closure lies within the line's slots and the source: the habitat and the
dweller lie beyond it. -/
theorem closure_in_region (σ σ' : Reading) (lev : Nat → Rel → Nat) {g : Rel}
    (within : WithinClosureOf (((world false σ).course present start).CoupledFromEither (webOf lev)
      ((world false σ').course present start) ownStanding) (fun x => isA x = true) g) :
    inR g = true :=
  match within with
  | ⟨f, inA, closure⟩ => closure (fun g => inR g = true) (region_closed σ σ' lev)
      (match f, inA with
        | .a0, _ => rfl
        | .a1, _ => rfl)

/-- **Persistence cannot tell reading the dweller out from reading it in, where nothing comes back.**
In the world where the source renews itself, the line's slots stand at arbitrarily late steps in the
course where the line clears the habitat exactly when in the course where it spares it: an instance of
`line_standing_unselected`, every premise discharged in the model (acts of what has stood reading only
what couples in, feasible generated courses, the two acts agreeing on everything coupled into the line's
coupling closure). -/
theorem beyond_standing_unselected :
    StandsLate (fun x => isA x = true) ((world false .source).levels present start) ↔
      StandsLate (fun x => isA x = true) ((world false .whole).levels present start) :=
  line_standing_unselected (law := restLaw false) (W := webOf keep) (obs := ownStanding)
    (part := isA) (group := fun x => isA x = true) (act := act false) (sig := .source) (sig' := .whole)
    (ExchangeLaw.byReading_nonanticipating (act_nonanticipating false) _) (act_nonanticipating false)
    (ExchangeLaw.byReading_through (act_readsThroughOwn false keep) _ isA)
    ((act_readsThroughOwn false keep).through_act .source _)
    (ExchangeLaw.feasible_of_follows (world_nonanticipating false .source) cleared_balances
      (fun _ => rfl) (flowOf_follows false .source cleared) (fun c => by cases c <;> rfl))
    (ExchangeLaw.feasible_of_follows (world_nonanticipating false .whole) (keep_balances false)
      (fun _ => rfl) (flowOf_follows false .whole keep) (fun _ => rfl))
    (fun t y l c inA ⟨g, within, coupled⟩ =>
      have hc : inR c = true := coupled_in_region (closure_in_region .source .whole keep within) coupled
      by cases y <;> cases c <;> first | exact ⟨rfl, rfl⟩ | exact Bool.noConfusion inA | exact Bool.noConfusion hc)
    (fun _ _ => rfl) (fun x inA => ⟨x, inA, WithinClosure.refl x⟩)

/-! ### Which readings persist -/

/-- A course in which a line's two slots alternate, one at even and one at odd steps, stands late in
it. -/
theorem standsLate_of_alt {group : Rel → Prop} {lev : Nat → Rel → Nat} {x y : Rel} (sx : group x)
    (sy : group y) (ex : ∀ t, lev t x = alt t) (ey : ∀ t, lev t y = alt' t) : StandsLate group lev :=
  fun N => match alt_or N with
  | .inl p => ⟨N, x, Nat.le_refl N, sx, Nat.lt_of_lt_of_le p (Nat.le_of_eq (ex N).symm)⟩
  | .inr p => ⟨N, y, Nat.le_refl N, sy, Nat.lt_of_lt_of_le p (Nat.le_of_eq (ey N).symm)⟩

theorem late_zero : ∀ t, 2 ≤ t → first t = 0 ∧ second t = 0
  | 0, le => absurd le (by decide)
  | 1, le => absurd le (by decide)
  | _ + 2, _ => ⟨rfl, rfl⟩

/-- A group whose members stand at no step from some step on does not stand late. -/
theorem not_standsLate_of_gone {group : Rel → Prop} {lev : Nat → Rel → Nat} {T : Nat}
    (gone : ∀ t x, T ≤ t → group x → lev t x = 0) : ¬ StandsLate group lev :=
  fun late => match late T with
  | ⟨t, x, le, member, stands⟩ =>
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands (Nat.le_of_eq (gone t x le member)))

/-- **Which readings persist, in one world where nothing comes back.** The line reading only itself
overdraws its source and ends; the line reading itself and its source persists, clearing the habitat,
and the dweller's line ends; the line reading everything persists, and so does the dweller's line. -/
theorem beyond_which_persist :
    ¬ (lineA false .own overdrawn).Persists ∧
    ((lineA false .source cleared).Persists ∧ ¬ (lineD false .source cleared).Persists) ∧
    ((lineA false .whole keep).Persists ∧ (lineD false .whole keep).Persists) :=
  ⟨overdrawn_ends.1, cleared_persists, keep_persists false⟩

/-- **Which readings persist where the dweller renews the source**: the line reading itself and its
source clears the habitat and ends with the dweller's line; the line reading everything persists, and
so does the dweller's. -/
theorem back_which_persist :
    (¬ (lineA true .source clearedBack).Persists ∧ ¬ (lineD true .source clearedBack).Persists) ∧
    ((lineA true .whole keep).Persists ∧ (lineD true .whole keep).Persists) :=
  ⟨clearedBack_ends, keep_persists true⟩

/-- Read off the levels: where nothing comes back, the line's slots stand late under the reading of its
source and under the reading of everything, and not under the reading of itself alone. -/
theorem beyond_standing :
    ¬ StandsLate (fun x => isA x = true) overdrawn ∧ StandsLate (fun x => isA x = true) cleared ∧
      StandsLate (fun x => isA x = true) keep :=
  ⟨not_standsLate_of_gone (T := 2) fun t x le inA => match x, inA with
      | .a0, _ => (late_zero t le).1
      | .a1, _ => (late_zero t le).2,
   standsLate_of_alt (x := .a0) (y := .a1) rfl rfl (fun _ => rfl) (fun _ => rfl),
   standsLate_of_alt (x := .a0) (y := .a1) rfl rfl (fun _ => rfl) (fun _ => rfl)⟩

/-! ### The pool read off the course: a selection removing its own readers -/

/-- The two lines: the line `a` and the dweller's line `d`, whose continuation reads the habitat. -/
inductive Line where
  | a | d

/-- Each line's slots. -/
def slotsOf : Line → Rel → Prop
  | .a, x => x = .a0 ∨ x = .a1
  | .d, x => x = .d0 ∨ x = .d1

/-- Cleared with nothing coming back, the dweller's line is not alive from the third step on. -/
theorem cleared_dweller_gone : ∀ t, 2 ≤ t → ¬ AliveIn slotsOf cleared t .d :=
  fun t le ⟨_, slot, stands⟩ => match slot with
  | .inl e => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands
      (Nat.le_of_eq ((congrArg (cleared t) e).trans (late_zero t le).1)))
  | .inr e => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands
      (Nat.le_of_eq ((congrArg (cleared t) e).trans (late_zero t le).2)))

/-- **The course where the line reads the dweller out removes the dweller's line from the pool it
gives.** -/
theorem cleared_removes_dweller : RemovesLine slotsOf cleared .d :=
  ⟨⟨.d0, .inl rfl, Nat.zero_lt_one⟩, 2, cleared_dweller_gone⟩

/-- **The meta-attractor's shape, witnessed.** In the course where the line reads the dweller out and
nothing comes back, selection by persistence read off the pool the course gives holds, and the course
removes the dweller's line, whose continuation reads the habitat, from that pool: a selection removing its
own readers. Read off the fixed pool of both lines, the same selection fails there; in the course where
the line reads everything, it holds read off either pool. -/
theorem cleared_removes_its_readers :
    RemovesItsReaders (SurvivorsPersist slotsOf) slotsOf (fun i => i = .d) cleared ∧
      ¬ AllPersist slotsOf cleared ∧ AllPersist slotsOf keep :=
  ⟨⟨survivorsPersist_of_settled ⟨2, fun i => match i with
      | .a => .inl (standsLate_of_alt (x := .a0) (y := .a1) (.inl rfl) (.inr rfl) (fun _ => rfl)
          (fun _ => rfl))
      | .d => .inr cleared_dweller_gone⟩, .d, rfl, cleared_removes_dweller⟩,
   not_allPersist_of_removes cleared_removes_dweller,
   fun i => match i with
    | .a => standsLate_of_alt (x := .a0) (y := .a1) (.inl rfl) (.inr rfl) (fun _ => rfl) (fun _ => rfl)
    | .d => standsLate_of_alt (x := .d0) (y := .d1) (.inl rfl) (.inr rfl) (fun _ => rfl) (fun _ => rfl)⟩

/-- **Where the dweller renews the source, the course removing it removes the line too.** -/
theorem clearedBack_removes_both :
    RemovesLine slotsOf clearedBack .d ∧ RemovesLine slotsOf clearedBack .a :=
  ⟨⟨⟨.d0, .inl rfl, Nat.zero_lt_one⟩, 2, fun t le ⟨_, slot, stands⟩ => match slot with
      | .inl e => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands
          (Nat.le_of_eq ((congrArg (clearedBack t) e).trans (late_zero t le).1)))
      | .inr e => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands
          (Nat.le_of_eq ((congrArg (clearedBack t) e).trans (late_zero t le).2)))⟩,
   ⟨⟨.a0, .inl rfl, Nat.zero_lt_one⟩, 3, fun t le ⟨_, slot, stands⟩ =>
      match t, le, slot with
      | _ + 3, _, .inl e => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands
          (Nat.le_of_eq ((congrArg (clearedBack _) e).trans rfl)))
      | _ + 3, _, .inr e => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands
          (Nat.le_of_eq ((congrArg (clearedBack _) e).trans rfl)))⟩⟩

/-! ### Standpoints in time -/

/-- **The line reaches the dweller's line before the second step** in the course where it clears the
habitat: it cleared it at the first step, and the dweller's member then requires it. -/
theorem cleared_reaches_dweller :
    (flowOf false .source cleared).LinesReachBefore (webOf cleared) (lineA false .source cleared)
      (lineD false .source cleared) 1 :=
  ⟨.d1, .head _, .a0, .h, 0, .head _, trivial, Nat.zero_lt_one, listed .a0, .inl Nat.zero_lt_one⟩

/-- Where nothing comes back, the dweller's line's cohorts are its two slots. -/
theorem lineD_slots (σ : Reading) (lev : Nat → Rel → Nat) :
    ∀ t x, x ∈ (lineD false σ lev).family t → x = .d0 ∨ x = .d1
  | 0, _, .head _ => .inl rfl
  | t + 1, x, member => match ListTests.mem_flatMap_iff.mp member with
    | ⟨p, parent, kid⟩ =>
      have gives := (Flow.mem_lineOf_kids.mp kid).2.2.1
      match p, lineD_slots σ lev t p parent with
      | .d0, _ => by cases x <;> first | exact .inl rfl | exact .inr rfl |
          exact absurd gives (Nat.lt_irrefl 0)
      | .d1, _ => by cases x <;> first | exact .inl rfl | exact .inr rfl |
          exact absurd gives (Nat.lt_irrefl 0)

/-- **Where nothing comes back, the dweller's line reaches nothing before any step**: what its members
exchange with no relatum requires. -/
theorem cleared_dweller_reaches_nothing :
    ∀ t g, ¬ (flowOf false .source cleared).LineReachesBefore (webOf cleared)
      (lineD false .source cleared) t g :=
  fun _ g ⟨y, c, s, member, req, _, _, exch⟩ =>
    match y, lineD_slots .source cleared s y member with
    | .d0, _ => by
      cases c <;> cases g <;> first | exact False.elim req |
        exact exch.elim (Nat.lt_irrefl 0) (Nat.lt_irrefl 0)
    | .d1, _ => by
      cases c <;> cases g <;> first | exact False.elim req |
        exact exch.elim (Nat.lt_irrefl 0) (Nat.lt_irrefl 0)

/-- **Where the dweller renews the source, the dweller's line reaches the line before the second step**:
its member gave to the source at the first step, and the line's member then requires it. -/
theorem clearedBack_dweller_reaches_line :
    (flowOf true .source clearedBack).LinesReachBefore (webOf clearedBack)
      (lineD true .source clearedBack) (lineA true .source clearedBack) 1 :=
  ⟨.a1, .head _, .d0, .s, 0, .head _, trivial, Nat.zero_lt_one, listed .d0, .inr Nat.zero_lt_one⟩

/-- At the third step of the course clearing the habitat with nothing coming back, the standpoints are
the line alone. -/
theorem cleared_standpoints_late :
    Flow.LineAlive (lineA false .source cleared) 2 ∧ ¬ Flow.LineAlive (lineD false .source cleared) 2 :=
  ⟨⟨.a0, .head _⟩, fun ⟨_, member⟩ => ListTests.not_mem_nil member⟩

end ReadingsPersist.Habitat

end Becoming
