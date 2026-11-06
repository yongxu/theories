import Becoming.Horizon
import Becoming.Labelled
import Becoming.Onward
import Becoming.Population
import Becoming.Admission
import Becoming.LawAlongRun
import Becoming.Extension
import Becoming.Lexical
import Becoming.Bundles
import Becoming.EventualWidening

/-!
# What can be reached: covering, widening it, and what a course adds to it

07's open item asks for a comparison of a range whose widening keeps widening with one merely
wider now. One candidate is what a course keeps reachable. Here it is read on any process, through
what each configuration admits (`adm : S → X → Prop`: a frame's realized claims, or what a
dependence admits at a configuration, `Dependence.AdmitsAt`, where each condition a formation
requires stands at least at its need), the courses from a configuration being the runs starting
there.

* **Same-offset covering is an order that implies inclusion now.** A course's range includes
  another's where what the other admits at an offset from its start it admits there
  (`Run.RangeIncludes`; exceeding and widening, `Run.RangeExceeds`, `Run.RangeWidens`). These are
  the grammar's inclusion and exceeding of what the courses admit (`Run.admitted`,
  `Run.rangeIncludes_iff`, `Run.rangeExceeds_iff`), and with fixed conditions 07's inclusion and
  widening (`Run.rangeIncludes_conditions_iff`, `Run.rangeWidens_conditions_iff`). A configuration
  covers another where every course from the other is included by a course from it
  (`Reaching.Covers`), and widens what can be reached over it where it covers it and some course
  from it is included by none from the other (`Reaching.Widens`). Covering is a preorder, and
  widening what can be reached is irreflexive and transitive and is not covered back, with no
  premise (`Reaching.Covers.refl`, `Reaching.Covers.trans`, `Reaching.Widens.covers`,
  `Reaching.Widens.irrefl`, `Reaching.Widens.trans_covers`, `Reaching.Covers.trans_widens`,
  `Reaching.Widens.trans`, `Reaching.widens_not_covered`). Covering implies inclusion now: a
  configuration covering one that starts a course admits now all that one admits now
  (`Reaching.Covers.now`). Inclusion now does not give covering
  (`WiderNow.inclusion_now_not_covering`), and a configuration that starts no course is covered by
  every configuration (`Reaching.covers_of_no_course`). So widening what can be reached never ranks
  a configuration above one that starts a course and admits now what it does not
  (`Reaching.not_widens_of_wider_now`), nor, the courses read as realized starting at their
  configurations, does the lexical order (`Reaching.not_above_wider_now`): a range that keeps
  widening is never ranked above one wider now that starts a course, and the premise is needed
  (`EndsNow.keeps_widening_above_wider_now`). Where each configuration has
  a course including every course from it, widening what can be reached is the strict part of
  range inclusion of those courses (`Reaching.widens_iff_of_greatest`,
  `Reaching.widens_of_rangeWidens_greatest`), and such a course can exist where courses differ
  (`KeptAlternative.greatest_not_unique`). On a determined process, where any two courses from one
  configuration agree, it is the strict part of range inclusion of the two courses, which range
  widening of them gives (`Reaching.greatest_of_unique`, `Reaching.widens_iff_of_unique`,
  `Reaching.widens_of_rangeWidens`): a first-order comparison.
* **With a lag, built as UE9's lagged order is, on families of courses.** A configuration covers
  another with lag `d` where every course from the other is included `d` offsets later by a course
  from it (`Reaching.CoversLater`, UE9's `Web.IncludesLater` read on courses); lag `0` is covering
  and lags add (`Reaching.CoversLater.zero`, `Reaching.CoversLater.trans`). Widening what can be
  reached with a lag is covering with some lag and covered back with none
  (`Reaching.WidensWithLag`), and the lagged order is widening what can be reached or widening it
  with a lag (`Reaching.WidensOrLater`), joined as UE9 joins widening and widening with a lag. It
  is a strict partial order containing widening what can be reached, and it never ranks a
  configuration above one covering it, so it never reverses widening what can be reached
  (`Reaching.WidensOrLater.irrefl`, `Reaching.WidensOrLater.trans`,
  `Reaching.WidensOrLater.not_covered`, `Reaching.WidensOrLater.not_reversed`). On a determined
  process it is the strict part of range inclusion of the two courses joined to the strict part of
  their inclusion with some lag (`Reaching.coversLater_iff_of_unique`,
  `Reaching.widensOrLater_iff_of_unique`). On one determined witness (`WiderNow`), where what the
  climb admits keeps widening, `none` admits now what the climb does not and each course exceeds
  the other, same-offset widening of what can be reached and the lexical order are silent both
  ways (`WiderNow.silent`), and the lagged order ranks the climb above `none` and not conversely
  (`WiderNow.decided`). It does not decide every such pair: with other admissions on the same
  process, each course still exceeding the other, it is silent both ways
  (`WiderNow.TwoSided.silent`). Where the configuration wider now also widens what can be reached
  over the climb, the lagged order ranks it above the climb, as it must (`WiderNow.Full.not_silent`,
  `Reaching.WidensOrLater.not_reversed`). Both orders satisfy C on the frame of reachable ranges
  (`Reaching.comparison_widens`,
  `Reaching.comparison_widensOrLater`), and on `WiderNow` they differ on the climb against `none`
  (`WiderNow.comparison_undecided`), so ranking that pair is a premise beyond C.
* **Nothing is added to the whole possible along a course; on a determined process a rise is the
  course one step on strictly including it.**
  What some configuration reachable from a configuration admits is its whole possible
  (`Reaching.Possible`), realizability of one formation within some bound
  (`Reaching.possible_iff_withinMoves`); what some configuration reached in at most `k` steps
  admits (`Reaching.PossibleWithin`) is realizability within `k` moves
  (`Reaching.possibleWithin_iff_withinMoves`; `Reaching.PossibleWithin.possible`,
  `Reaching.PossibleWithin.mono`, `Reaching.PossibleWithin.present`). What is possible from a
  reachable configuration is possible from the first (`Reaching.Possible.of_reach`, from
  `together_after_reach`), so along every course nothing is added to the whole possible
  (`Run.possible_of_next`, `Run.possible_of_later`, `Run.possible_from_start`), a step losing a
  possibility has no way back (`Run.not_possible_returns`, from `lost_together_not_returns`), and
  what is possible within `k` steps of the next configuration is possible within `k + 1` steps of
  the present one (`Run.possibleWithin_moves`, from `WithinMoves.before`). A trace into a course's
  start gives a course whose states from some step on are the other's (`Run.tail_of_trace`, the
  strong form of `Onward.run_of_trace`; `Run.tail_of_reach`). So where every configuration
  reachable from `s'` starts a course, a configuration covering `s'` has all that is possible from
  it (`Reaching.Covers.possible`), and a step of a course whose later configuration covers the
  earlier leaves the whole possible unchanged (`Run.possible_same_of_covers_next`). The premise is
  needed: a configuration from which nothing is possible widens what can be reached over one,
  starting no course, from which everything is possible (`NoCourse.widens_reversed`). Same-offset
  widening of what can be reached can rise along a course while the whole possible, and the
  possible within every horizon beyond the present, stay the same (`Rise.rises`,
  `Rise.possible_same`, `Rise.possibleWithin_same`). The rise is the same-offset reading of the
  course's own delay: with a lag of one step every configuration of a course covers its successor
  (`Run.coversLater_next`), and on a determined process the next configuration widens what can be
  reached over the present one exactly when what the course admits at each offset it admits one
  offset later, and not conversely (`Reaching.widens_next_iff_rising`). Widening with a lag never
  ranks a configuration of a course above its predecessor (`Run.not_widensWithLag_next`), so along
  a course the lagged order ranks a successor above its predecessor exactly where same-offset
  widening does (`Run.widensOrLater_next_iff`): the lag adds nothing there.
* **Keeping widening needs an unlisted range.** Keeping widening is 07's form for a chain of
  predicates: nothing held is lost from a step to any later one, and after every step something
  not held there is held later (`Reaching.KeepsWidening`). A chain keeping widening gathers, for
  every `n`, `n` distinct members held at one step (`Reaching.KeepsWidening.gathers`), so no list
  holds it (`Reaching.KeepsWidening.not_listed`). Along a course, the possible within `k` does not
  keep widening where a list holds what is possible within `k` along it, nor where a list holds the
  whole possible from its start (`Reaching.not_keepsWidening_of_listed_along`,
  `Reaching.listed_along_of_listed`, `Reaching.not_keepsWidening_of_listed`). Keeping widening by
  name on a web is exactly keeping widening of its chain (`Web.KeepsWidening.chain`,
  `Web.KeepsWidening.of_chain`, `Web.keepsWidening_iff_chain`), so the web's law over a listed
  type, `Web.KeepsWidening.not_listed`, follows from the chain's
  (`Web.KeepsWidening.not_listed_via_chain`). On the climb the possible within
  every horizon keeps widening and no list holds the whole possible (`Climb.keeps`,
  `Climb.not_listed`). The converse fails: from one configuration admitting every formation no
  list holds the whole possible, and the possible within no horizon keeps widening
  (`AllAtOnce.converse_fails`). `Rise` and `Climb` are determined laws (`Rise.process_eq_law`,
  `Climb.process_eq_law`; `Law.runs_agree`, the two-run form of Branching's `law_run_state`), so
  they witness nothing about alternatives.
* **What can be reached and realized courses rank a pair oppositely, on this witness.** With a
  course read as realized from each configuration, one configuration's realized course widens
  another's while the other widens what can be reached over it through a course not realized
  (`KeptAlternative.disagree`), so on this witness no strict partial order contains both
  (`KeptAlternative.no_order_contains_both`), nor satisfies C both on the realized courses and on
  the reachable ranges (`KeptAlternative.no_comparison_both`); on a determined process, with the
  realized courses starting at their configurations, realized widening gives widening what can be
  reached (`Reaching.widens_of_rangeWidens`). Realized widening, or keeping the same realized range
  and widening what can be reached (`Reaching.Lexical`), is a strict partial order containing
  realized widening and never reversing it (`Reaching.Lexical.irrefl`, `Reaching.Lexical.trans`,
  `Reaching.Lexical.of_rangeWidens`, `Reaching.Lexical.not_reversed`). It lies inside the
  package's two-tier lexical order read on realized claims and then reachable ranges, which gives
  it back where the inclusions are decided (`Reaching.realizedClaims`, `Reaching.realizedFrame`,
  `Reaching.lexical_above`, `Reaching.lexical_of_above_decided`), and it separates two
  configurations with the same realized range, one keeping an alternative not realized, which
  realized widening leaves unranked (`KeptAlternative.tie`).
* **Covering is the lower preorder of the families of course ranges, and widening what can be
  reached is C's extension on them.** Covering is the lower (Hoare) preorder of the families of
  course ranges: inclusion of the ranges some course includes (`Reaching.reachableRanges`,
  `Reaching.covers_iff_included`), dominance for every criterion on ranges closed upward under
  inclusion (`Reaching.covers_iff_criteria`), and carrying the profiles of the courses, so
  preserving every bundle of their admissions (`Reaching.coursesFrame`,
  `Reaching.covers_iff_carries`, `Reaching.covers_iff_preserves`). Widening what can be reached is
  extension (`Extension`, every claim living) on the frame of reachable ranges
  (`Reaching.reachFrame`, `Reaching.widens_iff_extension`), so C read there is
  `Comparison (Reaching.reachFrame P adm) (fun _ => True)`. Covering is linear-time: two
  configurations, one branching at its first step and one a step later, cover each other, yet one
  step on the next configuration of the later one widens what can be reached over each next
  configuration of the earlier, and a simulation relates them one way only
  (`DeferredBranching.cover_both`, `DeferredBranching.widens_after_one_step`,
  `DeferredBranching.late_simulates_early`, `DeferredBranching.early_not_simulating_late`).
* **The possible does not certify what can be reached together.** Two configurations with the
  same whole possible and the same bundles realizable together within every bound differ in what
  can be reached: from one, two formations are held together at every offset of one course; from
  the other, every course holds them together only at its start (`KeptTogether.same_possible`,
  `KeptTogether.same_bundles`, `KeptTogether.split_courses`, `KeptTogether.widens`). So on this
  witness no comparison read off a description that the bundles realizable within every bound
  determine, comparing no description with itself, satisfies C on the reachable ranges
  (`KeptTogether.no_comparison_through_bundles`).

Each law is near-definitional or a witness, stated for every process or on small witnesses; no
choice principle enters, and runs are built, never chosen. The possible within a horizon restates
Kauffman's adjacent possible (Kauffman 2000) only for a prestated space: within one fixed process
it moves with the actual, and the whole possible never grows; the adjacent possible that cannot be
prestated (Longo, Montévil and Kauffman 2012) is outside. That no listed range keeps widening is
the pigeonhole of finite recurrence, as `Web.KeepsWidening.not_listed` is, and its converse fails
(`AllAtOnce`). That nothing is added to the whole possible restates the irreversibility premise of
quasi-option value (Arrow and Fisher 1974; Henry 1974); covering does not capture quasi-option
value, having no learning and no view of when a commitment is made (`DeferredBranching`). What the
report does not catch lies in the modelling: discrete steps; courses are infinite runs, so a
configuration that starts no course is covered by every configuration (`NoCourse`); the whole
possible and the possible within a horizon read finite traces while covering reads infinite runs,
linked only under the premise of `Reaching.Covers.possible`; courses compared at the same offsets
from their starts, or with one lag for every offset; what each configuration admits given by a
reading, with formations compared by name over one type fixed across steps; one fixed process; the
realized course a function on configurations.
-/

namespace Becoming

open Generative

universe u v

/-! ## Ranges of courses -/

section Ranges

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A}

/-- A course's range includes another's: what the other admits at an offset from its start, it
admits at that offset. -/
def Run.RangeIncludes (adm : S → X → Prop) (r r' : Run P) : Prop :=
  ∀ t x, adm (r'.state t) x → adm (r.state t) x

/-- A course's range exceeds another's: at some offset it admits what the other does not. -/
def Run.RangeExceeds (adm : S → X → Prop) (r r' : Run P) : Prop :=
  ∃ t x, adm (r.state t) x ∧ ¬ adm (r'.state t) x

/-- Range widening of courses: including and exceeding. -/
def Run.RangeWidens (adm : S → X → Prop) (r r' : Run P) : Prop :=
  r.RangeIncludes adm r' ∧ r.RangeExceeds adm r'

/-- What a course admits, as a relation of the grammar on (offset, formation) pairs: the identity
at the pairs whose formation it admits at that offset, as `Web.admitted` reads a level path. -/
def Run.admitted (adm : S → X → Prop) (r : Run P) : «际» (Nat × X) :=
  fun p q => p = q ∧ adm (r.state p.1) p.2

variable {adm : S → X → Prop}

theorem Run.RangeIncludes.refl (r : Run P) : r.RangeIncludes adm r :=
  fun _ _ admitted => admitted

theorem Run.RangeIncludes.trans {r r' r'' : Run P} (first : r.RangeIncludes adm r')
    (second : r'.RangeIncludes adm r'') : r.RangeIncludes adm r'' :=
  fun t x admitted => first t x (second t x admitted)

/-- What exceeds is not included. -/
theorem Run.RangeExceeds.not_included {r r' : Run P} (exceeds : r.RangeExceeds adm r') :
    ¬ r'.RangeIncludes adm r :=
  fun includes => match exceeds with
    | ⟨t, x, yes, no⟩ => no (includes t x yes)

theorem Run.RangeWidens.irrefl (r : Run P) : ¬ r.RangeWidens adm r :=
  fun widens => widens.2.not_included (Run.RangeIncludes.refl r)

theorem Run.RangeWidens.trans {r r' r'' : Run P} (first : r.RangeWidens adm r')
    (second : r'.RangeWidens adm r'') : r.RangeWidens adm r'' :=
  match first, second with
  | ⟨includes, t, x, yes, no⟩, ⟨includes', _⟩ =>
    ⟨includes.trans includes', t, x, yes, fun admitted => no (includes' t x admitted)⟩

/-- **Range inclusion is the grammar's inclusion** (`«则»`) of what the courses admit. -/
theorem Run.rangeIncludes_iff {r r' : Run P} :
    r.RangeIncludes adm r' ↔ «则» (r'.admitted adm) (r.admitted adm) :=
  ⟨fun includes _ _ ⟨e, admits⟩ => ⟨e, includes _ _ admits⟩,
   fun inside t x admits => (inside (t, x) (t, x) ⟨rfl, admits⟩).2⟩

/-- **Range exceeding is the grammar's exceeding** (`«逾»`) of what the courses admit. -/
theorem Run.rangeExceeds_iff {r r' : Run P} :
    r.RangeExceeds adm r' ↔ «逾» (r.admitted adm) (r'.admitted adm) :=
  ⟨fun ⟨t, x, admits, not⟩ => ⟨(t, x), (t, x), ⟨rfl, admits⟩, fun ⟨_, admitted⟩ => not admitted⟩,
   fun ⟨p, _, ⟨e, admits⟩, not⟩ => ⟨p.1, p.2, admits, fun admitted => not ⟨e, admitted⟩⟩⟩

/-- **With fixed conditions, range inclusion of two courses is 07's inclusion** (`Web.Includes`)
of their levels, on the web of the first; with fixed conditions every course's web has the same
requirements. -/
theorem Run.rangeIncludes_conditions_iff {F C : Type} (K : Conditions S F C) (r r' : Run P) :
    r.RangeIncludes K.dependence.AdmitsAt r' ↔
      (K.dependence.along r).Includes (K.dependence.along r).level (K.dependence.along r').level :=
  Iff.rfl

/-- **With fixed conditions, range widening of two courses is 07's widening** (`Web.Widens`). -/
theorem Run.rangeWidens_conditions_iff {F C : Type} (K : Conditions S F C) (r r' : Run P) :
    r.RangeWidens K.dependence.AdmitsAt r' ↔
      (K.dependence.along r).Widens (K.dependence.along r).level (K.dependence.along r').level :=
  Iff.rfl

end Ranges

/-! ## What can be reached -/

namespace Reaching

variable {S : Type u} {A : Type v} {X : Type}

/-- `s` covers `s'`: every course from `s'` is included by some course from `s`. -/
def Covers (P : Process S A) (adm : S → X → Prop) (s s' : S) : Prop :=
  ∀ r' : Run P, r'.state 0 = s' → ∃ r : Run P, r.state 0 = s ∧ r.RangeIncludes adm r'

/-- **Widening what can be reached**: `s` covers `s'`, and some course from `s` is included by no
course from `s'`. -/
def Widens (P : Process S A) (adm : S → X → Prop) (s s' : S) : Prop :=
  Covers P adm s s' ∧
    ∃ r : Run P, r.state 0 = s ∧ ∀ r' : Run P, r'.state 0 = s' → ¬ r'.RangeIncludes adm r

/-- `s` covers `s'` with lag `d`: every course from `s'` is included with lag `d` by a course from
`s`, which admits `d` offsets later what the other admits at an offset (UE9's `Web.IncludesLater`,
read on courses). With lag `0` it is covering (`CoversLater.zero`). -/
def CoversLater (P : Process S A) (adm : S → X → Prop) (d : Nat) (s s' : S) : Prop :=
  ∀ r' : Run P, r'.state 0 = s' →
    ∃ r : Run P, r.state 0 = s ∧ ∀ t x, adm (r'.state t) x → adm (r.state (t + d)) x

/-- The whole possible from `s`: what some configuration reachable from `s` admits. -/
def Possible (P : Process S A) (adm : S → X → Prop) (s : S) (x : X) : Prop :=
  ∃ t, Reach P s t ∧ adm t x

/-- The possible within `k` steps of `s`: what some configuration reached from `s` in at most `k`
steps admits. With `k = 1` it is the adjacent possible with the present, read in a prestated
space: one fixed process and one reading. -/
def PossibleWithin (P : Process S A) (adm : S → X → Prop) (k : Nat) (s : S) (x : X) : Prop :=
  ∃ t as, as.length ≤ k ∧ Trace P s as t ∧ adm t x

/-- **Keeping widening**, 07's form for a chain of predicates: nothing held is lost from a step to
any later one, and after every step something not held there is held later. -/
def KeepsWidening (Q : Nat → X → Prop) : Prop :=
  (∀ n d x, Q n x → Q (n + d) x) ∧ ∀ n, ∃ d x, Q (n + d) x ∧ ¬ Q n x

variable {P : Process S A} {adm : S → X → Prop} {s s' s'' : S}

/-! ### Covering and widening what can be reached are orders -/

theorem Covers.refl (s : S) : Covers P adm s s :=
  fun r' start => ⟨r', start, Run.RangeIncludes.refl r'⟩

theorem Covers.trans (first : Covers P adm s s') (second : Covers P adm s' s'') :
    Covers P adm s s'' :=
  fun r'' start'' => match second r'' start'' with
    | ⟨r', start', includes'⟩ => match first r' start' with
      | ⟨r, start, includes⟩ => ⟨r, start, includes.trans includes'⟩

theorem Widens.covers (widens : Widens P adm s s') : Covers P adm s s' :=
  widens.1

theorem Widens.irrefl (s : S) : ¬ Widens P adm s s :=
  fun ⟨_, r, start, unmatched⟩ => unmatched r start (Run.RangeIncludes.refl r)

theorem Widens.trans_covers (first : Widens P adm s s') (second : Covers P adm s' s'') :
    Widens P adm s s'' :=
  match first with
  | ⟨covers, r, start, unmatched⟩ =>
    ⟨covers.trans second, r, start, fun r'' start'' includes'' =>
      match second r'' start'' with
      | ⟨r', start', includes'⟩ => unmatched r' start' (includes'.trans includes'')⟩

theorem Covers.trans_widens (first : Covers P adm s s') (second : Widens P adm s' s'') :
    Widens P adm s s'' :=
  match second with
  | ⟨covers, r', start', unmatched⟩ => match first r' start' with
    | ⟨r, start, includes⟩ =>
      ⟨first.trans covers, r, start, fun r'' start'' includes'' =>
        unmatched r'' start'' (includes''.trans includes)⟩

/-- **Widening what can be reached is transitive.** -/
theorem Widens.trans (first : Widens P adm s s') (second : Widens P adm s' s'') :
    Widens P adm s s'' :=
  first.trans_covers second.covers

/-- **What widens what can be reached over another is not covered by it.** -/
theorem widens_not_covered (widens : Widens P adm s s') : ¬ Covers P adm s' s :=
  fun back => match widens with
  | ⟨_, r, start, unmatched⟩ => match back r start with
    | ⟨r', start', includes⟩ => unmatched r' start' includes

/-- **Covering implies inclusion now**: a configuration covering one that starts a course admits
now everything that one admits now. -/
theorem Covers.now (covers : Covers P adm s s') {r' : Run P} (start' : r'.state 0 = s') {x : X}
    (admitted : adm s' x) : adm s x :=
  match covers r' start' with
  | ⟨_, start, includes⟩ => Eq.subst (motive := fun y => adm y x) start
      (includes 0 x (Eq.subst (motive := fun y => adm y x) start'.symm admitted))

/-- **Widening what can be reached never ranks a configuration above one that starts a course and
admits now what it does not.** -/
theorem not_widens_of_wider_now {r' : Run P} (start' : r'.state 0 = s') {x : X} (now : adm s' x)
    (notNow : ¬ adm s x) : ¬ Widens P adm s s' :=
  fun widens => notNow (widens.1.now start' now)

/-- **A configuration that starts no course is covered by every configuration.** -/
theorem covers_of_no_course (noCourse : ∀ r : Run P, r.state 0 = s' → False) :
    Covers P adm s s' :=
  fun r' start' => (noCourse r' start').elim

/-- **Covering is dominance for every criterion closed upward under inclusion**: `s` covers `s'`
exactly where every criterion on ranges, closed upward under inclusion, that some course from `s'`
meets, some course from `s` meets. It is the lower (Hoare) preorder of the families of course
ranges, read through criteria. -/
theorem covers_iff_criteria :
    Covers P adm s s' ↔
      ∀ V : (Nat → X → Prop) → Prop, (∀ ρ σ, (∀ t x, ρ t x → σ t x) → V ρ → V σ) →
        (∃ r' : Run P, r'.state 0 = s' ∧ V (fun t x => adm (r'.state t) x)) →
          ∃ r : Run P, r.state 0 = s ∧ V (fun t x => adm (r.state t) x) :=
  ⟨fun covers _ up ⟨r', start', met⟩ => match covers r' start' with
    | ⟨r, start, includes⟩ => ⟨r, start, up _ _ includes met⟩,
   fun criteria r' start' => criteria (fun ρ => ∀ t x, adm (r'.state t) x → ρ t x)
     (fun _ _ sub held t x admitted => sub t x (held t x admitted))
     ⟨r', start', fun _ _ admitted => admitted⟩⟩

/-! ### Where a configuration has a greatest course -/

/-- **Where each configuration has a greatest course**, one including every course from it,
widening what can be reached is the strict part of range inclusion of the two greatest courses. -/
theorem widens_iff_of_greatest {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s')
    (greatest : ∀ q : Run P, q.state 0 = s → r.RangeIncludes adm q)
    (greatest' : ∀ q : Run P, q.state 0 = s' → r'.RangeIncludes adm q) :
    Widens P adm s s' ↔ r.RangeIncludes adm r' ∧ ¬ r'.RangeIncludes adm r :=
  ⟨fun ⟨covers, q, qstart, unmatched⟩ => match covers r' start' with
    | ⟨q', q'start, includes⟩ =>
      ⟨(greatest q' q'start).trans includes,
       fun back => unmatched r' start' (back.trans (greatest q qstart))⟩,
   fun ⟨includes, notBack⟩ =>
    ⟨fun q' q'start => ⟨r, start, includes.trans (greatest' q' q'start)⟩,
     r, start, fun q' q'start includes' => notBack ((greatest' q' q'start).trans includes')⟩⟩

/-- Range widening of two courses gives widening what can be reached where the second includes
every course from its start. -/
theorem widens_of_rangeWidens_greatest {r r' : Run P} (start : r.state 0 = s)
    (greatest' : ∀ q : Run P, q.state 0 = s' → r'.RangeIncludes adm q)
    (widens : r.RangeWidens adm r') : Widens P adm s s' :=
  ⟨fun q' q'start => ⟨r, start, widens.1.trans (greatest' q' q'start)⟩,
   r, start, fun q' q'start includes' =>
     widens.2.not_included ((greatest' q' q'start).trans includes')⟩

/-- Where any two courses from one configuration agree, each course includes every course from its
start. -/
theorem greatest_of_unique
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {r : Run P} (start : r.state 0 = s) : ∀ q : Run P, q.state 0 = s → r.RangeIncludes adm q :=
  fun q qstart t x admitted =>
    Eq.subst (motive := fun y => adm y x) (unique q r (qstart.trans start.symm) t) admitted

/-- **On a determined process, widening what can be reached is the strict part of range inclusion
of the two courses**, where any two courses from one configuration agree; range widening of the
courses gives it (`widens_of_rangeWidens`). -/
theorem widens_iff_of_unique
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s') :
    Widens P adm s s' ↔ r.RangeIncludes adm r' ∧ ¬ r'.RangeIncludes adm r :=
  widens_iff_of_greatest start start' (greatest_of_unique unique start)
    (greatest_of_unique unique start')

/-- Where any two courses from one configuration agree, range widening of the courses is widening
what can be reached. -/
theorem widens_of_rangeWidens
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s')
    (widens : r.RangeWidens adm r') : Widens P adm s s' :=
  widens_of_rangeWidens_greatest start (greatest_of_unique unique start') widens

/-- **The rise is the course against its own delay.** Where any two courses from one configuration
agree, the next configuration of a course widens what can be reached over the present one exactly
where what the course admits at each offset it admits one offset later, and not conversely: the
course compared with itself one step late. -/
theorem widens_next_iff_rising
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    (r : Run P) :
    Widens P adm (r.state 1) (r.state 0) ↔
      (∀ t x, adm (r.state t) x → adm (r.state (t + 1)) x) ∧
        ¬ ∀ t x, adm (r.state (t + 1)) x → adm (r.state t) x :=
  widens_iff_of_unique unique
    (r := ⟨fun t => r.state (t + 1), fun t => r.act (t + 1), fun t => r.step (t + 1)⟩) (r' := r)
    rfl rfl

/-! ### Covering with a lag -/

/-- Covering with lag `0` is covering. -/
theorem CoversLater.zero : CoversLater P adm 0 s s' ↔ Covers P adm s s' :=
  Iff.rfl

/-- **Lags add** along covering with a lag. -/
theorem CoversLater.trans {d e : Nat} (first : CoversLater P adm d s s')
    (second : CoversLater P adm e s' s'') : CoversLater P adm (e + d) s s'' :=
  fun r'' start'' => match second r'' start'' with
    | ⟨r', start', later'⟩ => match first r' start' with
      | ⟨r, start, later⟩ => ⟨r, start, fun t x admitted =>
          Eq.subst (motive := fun m => adm (r.state m) x) (Nat.add_assoc t e d)
            (later (t + e) x (later' t x admitted))⟩

/-! ### The possible -/

/-- **The possible within `k` steps is realizability within `k` moves** (`WithinMoves`,
`Becoming.Labelled`) of the bundle holding one formation. -/
theorem possibleWithin_iff_withinMoves {k : Nat} {x : X} :
    PossibleWithin P adm k s x ↔ WithinMoves P adm s k (fun c => c = x) :=
  ⟨fun ⟨t, as, length, trace, admitted⟩ =>
     ⟨as, t, trace, length, fun _ same => Eq.subst (motive := fun y => adm t y) same.symm admitted⟩,
   fun ⟨as, t, trace, length, holds⟩ => ⟨t, as, length, trace, holds x rfl⟩⟩

/-- **The whole possible is realizability of one formation within some bound**
(`withinMoves_iff_reach`). -/
theorem possible_iff_withinMoves {x : X} :
    Possible P adm s x ↔ ∃ n, WithinMoves P adm s n (fun c => c = x) :=
  ⟨fun ⟨t, reach, admitted⟩ => withinMoves_iff_reach.mpr
     ⟨t, reach, fun _ same => Eq.subst (motive := fun y => adm t y) same.symm admitted⟩,
   fun within => match withinMoves_iff_reach.mp within with
    | ⟨t, reach, holds⟩ => ⟨t, reach, holds x rfl⟩⟩

/-- What is possible from a reachable configuration is possible from the first:
`together_after_reach` for one formation. -/
theorem Possible.of_reach (reach : Reach P s s') {x : X} (possible : Possible P adm s' x) :
    Possible P adm s x :=
  possible_iff_withinMoves.mpr (together_after_reach reach (possible_iff_withinMoves.mp possible))

theorem PossibleWithin.possible {k : Nat} {x : X} (within : PossibleWithin P adm k s x) :
    Possible P adm s x :=
  match within with
  | ⟨t, as, _, trace, admitted⟩ => ⟨t, ⟨as, trace⟩, admitted⟩

theorem PossibleWithin.mono {k k' : Nat} (le : k ≤ k') {x : X}
    (within : PossibleWithin P adm k s x) : PossibleWithin P adm k' s x :=
  match within with
  | ⟨t, as, length, trace, admitted⟩ => ⟨t, as, Nat.le_trans length le, trace, admitted⟩

/-- What a configuration admits is possible within every horizon from it. -/
theorem PossibleWithin.present {k : Nat} {x : X} (admitted : adm s x) :
    PossibleWithin P adm k s x :=
  ⟨s, [], Nat.zero_le k, .nil s, admitted⟩

/-! ### Keeping widening, for chains -/

/-- A chain keeping widening gathers, for every `n`, `n` distinct members held together at one
step. -/
theorem KeepsWidening.gathers {Q : Nat → X → Prop} (keeps : KeepsWidening Q) :
    ∀ n, ∃ xs : List X, ∃ m, xs.length = n ∧ Distinct xs ∧ ∀ x, x ∈ xs → Q m x
  | 0 => ⟨[], 0, rfl, trivial, fun _ mem => nomatch mem⟩
  | n + 1 => match KeepsWidening.gathers keeps n with
    | ⟨xs, m, length, distinct, all⟩ => match keeps.2 m with
      | ⟨d, x, new, before⟩ =>
        ⟨x :: xs, m + d, congrArg Nat.succ length, ⟨fun mem => before (all x mem), distinct⟩,
         fun y mem => match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun z => Q (m + d) z) same.symm new
          | .inr rest => keeps.1 m d y (all y rest)⟩

/-- **No chain keeping widening is held by a list**: the pigeonhole. -/
theorem KeepsWidening.not_listed {Q : Nat → X → Prop} (keeps : KeepsWidening Q) :
    ¬ ∃ ys : List X, ∀ n x, Q n x → x ∈ ys :=
  fun ⟨ys, holds⟩ => match keeps.gathers (ys.length + 1) with
  | ⟨_, m, length, distinct, all⟩ =>
    Nat.not_succ_le_self ys.length (Eq.subst (motive := fun n => n ≤ ys.length) length
      (length_le_of_sub distinct fun x mem => holds m x (all x mem)))

/-! ### The lexical order -/

/-- **The lexical order**: realized widening, or keeping the same realized range and widening what
can be reached, with `course : S → Run P` giving a course from each configuration, read as the
realized one. The laws about a configuration's realized course need `∀ s, (course s).state 0 = s`
(as `KeptAlternative.course_start` gives); `not_above_wider_now` takes it for the two
configurations compared. -/
def Lexical (P : Process S A) (adm : S → X → Prop) (course : S → Run P) (s s' : S) : Prop :=
  (course s).RangeWidens adm (course s') ∨
    ((course s).RangeIncludes adm (course s') ∧ (course s').RangeIncludes adm (course s) ∧
      Widens P adm s s')

variable {course : S → Run P}

theorem Lexical.irrefl (s : S) : ¬ Lexical P adm course s s
  | .inl widens => Run.RangeWidens.irrefl _ widens
  | .inr ⟨_, _, widens⟩ => Widens.irrefl s widens

theorem Lexical.trans {s s' s'' : S} :
    Lexical P adm course s s' → Lexical P adm course s' s'' → Lexical P adm course s s''
  | .inl widens, .inl widens' => .inl (widens.trans widens')
  | .inl ⟨includes, t, x, yes, no⟩, .inr ⟨includes', _, _⟩ =>
    .inl ⟨includes.trans includes', t, x, yes, fun admitted => no (includes' t x admitted)⟩
  | .inr ⟨includes, _, _⟩, .inl ⟨includes', t, x, yes, no⟩ =>
    .inl ⟨includes.trans includes', t, x, includes t x yes, no⟩
  | .inr ⟨includes, back, widens⟩, .inr ⟨includes', back', widens'⟩ =>
    .inr ⟨includes.trans includes', back'.trans back, widens.trans widens'⟩

/-- The lexical order contains realized widening. -/
theorem Lexical.of_rangeWidens {s s' : S} (widens : (course s).RangeWidens adm (course s')) :
    Lexical P adm course s s' :=
  .inl widens

/-- **The lexical order never reverses realized widening.** -/
theorem Lexical.not_reversed {s s' : S} (widens : (course s).RangeWidens adm (course s')) :
    ¬ Lexical P adm course s' s
  | .inl widens' => widens.2.not_included widens'.1
  | .inr ⟨includes, _, _⟩ => widens.2.not_included includes

/-- **Neither order ranks a configuration above one that starts a course and admits now what it
does not**: where `s'` admits now what `s` does not, `s` does not widen what can be reached over
`s'` (`not_widens_of_wider_now`), nor is it above `s'` in the lexical order, the chosen courses
starting at their configurations. So a range that keeps widening is never ranked above one wider
now that starts a course. -/
theorem not_above_wider_now {s s' : S} (start : (course s).state 0 = s)
    (start' : (course s').state 0 = s') {x : X} (now : adm s' x) (notNow : ¬ adm s x) :
    ¬ Widens P adm s s' ∧ ¬ Lexical P adm course s s' :=
  have included : (course s).RangeIncludes adm (course s') → False := fun includes =>
    notNow (Eq.subst (motive := fun y => adm y x) start
      (includes 0 x (Eq.subst (motive := fun y => adm y x) start'.symm now)))
  ⟨not_widens_of_wider_now start' now notNow,
   fun | .inl widens => included widens.1
       | .inr ⟨includes, _, _⟩ => included includes⟩

end Reaching

/-! ## Along a course -/

section Along

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- **Nothing is added to the whole possible along a course**: what is possible from the next
configuration is possible from the present one. -/
theorem Run.possible_of_next (r : Run P) (n : Nat) {x : X} :
    Reaching.Possible P adm (r.state (n + 1)) x → Reaching.Possible P adm (r.state n) x :=
  Reaching.Possible.of_reach (Reach.of_step (r.step n))

/-- What is possible from a later configuration of a course is possible from an earlier one
(`Run.reach`). -/
theorem Run.possible_of_later (r : Run P) (m k : Nat) {x : X} :
    Reaching.Possible P adm (r.state (m + k)) x → Reaching.Possible P adm (r.state m) x :=
  Reaching.Possible.of_reach (r.reach m k)

/-- What is possible from a configuration of a course is possible from its start
(`Onward.reach_of_run`). -/
theorem Run.possible_from_start (r : Run P) (n : Nat) {x : X} :
    Reaching.Possible P adm (r.state n) x → Reaching.Possible P adm (r.state 0) x :=
  Reaching.Possible.of_reach (Onward.reach_of_run r n)

/-- **The possible within a horizon moves with the actual**: what is possible within `k` steps of
the next configuration is possible within `k + 1` steps of the present one
(`WithinMoves.before`). -/
theorem Run.possibleWithin_moves (r : Run P) (n : Nat) {k : Nat} {x : X}
    (within : Reaching.PossibleWithin P adm k (r.state (n + 1)) x) :
    Reaching.PossibleWithin P adm (k + 1) (r.state n) x :=
  Reaching.possibleWithin_iff_withinMoves.mpr
    (WithinMoves.before (r.step n) (Reaching.possibleWithin_iff_withinMoves.mp within))

/-- **A step losing a possibility has no way back**: the one-formation case of
`lost_together_not_returns`. -/
theorem Run.not_possible_returns (r : Run P) (n : Nat) {x : X}
    (before : Reaching.Possible P adm (r.state n) x)
    (after : ¬ Reaching.Possible P adm (r.state (n + 1)) x) :
    ¬ Reach P (r.state (n + 1)) (r.state n) :=
  lost_together_not_returns (Reaching.possible_iff_withinMoves.mp before)
    (fun within => after (Reaching.possible_iff_withinMoves.mpr within))

/-- **The strong form of `Onward.run_of_trace`, keeping the tail**: a trace from `s` into a
course's start gives a course from `s` whose states from step `k` on are the other's, by prefixing
(`Run.cons`). -/
theorem Run.tail_of_trace (r' : Run P) : ∀ (as : List A) (s : S), Trace P s as (r'.state 0) →
    ∃ r : Run P, ∃ k, r.state 0 = s ∧ ∀ t, r.state (t + k) = r'.state t
  | [], _, .nil _ => ⟨r', 0, rfl, fun _ => rfl⟩
  | a :: as, s, .cons step rest => match Run.tail_of_trace r' as _ rest with
    | ⟨q, k, start, tail⟩ =>
      ⟨Run.cons s a q (Eq.subst (motive := fun y => P.step s a y) start.symm step), k + 1, rfl,
        fun t => tail t⟩

/-- **Every course from a reachable configuration is matched, from some step on, by a course from
the first**: one whose states from step `k` on are its own, built by prefixing, with no choice. -/
theorem Run.tail_of_reach {s s' : S} (reach : Reach P s s') (r' : Run P) (start : r'.state 0 = s') :
    ∃ r : Run P, ∃ k, r.state 0 = s ∧ ∀ t, r.state (t + k) = r'.state t :=
  match reach with
  | ⟨as, trace⟩ =>
    Run.tail_of_trace r' as s (Eq.subst (motive := fun y => Trace P s as y) start.symm trace)

/-- **With a lag of one step every configuration of a course covers its successor**, by prefixing
(`Run.cons`): what a course from the next configuration admits, a course from the present one
admits one step later. -/
theorem Run.coversLater_next (r : Run P) (n : Nat) :
    Reaching.CoversLater P adm 1 (r.state n) (r.state (n + 1)) :=
  fun q start => ⟨Run.cons (r.state n) (r.act n) q
      (Eq.subst (motive := fun y => P.step (r.state n) (r.act n) y) start.symm (r.step n)),
    rfl, fun _ _ admitted => admitted⟩

/-- **Covering carries the whole possible where reachable configurations start courses**: where
every configuration reachable from `s'` starts a course, what is possible from `s'` is possible
from a configuration covering it. -/
theorem Reaching.Covers.possible {s s' : S} (covers : Reaching.Covers P adm s s')
    (runs : ∀ t, Reach P s' t → ∃ q : Run P, q.state 0 = t) {x : X}
    (possible : Reaching.Possible P adm s' x) : Reaching.Possible P adm s x :=
  match possible with
  | ⟨t, reach, admitted⟩ => match runs t reach with
    | ⟨q, qstart⟩ => match Run.tail_of_reach reach q qstart with
      | ⟨r', k, start', tail⟩ => match covers r' start' with
        | ⟨r, start, includes⟩ =>
          have here : r'.state (0 + k) = t := (tail 0).trans qstart
          ⟨r.state (0 + k), Eq.subst (motive := fun y => Reach P y (r.state (0 + k))) start
              (Onward.reach_of_run r (0 + k)),
           includes (0 + k) x (Eq.subst (motive := fun y => adm y x) here.symm admitted)⟩

/-- **A step whose later configuration covers the earlier leaves the whole possible unchanged**,
where every configuration reachable from the earlier starts a course. -/
theorem Run.possible_same_of_covers_next (r : Run P) (n : Nat)
    (covers : Reaching.Covers P adm (r.state (n + 1)) (r.state n))
    (runs : ∀ t, Reach P (r.state n) t → ∃ q : Run P, q.state 0 = t) (x : X) :
    Reaching.Possible P adm (r.state (n + 1)) x ↔ Reaching.Possible P adm (r.state n) x :=
  ⟨r.possible_of_next n, covers.possible runs⟩

/-- **Along a course, the possible within `k` does not keep widening where a list holds what is
possible within `k` at every configuration of the course.** -/
theorem Reaching.not_keepsWidening_of_listed_along {k : Nat} {r : Run P}
    (listed : ∃ ys : List X, ∀ n x, Reaching.PossibleWithin P adm k (r.state n) x → x ∈ ys) :
    ¬ Reaching.KeepsWidening (fun n => Reaching.PossibleWithin P adm k (r.state n)) :=
  fun keeps => keeps.not_listed listed

/-- A list holding the whole possible from a course's start holds what is possible within every
horizon at every configuration of the course. -/
theorem Reaching.listed_along_of_listed {k : Nat} {r : Run P}
    (listed : ∃ ys : List X, ∀ x, Reaching.Possible P adm (r.state 0) x → x ∈ ys) :
    ∃ ys : List X, ∀ n x, Reaching.PossibleWithin P adm k (r.state n) x → x ∈ ys :=
  match listed with
  | ⟨ys, holds⟩ => ⟨ys, fun n x within => holds x (r.possible_from_start n within.possible)⟩

/-- **No course keeps the possible within a horizon widening where a list holds the whole possible
from its start.** -/
theorem Reaching.not_keepsWidening_of_listed {k : Nat} {r : Run P}
    (listed : ∃ ys : List X, ∀ x, Reaching.Possible P adm (r.state 0) x → x ∈ ys) :
    ¬ Reaching.KeepsWidening (fun n => Reaching.PossibleWithin P adm k (r.state n)) :=
  Reaching.not_keepsWidening_of_listed_along (Reaching.listed_along_of_listed listed)

end Along

/-! ## Keeping widening by name is keeping widening of a chain -/

section Chains

variable {F C : Type} {W : Web F C} {l : Nat → C → Nat}

/-- **Keeping widening by name gives keeping widening of a chain**: from `T`, what the levels admit
at the steps from `T` on keeps widening in 07's form. With `Reaching.KeepsWidening.not_listed` it
gives `Web.KeepsWidening.not_listed` (`Web.KeepsWidening.not_listed_via_chain`): over a listed
type no level path keeps widening by name. -/
theorem Web.KeepsWidening.chain {T : Nat} (keeps : W.KeepsWidening Web.itself l T) :
    Reaching.KeepsWidening (fun n f => W.Admits (l (T + n)) (T + n) f) :=
  ⟨fun n d f admitted =>
     Eq.subst (motive := fun m => W.Admits (l m) m f) (Nat.add_assoc T n d)
       ((Web.includesAcross_itself_iff (Nat.le_add_right (T + n) d)).mp
         (keeps.1 (T + n) (T + n + d) (Nat.le_add_right T n) (Nat.le_add_right (T + n) d)) f
         admitted),
   fun n => match keeps.2 (T + n) (Nat.le_add_right T n) with
    | ⟨_, later, exceeds⟩ =>
      match le_dest later, (Web.exceedsAcross_itself_iff later).mp exceeds with
      | ⟨d, apart⟩, ⟨g, admitted, before⟩ =>
        ⟨d, g, Eq.subst (motive := fun m => W.Admits (l m) m g)
          (apart.trans (Nat.add_assoc T n d)) admitted, before⟩⟩

/-- **Keeping widening of the chain gives keeping widening by name**, the converse of
`Web.KeepsWidening.chain`. -/
theorem Web.KeepsWidening.of_chain {T : Nat}
    (chain : Reaching.KeepsWidening (fun n f => W.Admits (l (T + n)) (T + n) f)) :
    W.KeepsWidening Web.itself l T :=
  ⟨fun _ U from_ le => (Web.includesAcross_itself_iff le).mpr fun f admitted =>
     match le_dest from_, le_dest le with
     | ⟨n, atS⟩, ⟨d, atU⟩ =>
       have here : W.Admits (l (T + n)) (T + n) f :=
         Eq.subst (motive := fun m => W.Admits (l m) m f) atS admitted
       have there : T + (n + d) = U :=
         (Nat.add_assoc T n d).symm.trans ((congrArg (· + d) atS).symm.trans atU.symm)
       Eq.subst (motive := fun m => W.Admits (l m) m f) there (chain.1 n d f here),
   fun S from_ => match le_dest from_ with
    | ⟨n, atS⟩ => match chain.2 n with
      | ⟨d, g, now, before⟩ =>
        ⟨S + d, Nat.le_add_right S d, (Web.exceedsAcross_itself_iff (Nat.le_add_right S d)).mpr
          ⟨g, Eq.subst (motive := fun m => W.Admits (l m) m g)
              ((Nat.add_assoc T n d).symm.trans (congrArg (· + d) atS).symm) now,
           fun admitted => before
             (Eq.subst (motive := fun m => W.Admits (l m) m g) atS admitted)⟩⟩⟩

/-- **Keeping widening by name from `T` is keeping widening of the chain from `T`.** -/
theorem Web.keepsWidening_iff_chain {T : Nat} :
    W.KeepsWidening Web.itself l T ↔
      Reaching.KeepsWidening (fun n f => W.Admits (l (T + n)) (T + n) f) :=
  ⟨Web.KeepsWidening.chain, Web.KeepsWidening.of_chain⟩

/-- **The landed law over a listed type, re-derived from the chain law**: over a listed type of
formations no level path keeps widening by name (`Web.KeepsWidening.not_listed`), from
`Web.KeepsWidening.chain` and the chain's pigeonhole, `Reaching.KeepsWidening.not_listed`. -/
theorem Web.KeepsWidening.not_listed_via_chain {fs : List F} (every : ∀ f, f ∈ fs) {T : Nat} :
    ¬ W.KeepsWidening Web.itself l T :=
  fun keeps => keeps.chain.not_listed ⟨fs, fun _ f _ => every f⟩

end Chains

/-! ## Widening what can be reached, or widening it with a lag -/

section Lag

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- **Widening what can be reached with a lag**: covering with some lag and covered back with none,
UE9's widening with a lag (`Web.WidensWithLag`) read on families of courses. -/
def Reaching.WidensWithLag (P : Process S A) (adm : S → X → Prop) (s s' : S) : Prop :=
  (∃ d, Reaching.CoversLater P adm d s s') ∧ ¬ ∃ d, Reaching.CoversLater P adm d s' s

/-- **The lagged order**: widening what can be reached, or widening it with a lag. Its definition
follows UE9's widening or widening with a lag (`Web.WidensOrWithLag`), read on families of courses.
It is a strict partial order containing widening what can be reached, by its first disjunct, and it
never ranks a configuration above one covering it. It decides `WiderNow`'s pair
(`WiderNow.decided`), though not every such pair (`WiderNow.TwoSided.silent`). -/
def Reaching.WidensOrLater (P : Process S A) (adm : S → X → Prop) (s s' : S) : Prop :=
  Reaching.Widens P adm s s' ∨ Reaching.WidensWithLag P adm s s'

/-- The lagged order is irreflexive: widening what can be reached is, and the strict part of
covering with some lag joined to it is (`strictJoin_irrefl`, a law of any two relations in the
grammar's laws). -/
theorem Reaching.WidensOrLater.irrefl (s : S) : ¬ Reaching.WidensOrLater P adm s s :=
  strictJoin_irrefl (S := Reaching.Widens P adm) (P := fun a b => ∃ d, Reaching.CoversLater P adm d a b)
    (Reaching.Widens.irrefl s)

/-- **The lagged order is transitive**: widening what can be reached is transitive, covering with
some lag is, and what widens covers with lag zero, so the join is (`strictJoin_trans`, a law of any
two relations in the grammar's laws). -/
theorem Reaching.WidensOrLater.trans {s s' s'' : S} :
    Reaching.WidensOrLater P adm s s' → Reaching.WidensOrLater P adm s' s'' →
      Reaching.WidensOrLater P adm s s'' :=
  strictJoin_trans (S := Reaching.Widens P adm) (P := fun a b => ∃ d, Reaching.CoversLater P adm d a b)
    (fun first second => first.trans second)
    (fun ⟨d, later⟩ ⟨e, later'⟩ => ⟨e + d, later.trans later'⟩)
    (fun widens => ⟨0, Reaching.CoversLater.zero.mpr widens.1⟩)

/-- **The lagged order never ranks a configuration above one covering it.** -/
theorem Reaching.WidensOrLater.not_covered {s s' : S} (above : Reaching.WidensOrLater P adm s s') :
    ¬ Reaching.Covers P adm s' s :=
  match above with
  | .inl widens => Reaching.widens_not_covered widens
  | .inr ⟨_, notBack⟩ => fun covers => notBack ⟨0, Reaching.CoversLater.zero.mpr covers⟩

/-- **The lagged order never reverses widening what can be reached.** -/
theorem Reaching.WidensOrLater.not_reversed {s s' : S} (widens : Reaching.Widens P adm s s') :
    ¬ Reaching.WidensOrLater P adm s' s :=
  fun back => back.not_covered widens.1

/-- **Along a course, widening with a lag never ranks a configuration above its predecessor**: the
predecessor covers it with lag one (`Run.coversLater_next`). -/
theorem Run.not_widensWithLag_next (r : Run P) (n : Nat) :
    ¬ Reaching.WidensWithLag P adm (r.state (n + 1)) (r.state n) :=
  fun ⟨_, notBack⟩ => notBack ⟨1, r.coversLater_next n⟩

/-- **Along a course the lagged order ranks a successor above its predecessor exactly where
same-offset widening does**: the lag adds nothing there. -/
theorem Run.widensOrLater_next_iff (r : Run P) (n : Nat) :
    Reaching.WidensOrLater P adm (r.state (n + 1)) (r.state n) ↔
      Reaching.Widens P adm (r.state (n + 1)) (r.state n) :=
  ⟨fun | .inl widens => widens
       | .inr lag => (r.not_widensWithLag_next n lag).elim,
   .inl⟩

/-- **On a determined process, covering with lag `d` is inclusion with lag `d` of the two
courses.** -/
theorem Reaching.coversLater_iff_of_unique
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {s s' : S} {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s') (d : Nat) :
    Reaching.CoversLater P adm d s s' ↔ ∀ t x, adm (r'.state t) x → adm (r.state (t + d)) x :=
  ⟨fun covers => match covers r' start' with
    | ⟨q, qstart, later⟩ => fun t x admitted =>
        Eq.subst (motive := fun y => adm y x) (unique q r (qstart.trans start.symm) (t + d))
          (later t x admitted),
   fun later q' q'start => ⟨r, start, fun t x admitted =>
     later t x (Eq.subst (motive := fun y => adm y x) (unique q' r' (q'start.trans start'.symm) t)
       admitted)⟩⟩

/-- **On a determined process, the lagged order is the strict part of range inclusion of the two
courses joined to the strict part of their inclusion with some lag.** -/
theorem Reaching.widensOrLater_iff_of_unique
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {s s' : S} {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s') :
    Reaching.WidensOrLater P adm s s' ↔
      (r.RangeIncludes adm r' ∧ ¬ r'.RangeIncludes adm r) ∨
        ((∃ d, ∀ t x, adm (r'.state t) x → adm (r.state (t + d)) x) ∧
          ¬ ∃ d, ∀ t x, adm (r.state t) x → adm (r'.state (t + d)) x) :=
  have w := Reaching.widens_iff_of_unique (adm := adm) unique start start'
  have c := fun d => Reaching.coversLater_iff_of_unique (adm := adm) unique start start' d
  have c' := fun d => Reaching.coversLater_iff_of_unique (adm := adm) unique start' start d
  ⟨fun | .inl widens => .inl (w.mp widens)
       | .inr ⟨⟨d, later⟩, notBack⟩ =>
         .inr ⟨⟨d, (c d).mp later⟩, fun ⟨e, back⟩ => notBack ⟨e, (c' e).mpr back⟩⟩,
   fun | .inl strict => .inl (w.mpr strict)
       | .inr ⟨⟨d, later⟩, notBack⟩ =>
         .inr ⟨⟨d, (c d).mpr later⟩, fun ⟨e, back⟩ => notBack ⟨e, (c' e).mp back⟩⟩⟩

end Lag

/-! ## Covering on the frame of courses, and C on the frame of reachable ranges -/

section Instances

variable {S : Type} {A : Type} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- The frame of courses: the courses of a process as configurations of a frame with no moves, each
realizing what it admits at each offset, as claims on (offset, formation) pairs. -/
def Reaching.coursesFrame (P : Process S A) (adm : S → X → Prop) : Frame (Run P) Unit (Nat × X) :=
  ⟨Witnesses.halted _ _, fun r p => adm (r.state p.1) p.2⟩

/-- **Covering carries profiles on the frame of courses** (`CarriesProfiles`): from the courses
from `s'` to the courses from `s`. -/
theorem Reaching.covers_iff_carries {s s' : S} :
    Reaching.Covers P adm s s' ↔
      CarriesProfiles (Reaching.coursesFrame P adm) (fun r => r.state 0 = s')
        (Reaching.coursesFrame P adm) (fun r => r.state 0 = s) :=
  ⟨fun covers r' start' => match covers r' start' with
    | ⟨r, start, includes⟩ => ⟨r, start, fun p admitted => includes p.1 p.2 admitted⟩,
   fun carries r' start' => match carries r' start' with
    | ⟨r, start, keeps⟩ => ⟨r, start, fun t x admitted => keeps (t, x) admitted⟩⟩

/-- **Covering preserves every bundle** of (offset, formation) admissions that some course from
`s'` realizes together (`carries_iff_preserves`). -/
theorem Reaching.covers_iff_preserves {s s' : S} :
    Reaching.Covers P adm s s' ↔
      PreservesBundles (Reaching.coursesFrame P adm) (fun r => r.state 0 = s')
        (Reaching.coursesFrame P adm) (fun r => r.state 0 = s) :=
  Reaching.covers_iff_carries.trans carries_iff_preserves

/-- The ranges some course from `s` includes. -/
def Reaching.reachableRanges (P : Process S A) (adm : S → X → Prop) (s : S)
    (ρ : Nat → X → Prop) : Prop :=
  ∃ r : Run P, r.state 0 = s ∧ ∀ t x, ρ t x → adm (r.state t) x

/-- The frame of reachable ranges: the configurations of a process, each realizing the ranges some
course from it includes. -/
def Reaching.reachFrame (P : Process S A) (adm : S → X → Prop) : Frame S A (Nat → X → Prop) :=
  ⟨P, Reaching.reachableRanges P adm⟩

/-- **Covering is the lower (Hoare) preorder of the families of course ranges**: inclusion of the
ranges some course includes. -/
theorem Reaching.covers_iff_included {s s' : S} :
    Reaching.Covers P adm s s' ↔
      Lexical.Included (Reaching.reachableRanges P adm s') (Reaching.reachableRanges P adm s) :=
  ⟨fun covers _ ⟨r', start', sub⟩ => match covers r' start' with
    | ⟨r, start, includes⟩ => ⟨r, start, fun t x held => includes t x (sub t x held)⟩,
   fun included r' start' => match included _ ⟨r', start', fun _ _ admitted => admitted⟩ with
    | ⟨r, start, includes⟩ => ⟨r, start, includes⟩⟩

/-- **Widening what can be reached is C's extension on the frame of reachable ranges**
(`Extension`, every claim living), both ways, with no premise. So C read on the frame of reachable
ranges is `Comparison (Reaching.reachFrame P adm) (fun _ => True)`. -/
theorem Reaching.widens_iff_extension {s s' : S} :
    Reaching.Widens P adm s s' ↔ Extension (Reaching.reachFrame P adm) (fun _ => True) s' s :=
  ⟨fun ⟨covers, r, start, unmatched⟩ =>
     ⟨Reaching.covers_iff_included.mp covers, fun t x => adm (r.state t) x, trivial,
      ⟨r, start, fun _ _ admitted => admitted⟩,
      fun ⟨r', start', includes⟩ => unmatched r' start' includes⟩,
   fun ⟨kept, _, _, ⟨r, start, sub⟩, notBefore⟩ =>
     ⟨Reaching.covers_iff_included.mpr kept, r, start, fun r' start' includes =>
       notBefore ⟨r', start', fun t x held => includes t x (sub t x held)⟩⟩⟩

/-- **Widening what can be reached satisfies C on the frame of reachable ranges** (`Better a b`:
`b` ranked above `a`). -/
theorem Reaching.comparison_widens :
    Comparison (Reaching.reachFrame P adm) (fun _ => True) (fun a b => Reaching.Widens P adm b a) :=
  fun _ _ extension => Reaching.widens_iff_extension.mpr extension

/-- **The lagged order satisfies C on the frame of reachable ranges too**, by its first
disjunct. -/
theorem Reaching.comparison_widensOrLater :
    Comparison (Reaching.reachFrame P adm) (fun _ => True)
      (fun a b => Reaching.WidensOrLater P adm b a) :=
  fun _ _ extension => .inl (Reaching.widens_iff_extension.mpr extension)

/-- What the course read as realized from a configuration admits, as claims on (offset, formation)
pairs. -/
def Reaching.realizedClaims (course : S → Run P) (adm : S → X → Prop) (s : S) (p : Nat × X) :
    Prop :=
  adm ((course s).state p.1) p.2

/-- The frame of realized courses: the configurations of a process, each realizing what the course
read as realized from it admits at each offset. -/
def Reaching.realizedFrame (P : Process S A) (adm : S → X → Prop) (course : S → Run P) :
    Frame S A (Nat × X) :=
  ⟨P, Reaching.realizedClaims course adm⟩

/-- **The lexical order lies inside the package's two-tier lexical order** (`Lexical.Above`), read
on the realized claims and then the reachable ranges. The converse holds where the inclusions are
decided (`Reaching.lexical_of_above_decided`): `Above` reads the negation of inclusion where the
lexical order reads exceeding. -/
theorem Reaching.lexical_above {course : S → Run P} {s s' : S}
    (lexical : Reaching.Lexical P adm course s s') :
    Lexical.Above (Reaching.realizedClaims course adm) (Reaching.reachableRanges P adm) s s' :=
  match lexical with
  | .inl ⟨includes, t, x, yes, no⟩ =>
    .inl ⟨fun p held => includes p.1 p.2 held, fun back => no (back (t, x) yes)⟩
  | .inr ⟨includes, back, widens⟩ =>
    match Reaching.widens_iff_extension.mp widens with
    | ⟨kept, ρ, _, now, before⟩ =>
      .inr ⟨fun p held => includes p.1 p.2 held, fun p held => back p.1 p.2 held,
        kept, fun again => before (again ρ now)⟩

/-- **The two-tier order gives the lexical order where the inclusions are decided**: the realized
inclusion back against a witness of exceeding, and covering back against a course from `s` that no
course from `s'` includes. -/
theorem Reaching.lexical_of_above_decided {course : S → Run P} {s s' : S}
    (realizedDecided : (course s').RangeIncludes adm (course s) ∨
      (course s).RangeExceeds adm (course s'))
    (reachDecided : Reaching.Covers P adm s' s ∨
      ∃ r : Run P, r.state 0 = s ∧ ∀ r' : Run P, r'.state 0 = s' → ¬ r'.RangeIncludes adm r)
    (above : Lexical.Above (Reaching.realizedClaims course adm) (Reaching.reachableRanges P adm)
      s s') : Reaching.Lexical P adm course s s' :=
  match above with
  | .inl ⟨includes, notBack⟩ => match realizedDecided with
    | .inl back => (notBack fun p held => back p.1 p.2 held).elim
    | .inr exceeds => .inl ⟨fun t x held => includes (t, x) held, exceeds⟩
  | .inr ⟨includes, back, kept, notKept⟩ => match reachDecided with
    | .inl covers => (notKept (Reaching.covers_iff_included.mp covers)).elim
    | .inr unmatched => .inr ⟨fun t x held => includes (t, x) held,
        fun t x held => back (t, x) held, Reaching.covers_iff_included.mpr kept, unmatched⟩

end Instances

/-! ## Witnesses -/

/-- Any two runs of a determined law (`Law.process`) from one configuration agree at every step:
the two-run form of Branching's `law_run_state`. -/
theorem Law.runs_agree {S : Type u} {next : S → S} :
    ∀ q q' : Run (Law.process next), q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t :=
  fun q q' start t => (Branching.law_run_state q t).trans
    ((congrArg (fun z => Law.orbit next z t) start).trans (Branching.law_run_state q' t).symm)

namespace Rise

/-- Every step leads to `true`. -/
def process : Process Bool Unit := ⟨fun _ _ t => t = true⟩

/-- The process is a determined law: from each configuration, one course. -/
theorem process_eq_law : process = Law.process (fun _ => true) :=
  rfl

/-- `false` admits `0`; `true` admits `0` and `1`. -/
def adm : Bool → Nat → Prop
  | false, x => x = 0
  | true, x => x ≤ 1

/-- Staying at `true`. -/
def stay : Run process := ⟨fun _ => true, fun _ => (), fun _ => rfl⟩

/-- From `false` to `true`, then staying. -/
def course : Run process := ⟨fun | 0 => false | _ + 1 => true, fun _ => (), fun _ => rfl⟩

theorem adm_le : ∀ {s : Bool} {x : Nat}, adm s x → x ≤ 1
  | false, _, zero => Eq.subst (motive := fun z => z ≤ 1) zero.symm (Nat.zero_le 1)
  | true, _, le => le

/-- **Widening what can be reached, read at the same offsets from each configuration's own start,
can rise along a course, while nothing is added to the whole possible**: on this course the whole
possible, and the possible within every horizon beyond the present, are the same from both
configurations (`possible_same`, `possibleWithin_same`); only what each admits now rises. It is
the same-offset reading of the course's own delay: with a lag of one step every configuration of a
course covers its successor (`Run.coversLater_next`). The process is a determined law
(`process_eq_law`), so the witness says nothing about alternatives. -/
theorem rises : Reaching.Widens process adm (course.state 1) (course.state 0) :=
  ⟨fun _ _ => ⟨stay, rfl, fun _ _ admitted => adm_le admitted⟩, stay, rfl,
    fun r' start includes =>
      have one : adm (r'.state 0) 1 := includes 0 1 (Nat.le_refl 1)
      have zero : (1 : Nat) = 0 := Eq.subst (motive := fun y => adm y 1) start one
      Nat.noConfusion zero⟩

/-- On the rising step the whole possible is the same from both configurations. -/
theorem possible_same (x : Nat) :
    Reaching.Possible process adm (course.state 1) x ↔
      Reaching.Possible process adm (course.state 0) x :=
  Run.possible_same_of_covers_next course 0 rises.1
    (fun t _ => match t with
      | true => ⟨stay, rfl⟩
      | false => ⟨course, rfl⟩) x

/-- On the rising step the possible within every horizon beyond the present is the same from both
configurations. -/
theorem possibleWithin_same (k x : Nat) :
    Reaching.PossibleWithin process adm (k + 1) (course.state 1) x ↔
      Reaching.PossibleWithin process adm (k + 1) (course.state 0) x :=
  ⟨fun ⟨_, _, _, _, admitted⟩ =>
     ⟨true, [()], Nat.succ_le_succ (Nat.zero_le k), .cons rfl (.nil true),
      (adm_le admitted : adm true x)⟩,
   fun ⟨_, _, _, _, admitted⟩ =>
     Reaching.PossibleWithin.present (adm_le admitted : adm true x)⟩

end Rise

namespace Climb

/-- Each step climbs one. -/
def process : Process Nat Unit := ⟨fun n _ m => m = n + 1⟩

/-- The process is the determined law of the successor: from each configuration, one course. -/
theorem process_eq_law : process = Law.process (fun n => n + 1) :=
  rfl

/-- `n` admits the formations up to `n`. -/
def adm (n x : Nat) : Prop := x ≤ n

/-- The climb from zero. -/
def course : Run process := ⟨fun t => t, fun _ => (), fun _ => rfl⟩

/-- `j` steps from `n` reach `n + j`. -/
theorem trace_units : ∀ j n, Trace process n (List.replicate j ()) (n + j)
  | 0, n => .nil n
  | j + 1, n => .cons rfl (Eq.subst
      (motive := fun y => Trace process (n + 1) (List.replicate j ()) y)
      (Nat.succ_add n j) (trace_units j (n + 1)))

/-- A trace from `n` ends at `n` plus its length. -/
theorem trace_end : ∀ {n : Nat} {as : List Unit} {m : Nat}, Trace process n as m → m = n + as.length
  | _, _, _, .nil _ => rfl
  | n, _ :: as, _, .cons step rest =>
    (trace_end rest).trans (Eq.subst (motive := fun y => y + as.length = n + (as.length + 1))
      step.symm (Nat.succ_add n as.length))

theorem within_le {k n x : Nat} : Reaching.PossibleWithin process adm k n x → x ≤ n + k :=
  fun ⟨_, _, length, trace, admitted⟩ =>
    Nat.le_trans admitted (Eq.subst (motive := fun y => y ≤ n + k) (trace_end trace).symm
      (Nat.add_le_add_left length n))

theorem within_of_le {k n x : Nat} (le : x ≤ n + k) : Reaching.PossibleWithin process adm k n x :=
  ⟨n + k, List.replicate k (), Nat.le_of_eq (Branching.units_length k), trace_units k n, le⟩

/-- **On the climb the possible within every horizon keeps widening**, in 07's form. The process is
a determined law (`process_eq_law`): what is possible within `k` of the climb's configuration at
`n` is what the climb itself admits at `n + k` (`within_le`, `within_of_le`), so the witness says
nothing about alternatives. -/
theorem keeps (k : Nat) :
    Reaching.KeepsWidening (fun n => Reaching.PossibleWithin process adm k (course.state n)) :=
  ⟨fun n d _ within => within_of_le (Nat.le_trans (within_le within)
      (Nat.add_le_add_right (Nat.le_add_right n d) k)),
   fun n => ⟨1, n + k + 1, within_of_le (Nat.le_of_eq (Nat.succ_add n k).symm),
     fun within => Nat.not_succ_le_self (n + k) (within_le within)⟩⟩

/-- No list holds the whole possible from the climb's start. -/
theorem not_listed :
    ¬ ∃ xs : List Nat, ∀ x, Reaching.Possible process adm (course.state 0) x → x ∈ xs :=
  fun listed => Reaching.not_keepsWidening_of_listed listed (keeps 1)

end Climb

namespace NoCourse

/-- `true` stays; `false` has no step. -/
def process : Process Bool Unit := ⟨fun s _ t => s = true ∧ t = true⟩

/-- `true` admits nothing; `false` admits every formation. -/
def adm : Bool → Nat → Prop
  | true, _ => False
  | false, _ => True

/-- Staying at `true`. -/
def stay : Run process := ⟨fun _ => true, fun _ => (), fun _ => ⟨rfl, rfl⟩⟩

/-- `false` starts no course. -/
theorem no_course (r : Run process) (start : r.state 0 = false) : False :=
  Bool.noConfusion (start.symm.trans (r.step 0).1)

/-- Only `true` is reachable from `true`. -/
theorem from_true {t : Bool} (reach : Reach process true t) : t = true :=
  Invariant.reach (P := process) (I := fun y => y = true) (fun _ _ _ step _ => step.2) reach rfl

/-- **Covering needs courses**: `true`, admitting nothing on its one course, widens what can be
reached over `false`, which starts no course and admits every formation; everything is possible
from `false` and nothing from `true`. So `Reaching.Covers.possible` needs its premise. -/
theorem widens_reversed :
    Reaching.Widens process adm true false ∧ (∀ x, Reaching.Possible process adm false x) ∧
      ∀ x, ¬ Reaching.Possible process adm true x :=
  ⟨⟨fun r' start' => (no_course r' start').elim, stay, rfl,
     fun r' start' _ => no_course r' start'⟩,
   fun _ => ⟨false, Reach.refl _ _, trivial⟩,
   fun x ⟨_, reach, admitted⟩ =>
     (Eq.subst (motive := fun y => adm y x) (from_true reach) admitted : adm true x)⟩

end NoCourse

namespace EndsNow

/-- `some n` climbs to `some (n + 1)`; `none` has no step. -/
def process : Process (Option Nat) Unit := ⟨fun s _ t => match s with
  | none => False
  | some n => t = some (n + 1)⟩

/-- `none` admits every formation; `some n` admits the formations up to `n`. -/
def adm : Option Nat → Nat → Prop
  | none, _ => True
  | some n, x => x ≤ n

/-- The climb from `some 0`. -/
def climb : Run process := ⟨fun t => some t, fun _ => (), fun _ => rfl⟩

/-- `none` starts no course. -/
theorem no_course (r : Run process) (start : r.state 0 = none) : False :=
  (Eq.subst (motive := fun c => process.step c (r.act 0) (r.state 1)) start (r.step 0) : False)

/-- What the climb admits keeps widening, in 07's form. -/
theorem climb_keeps : Reaching.KeepsWidening (fun n => adm (climb.state n)) :=
  ⟨fun n d _ admitted => Nat.le_trans admitted (Nat.le_add_right n d),
   fun n => ⟨1, n + 1, Nat.le_refl _, Nat.not_succ_le_self n⟩⟩

/-- **The premise that the configuration wider now starts a course is needed**: what the climb
from `some 0` admits keeps widening, `none` admits now what `some 0` does not, and `some 0` widens
what can be reached over `none`, which starts no course. -/
theorem keeps_widening_above_wider_now :
    Reaching.KeepsWidening (fun n => adm (climb.state n)) ∧ adm none 1 ∧ ¬ adm (some 0) 1 ∧
      Reaching.Widens process adm (some 0) none :=
  ⟨climb_keeps, trivial, Nat.not_succ_le_self 0,
   ⟨fun r' start' => (no_course r' start').elim, climb, rfl,
    fun r' start' _ => no_course r' start'⟩⟩

end EndsNow

namespace AllAtOnce

/-- One configuration, staying. -/
def process : Process Unit Unit := ⟨fun _ _ _ => True⟩

/-- Every formation is admitted. -/
def adm (_ : Unit) (_ : Nat) : Prop := True

/-- **An unlisted whole possible does not suffice for keeping widening**: no list holds the whole
possible, and along no course does the possible within any horizon keep widening, everything
possible being admitted now. -/
theorem converse_fails :
    (¬ ∃ xs : List Nat, ∀ x, Reaching.Possible process adm () x → x ∈ xs) ∧
      ∀ (r : Run process) (k : Nat),
        ¬ Reaching.KeepsWidening (fun n => Reaching.PossibleWithin process adm k (r.state n)) :=
  ⟨fun ⟨xs, holds⟩ => Reaching.KeepsWidening.not_listed (Q := fun n (x : Nat) => x ≤ n)
      ⟨fun n d _ le => Nat.le_trans le (Nat.le_add_right n d),
       fun n => ⟨1, n + 1, Nat.le_refl _, Nat.not_succ_le_self n⟩⟩
      ⟨xs, fun _ x _ => holds x ⟨(), Reach.refl _ _, trivial⟩⟩,
   fun r _ keeps => match keeps.2 0 with
    | ⟨_, _, _, before⟩ =>
      before (Reaching.PossibleWithin.present (adm := adm) (s := r.state 0) trivial)⟩

end AllAtOnce

namespace KeptAlternative

/-- The configurations: `e t` on the course from E; `k` and `single`, two starts; `real t`, the
branch realized from both; `wide t`, the branch from `k` not realized. -/
inductive Config
  | e (t : Nat)
  | k
  | single
  | real (t : Nat)
  | wide (t : Nat)

def process : Process Config Unit := ⟨fun s _ c => match s with
  | .e t => c = .e (t + 1)
  | .k => c = .real 1 ∨ c = .wide 1
  | .single => c = .real 1
  | .real t => c = .real (t + 1)
  | .wide t => c = .wide (t + 1)⟩

/-- E, `k` and `single` admit formations `0` and `1`; the realized branch admits `0`; the wide
branch admits the formations up to `t + 1` at `wide t`. -/
def adm : Config → Nat → Prop
  | .e _, x => x ≤ 1
  | .k, x => x ≤ 1
  | .single, x => x ≤ 1
  | .real _, x => x = 0
  | .wide t, x => x ≤ t + 1

/-- From `k` along the realized branch. -/
def realized : Run process :=
  ⟨fun | 0 => .k | t + 1 => .real (t + 1), fun _ => (), fun | 0 => .inl rfl | _ + 1 => rfl⟩

/-- From `k` along the wide branch. -/
def unrealized : Run process :=
  ⟨fun | 0 => .k | t + 1 => .wide (t + 1), fun _ => (), fun | 0 => .inr rfl | _ + 1 => rfl⟩

/-- From `single`, the one course. -/
def fromSingle : Run process :=
  ⟨fun | 0 => .single | t + 1 => .real (t + 1), fun _ => (), fun | 0 => rfl | _ + 1 => rfl⟩

/-- The course read as realized from each configuration. -/
def course : Config → Run process
  | .e t => ⟨fun n => .e (t + n), fun _ => (), fun _ => rfl⟩
  | .k => realized
  | .single => fromSingle
  | .real t => ⟨fun n => .real (t + n), fun _ => (), fun _ => rfl⟩
  | .wide t => ⟨fun n => .wide (t + n), fun _ => (), fun _ => rfl⟩

/-- Each realized course starts at its configuration. -/
theorem course_start : ∀ c, (course c).state 0 = c
  | .e _ => rfl
  | .k => rfl
  | .single => rfl
  | .real _ => rfl
  | .wide _ => rfl

/-- The course from E is the only one. -/
theorem fromE_states : ∀ (r : Run process), r.state 0 = .e 0 → ∀ t, r.state t = .e t
  | _, start, 0 => start
  | r, start, t + 1 =>
    Eq.mp (congrArg (fun c => process.step c (r.act t) (r.state (t + 1))) (fromE_states r start t))
      (r.step t)

/-- The course from `single` is the only one. -/
theorem fromSingle_states : ∀ (r : Run process), r.state 0 = .single →
    ∀ t, r.state t = fromSingle.state t
  | _, start, 0 => start
  | r, start, t + 1 =>
    have step := Eq.mp (congrArg (fun c => process.step c (r.act t) (r.state (t + 1)))
      (fromSingle_states r start t)) (r.step t)
    match t, step with
    | 0, step => step
    | _ + 1, step => step

/-- After its first step a course from `k` is on the realized branch or on the wide branch. -/
theorem from_k : ∀ (q : Run process), q.state 0 = .k →
    ∀ t, q.state (t + 1) = .real (t + 1) ∨ q.state (t + 1) = .wide (t + 1)
  | q, start, 0 => Eq.mp (congrArg (fun c => process.step c (q.act 0) (q.state 1)) start) (q.step 0)
  | q, start, t + 1 => match from_k q start t with
    | .inl real => .inl (Eq.mp (congrArg (fun c => process.step c (q.act (t + 1))
        (q.state (t + 1 + 1))) real) (q.step (t + 1)))
    | .inr wide => .inr (Eq.mp (congrArg (fun c => process.step c (q.act (t + 1))
        (q.state (t + 1 + 1))) wide) (q.step (t + 1)))

theorem realized_le : ∀ t {x : Nat}, adm (realized.state t) x → x ≤ 1
  | 0, _, le => le
  | _ + 1, _, zero => Eq.subst (motive := fun z => z ≤ 1) zero.symm (Nat.zero_le 1)

theorem unrealized_of_le : ∀ t {x : Nat}, x ≤ 1 → adm (unrealized.state t) x
  | 0, _, le => le
  | t + 1, _, le => Nat.le_trans le (Nat.succ_le_succ (Nat.zero_le (t + 1)))

/-- **A greatest course where courses differ**: the wide branch includes every course from `k`,
while two courses from `k` differ. -/
theorem greatest_not_unique :
    (∀ q : Run process, q.state 0 = .k → unrealized.RangeIncludes adm q) ∧
      ¬ ∀ q q' : Run process, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t :=
  ⟨fun q start t x admitted => match t with
    | 0 => Eq.subst (motive := fun c => adm c x) start admitted
    | t + 1 => match from_k q start t with
      | .inl real => Nat.le_trans
          (Nat.le_of_eq (Eq.subst (motive := fun c => adm c x) real admitted : x = 0))
          (Nat.zero_le (t + 1 + 1))
      | .inr wide => Eq.subst (motive := fun c => adm c x) wide admitted,
   fun unique => Config.noConfusion (unique realized unrealized rfl 1)⟩

/-- **E's realized course widens `k`'s, while `k` widens what can be reached over E** through its
course not realized. -/
theorem disagree :
    (course (.e 0)).RangeWidens adm (course .k) ∧ Reaching.Widens process adm .k (.e 0) :=
  ⟨⟨fun t _ admitted => realized_le t admitted, 1, 1, Nat.le_refl 1,
     fun zero => Nat.noConfusion (zero : (1 : Nat) = 0)⟩,
   fun r' start => ⟨unrealized, rfl, fun t x admitted => unrealized_of_le t
      (Eq.subst (motive := fun c => adm c x) (fromE_states r' start t) admitted)⟩,
   unrealized, rfl, fun r' start includes =>
    Nat.not_succ_le_self 1 (Eq.subst (motive := fun c => adm c 2) (fromE_states r' start 1)
      (includes 1 2 (Nat.le_refl 2)))⟩

/-- **On this witness, no strict partial order contains both realized widening and widening what
can be reached.** A determined process gives no such conflict where the realized courses start at
their configurations: there realized widening gives widening what can be reached
(`Reaching.widens_of_rangeWidens`). -/
theorem no_order_contains_both {R : Config → Config → Prop} (irrefl : ∀ a, ¬ R a a)
    (trans : ∀ {a b c}, R a b → R b c → R a c)
    (realizedWidening : ∀ {a b}, (course a).RangeWidens adm (course b) → R a b)
    (reaching : ∀ {a b}, Reaching.Widens process adm a b → R a b) : False :=
  irrefl _ (trans (realizedWidening disagree.1) (reaching disagree.2))

/-- **On this witness, no strict partial order satisfies C both on the realized courses and on the
reachable ranges** (`Reaching.realizedFrame`, `Reaching.reachFrame`). -/
theorem no_comparison_both {Better : Config → Config → Prop} (irrefl : ∀ a, ¬ Better a a)
    (trans : ∀ {a b c}, Better a b → Better b c → Better a c)
    (realizedC : Comparison (Reaching.realizedFrame process adm course) (fun _ => True) Better)
    (reachableC : Comparison (Reaching.reachFrame process adm) (fun _ => True) Better) : False :=
  match disagree with
  | ⟨⟨includes, t, x, yes, no⟩, widens⟩ =>
    irrefl _ (trans
      (realizedC .k (.e 0) ⟨fun p held => includes p.1 p.2 held, (t, x), trivial, yes, no⟩)
      (reachableC (.e 0) .k (Reaching.widens_iff_extension.mp widens)))

theorem same_realized : ∀ t {x : Nat}, adm (realized.state t) x ↔ adm (fromSingle.state t) x
  | 0, _ => Iff.rfl
  | _ + 1, _ => Iff.rfl

/-- **The tie**: `k` and `single` have the same realized range, so realized widening ranks neither
above the other, while `k` widens what can be reached over `single` and the lexical order ranks it
above. -/
theorem tie :
    (course .k).RangeIncludes adm (course .single) ∧
      (course .single).RangeIncludes adm (course .k) ∧
      ¬ (course .k).RangeWidens adm (course .single) ∧
      ¬ (course .single).RangeWidens adm (course .k) ∧
      Reaching.Widens process adm .k .single ∧ Reaching.Lexical process adm course .k .single :=
  have includes : (course .k).RangeIncludes adm (course .single) :=
    fun t _ admitted => (same_realized t).mpr admitted
  have back : (course .single).RangeIncludes adm (course .k) :=
    fun t _ admitted => (same_realized t).mp admitted
  have widens : Reaching.Widens process adm .k .single :=
    ⟨fun r' start => ⟨realized, rfl, fun t x admitted => (same_realized t).mpr
        (Eq.subst (motive := fun c => adm c x) (fromSingle_states r' start t) admitted)⟩,
     unrealized, rfl, fun r' start includes' =>
      Nat.noConfusion (Eq.subst (motive := fun c => adm c 2) (fromSingle_states r' start 1)
        (includes' 1 2 (Nat.le_refl 2)) : (2 : Nat) = 0)⟩
  ⟨includes, back, fun w => w.2.not_included back, fun w => w.2.not_included includes, widens,
   .inr ⟨includes, back, widens⟩⟩

end KeptAlternative

namespace KeptTogether

/-- The configurations: `both`, staying; `split`, with a step to `zero` and a step to `one`. -/
inductive Config
  | both
  | split
  | zero
  | one

def process : Process Config Unit := ⟨fun s _ c => match s with
  | .both => c = .both
  | .split => c = .zero ∨ c = .one
  | .zero => c = .zero
  | .one => c = .one⟩

/-- `both` and `split` admit formations `0` and `1`; `zero` admits `0`; `one` admits `1`. -/
def adm : Config → Nat → Prop
  | .both, x => x ≤ 1
  | .split, x => x ≤ 1
  | .zero, x => x = 0
  | .one, x => x = 1

theorem adm_le : ∀ {c : Config} {x : Nat}, adm c x → x ≤ 1
  | .both, _, le => le
  | .split, _, le => le
  | .zero, _, zero => Eq.subst (motive := fun z => z ≤ 1) zero.symm (Nat.zero_le 1)
  | .one, _, one => Eq.subst (motive := fun z => z ≤ 1) one.symm (Nat.le_refl 1)

/-- Staying at `both`. -/
def loop : Run process := ⟨fun _ => .both, fun _ => (), fun _ => rfl⟩

/-- A course at a configuration whose every step returns to it stays there. -/
theorem stays {q : Run process} {c : Config} (first : q.state 1 = c)
    (only : ∀ a c', process.step c a c' → c' = c) : ∀ t, q.state (t + 1) = c
  | 0 => first
  | t + 1 => only _ _ (Eq.mp (congrArg (fun y => process.step y (q.act (t + 1))
      (q.state (t + 1 + 1))) (stays first only t)) (q.step (t + 1)))

/-- **Every course from `split` holds the two formations together only at its start**: from its
first step on it stays at `zero` or stays at `one`. -/
theorem split_courses (q : Run process) (start : q.state 0 = .split) :
    (∀ t, q.state (t + 1) = .zero) ∨ ∀ t, q.state (t + 1) = .one :=
  match (Eq.mp (congrArg (fun c => process.step c (q.act 0) (q.state 1)) start) (q.step 0) :
      q.state 1 = .zero ∨ q.state 1 = .one) with
  | .inl zero => .inl (stays zero fun _ _ step => step)
  | .inr one => .inr (stays one fun _ _ step => step)

theorem possible_le {c : Config} {x : Nat} : Reaching.Possible process adm c x → x ≤ 1 :=
  fun ⟨_, _, admitted⟩ => adm_le admitted

/-- **The same whole possible.** -/
theorem same_possible {x : Nat} :
    Reaching.Possible process adm .both x ↔ Reaching.Possible process adm .split x :=
  ⟨fun possible => ⟨.split, Reach.refl _ _, possible_le possible⟩,
   fun possible => ⟨.both, Reach.refl _ _, possible_le possible⟩⟩

/-- **The same bundles within every bound**: every bundle of formations realizable together within
`n` moves from one of `both` and `split` is realizable so from the other. -/
theorem same_bundles (n : Nat) (bundle : Nat → Prop) :
    WithinMoves process adm .both n bundle ↔ WithinMoves process adm .split n bundle :=
  ⟨fun ⟨_, _, _, _, holds⟩ =>
     ⟨[], .split, .nil _, Nat.zero_le n, fun c held => adm_le (holds c held)⟩,
   fun ⟨_, _, _, _, holds⟩ =>
     ⟨[], .both, .nil _, Nat.zero_le n, fun c held => adm_le (holds c held)⟩⟩

/-- **Different reach**: `both` widens what can be reached over `split`. From `both` one course
holds the two formations together at every offset; every course from `split` holds them together
only at its start (`split_courses`). -/
theorem widens : Reaching.Widens process adm .both .split :=
  ⟨fun _ _ => ⟨loop, rfl, fun _ _ admitted => adm_le admitted⟩, loop, rfl,
   fun r' start includes =>
    have step : r'.state 1 = .zero ∨ r'.state 1 = .one :=
      Eq.mp (congrArg (fun c => process.step c (r'.act 0) (r'.state 1)) start) (r'.step 0)
    match step with
    | .inl zero => Nat.noConfusion
        (Eq.subst (motive := fun c => adm c 1) zero (includes 1 1 (Nat.le_refl 1)) : (1 : Nat) = 0)
    | .inr one => Nat.noConfusion
        (Eq.subst (motive := fun c => adm c 0) one (includes 1 0 (Nat.zero_le 1)) : (0 : Nat) = 1)⟩

/-- **What can be reached separates what the bundles from a configuration do not**: on this
witness no comparison read off a description that the bundles realizable within every bound
determine, comparing no description with itself, satisfies C on the reachable ranges
(`Reaching.reachFrame`). An instance of `Comparison.separates`, as
`Regimes.no_comparison_through_marginals` is. -/
theorem no_comparison_through_bundles {D : Type} (π : Config → D)
    (determines : ∀ a b, (∀ n bundle, WithinMoves process adm a n bundle ↔
      WithinMoves process adm b n bundle) → π a = π b)
    (compare : D → D → Prop) (irreflexive : ∀ d, ¬ compare d d) :
    ¬ Comparison (Reaching.reachFrame process adm) (fun _ => True)
      (fun s t => compare (π s) (π t)) :=
  fun comparison => Comparison.separates irreflexive comparison
    (Reaching.widens_iff_extension.mp widens)
    (determines _ _ fun n bundle => (same_bundles n bundle).symm)

end KeptTogether

namespace WiderNow

/-- `none` stays; `some n` climbs. -/
def next : Option Nat → Option Nat
  | none => none
  | some n => some (n + 1)

/-- The determined law of `next`. -/
def process : Process (Option Nat) Unit := Law.process next

/-- `none` admits `0` and `1` at every step; `some n` admits the formations up to `n`. -/
def adm : Option Nat → Nat → Prop
  | none, x => x ≤ 1
  | some n, x => x ≤ n

/-- The course from each configuration, the only one. -/
def course : Option Nat → Run process
  | none => ⟨fun _ => none, fun _ => (), fun _ => rfl⟩
  | some n => ⟨fun t => some (n + t), fun _ => (), fun _ => rfl⟩

theorem course_start : ∀ c, (course c).state 0 = c
  | none => rfl
  | some _ => rfl

/-- **Same-offset covering is silent here**: what the climb from `some 0` admits keeps widening, in
07's form, while `none` admits now what the climb does not, and each course exceeds the other;
neither widening what can be reached nor the lexical order ranks either above the other. -/
theorem silent :
    Reaching.KeepsWidening (fun n => adm ((course (some 0)).state n)) ∧
      (course none).RangeExceeds adm (course (some 0)) ∧
      (course (some 0)).RangeExceeds adm (course none) ∧
      ¬ Reaching.Widens process adm (some 0) none ∧ ¬ Reaching.Widens process adm none (some 0) ∧
      ¬ Reaching.Lexical process adm course (some 0) none ∧
      ¬ Reaching.Lexical process adm course none (some 0) :=
  have notDown : ¬ (course none).RangeIncludes adm (course (some 0)) := fun includes =>
    Nat.not_succ_le_self 1 (includes 2 2 (Nat.le_refl 2))
  have above := Reaching.not_above_wider_now (adm := adm) (course_start (some 0))
    (course_start none) (x := 1) (Nat.le_refl 1) (Nat.not_succ_le_self 0)
  ⟨⟨fun n d _ le => Nat.le_trans le (Nat.add_le_add_left (Nat.le_add_right n d) 0),
    fun n => ⟨1, 0 + n + 1, Nat.le_refl _, Nat.not_succ_le_self (0 + n)⟩⟩,
   ⟨0, 1, Nat.le_refl 1, Nat.not_succ_le_self 0⟩,
   ⟨2, 2, Nat.le_refl 2, Nat.not_succ_le_self 1⟩,
   above.1,
   fun widens => notDown ((Reaching.widens_iff_of_unique Law.runs_agree (course_start none)
     (course_start (some 0))).mp widens).1,
   above.2,
   fun | .inl widens => notDown widens.1 | .inr ⟨includes, _, _⟩ => notDown includes⟩

/-- **The lagged order decides it**: with a lag of one step the climb covers `none`, and `none`
covers the climb at no lag, so the lagged order ranks the climb above `none` and not conversely. -/
theorem decided :
    Reaching.WidensOrLater process adm (some 0) none ∧
      ¬ Reaching.WidensOrLater process adm none (some 0) :=
  have later : Reaching.CoversLater process adm 1 (some 0) none := fun r' start' =>
    ⟨course (some 0), rfl, fun t x admitted =>
      Nat.le_trans (Eq.subst (motive := fun c => adm c x)
        (Law.runs_agree r' (course none) start' t) admitted)
        (Nat.succ_le_succ (Nat.zero_le (0 + t)))⟩
  have notBack : ¬ ∃ d, Reaching.CoversLater process adm d none (some 0) := fun ⟨d, covers⟩ =>
    match covers (course (some 0)) rfl with
    | ⟨r, start, includes⟩ => Nat.not_succ_le_self 1
        (Eq.subst (motive := fun c => adm c 2) (Law.runs_agree r (course none) start (2 + d))
          (includes 2 2 (Nat.le_refl 2)))
  ⟨.inr ⟨⟨1, later⟩, notBack⟩,
   fun | .inl widens => silent.2.2.2.2.1 widens
       | .inr ⟨_, notBack'⟩ => notBack' ⟨1, later⟩⟩

/-- **Inclusion now does not give covering**: what the climb from `some 0` admits now `none` admits
now, yet `none` does not cover the climb. -/
theorem inclusion_now_not_covering :
    (∀ x, adm (some 0) x → adm none x) ∧ ¬ Reaching.Covers process adm none (some 0) :=
  ⟨fun _ le => Nat.le_trans le (Nat.zero_le 1),
   fun covers => match covers (course (some 0)) rfl with
    | ⟨r, start, includes⟩ => Nat.not_succ_le_self 1
        (Eq.subst (motive := fun c => adm c 2) (Law.runs_agree r (course none) start 2)
          (includes 2 2 (Nat.le_refl 2)))⟩

/-- **C leaves the pair undecided**: widening what can be reached and the lagged order are strict
partial orders (`Reaching.Widens.irrefl`, `Reaching.Widens.trans`, `Reaching.WidensOrLater.irrefl`,
`Reaching.WidensOrLater.trans`) satisfying C on the frame of reachable ranges
(`Reaching.comparison_widens`, `Reaching.comparison_widensOrLater`); here the first does not rank
the climb above `none` and the second does. So ranking the pair is a premise beyond C. -/
theorem comparison_undecided :
    Comparison (Reaching.reachFrame process adm) (fun _ => True)
        (fun a b => Reaching.Widens process adm b a) ∧
      Comparison (Reaching.reachFrame process adm) (fun _ => True)
        (fun a b => Reaching.WidensOrLater process adm b a) ∧
      ¬ Reaching.Widens process adm (some 0) none ∧ Reaching.WidensOrLater process adm (some 0) none :=
  ⟨Reaching.comparison_widens, Reaching.comparison_widensOrLater, silent.2.2.2.1, decided.1⟩

/-! Other admissions on the same process: where each course still exceeds the other the lagged order
can be silent both ways (`TwoSided`), and where the configuration wider now also widens what can be
reached over the climb it ranks that configuration above (`Full`). -/

namespace TwoSided

/-- `none` admits the first formation of the left side and every formation of the right side;
`some n` admits the left formations up to `n`. -/
def adm : Option Nat → Sum Nat Nat → Prop
  | none, .inl i => i = 0
  | none, .inr _ => True
  | some n, .inl i => i ≤ n
  | some _, .inr _ => False

/-- **The lagged order can be silent both ways**: what the climb from `some 0` admits keeps
widening in 07's form, `none` admits now what the climb does not and each course exceeds the
other, yet neither is above the other in the lagged order, since neither covers the other at any
lag (UE9's `Sides.silent` read on courses). -/
theorem silent :
    Reaching.KeepsWidening (fun n => adm ((course (some 0)).state n)) ∧
      adm none (.inr 0) ∧ ¬ adm (some 0) (.inr 0) ∧
      (course none).RangeExceeds adm (course (some 0)) ∧
      (course (some 0)).RangeExceeds adm (course none) ∧
      ¬ Reaching.WidensOrLater process adm (some 0) none ∧
      ¬ Reaching.WidensOrLater process adm none (some 0) :=
  ⟨⟨fun n d x admitted => match x, admitted with
      | .inl _, le => Nat.le_trans le (Nat.add_le_add_left (Nat.le_add_right n d) 0)
      | .inr _, no => no.elim,
    fun n => ⟨1, .inl (0 + n + 1), Nat.le_refl _, Nat.not_succ_le_self (0 + n)⟩⟩,
   trivial, id,
   ⟨0, .inr 0, trivial, id⟩, ⟨1, .inl 1, Nat.le_refl _, fun same => Nat.noConfusion same⟩,
   fun
    | .inl widens => widens.1.now (r' := course none) rfl (x := .inr 0) trivial
    | .inr ⟨⟨_, later⟩, _⟩ => match later (course none) rfl with
      | ⟨r, start, includes⟩ =>
        (Eq.subst (motive := fun c => adm c (.inr 0))
          (Law.runs_agree r (course (some 0)) start _) (includes 0 (.inr 0) trivial) :
          adm (some _) (.inr 0)),
   fun
    | .inl widens => match widens.1 (course (some 0)) rfl with
      | ⟨r, start, includes⟩ => Nat.noConfusion
          (Eq.subst (motive := fun c => adm c (.inl 1))
            (Law.runs_agree r (course none) start 1) (includes 1 (.inl 1) (Nat.le_refl 1)) :
            (1 : Nat) = 0)
    | .inr ⟨⟨_, later⟩, _⟩ => match later (course (some 0)) rfl with
      | ⟨r, start, includes⟩ => Nat.noConfusion
          (Eq.subst (motive := fun c => adm c (.inl 1))
            (Law.runs_agree r (course none) start _) (includes 1 (.inl 1) (Nat.le_refl 1)) :
            (1 : Nat) = 0)⟩

end TwoSided

namespace Full

/-- `none` admits every formation; `some n` admits the formations up to `n`. -/
def adm : Option Nat → Nat → Prop
  | none, _ => True
  | some n, x => x ≤ n

/-- **Same-offset widening can rank the configuration wider now above the climb**: what the climb
from `some 0` admits keeps widening and `none` admits now what the climb does not; here `none`
widens what can be reached over the climb, and the lagged order ranks `none` above it and not
conversely. -/
theorem not_silent :
    Reaching.KeepsWidening (fun n => adm ((course (some 0)).state n)) ∧
      adm none 1 ∧ ¬ adm (some 0) 1 ∧
      Reaching.Widens process adm none (some 0) ∧
      Reaching.WidensOrLater process adm none (some 0) ∧
      ¬ Reaching.WidensOrLater process adm (some 0) none :=
  have widens : Reaching.Widens process adm none (some 0) :=
    ⟨fun _ _ => ⟨course none, rfl, fun _ _ _ => trivial⟩, course none, rfl,
     fun _ start' includes => Nat.not_succ_le_self 0
       (Eq.subst (motive := fun c => adm c 1) start' (includes 0 1 trivial) : adm (some 0) 1)⟩
  ⟨⟨fun n d _ le => Nat.le_trans le (Nat.add_le_add_left (Nat.le_add_right n d) 0),
    fun n => ⟨1, 0 + n + 1, Nat.le_refl _, Nat.not_succ_le_self (0 + n)⟩⟩,
   trivial, Nat.not_succ_le_self 0, widens, .inl widens,
   Reaching.WidensOrLater.not_reversed widens⟩

end Full

end WiderNow

namespace DeferredBranching

/-- `late` steps to `mid`, which steps to `a` or to `b`; `early` steps at once to `ma` or to `mb`,
which step to `a` and to `b`. -/
inductive Config
  | late
  | mid
  | early
  | ma
  | mb
  | a
  | b

def process : Process Config Unit := ⟨fun s _ c => match s with
  | .late => c = .mid
  | .mid => c = .a ∨ c = .b
  | .early => c = .ma ∨ c = .mb
  | .ma => c = .a
  | .mb => c = .b
  | .a => c = .a
  | .b => c = .b⟩

/-- `a` admits `1`, `b` admits `2`, every other configuration admits `0`. -/
def adm : Config → Nat → Prop
  | .late, x => x = 0
  | .mid, x => x = 0
  | .early, x => x = 0
  | .ma, x => x = 0
  | .mb, x => x = 0
  | .a, x => x = 1
  | .b, x => x = 2

def lateA : Run process :=
  ⟨fun | 0 => .late | 1 => .mid | _ + 2 => .a, fun _ => (),
    fun | 0 => rfl | 1 => .inl rfl | _ + 2 => rfl⟩

def lateB : Run process :=
  ⟨fun | 0 => .late | 1 => .mid | _ + 2 => .b, fun _ => (),
    fun | 0 => rfl | 1 => .inr rfl | _ + 2 => rfl⟩

def earlyA : Run process :=
  ⟨fun | 0 => .early | 1 => .ma | _ + 2 => .a, fun _ => (),
    fun | 0 => .inl rfl | 1 => rfl | _ + 2 => rfl⟩

def earlyB : Run process :=
  ⟨fun | 0 => .early | 1 => .mb | _ + 2 => .b, fun _ => (),
    fun | 0 => .inr rfl | 1 => rfl | _ + 2 => rfl⟩

def midA : Run process :=
  ⟨fun | 0 => .mid | _ + 1 => .a, fun _ => (), fun | 0 => .inl rfl | _ + 1 => rfl⟩

def midB : Run process :=
  ⟨fun | 0 => .mid | _ + 1 => .b, fun _ => (), fun | 0 => .inr rfl | _ + 1 => rfl⟩

theorem stepped {r : Run process} {t : Nat} {c : Config} (at_t : r.state t = c) :
    process.step c (r.act t) (r.state (t + 1)) :=
  Eq.mp (congrArg (fun y => process.step y (r.act t) (r.state (t + 1))) at_t) (r.step t)

/-- A course at `a` at step two stays there; so at `b`. -/
theorem at_a {r : Run process} (two : r.state 2 = .a) : ∀ d, r.state (d + 2) = .a
  | 0 => two
  | d + 1 => (stepped (at_a two d) : r.state (d + 2 + 1) = .a)

theorem at_b {r : Run process} (two : r.state 2 = .b) : ∀ d, r.state (d + 2) = .b
  | 0 => two
  | d + 1 => (stepped (at_b two d) : r.state (d + 2 + 1) = .b)

/-- After two steps a course from `early` is at `a` for good or at `b` for good. -/
theorem from_early (r : Run process) (start : r.state 0 = .early) :
    (r.state 1 = .ma ∧ ∀ d, r.state (d + 2) = .a) ∨ (r.state 1 = .mb ∧ ∀ d, r.state (d + 2) = .b) :=
  match (stepped start : r.state 1 = .ma ∨ r.state 1 = .mb) with
  | .inl ma => .inl ⟨ma, at_a (stepped ma : r.state 2 = .a)⟩
  | .inr mb => .inr ⟨mb, at_b (stepped mb : r.state 2 = .b)⟩

theorem from_late (r : Run process) (start : r.state 0 = .late) :
    r.state 1 = .mid ∧ ((∀ d, r.state (d + 2) = .a) ∨ ∀ d, r.state (d + 2) = .b) :=
  have mid : r.state 1 = .mid := stepped start
  ⟨mid, match (stepped mid : r.state 2 = .a ∨ r.state 2 = .b) with
    | .inl a => .inl (at_a a)
    | .inr b => .inr (at_b b)⟩

/-- A course including another offset by offset, given at the first two offsets and after. -/
theorem includes_of {r q : Run process} (zero : ∀ x, adm (r.state 0) x → adm (q.state 0) x)
    (one : ∀ x, adm (r.state 1) x → adm (q.state 1) x)
    (rest : ∀ d x, adm (r.state (d + 2)) x → adm (q.state (d + 2)) x) : q.RangeIncludes adm r :=
  fun t x admitted => match t with
  | 0 => zero x admitted
  | 1 => one x admitted
  | d + 2 => rest d x admitted

/-- Moving what a configuration admits along an equation. -/
theorem moved {r : Run process} {n : Nat} {c : Config} (at_n : r.state n = c) {x : Nat}
    (admitted : adm (r.state n) x) : adm c x :=
  Eq.subst (motive := fun y => adm y x) at_n admitted

/-- **Covering is linear-time and cannot see when a commitment is made**: `late`, which branches a
step later, and `early`, which branches at once, cover each other, so neither widens what can be
reached over the other. -/
theorem cover_both :
    Reaching.Covers process adm .late .early ∧ Reaching.Covers process adm .early .late ∧
      ¬ Reaching.Widens process adm .late .early ∧ ¬ Reaching.Widens process adm .early .late :=
  have lateCovers : Reaching.Covers process adm .late .early := fun r' start' =>
    match from_early r' start' with
    | .inl ⟨ma, rest⟩ => ⟨lateA, rfl, includes_of
        (fun _ h => (moved start' h : adm .early _)) (fun _ h => (moved ma h : adm .ma _))
        (fun d _ h => match d with
          | 0 => (moved (rest 0) h : adm .a _)
          | _ + 1 => (moved (rest _) h : adm .a _))⟩
    | .inr ⟨mb, rest⟩ => ⟨lateB, rfl, includes_of
        (fun _ h => (moved start' h : adm .early _)) (fun _ h => (moved mb h : adm .mb _))
        (fun d _ h => match d with
          | 0 => (moved (rest 0) h : adm .b _)
          | _ + 1 => (moved (rest _) h : adm .b _))⟩
  have earlyCovers : Reaching.Covers process adm .early .late := fun r' start' =>
    match from_late r' start' with
    | ⟨mid, .inl rest⟩ => ⟨earlyA, rfl, includes_of
        (fun _ h => (moved start' h : adm .late _)) (fun _ h => (moved mid h : adm .mid _))
        (fun d _ h => match d with
          | 0 => (moved (rest 0) h : adm .a _)
          | _ + 1 => (moved (rest _) h : adm .a _))⟩
    | ⟨mid, .inr rest⟩ => ⟨earlyB, rfl, includes_of
        (fun _ h => (moved start' h : adm .late _)) (fun _ h => (moved mid h : adm .mid _))
        (fun d _ h => match d with
          | 0 => (moved (rest 0) h : adm .b _)
          | _ + 1 => (moved (rest _) h : adm .b _))⟩
  ⟨lateCovers, earlyCovers,
   fun widens => Reaching.widens_not_covered widens earlyCovers,
   fun widens => Reaching.widens_not_covered widens lateCovers⟩

/-- `mid` widens what can be reached over `ma`. -/
theorem mid_widens_ma : Reaching.Widens process adm .mid .ma :=
  ⟨fun r' start' =>
     have one : r'.state 1 = .a := stepped start'
     ⟨midA, rfl, includes_of (fun _ h => (moved start' h : adm .ma _))
       (fun _ h => (moved one h : adm .a _))
       (fun d _ h => (moved (at_a (stepped one : r'.state 2 = .a) d) h : adm .a _))⟩,
   midB, rfl, fun r' start' includes =>
     Nat.not_succ_le_self 1 (Nat.le_of_eq ((moved (stepped start' : r'.state 1 = .a)
       (includes 1 2 rfl) : adm .a 2) : (2 : Nat) = 1))⟩

/-- `mid` widens what can be reached over `mb`. -/
theorem mid_widens_mb : Reaching.Widens process adm .mid .mb :=
  ⟨fun r' start' =>
     have one : r'.state 1 = .b := stepped start'
     ⟨midB, rfl, includes_of (fun _ h => (moved start' h : adm .mb _))
       (fun _ h => (moved one h : adm .b _))
       (fun d _ h => (moved (at_b (stepped one : r'.state 2 = .b) d) h : adm .b _))⟩,
   midA, rfl, fun r' start' includes =>
     Nat.not_succ_le_self 1 (Nat.le_of_eq ((moved (stepped start' : r'.state 1 = .b)
       (includes 1 1 rfl) : adm .b 1) : (1 : Nat) = 2).symm)⟩

/-- **One step on, the branch taken is seen**: the next configuration of every course from `late`
widens what can be reached over the next configuration of every course from `early`. -/
theorem widens_after_one_step (q : Run process) (lateStart : q.state 0 = .late) (r : Run process)
    (earlyStart : r.state 0 = .early) : Reaching.Widens process adm (q.state 1) (r.state 1) :=
  have mid : q.state 1 = .mid := (from_late q lateStart).1
  match from_early r earlyStart with
  | .inl ⟨ma, _⟩ => Eq.subst (motive := fun c => Reaching.Widens process adm (q.state 1) c) ma.symm
      (Eq.subst (motive := fun c => Reaching.Widens process adm c .ma) mid.symm mid_widens_ma)
  | .inr ⟨mb, _⟩ => Eq.subst (motive := fun c => Reaching.Widens process adm (q.state 1) c) mb.symm
      (Eq.subst (motive := fun c => Reaching.Widens process adm c .mb) mid.symm mid_widens_mb)

/-- A simulation on this process: related configurations admit alike or more on the right, and
every step on the left is matched on the right into related configurations. -/
def Simulation (R : Config → Config → Prop) : Prop :=
  ∀ s s', R s s' → (∀ x, adm s x → adm s' x) ∧
    ∀ t, process.step s () t → ∃ t', process.step s' () t' ∧ R t t'

/-- **No simulation relates `late` to `early`**: `early` cannot match `late`'s later branching, though
the two cover each other. -/
theorem early_not_simulating_late {R : Config → Config → Prop} (simulation : Simulation R)
    (related : R .late .early) : False :=
  match (simulation _ _ related).2 .mid rfl with
  | ⟨.ma, _, toMa⟩ => match (simulation _ _ toMa).2 .b (.inr rfl) with
    | ⟨.a, _, toA⟩ => Nat.not_succ_le_self 1
        (Nat.le_of_eq ((simulation _ _ toA).1 2 rfl : (2 : Nat) = 1))
    | ⟨.late, e, _⟩ => Config.noConfusion e
    | ⟨.mid, e, _⟩ => Config.noConfusion e
    | ⟨.early, e, _⟩ => Config.noConfusion e
    | ⟨.ma, e, _⟩ => Config.noConfusion e
    | ⟨.mb, e, _⟩ => Config.noConfusion e
    | ⟨.b, e, _⟩ => Config.noConfusion e
  | ⟨.mb, _, toMb⟩ => match (simulation _ _ toMb).2 .a (.inl rfl) with
    | ⟨.b, _, toB⟩ => Nat.not_succ_le_self 1
        (Nat.le_of_eq ((simulation _ _ toB).1 1 rfl : (1 : Nat) = 2).symm)
    | ⟨.late, e, _⟩ => Config.noConfusion e
    | ⟨.mid, e, _⟩ => Config.noConfusion e
    | ⟨.early, e, _⟩ => Config.noConfusion e
    | ⟨.ma, e, _⟩ => Config.noConfusion e
    | ⟨.mb, e, _⟩ => Config.noConfusion e
    | ⟨.a, e, _⟩ => Config.noConfusion e
  | ⟨.late, step, _⟩ => match step with
    | .inl e => Config.noConfusion e
    | .inr e => Config.noConfusion e
  | ⟨.mid, step, _⟩ => match step with
    | .inl e => Config.noConfusion e
    | .inr e => Config.noConfusion e
  | ⟨.early, step, _⟩ => match step with
    | .inl e => Config.noConfusion e
    | .inr e => Config.noConfusion e
  | ⟨.a, step, _⟩ => match step with
    | .inl e => Config.noConfusion e
    | .inr e => Config.noConfusion e
  | ⟨.b, step, _⟩ => match step with
    | .inl e => Config.noConfusion e
    | .inr e => Config.noConfusion e

/-- The simulation relating `early` to `late`. -/
def lateOverEarly : Config → Config → Prop
  | .late, _ => False
  | .mid, _ => False
  | .early, c => c = .late
  | .ma, c => c = .mid
  | .mb, c => c = .mid
  | .a, c => c = .a
  | .b, c => c = .b

/-- **`late` simulates `early`.** -/
theorem late_simulates_early : Simulation lateOverEarly ∧ lateOverEarly .early .late :=
  ⟨fun s s' related => match s, s', related with
    | .early, _, rfl => ⟨fun _ h => h, fun t step => ⟨.mid, rfl, match t, step with
        | .ma, _ => rfl
        | .mb, _ => rfl
        | .late, .inl e => Config.noConfusion e
        | .late, .inr e => Config.noConfusion e
        | .mid, .inl e => Config.noConfusion e
        | .mid, .inr e => Config.noConfusion e
        | .early, .inl e => Config.noConfusion e
        | .early, .inr e => Config.noConfusion e
        | .a, .inl e => Config.noConfusion e
        | .a, .inr e => Config.noConfusion e
        | .b, .inl e => Config.noConfusion e
        | .b, .inr e => Config.noConfusion e⟩⟩
    | .ma, _, rfl => ⟨fun _ h => h, fun _ step => ⟨.a, .inl rfl,
        Eq.subst (motive := fun c => lateOverEarly c .a) step.symm rfl⟩⟩
    | .mb, _, rfl => ⟨fun _ h => h, fun _ step => ⟨.b, .inr rfl,
        Eq.subst (motive := fun c => lateOverEarly c .b) step.symm rfl⟩⟩
    | .a, _, rfl => ⟨fun _ h => h, fun _ step => ⟨.a, rfl,
        Eq.subst (motive := fun c => lateOverEarly c .a) step.symm rfl⟩⟩
    | .b, _, rfl => ⟨fun _ h => h, fun _ step => ⟨.b, rfl,
        Eq.subst (motive := fun c => lateOverEarly c .b) step.symm rfl⟩⟩,
   rfl⟩

end DeferredBranching

end Becoming
