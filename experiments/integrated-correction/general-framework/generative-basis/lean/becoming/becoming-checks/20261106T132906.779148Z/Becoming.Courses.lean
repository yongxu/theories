import Becoming.Lasting
import Becoming.Countdown
import Becoming.Retrodiction
import Becoming.Copying
import Becoming.CrossSituational
import Becoming.Readout
import Becoming.Weighted
import Becoming.Description
import Becoming.Feedback
import Becoming.Decidedness
import Becoming.Parting
import Becoming.Extension

/-!
# Courses: the apart laws read on the shared base

Several modules state their laws for a sequence, a history, a law of change, a pool or a list of
configurations without naming the base on which the rest of the spine stands: the courses of a
process (`Generative.Process`, `Generative.Trace`, `Becoming.Run`), the configurations of a
`Frame`, and the conditions of a `Web` or `Flow`. Their objects are the base's own. An admissible
history of a law under disturbances is a run of the disturbed process; a determined law's orbit is
the course of its process; a partial law's run is a trace of its process; a dated history is a
run; a reduction of a run is a run of the law read through it. This module states each law on
those courses, with no premise beyond what the law names, so that each is a law of the one
unfolding's courses and not of a separate model.

* **Lasting.** A start lasts `n` steps exactly when every course of at most `n` admissible
  disturbances stays within the guard (`lasts_iff_courses`); so lasting is having a ladder, or
  being held by every necessary family, read on courses (`courses_iff_ladder`,
  `courses_iff_necessary`). A run of the disturbed process is an admissible history
  (`run_history`), so a start below level `n` of a drained family leaves the guard within `n`
  steps on every run (`Drains.leaves_run`, `exhausts_run`). A determined law never reaches a
  target from a start exactly when no configuration its process reaches is in the target
  (`Branching.law_reach_iff`), so exactly when a closed set holding the start avoids it
  (`avoids_iff_closed_reach`, `some_avoids_iff_reach`, `fixed_avoids_reach`); what a funnel or
  every basin holds at level `n` meets the target within `n` steps on every run
  (`Funnel.runs`, `basin_runs`), and for a determined law a course of at most `n` steps reaches
  the target exactly when a funnel or a numeric variant holds the start
  (`course_reaches_iff_funnel`, `course_reaches_iff_variant`).
* **Countdown.** An admitted plan from a valid configuration completes, as a plan of the partial
  law's process, into a valid configuration (`runs_valid_completes`), and into the exit where it
  is longer than the margin (`exits_completes`). Unfuelled work completes in `work + 1` unit
  moves (`Advances.completes_plan`), and every course of at most `work` moves leaves it pending
  with the work lowered by the moves taken (`pending_before_course`).
* **Retrodiction.** With the runs of a process as the histories and the configuration at a date
  as the relation then holding, reading an earlier packet right is separating every rival run by
  a dated control (`runs_reading_right_iff`, `runs_look_right_iff`). Where every change is
  admitted, controls at both ends settle the dates between on every run exactly when at most one
  change is admitted or no date lies strictly between (`runs_settle_iff`).
* **Copying.** A plan of `k` moves of a determined law completes exactly when the goal holds on
  its orbit at `k` (`completes_units_iff`), and a copy's moves go along the orbit of its law
  (`steps_orbit`). So the copy of a word, as a plan of its process, completes with nothing pending,
  builds the word, or empties the pool exactly where the copying laws say
  (`copy_completes_iff`, `copy_built_iff`, `copy_empties_iff`), and its product only grows along
  every course (`copy_grows`); reading through contacts is the same for the reading copy
  (`reading_completes_iff`). Inspection is a process whose moves are the sites inspected: a move
  never raises the defects exactly at a faithful site, and no course of faithful inspections does
  (`inspection_le_iff`, `inspection_course_le`). Copies from one shared pool are a course of the
  release law exactly when every copy of the batch is released (`every_released_iff_course`), so
  exactly when the pool supplies all the words and the support covers their draws and releases
  (`release_course_iff`, `lineage_course_iff`).
* **Segmentation.** Where every word is a course from `s` back to `s`, every sequence of words is
  (`encode_course`); grouping recovers the words of every such course exactly when each word is
  linked inside and no word's end is linked to a word's start (`course_words_iff`), the grouping of
  a course's moves is unique (`course_chunks_iff`), no record of a run groups every course of words
  where two words continue one move differently (`no_run_record_groups`), and every course of
  words is read as the meanings of its words exactly when each word is (`course_reads_iff`).
* **Cross-situational resolution.** Read as records, the moves of a run only narrow the candidates
  (`run_candidates_append`, `run_narrows`, `run_stays_iff`); a form resolves after `n` moves of a
  run exactly when every other meaning is missing from some bearing move (`run_resolves_iff`),
  also where the moves are read through a family of explanations (`run_resolves_explained_iff`),
  and every course of words is read by resolution exactly when each word's records separate its
  meaning (`course_resolves_every_iff`).
* **Readout.** What a reduction keeps of a run is a run of the law read through it
  (`reducedRun`): no map of reduced runs restores two runs it merges (`runs_no_restore`), an
  observable of two runs is decoded from their merged reduced runs exactly where it agrees on them
  (`Readout.decoder_pair_iff`), and a judge reads an observable through a run's reduced run exactly
  when the observable goes alike at the dates the reduction merges (`run_judges_iff`,
  `no_run_judge_of_merged`). Two steps of a web agree under every reading through its conditions
  exactly where every condition stands at the same level (`Readout.agree_iff_parts`,
  `Readout.supplied_agree_iff_parts`).
* **Fallible witnesses.** The values a map takes along a run at listed dates are fallible witnesses: where
  two fault sets leave a common faithful date, no run of any process is explained by two answers
  under them (`run_reports_apart`); over the courses in which every change is admitted, no course
  is so explained exactly where every two admitted fault sets leave one
  (`dates_no_common_report_iff`, `dates_no_common_report_envelopes_iff`).
* **Masses.** Read at a frame's listed configurations, every chance keeps one claim's mass within
  another's exactly where the second is realized wherever the first is
  (`claims_every_weighting_iff`), and fulfillment gives a floor of chance (`claims_floor`). Every
  selection of the formations drawing on a web's condition is within its standing exactly when
  all of them together are (`every_event_within_iff`), while each formation supported does not put
  them together within it (`supported_not_together`). Around a loop of one configuration and two
  moves, the courses of `n` moves are `2 ^ n` (`loop_courses_double`).
* **Feedback.** A region is a formation's system, the closure under sharing a condition, exactly
  when it holds the formation, is closed under sharing and lies within the system
  (`closure_iff_certified`); certified regions apart are systems apart
  (`not_within_of_closed`).
* **Separation.** Along every course of a determined law (`reachedFrom`), parts moved each by
  itself stay unrelated (`courses_keep_unrelated`), and a relation persists where neither move
  merges (`relation_persists_courses`); a course of copying relates the parts
  (`copy_relates_course`), forgetting a part unrelates it (`forgetting_unrelates_courses`), and a
  coupling relates and, acting again, unrelates (`coupling_course`).
* **Generative frontier.** On a nonempty listed menu of a frame's configurations, with generative
  extension weakly decided, some configuration is extended by no member
  (`extension_frontier_exists`); with extension and a task decided, every configuration no member
  extends performs the task exactly when every member lacking it is extended by some member
  (`undominated_has_iff`).
* **One notion, one definition.** The process in which every change is admitted is free branching
  of `Becoming.Parting` (`anyChange_eq_free`, by definition); the lists without repetition are
  one definition, `Distinct` of `Becoming.Prelude` (R37).

No premise is added; the module changes no definition and every declaration has an empty axiom
report. `Becoming.CoursesBridge`, outside the core, reads the comparison under every
classification of fresh contents on a frame's configurations.
-/

namespace Becoming

open Generative Generative.InquirySufficiency

universe u v w x y z p q

namespace Courses

/-! ## Lasting -/

section Lasting

open Viability Lasting

variable {S : Type u} {A : Type v} {f : S → A → S} {adm : A → Prop} {guard : S → Prop}

/-- A run of the disturbed process is the admissible history of its moves. -/
theorem run_history (r : Run (disturbed f adm)) : ∀ n, r.state n = history f (r.state 0) r.act n
  | 0 => rfl
  | n + 1 => (r.step n).2.trans (congrArg (fun x => f x (r.act n)) (run_history r n))

/-- The moves of a run of the disturbed process are admissible. -/
theorem run_admissible (r : Run (disturbed f adm)) : ∀ k, adm (r.act k) := fun k => (r.step k).1

/-- An admissible history is a run of the disturbed process. -/
def historyRun (s : S) (d : Nat → A) (admissible : ∀ k, adm (d k)) : Run (disturbed f adm) :=
  ⟨history f s d, d, fun n => ⟨admissible n, rfl⟩⟩

/-- What every course of at most `n` admissible disturbances keeps within the guard lasts
`n` steps. -/
theorem lasts_of_courses : ∀ {n : Nat} {s : S},
    (∀ plan t, Trace (disturbed f adm) s plan t → plan.length ≤ n → guard t) →
      Lasts f adm guard n s
  | 0, s, every => every [] s (.nil s) (Nat.le_refl 0)
  | _ + 1, s, every => And.intro (every [] s (.nil s) (Nat.zero_le _))
      (fun a admitted => lasts_of_courses (fun plan t path bound =>
        every (a :: plan) t (.cons ⟨admitted, rfl⟩ path) (Nat.succ_le_succ bound)))

/-- **Lasting is staying within the guard on every course.** A start lasts `n` steps exactly
when every course of at most `n` admissible disturbances from it stays within the guard. -/
theorem lasts_iff_courses {n : Nat} {s : S} :
    Lasts f adm guard n s ↔
      ∀ plan t, Trace (disturbed f adm) s plan t → plan.length ≤ n → guard t :=
  ⟨fun lasts _ _ path bound => Lasts.trace lasts path bound, lasts_of_courses⟩

/-- **The lasting law on courses.** Every course of at most `n` admissible disturbances stays
within the guard exactly when some ladder holds the start at level `n`. -/
theorem courses_iff_ladder {n : Nat} {s : S} :
    (∀ plan t, Trace (disturbed f adm) s plan t → plan.length ≤ n → guard t) ↔
      ∃ C : Nat → S → Prop, C n s ∧ Ladder f adm guard C :=
  lasts_iff_courses.symm.trans lasts_iff_ladder

/-- **What lasting requires, on courses.** Every course of at most `n` admissible disturbances
stays within the guard exactly when every necessary family holds the start at level `n`. -/
theorem courses_iff_necessary {n : Nat} {s : S} :
    (∀ plan t, Trace (disturbed f adm) s plan t → plan.length ≤ n → guard t) ↔
      ∀ L : Nat → S → Prop, Necessary f adm guard L → L n s :=
  lasts_iff_courses.symm.trans lasts_iff_necessary

/-- **Exhaustion on runs.** A start below level `n` of a drained family leaves the guard within
`n` steps on every run of the disturbed process. -/
theorem Drains.leaves_run {L : Nat → S → Prop} (drains : Drains f adm guard L) {n : Nat}
    (r : Run (disturbed f adm)) (below : ¬ L n (r.state 0)) :
    ¬ ∀ k, k ≤ n → guard (r.state k) :=
  fun within => Lasting.Drains.leaves drains below r.act (run_admissible r)
    (fun k bound => Eq.mp (congrArg guard (run_history r k)) (within k bound))

/-- **Exhaustion by bounded growth, on runs**: `exhausts` for every run of the disturbed
process. -/
theorem exhausts_run {V : Type w} {rel : V → V → Prop} {g : V → V}
    (trans : ∀ a b c, rel a b → rel b c → rel a c)
    (mono : ∀ a b, rel a b → rel (g a) (g b)) {R : S → Prop} {q : S → V} {θ : V}
    {level : Nat → S → Prop}
    (kept : ∀ x a, adm a → R x → R (f x a))
    (grows : ∀ x a, adm a → R x → rel (q (f x a)) (g (q x)))
    (base : ∀ x, guard x → level 0 x)
    (lowers : ∀ k x a, R x → guard x → adm a → rel (Law.orbit g (q x) (k + 1)) θ →
      level k (f x a) → level (k + 1) x)
    {n : Nat} (r : Run (disturbed f adm)) (region : R (r.state 0))
    (small : rel (Law.orbit g (q (r.state 0)) n) θ) (short : ¬ level n (r.state 0)) :
    ¬ ∀ k, k ≤ n → guard (r.state k) :=
  fun within => exhausts trans mono kept grows base lowers region small short r.act
    (run_admissible r) (fun k bound => Eq.mp (congrArg guard (run_history r k)) (within k bound))

/-- **Reaching on runs.** What reaches the target within `n` steps meets it within `n` steps on
every run of the disturbed process. -/
theorem Reaches.runs {target : S → Prop} {n : Nat} (r : Run (disturbed f adm))
    (reaches : Reaches f adm target n (r.state 0)) : ∃ k, k ≤ n ∧ target (r.state k) :=
  match Lasting.Reaches.histories reaches r.act (run_admissible r) with
  | ⟨k, bound, inside⟩ => ⟨k, bound, Eq.mpr (congrArg target (run_history r k)) inside⟩

/-- **A funnel on runs**: a start a funnel holds at level `n` meets the target within `n` steps
on every run of the disturbed process. -/
theorem Funnel.runs {target : S → Prop} {F : Nat → S → Prop} (funnel : Funnel f adm target F)
    {n : Nat} (r : Run (disturbed f adm)) (held : F n (r.state 0)) :
    ∃ k, k ≤ n ∧ target (r.state k) :=
  Reaches.runs r (funnel.reaches n (r.state 0) held)

/-- **Every basin on runs**: a start that every basin holds at level `n` meets the target within
`n` steps on every run of the disturbed process. -/
theorem basin_runs {target : S → Prop} {n : Nat} (r : Run (disturbed f adm))
    (every : ∀ L : Nat → S → Prop, Basin f adm target L → L n (r.state 0)) :
    ∃ k, k ≤ n ∧ target (r.state k) :=
  Reaches.runs r (reaches_iff_basin.mpr every)

end Lasting

/-! ### A determined law as a process -/

section Determined

open Lasting

variable {S : Type u} {next : S → S} {target : S → Prop}

/-- A course of a determined law's process ends on the orbit, at its length. -/
theorem trace_orbit : ∀ {s t : S} {plan : List Unit},
    Trace (Law.process next) s plan t → t = Law.orbit next s plan.length
  | _, _, [], .nil _ => rfl
  | s, _, _ :: rest, .cons moved tail =>
    (trace_orbit tail).trans ((congrArg (fun x => Law.orbit next x rest.length) moved).trans
      (Law.orbit_shift next s rest.length).symm)

/-- The orbit at `k` is where the course of `k` moves of the determined law's process ends. -/
theorem orbit_trace (next : S → S) : ∀ (k : Nat) (s : S),
    Trace (Law.process next) s (List.replicate k ()) (Law.orbit next s k)
  | 0, s => .nil s
  | k + 1, s => .cons rfl (Eq.mpr (congrArg (Trace (Law.process next) (next s)
      (List.replicate k ())) (Law.orbit_shift next s k)) (orbit_trace next k (next s)))

/-- **Never reaching on courses.** No configuration a determined law's process reaches from `s`
is in the target exactly when some set containing `s` avoids the target and is closed under the
law. -/
theorem avoids_iff_closed_reach {s : S} :
    (∀ t, Reach (Law.process next) s t → ¬ target t) ↔
      ∃ K : S → Prop, K s ∧ (∀ x, K x → ¬ target x) ∧ ∀ x, K x → K (next x) :=
  (⟨fun avoids n => avoids _ (Branching.law_reach_iff.mpr ⟨n, rfl⟩),
    fun avoids _ reach => match Branching.law_reach_iff.mp reach with
      | ⟨n, at_n⟩ => at_n ▸ avoids n⟩ :
      (∀ t, Reach (Law.process next) s t → ¬ target t) ↔ ∀ n, ¬ target (Law.orbit next s n)).trans
    avoids_iff_closed

/-- **Some seed never reaches the target, on courses**, exactly when a closed set avoiding the
target holds a seed. -/
theorem some_avoids_iff_reach {seed : S → Prop} :
    (∃ s, seed s ∧ ∀ t, Reach (Law.process next) s t → ¬ target t) ↔
      ∃ K : S → Prop, (∃ s, seed s ∧ K s) ∧ (∀ x, K x → ¬ target x) ∧
        ∀ x, K x → K (next x) :=
  ⟨fun ⟨s, seeded, avoids⟩ => match avoids_iff_closed_reach.mp avoids with
    | ⟨K, held, avoid, closed⟩ => ⟨K, ⟨s, seeded, held⟩, avoid, closed⟩,
   fun ⟨K, ⟨s, seeded, held⟩, avoid, closed⟩ =>
    ⟨s, seeded, avoids_iff_closed_reach.mpr ⟨K, held, avoid, closed⟩⟩⟩

/-- A fixed configuration outside the target reaches no configuration in it: `Lasting.fixed_avoids`
on the courses of the law's process. -/
theorem fixed_avoids_reach {x : S} (fixed : next x = x) (outside : ¬ target x) :
    ∀ t, Reach (Law.process next) x t → ¬ target t :=
  fun _ reach => match Branching.law_reach_iff.mp reach with
    | ⟨n, at_n⟩ => Eq.mp (congrArg (fun z => ¬ target z) at_n) (Lasting.fixed_avoids fixed outside n)

/-- A course of at most `n` moves of a determined law's process reaches the target exactly when
the orbit meets it within `n` steps. -/
theorem course_reaches_iff_orbit {n : Nat} {s : S} :
    (∃ plan t, Trace (Law.process next) s plan t ∧ plan.length ≤ n ∧ target t) ↔
      ∃ k, k ≤ n ∧ target (Law.orbit next s k) :=
  ⟨fun ⟨plan, _, path, bound, inside⟩ => ⟨plan.length, bound, trace_orbit path ▸ inside⟩,
   fun ⟨k, bound, inside⟩ => ⟨List.replicate k (), _, orbit_trace next k s,
     Eq.mpr (congrArg (· ≤ n) (Branching.units_length k)) bound, inside⟩⟩

/-- **The funnel law on courses.** A course of at most `n` moves of a determined law's process
reaches the target exactly when a funnel holds the start at level `n`. -/
theorem course_reaches_iff_funnel {n : Nat} {s : S} :
    (∃ plan t, Trace (Law.process next) s plan t ∧ plan.length ≤ n ∧ target t) ↔
      ∃ F : Nat → S → Prop, F n s ∧ (∀ x, F 0 x → target x) ∧
        ∀ k x, F (k + 1) x → target x ∨ F k (next x) :=
  course_reaches_iff_orbit.trans orbit_reaches_iff_funnel

/-- **The variant law on courses.** With a decided target, a course of at most `n` moves of a
determined law's process reaches the target exactly when a numeric variant is at most `n` at the
start. -/
theorem course_reaches_iff_variant [DecidablePred target] {n : Nat} {s : S} :
    (∃ plan t, Trace (Law.process next) s plan t ∧ plan.length ≤ n ∧ target t) ↔
      ∃ V : S → Nat, V s ≤ n ∧ ∀ x, V x ≤ n → target x ∨ V (next x) < V x :=
  course_reaches_iff_orbit.trans orbit_reaches_iff_variant

end Determined

/-! ## Countdown -/

section Countdown

open Countdown Assurance

variable {S : Type u} {A : Type v}

/-- **An admitted plan completes, valid.** From a valid configuration, every admitted plan of a
law with a reserved exit completes, as a plan of the partial law's process, into a valid
configuration. -/
theorem runs_valid_completes {f : S → A → Option S} {adm : A → Prop} {valid exit : S → Prop}
    {margin : S → Nat} (reserved : Reserved f adm valid exit margin) {plan : List A} {s : S}
    (held : valid s) (admissible : ∀ a, a ∈ plan → adm a) :
    Completes (ofPartial f) free valid s plan :=
  completes_ofPartial_iff f |>.mpr (runs_valid reserved plan s held admissible)

/-- **The reserved exit secures every longer plan.** From a valid configuration, every admitted
plan longer than the margin completes, as a plan of the partial law's process, into a valid
configuration at the exit. -/
theorem exits_completes {f : S → A → Option S} {adm : A → Prop} {valid exit : S → Prop}
    {margin : S → Nat} (reserved : Reserved f adm valid exit margin) {plan : List A} {s : S}
    (held : valid s) (admissible : ∀ a, a ∈ plan → adm a) (long : margin s < plan.length) :
    Completes (ofPartial f) free (fun t => valid t ∧ exit t) s plan :=
  completes_ofPartial_iff f |>.mpr (match exits reserved plan s held admissible long with
    | ⟨t, ran, held', out⟩ => ⟨t, ran, held', out⟩)

/-- **Unfuelled work completes in `work + 1` moves**, as a plan of the tick's process:
`Countdown.Advances.completes` read through the plan's run. -/
theorem Advances.completes_plan {tick : S → Option S} {busy done : S → Prop} {work : S → Nat}
    (advances : Countdown.Advances tick busy done work) {s : S} (pending : busy s) :
    Completes (ofPartial fun s (_ : Unit) => tick s) free done s (List.replicate (work s + 1) ()) :=
  (completes_ofPartial_iff _).mpr (match advances.completes pending with
    | ⟨t, ran, finished⟩ => ⟨t, (ticks_eq_runPartial tick _ s).symm.trans ran, finished⟩)

/-- **Every shorter course leaves the task pending**: every course of at most `work` moves of the
tick's process leaves the task pending, with the work lowered by the moves taken. -/
theorem pending_before_course {tick : S → Option S} {busy done : S → Prop} {work fuel : S → Nat}
    (counts : Countdown.CountedWork tick busy done work fuel) {s t : S} {k : Nat} (pending : busy s)
    (within : k ≤ work s)
    (path : Trace (ofPartial fun s (_ : Unit) => tick s) s (List.replicate k ()) t) :
    busy t ∧ work t + k = work s :=
  pending_before counts pending within
    ((ticks_eq_runPartial tick k s).trans ((trace_ofPartial_iff _).mp path))

end Countdown

/-! ## Retrodiction -/

section Retrodiction

open Retrodiction

variable {S : Type u} {A : Type v} {P : Process S A} {Q : Type x} {O : Type y}

/-- **Reading an earlier configuration's packet right, on runs.** The histories are the runs of a
process and the relation at a date is the configuration then. The packet at date `d` was produced
by the actual run's configuration and the hidden source `s`. Every explanation of it by a run of
the family fitting the dated records and an admitted source gives the actual content exactly
when every run of the family that, with some admitted source, gives the same packet with another
content is told apart from the actual run by some dated control. -/
theorem runs_reading_right_iff {X : Type z} {Pk : Type p} {V : Type q} [DecidableEq O]
    [DecidableEq V] (emit : S → Q → O) (packet : S → X → Pk) (content : X → V)
    (F : Run P → Prop) (Admitted : X → Prop) (d : Nat) (r : Run P) (s : X)
    (ps : List (Nat × Q)) :
    (∀ g t, F g → Retrodiction.Fits (fun g : Run P => g.state) emit g (Retrodiction.acquire (fun g : Run P => g.state) emit r ps) →
        Admitted t → packet (g.state d) t = packet (r.state d) s → content t = content s) ↔
      (∀ g t, F g → Admitted t → packet (g.state d) t = packet (r.state d) s →
        content t ≠ content s → Retrodiction.Separated (fun g : Run P => g.state) emit g r ps) :=
  reading_right_iff (fun g : Run P => g.state) emit packet content F Admitted d r s ps

/-- **Reading a run's configuration at a date right.** Every run of the family fitting the dated
records agrees with the actual run on what `look` reads at `d` exactly when every run of the
family that disagrees there is told apart by some dated control. -/
theorem runs_look_right_iff {V : Type q} [DecidableEq O] [DecidableEq V] (emit : S → Q → O)
    (look : S → V) (F : Run P → Prop) (d : Nat) (r : Run P) (ps : List (Nat × Q)) :
    (∀ g, F g → Retrodiction.Fits (fun g : Run P => g.state) emit g (Retrodiction.acquire (fun g : Run P => g.state) emit r ps) →
        look (g.state d) = look (r.state d)) ↔
      (∀ g, F g → look (g.state d) ≠ look (r.state d) →
        Retrodiction.Separated (fun g : Run P => g.state) emit g r ps) :=
  look_right_iff (fun g : Run P => g.state) emit look F d r ps

/-- The process in which every change is admitted: free branching of `Becoming.Parting`, kept
under this name (`anyChange_eq_free`). -/
def anyChange (S : Type u) : Process S Unit := Parting.free S

/-- `anyChange` is `Parting.free`, by definition. -/
theorem anyChange_eq_free (S : Type u) : anyChange S = Parting.free S :=
  rfl

/-- Every course of configurations is a run of the process in which every change is admitted. -/
def anyRun (c : Nat → S) : Run (anyChange S) := ⟨c, fun _ => (), fun _ => trivial⟩

/-- **Controls at both ends settle every run between**, for every process: on every run with
at most one change over the `n` steps from `a` that returns to its configuration at `a`, or with
no date strictly between, the configuration at every date between is the one at `a`. -/
theorem run_settles [DecidableEq S] {k n : Nat} (few : k < 2 ∨ n < 2) (r : Run P) (a : Nat)
    (within : Retrodiction.changes r.state a n ≤ k) (back : r.state (a + n) = r.state a) :
    ∀ j, j ≤ n → r.state (a + j) = r.state a :=
  fun j le => match decEq (r.state (a + j)) (r.state a) with
    | isTrue e => e
    | isFalse away => by
      have ⟨m, e⟩ := le_dest le
      subst e
      have twice := bracket r.state a j m back away
      exact match few with
        | .inl lt => absurd (Nat.le_trans twice within) (Nat.not_le_of_lt lt)
        | .inr lt => absurd (Nat.le_trans twice (Retrodiction.changes_le r.state a (j + m))) (Nat.not_le_of_lt lt)

/-- **Controls at both ends settle the dates between on every run exactly when at most one change
is admitted, or no date lies strictly between**, where every change is admitted and two
configurations differ. -/
theorem runs_settle_iff [DecidableEq S] {s s' : S} (two : s ≠ s') (a n k : Nat) :
    (∀ g : Run (anyChange S), Retrodiction.changes g.state a n ≤ k → g.state (a + n) = g.state a →
        ∀ j, j ≤ n → g.state (a + j) = g.state a) ↔
      (k < 2 ∨ n < 2) :=
  ⟨fun settles => (bracket_settles_iff two a n k).mp
     fun c within back => settles (anyRun c) within back,
   fun few g within back => run_settles few g a within back⟩

end Retrodiction

/-! ## Copying -/

section Units

open Assurance

variable {S : Type u}

/-- `k` unit moves of a determined law go along its orbit. -/
theorem foldl_units (next : S → S) : ∀ (k : Nat) (s : S),
    (List.replicate k ()).foldl (fun x (_ : Unit) => next x) s = Law.orbit next s k
  | 0, _ => rfl
  | k + 1, s => (foldl_units next k (next s)).trans (Law.orbit_shift next s k).symm

/-- **A plan of `k` moves of a determined law completes exactly when the goal holds on its orbit
at `k`.** -/
theorem completes_units_iff (next : S → S) {goal : S → Prop} (k : Nat) (s : S) :
    Completes (Law.process next) free goal s (List.replicate k ()) ↔ goal (Law.orbit next s k) :=
  (completes_ofMap_iff (fun x (_ : Unit) => next x) s (List.replicate k ())).trans
    (Eq.mpr (congrArg (fun y => goal y ↔ goal (Law.orbit next s k)) (foldl_units next k s)) Iff.rfl)

end Units

section Copying

open Assurance Copying

variable {α : Type u} [DecidableEq α] (draw : Option α → α → Nat)

/-- `n` moves of a copy go along the orbit of its determined law. -/
theorem steps_orbit : ∀ (n : Nat) (s : Scan α), Copying.steps draw n s = Law.orbit (tick draw) s n
  | 0, _ => rfl
  | n + 1, s => (steps_orbit n (tick draw s)).trans (Law.orbit_shift (tick draw) s n).symm

/-- `n` moves of a copy reading through `read` go along the orbit of its law. -/
theorem readSteps_orbit (read : Nat → Option α) :
    ∀ (n : Nat) (s : Scan α), readSteps draw read n s = Law.orbit (readTick draw read) s n
  | 0, _ => rfl
  | n + 1, s => (readSteps_orbit read n (readTick draw read s)).trans
      (Law.orbit_shift (readTick draw read) s n).symm

/-- **Exact copying as a plan of the copy's process.** The copy of a word, as a plan of its
determined process, completes with nothing pending exactly when the pool supplies the word and
the support covers what its attachments draw. -/
theorem copy_completes_iff (prev : Option α) (built word pool : List α) (supply used : Nat) :
    Completes (Law.process (tick draw)) free (fun t => t.pending = [])
        ⟨prev, word, built, pool, supply, used⟩ (List.replicate word.length ()) ↔
      Supplies word pool ∧ use draw prev word ≤ supply :=
  (completes_units_iff (tick draw) _ _).trans
    (Eq.mpr (congrArg (fun y => y.pending = [] ↔ _) (steps_orbit draw _ _).symm)
      (completes_iff draw prev built word pool supply used))

/-- **The product of the copy's process is the word exactly when the copy is supplied and
covered.** -/
theorem copy_built_iff (prev : Option α) (built word pool : List α) (supply used : Nat) :
    Completes (Law.process (tick draw)) free (fun t => t.built = built ++ word)
        ⟨prev, word, built, pool, supply, used⟩ (List.replicate word.length ()) ↔
      Supplies word pool ∧ use draw prev word ≤ supply :=
  (completes_units_iff (tick draw) _ _).trans
    (Eq.mpr (congrArg (fun y => y.built = built ++ word ↔ _) (steps_orbit draw _ _).symm)
      (built_iff draw prev built word pool supply used))

/-- **The copy's process leaves nothing in the pool** exactly when the pool holds each token
exactly as often as the word uses it and the support covers the draws. -/
theorem copy_empties_iff (prev : Option α) (built word pool : List α) (supply used : Nat) :
    Completes (Law.process (tick draw)) free (fun t => t.pending = [] ∧ t.pool = [])
        ⟨prev, word, built, pool, supply, used⟩ (List.replicate word.length ()) ↔
      (∀ a, countOf a word = countOf a pool) ∧ use draw prev word ≤ supply :=
  (completes_units_iff (tick draw) _ _).trans
    (Eq.mpr (congrArg (fun y => (y.pending = [] ∧ y.pool = []) ↔ _) (steps_orbit draw _ _).symm)
      (empties_iff draw prev built word pool supply used))

/-- One move of the copy keeps its product as a prefix. -/
theorem tick_extends : ∀ s : Scan α, ∃ tail, (tick draw s).built = s.built ++ tail
  | ⟨_, [], _, _, _, _⟩ => ⟨[], (ListTests.append_nil _).symm⟩
  | ⟨prev, x :: xs, built, pool, supply, used⟩ =>
    Eq.mpr (congrArg (fun y : Scan α => ∃ tail, y.built = built ++ tail)
      (tick_cons draw prev x xs built pool supply used))
      (ite_cases (fun y : Scan α => ∃ tail, y.built = built ++ tail)
        (fun _ => ⟨[x], rfl⟩) (fun _ => ⟨[], (ListTests.append_nil _).symm⟩))

/-- **The product of the copy only grows along every course of its process.** -/
theorem copy_grows : ∀ (s : Scan α) (plan : List Unit) (t : Scan α),
    Trace (Law.process (tick draw)) s plan t → ∃ tail, t.built = s.built ++ tail :=
  extends_along_iff.mpr fun s _ _ moved => moved ▸ tick_extends draw s

/-- **Reading through contacts as a plan of the reading copy's process.** Where as many tokens
are pending as the word has, the reading copy's plan of `word.length` moves completes with the
word added to the product exactly when every site reads the word's token, the pool supplies the
word and the support covers what it draws. -/
theorem reading_completes_iff (read : Nat → Option α) (word pending : List α) (prev : Option α)
    (built pool : List α) (supply used : Nat) (lengths : pending.length = word.length) :
    Completes (Law.process (readTick draw read)) free (fun t => t.built = built ++ word)
        ⟨prev, pending, built, pool, supply, used⟩ (List.replicate word.length ()) ↔
      Reads read built.length word ∧ Supplies word pool ∧ use draw prev word ≤ supply :=
  (completes_units_iff (readTick draw read) _ _).trans
    (Eq.mpr (congrArg (fun y => y.built = built ++ word ↔ _) (readSteps_orbit draw read _ _).symm)
      (reading_iff draw read word pending prev built pool supply used lengths))

/-- Inspection read as a process whose moves are the sites inspected. -/
def inspection (ci ce : Nat) (ref : Nat → Option α) : Process (Scan α) Nat :=
  ofMap fun s i => inspect ci ce ref i s

/-- **Inspection against a reference, as a move.** Every inspection of site `i` keeps the defects
against a template from rising, for every product, pool and support, exactly when the reference
agrees with the template at `i`. -/
theorem inspection_le_iff (ci ce : Nat) (t : List α) (ref : Nat → Option α) (i : Nat) :
    (∀ s u, (inspection ci ce ref).step s i u → defects t u.built ≤ defects t s.built) ↔
      FaithfulAt ref t i :=
  ⟨fun never => (inspect_le_iff ci ce t ref i).mp fun s => never s _ rfl,
   fun faithful s _ moved => moved ▸ inspect_le faithful ci ce s⟩

/-- **A course of inspections is the scan of its sites.** -/
theorem inspection_trace_scan {ref : Nat → Option α} (ci ce : Nat) :
    ∀ {s u : Scan α} {sites : List Nat}, Trace (inspection ci ce ref) s sites u →
      u = scanSites ci ce ref sites s
  | _, _, [], .nil _ => rfl
  | _, _, _ :: _, .cons moved tail =>
    (inspection_trace_scan ci ce tail).trans (congrArg (scanSites ci ce ref _) moved)

/-- **A course of inspections at faithful sites never raises the defects**: `Copying.scan_le` on
the course, which is the scan of its sites. -/
theorem inspection_course_le {t : List α} {ref : Nat → Option α} (ci ce : Nat) :
    ∀ {s u : Scan α} {sites : List Nat}, (∀ i, i ∈ sites → FaithfulAt ref t i) →
      Trace (inspection ci ce ref) s sites u → defects t u.built ≤ defects t s.built :=
  fun {s} {_} {sites} faithful path =>
    Eq.mpr (congrArg (fun x => defects t x.built ≤ defects t s.built) (inspection_trace_scan ci ce path))
      (scan_le ci ce sites s faithful)

/-- The release law of copies from one shared pool: the copy of a word from the pool and support
held, released where it completes with `r` free, drawing `r`; no move where it is not. -/
def release (r : Nat) (c : List α × Nat × Nat) (w : List α) : Option (List α × Nat × Nat) :=
  let t := Copying.steps draw w.length ⟨none, w, [], c.1, c.2.1, c.2.2⟩
  cond (released r t) (some (t.pool, t.free - r, t.used + r)) none

/-- **The batch is a course of the release law.** Every copy of a batch is released exactly when
its words are a course of the release law from the pool and support held. -/
theorem every_released_iff_course (r : Nat) : ∀ (words : List (List α)) (pool : List α)
    (supply used : Nat),
    Every (batch draw r words pool supply used).1 ↔
      ∃ c, Trace (ofPartial (release draw r)) (pool, supply, used) words c
  | [], pool, supply, used => ⟨fun _ => ⟨_, .nil (pool, supply, used)⟩, fun _ => trivial⟩
  | w :: ws, pool, supply, used => by
    show (released r (Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩) = true ∧
        Every (batch draw r ws (Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩).pool
          (cond (released r (Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩))
            ((Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩).free - r)
            (Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩).free)
          (cond (released r (Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩))
            ((Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩).used + r)
            (Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩).used)).1) ↔ _
    cases ok : released r (Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩) with
    | false =>
      refine ⟨fun h => (nomatch h.1), fun ⟨_, path⟩ => ?_⟩
      cases path with
      | cons moved _ =>
        have none_eq : release draw r (pool, supply, used) w = none := by
          show cond (released r (Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩)) _ none = none
          rw [ok]
          rfl
        exact absurd (none_eq.symm.trans moved) (fun h => nomatch h)
    | true =>
      have some_eq : release draw r (pool, supply, used) w =
          some ((Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩).pool,
            (Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩).free - r,
            (Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩).used + r) := by
        show cond (released r (Copying.steps draw w.length ⟨none, w, [], pool, supply, used⟩)) _ none = _
        rw [ok]
        rfl
      constructor
      · intro held
        match (every_released_iff_course r ws _ _ _).mp held.2 with
        | ⟨c, tail⟩ => exact ⟨c, .cons some_eq tail⟩
      · intro found
        match found with
        | ⟨c, .cons moved tail⟩ =>
          have same := Option.some.inj (some_eq.symm.trans moved)
          subst same
          exact ⟨rfl, (every_released_iff_course r ws _ _ _).mpr ⟨c, tail⟩⟩

/-- **Copies from one shared pool, on courses.** The words are a course of the release law from
the pool and support held exactly when the pool supplies all the words together and the support
covers all their draws and releases. -/
theorem release_course_iff (r : Nat) (words : List (List α)) (pool : List α) (supply used : Nat) :
    (∃ c, Trace (ofPartial (release draw r)) (pool, supply, used) words c) ↔
      Supplies (joinAll words) pool ∧ totalOf (fun w => use draw none w + r) words ≤ supply :=
  (every_released_iff_course draw r words pool supply used).symm.trans
    (batch_all_iff draw r words pool supply used)

/-- **A lineage on courses.** One word copied `n` times in turn is a course of the release law
exactly when the pool holds each token at least `n` times as often as the word uses it and the
support covers `n` times the word's draws and release. -/
theorem lineage_course_iff (r : Nat) (word pool : List α) (supply used n : Nat) :
    (∃ c, Trace (ofPartial (release draw r)) (pool, supply, used) (List.replicate n word) c) ↔
      (∀ a, n * countOf a word ≤ countOf a pool) ∧ n * (use draw none word + r) ≤ supply :=
  (every_released_iff_course draw r _ pool supply used).symm.trans
    (lineage_all_iff draw r word pool supply used n)

end Copying

/-! ## Segmentation -/

section Segmentation

open Segmentation

variable {S : Type u} {A : Type v} {P : Process S A} {W : Type w}

/-- **Words compose courses.** Where every word is a course of the process from `s` back to `s`,
every sequence of words, written out, is a course of the process from `s` back to `s`. -/
theorem encode_course {word : W → List A} {s : S} (loops : ∀ w, Trace P s (word w) s) :
    ∀ ws, Trace P s (encode word ws) s
  | [] => .nil s
  | w :: ws => trace_append_iff.mpr ⟨s, loops w, encode_course loops ws⟩

/-- **Grouping the moves of every course of words.** Where every word is a course from `s` back
to `s`, grouping by `r` recovers the words of every course of words exactly when each word is
linked inside and no word's last move is linked to any word's first. -/
theorem course_words_iff (r : A → A → Bool) {word : W → List A} {first : W → A}
    {rest : W → List A} (spelled : Spelled word first rest) {s : S}
    (loops : ∀ w, Trace P s (word w) s) :
    (∀ ws as, Trace P s as s → as = encode word ws → chunks r as = ws.map word) ↔
      (∀ w, LinkedFrom r (first w) (rest w)) ∧
        ∀ w v, r (lastOf (first w) (rest w)) (first v) = false :=
  ⟨fun every => (encode_iff r spelled).mp fun ws => every ws _ (encode_course loops ws) rfl,
   fun conditions ws _ _ same =>
    Eq.mpr (congrArg (fun x => chunks r x = ws.map word) same) ((encode_iff r spelled).mpr conditions ws)⟩

/-- **Grouping a course's moves is exact.** Grouping the moves of a course by `r` returns the
partition `L` exactly when `L` is grouped and joins to those moves; that partition is the only
one. -/
theorem course_chunks_iff (r : A → A → Bool) {s t : S} {as : List A} (_ : Trace P s as t)
    (L : List (List A)) : chunks r as = L ↔ Grouped r L ∧ join L = as :=
  ⟨fun same => ⟨same ▸ grouped_chunks r as, same ▸ join_chunks r as⟩,
   fun ⟨grouped, joined⟩ => chunks_unique r grouped joined⟩

/-- **No record of a run groups every course of words** where two words continue one move
differently inside: for the record of the first `n` moves of any run, grouping by its majority
bonds misses some course of words. -/
theorem no_run_record_groups [DecidableEq A] {word : W → List A} {first : W → A}
    {rest : W → List A} (spelled : Spelled word first rest) {x y z : A} (different : y ≠ z)
    (hasY : ∀ log : List (Option A), (∀ w, LinkedFrom (bond log) (first w) (rest w)) →
      bond log x y = true)
    (hasZ : ∀ log : List (Option A), (∀ w, LinkedFrom (bond log) (first w) (rest w)) →
      bond log x z = true) {s : S} (loops : ∀ w, Trace P s (word w) s) {Q : Process S A}
    (run : Run Q) (n : Nat) :
    ¬ ∀ ws as, Trace P s as s → as = encode word ws →
      chunks (bond ((run.window 0 n).map some)) as = ws.map word :=
  fun every => no_record_groups spelled different hasY hasZ ((run.window 0 n).map some)
    fun ws => every ws _ (encode_course loops ws) rfl

/-- **Reading every course of words.** Where every word is a course from `s` back to `s` and
grouping recovers the words, every course of words is read as the meanings of its words exactly
when each word is read as its meaning. -/
theorem course_reads_iff {M : Type x} (r : A → A → Bool) (word : W → List A)
    (res : List A → Option M) (meaning : W → M) {s : S} (loops : ∀ w, Trace P s (word w) s)
    (segments : ∀ ws, chunks r (encode word ws) = ws.map word) :
    (∀ ws as, Trace P s as s → as = encode word ws →
        readAll res (chunks r as) = some (ws.map meaning)) ↔
      ∀ w, res (word w) = some (meaning w) :=
  ⟨fun every => (Segmentation.reads_every_iff r word res meaning segments).mp
     fun ws => every ws _ (encode_course loops ws) rfl,
   fun each ws _ _ same =>
    Eq.mpr (congrArg (fun x => readAll res (chunks r x) = some (ws.map meaning)) same)
      ((Segmentation.reads_every_iff r word res meaning segments).mpr each ws)⟩

end Segmentation

/-! ## Cross-situational resolution -/

section CrossSituational

open CrossSituational

variable {S : Type u} {A : Type v} {P : Process S A} {M : Type w}

/-- The moves of a run from `m`: `j + k` of them are `j` and then `k` more. -/
theorem window_append (run : Run P) : ∀ (j m k : Nat),
    run.window m (j + k) = run.window m j ++ run.window (m + j) k
  | 0, m, k => congrArg (run.window m) (Nat.zero_add k)
  | j + 1, m, k =>
    (congrArg (run.window m) (Nat.succ_add j k)).trans
      (congrArg (run.act m :: ·) ((window_append run j (m + 1) k).trans
        (congrArg (fun i => run.window (m + 1) j ++ run.window i k)
          ((Nat.add_assoc m 1 j).trans (congrArg (m + ·) (Nat.add_comm 1 j))))))

/-- **A run's records only narrow.** Read as records, the moves of the first `n + k` steps of a
run leave as candidates exactly the candidates of the first `n` steps that stand on the next
`k`. -/
theorem run_candidates_append (bears : A → Bool) (offers : A → M → Bool) (run : Run P)
    (rep : List M) (n k : Nat) :
    candidates bears offers rep (run.window 0 (n + k)) =
      List.filter (stands bears offers (run.window n k)) (candidates bears offers rep (run.window 0 n)) :=
  (congrArg (candidates bears offers rep) ((window_append run n 0 k).trans
    (congrArg (fun i => run.window 0 n ++ run.window i k) (Nat.zero_add n)))).trans
    (candidates_append rep (run.window 0 n) (run.window n k))

/-- **A meaning ruled out at a step of a run stays ruled out at every later step**:
`CrossSituational.narrows` on the run's records. -/
theorem run_narrows {bears : A → Bool} {offers : A → M → Bool} {run : Run P} {rep : List M}
    {n k : Nat} {m : M} (later : m ∈ candidates bears offers rep (run.window 0 (n + k))) :
    m ∈ candidates bears offers rep (run.window 0 n) :=
  narrows (more := run.window n k) (Eq.mp (congrArg (fun l => m ∈ candidates bears offers rep l)
    ((window_append run n 0 k).trans
      (congrArg (fun i => run.window 0 n ++ run.window i k) (Nat.zero_add n)))) later)

/-- **A candidate stays one along a run exactly while every later bearing move offers it.** -/
theorem run_stays_iff {bears : A → Bool} {offers : A → M → Bool} {run : Run P} {rep : List M}
    {n k : Nat} {m : M} :
    m ∈ candidates bears offers rep (run.window 0 (n + k)) ↔
      m ∈ candidates bears offers rep (run.window 0 n) ∧
        ∀ a, a ∈ run.window n k → bears a = true → offers a m = true :=
  Eq.mpr (congrArg (fun l => m ∈ candidates bears offers rep l ↔ _) ((window_append run n 0 k).trans
      (congrArg (fun i => run.window 0 n ++ run.window i k) (Nat.zero_add n))))
    stays_iff

/-- **Resolution along a run is separation.** For a repertoire without repeats, the form
resolves to `e` after the first `n` moves of a run exactly when `e` is in the repertoire, every
bearing move offers it, and every other meaning is missing from some bearing move. -/
theorem run_resolves_iff [DecidableEq M] (bears : A → Bool) (offers : A → M → Bool)
    {rep : List M} (distinct : Distinct rep) (run : Run P) (n : Nat) {e : M} :
    unique (candidates bears offers rep (run.window 0 n)) = some e ↔
      e ∈ rep ∧ (∀ a, a ∈ run.window 0 n → bears a = true → offers a e = true) ∧
        ∀ m, m ∈ rep → m ≠ e → ∃ a, a ∈ run.window 0 n ∧ bears a = true ∧ offers a m = false :=
  resolves_iff distinct

/-- **Moves read through a family of explanations, along a run.** Where a move offers a meaning
exactly when some family world with that meaning as its target explains it, and each bearing
move of the first `n` is explained by some family world with the target `t`, the form's
candidates after `n` moves are exactly `[t]` when every other meaning of the repertoire is ruled
out by some bearing move that no family world with that meaning explains. -/
theorem run_resolves_explained_iff [DecidableEq M] {Wd : Type x} (bears : A → Bool)
    (offers : A → M → Bool) (family : Wd → Prop) (target : Wd → M) (explains : A → Wd → Prop)
    (offered : ∀ a m, offers a m = true ↔ ∃ w, family w ∧ target w = m ∧ explains a w)
    {rep : List M} (distinct : Distinct rep) (run : Run P) (n : Nat) {t : M} (available : t ∈ rep)
    (actual : ∀ a, a ∈ run.window 0 n → bears a = true →
      ∃ w, family w ∧ target w = t ∧ explains a w) :
    candidates bears offers rep (run.window 0 n) = [t] ↔
      ∀ m, m ∈ rep → m ≠ t → ∃ a, a ∈ run.window 0 n ∧ bears a = true ∧
        ∀ w, family w → target w = m → ¬ explains a w :=
  resolves_explained_iff family target explains offered distinct available actual

/-- **Reading every course of words by resolution.** Where every word is a course from `s` back
to `s` and grouping recovers the words, reading each group by resolution gives the meanings of
the words of every course of words exactly when each word's records separate its meaning. -/
theorem course_resolves_every_iff [DecidableEq M] {W : Type x} {R : Type y} (r : A → A → Bool)
    (word : W → List A) (meaning : W → M) (bears : List A → R → Bool) (offers : R → M → Bool)
    {rep : List M} (distinct : Distinct rep) (rs : List R) {s : S}
    (loops : ∀ w, Trace P s (word w) s)
    (segments : ∀ ws, Segmentation.chunks r (Segmentation.encode word ws) = ws.map word) :
    (∀ ws as, Trace P s as s → as = Segmentation.encode word ws →
        Segmentation.readAll (fun f => unique (candidates (bears f) offers rep rs))
          (Segmentation.chunks r as) = some (ws.map meaning)) ↔
      ∀ w, meaning w ∈ rep ∧ (∀ x, x ∈ rs → bears (word w) x = true → offers x (meaning w) = true) ∧
        ∀ m, m ∈ rep → m ≠ meaning w → ∃ x, x ∈ rs ∧ bears (word w) x = true ∧ offers x m = false :=
  (course_reads_iff r word _ meaning loops segments).trans
    ((Segmentation.reads_every_iff r word _ meaning segments).symm.trans
      (CrossSituational.reads_every_iff r word meaning bears offers distinct rs segments))

end CrossSituational

/-! ## Readout -/

section Readout

open Readout

variable {S : Type u} {A : Type v} {K : Type w} {P : Process S A}

/-- **What a reduction keeps of a run is a run of the law read through it.** -/
def reducedRun (π : S → K) (r : Run P) : Run (Image P π) :=
  ⟨fun n => π (r.state n), r.act, fun n => ⟨r.state n, r.state (n + 1), rfl, r.step n, rfl⟩⟩

/-- **A reduction undoes no merge of two runs.** Where the reduced runs agree at a date at which
the runs differ, no map of the reduced runs restores both runs at every date. -/
theorem runs_no_restore (π : S → K) {r r' : Run P} {n : Nat}
    (merged : (reducedRun π r).state n = (reducedRun π r').state n)
    (different : r.state n ≠ r'.state n) :
    ¬ ∃ restore : K → S, ∀ m, restore ((reducedRun π r).state m) = r.state m ∧
      restore ((reducedRun π r').state m) = r'.state m :=
  fun ⟨restore, back⟩ => no_restore merged different ⟨restore, (back n).1, (back n).2⟩

/-- The configurations of a run's first `n` steps, latest first. -/
def visited (r : Run P) : Nat → List S
  | 0 => []
  | n + 1 => r.state n :: visited r n

theorem mem_visited (r : Run P) {s : S} : ∀ {n : Nat}, s ∈ visited r n ↔ ∃ k, k < n ∧ r.state k = s
  | 0 => ⟨fun mem => (nomatch mem), fun ⟨_, lt, _⟩ => absurd lt (Nat.not_lt_zero _)⟩
  | n + 1 => ⟨fun mem => match mem_cons_cases mem with
      | .inl here => ⟨n, Nat.lt_succ_self n, here.symm⟩
      | .inr earlier => match (mem_visited r).mp earlier with
        | ⟨k, lt, at_k⟩ => ⟨k, Nat.lt_succ_of_lt lt, at_k⟩,
     fun ⟨k, lt, at_k⟩ => match Nat.lt_or_ge k n with
      | .inl before => .tail _ ((mem_visited r).mpr ⟨k, before, at_k⟩)
      | .inr after =>
        have same : k = n := Nat.le_antisymm (Nat.le_of_lt_succ lt) after
        at_k ▸ same ▸ .head _⟩

/-- **Judging a run through its reduced run.** A judge reading only the reduced run gives an
observable at each of the first `n` dates exactly when the observable goes alike at every two of
those dates the reduction merges. No choice is used. -/
theorem run_judges_iff [DecidableEq K] {V : Type x} (π : S → K) (f : S → V) (d : V) (r : Run P)
    (n : Nat) :
    (∃ judge : K → V, ∀ k, k < n → judge ((reducedRun π r).state k) = f (r.state k)) ↔
      ∀ j k, j < n → k < n → π (r.state j) = π (r.state k) → f (r.state j) = f (r.state k) := by
  constructor
  · intro found j k lj lk same
    match found with
    | ⟨judge, judges⟩ => exact (judges j lj).symm.trans ((congrArg judge same).trans (judges k lk))
  · intro lumped
    have onFamily : LumpedOn (visited r n) π f := fun _ _ mem mem' same =>
      match (mem_visited r).mp mem, (mem_visited r).mp mem' with
      | ⟨j, lj, at_j⟩, ⟨k, lk, at_k⟩ => by
        subst at_j
        subst at_k
        exact lumped j k lj lk same
    match (judges_iff_lumpedOn (visited r n) π f d).mpr onFamily with
    | ⟨judge, judges⟩ => exact ⟨judge, fun k lk => judges (r.state k) ((mem_visited r).mpr ⟨k, lk, rfl⟩)⟩

/-- **No judge reads a run through a reduction that merges two of its dates the observable tells
apart.** -/
theorem no_run_judge_of_merged {V : Type x} (π : S → K) (f : S → V) (r : Run P) {n j k : Nat}
    (lj : j < n) (lk : k < n) (merged : π (r.state j) = π (r.state k))
    (apart : f (r.state j) ≠ f (r.state k)) :
    ¬ ∃ judge : K → V, ∀ i, i < n → judge ((reducedRun π r).state i) = f (r.state i) :=
  fun ⟨judge, judges⟩ => no_judge_of_merged ((mem_visited r).mpr ⟨j, lj, rfl⟩)
    ((mem_visited r).mpr ⟨k, lk, rfl⟩) merged apart
    ⟨judge, fun _ mem => match (mem_visited r).mp mem with
      | ⟨i, li, at_i⟩ => Eq.mp (congrArg (fun x => judge (π x) = f x) at_i) (judges i li)⟩

end Readout

/-! ## Fallible witnesses at the dates of a run -/

section Witnesses

open Readout

/-- **The values a map takes along a run at listed dates as fallible witnesses.** For every
process and every two-valued map, where two fault sets leave a common faithful date, no run's
values through the map are explained both by `x` with the dates of the one at fault and by `y` with those
of the other. -/
theorem run_reports_apart {S : Type u} {A : Type v} {P : Process S A} (o : S → Bool)
    {roster a b : List Nat} {x y : Bool} (different : x ≠ y) (common : CommonWitness roster a b)
    (r : Run P) :
    Explains roster a x (fun d => o (r.state d)) → ¬ Explains roster b y (fun d => o (r.state d)) :=
  (no_common_report_iff different).mpr common _

/-- **The values of every course tell two answers apart exactly where the fault sets leave
a common faithful date**, for the courses of two-valued configurations in which every change is
admitted. -/
theorem dates_no_common_report_iff {roster a b : List Nat} {x y : Bool} (different : x ≠ y) :
    (∀ g : Run (anyChange Bool), Explains roster a x g.state → ¬ Explains roster b y g.state) ↔
      CommonWitness roster a b :=
  ⟨fun apart => (no_common_report_iff different).mp fun report => apart (anyRun report),
   fun common g => (no_common_report_iff different).mpr common g.state⟩

/-- **With admitted fault envelopes, on courses.** No course of two-valued configurations is
explained both by `x` under a fault set admitted in `fa` and by `y` under one admitted in `fb`
exactly where every two such fault sets leave a common faithful date. -/
theorem dates_no_common_report_envelopes_iff {roster : List Nat} {fa fb : List (List Nat)}
    {x y : Bool} (different : x ≠ y) :
    (∀ g : Run (anyChange Bool), (∃ a, a ∈ fa ∧ Explains roster a x g.state) →
        ¬ ∃ b, b ∈ fb ∧ Explains roster b y g.state) ↔
      ∀ a, a ∈ fa → ∀ b, b ∈ fb → CommonWitness roster a b :=
  ⟨fun apart => (no_common_report_envelopes_iff different).mp fun report => apart (anyRun report),
   fun cross g => (no_common_report_envelopes_iff different).mpr cross g.state⟩

end Witnesses

/-! ## Weighted: masses of claims and draws on a condition -/

section Mass

/-- **Every chance over listed configurations keeps one claim's mass within another's exactly
where the second is realized wherever the first is.** The claims of a frame are read at its
listed configurations by Boolean events. -/
theorem claims_every_weighting_iff {S : Type u} {A : Type v} {C : Type w} [DecidableEq S]
    (F : Frame S A C) {c c' : C} {e e' : S → Bool} (reads : ∀ s, e s = true ↔ F.realized s c)
    (reads' : ∀ s, e' s = true ↔ F.realized s c') (domain : List S) :
    (∀ weight : S → Nat, mass domain weight e ≤ mass domain weight e') ↔
      ∀ s, s ∈ domain → F.realized s c → F.realized s c' :=
  every_weighting_iff.trans
    ⟨fun included s mem held => (reads' s).mp (included s mem ((reads s).mpr held)),
     fun included s mem held => (reads' s).mpr (included s mem ((reads s).mp held))⟩

/-- **Fulfillment gives a floor of chance, on a frame.** Where every listed configuration
realizing the demand and the old support realizes the new support, under every weighting the
mass of demand met by old support is within the mass of the new support, and that within the
whole. -/
theorem claims_floor {S : Type u} {A : Type v} {C : Type w} (F : Frame S A C) {d o n : C}
    {ed eo en : S → Bool} (readsD : ∀ s, ed s = true ↔ F.realized s d)
    (readsO : ∀ s, eo s = true ↔ F.realized s o) (readsN : ∀ s, en s = true ↔ F.realized s n)
    (domain : List S) (fulfilled : ∀ s, s ∈ domain → F.realized s d → F.realized s o → F.realized s n)
    (weight : S → Nat) :
    mass domain weight (fun s => ed s && eo s) ≤ mass domain weight en ∧
      mass domain weight en ≤ mass domain weight (fun _ => true) :=
  ⟨mass_mono weight fun s mem both =>
     match bool_of_and_true both with
     | ⟨hd, ho⟩ => (readsN s).mpr (fulfilled s mem ((readsD s).mp hd) ((readsO s).mp ho)),
   mass_mono weight fun _ _ _ => rfl⟩

/-- Two formations, each needing the whole standing, two, of one condition. -/
def twoDrawers : Web Bool Unit :=
  ⟨fun _ _ => 2, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 2, fun _ _ _ => True⟩

/-- **Each formation supported does not put them together within the standing.** Each formation
of `twoDrawers` is supported at step `0`, while their needs together exceed the condition's
level. -/
theorem supported_not_together :
    (∀ f, twoDrawers.Supported 0 f) ∧
      ¬ mass [false, true] (fun f => twoDrawers.need 0 f ()) (fun _ => true) ≤ twoDrawers.level 0 () :=
  ⟨fun _ _ _ => Nat.le_refl 2, entries_within_not_together.2⟩

/-- One configuration and two moves back to it. -/
def loop : Process Unit Bool := everyStep Unit Bool

/-- Every word of moves is a course of the loop. -/
theorem loop_trace : ∀ word : List Bool, Trace loop () word ()
  | [] => .nil ()
  | _ :: word => .cons True.intro (loop_trace word)

theorem along_one {S : Type u} {A : Type v} (s : S) :
    ∀ h : List (A × S), counting.along (fun _ _ _ => 1) (fun _ => 1) s h = 1
  | [] => rfl
  | p :: h => (congrArg (Nat.mul 1) (along_one p.2 h)).trans (Nat.mul_one 1)

/-- **Around the loop the courses double at every step, on courses.** The courses of `n` moves
the sum over histories goes through are courses of the loop, and there are `2 ^ n` of them. -/
theorem loop_courses_double (n : Nat) :
    (∀ h, h ∈ courses [true, false] [()] n → Trace loop () (h.map Prod.fst) ()) ∧
      (courses [true, false] [()] n).length = 2 ^ n :=
  ⟨fun h _ => loop_trace (h.map Prod.fst),
   (Situations.sum_one _).symm.trans ((Weights.sum_congr _ fun h _ => (along_one () h).symm).trans
     ((Weights.sum_courses (W := counting) (fun _ _ _ => 1) [true, false] [()] (fun _ => 1) n ()).trans
       (Weighted.Loop.courses_double n)))⟩

end Mass

/-! ## Feedback: a formation's system -/

/-! ## Description: relations among parts along the courses of a law -/

section Separation

variable {X : Type u}

/-- What courses of `n` moves of a determined law's process reach from a whole. -/
def reachedFrom (next : X → X) (whole : X → Prop) (n : Nat) (p : X) : Prop :=
  ∃ q, whole q ∧ Trace (Law.process next) q (List.replicate n ()) p

theorem reachedFrom_iff {next : X → X} {whole : X → Prop} {n : Nat} {p : X} :
    reachedFrom next whole n p ↔ ∃ q, whole q ∧ Law.orbit next q n = p :=
  ⟨fun ⟨q, held, path⟩ => ⟨q, held, ((trace_orbit path).trans
     (congrArg (Law.orbit next q) (Branching.units_length n))).symm⟩,
   fun ⟨q, held, at_n⟩ => ⟨q, held, at_n ▸ orbit_trace next n q⟩⟩

theorem reachedFrom_zero {next : X → X} {whole : X → Prop} {p : X} :
    reachedFrom next whole 0 p ↔ whole p :=
  reachedFrom_iff.trans ⟨fun ⟨_, held, at_0⟩ => at_0 ▸ held, fun held => ⟨p, held, rfl⟩⟩

/-- One more move of the course is one more step of the law. -/
theorem reachedFrom_succ {next : X → X} {whole : X → Prop} {n : Nat} {p : X} :
    reachedFrom next whole (n + 1) p ↔ ∃ q, reachedFrom next whole n q ∧ next q = p :=
  reachedFrom_iff.trans
    ⟨fun ⟨q, held, at_n⟩ => ⟨Law.orbit next q n, reachedFrom_iff.mpr ⟨q, held, rfl⟩, at_n⟩,
     fun ⟨_, reached, moved⟩ => match reachedFrom_iff.mp reached with
      | ⟨q, held, at_n⟩ => ⟨q, held, (congrArg next at_n).trans moved⟩⟩

variable {A : Type u} {B : Type v}

theorem rectangular_congr {R R' : A × B → Prop} (same : ∀ p, R p ↔ R' p) (rect : Rectangular R) :
    Rectangular R' :=
  fun a a' b b' h h' => (same _).mp (rect a a' b b' ((same _).mpr h) ((same _).mpr h'))

/-- **Parts moved each by itself stay unrelated along every course.** -/
theorem courses_keep_unrelated {whole : A × B → Prop} (rect : Rectangular whole) (f : A → A)
    (g : B → B) : ∀ n, Rectangular (reachedFrom (fun p => (f p.1, g p.2)) whole n)
  | 0 => rectangular_congr (fun _ => reachedFrom_zero.symm) rect
  | n + 1 => rectangular_congr (fun _ => reachedFrom_succ.symm)
      (Rectangular.image_of_separate (courses_keep_unrelated rect f g n) f g)

/-- **A relation persists along every course of a law that moves each part by itself and merges
nothing.** -/
theorem relation_persists_courses {whole : A × B → Prop} {f : A → A} {g : B → B}
    (inj_f : ∀ a a', f a = f a' → a = a') (inj_g : ∀ b b', g b = g b' → b = b')
    (related : ¬ Rectangular whole) :
    ∀ n, ¬ Rectangular (reachedFrom (fun p => (f p.1, g p.2)) whole n)
  | 0 => fun rect => related (rectangular_congr (fun _ => reachedFrom_zero) rect)
  | n + 1 => fun rect => relation_persists (whole := reachedFrom (fun p => (f p.1, g p.2)) whole n)
      (fun a a' _ _ _ _ same => inj_f a a' same) (fun _ _ b b' _ _ same => inj_g b b' same)
      (relation_persists_courses inj_f inj_g related n)
      (rectangular_congr (fun _ => reachedFrom_succ) rect)

/-- **Relation forms along a course of copying.** One move of the law copying the first part
into the second leads from every configuration to the parts going alike, which is not
rectangular. -/
theorem copy_relates_course :
    (∀ p, reachedFrom (fun p : Bool × Bool => (p.1, p.1)) (fun _ => True) 1 p ↔ p.1 = p.2) ∧
      ¬ Rectangular (reachedFrom (fun p : Bool × Bool => (p.1, p.1)) (fun _ => True) 1) :=
  have reached : ∀ p, reachedFrom (fun p : Bool × Bool => (p.1, p.1)) (fun _ => True) 1 p ↔
      imageOf (fun p : Bool × Bool => (p.1, p.1)) (fun _ => True) p := fun _ =>
    reachedFrom_succ.trans ⟨fun ⟨q, _, moved⟩ => ⟨q, trivial, moved⟩,
      fun ⟨q, _, moved⟩ => ⟨q, reachedFrom_zero.mpr trivial, moved⟩⟩
  ⟨fun p => (reached p).trans (copy_relates.2.1 p),
   fun rect => copy_relates.2.2 (rectangular_congr reached rect)⟩

/-- **Forgetting a part unrelates it along every course**: after one move of a law sending the
first part to one value, every course leads to a rectangular whole. -/
theorem forgetting_unrelates_courses (whole : A × B → Prop) (a₀ : A) (g : B → B) (n : Nat) :
    Rectangular (reachedFrom (fun p => (a₀, g p.2)) whole (n + 1)) :=
  rectangular_congr (fun _ => reachedFrom_succ.symm) (forgetting_unrelates _ a₀ g)

/-- **A coupling relates and, acting again, unrelates, along a course.** From the second part
settled, one move of `couple` leads to a whole that is not rectangular, and two moves lead back to
the second part settled. -/
theorem coupling_course :
    ¬ Rectangular (reachedFrom couple (fun p : Bool × Bool => p.2 = false) 1) ∧
      ∀ p, reachedFrom couple (fun p : Bool × Bool => p.2 = false) 2 p ↔ p.2 = false := by
  have zero : ∀ q, reachedFrom couple (fun p : Bool × Bool => p.2 = false) 0 q ↔ q.2 = false :=
    fun _ => reachedFrom_zero
  have one : ∀ p, reachedFrom couple (fun p : Bool × Bool => p.2 = false) 1 p ↔
      imageOf couple (fun p : Bool × Bool => p.2 = false) p := fun p =>
    reachedFrom_succ.trans (Iff.intro
      (fun ⟨q, held, moved⟩ => ⟨q, (zero q).mp held, moved⟩)
      (fun ⟨q, held, moved⟩ => ⟨q, (zero q).mpr held, moved⟩))
  have two : ∀ p, reachedFrom couple (fun p : Bool × Bool => p.2 = false) 2 p ↔
      imageOf couple (imageOf couple (fun p : Bool × Bool => p.2 = false)) p := fun p =>
    reachedFrom_succ.trans (Iff.intro
      (fun ⟨q, held, moved⟩ => ⟨q, (one q).mp held, moved⟩)
      (fun ⟨q, held, moved⟩ => ⟨q, (one q).mpr held, moved⟩))
  exact ⟨fun rect => coupling_relates_and_unrelates.2.1 (rectangular_congr one rect),
    fun p => (two p).trans (coupling_relates_and_unrelates.2.2 p)⟩

end Separation

/-! ## Undominated configurations under generative extension -/

section Undominated

variable {S A C : Type} (F : Frame S A C) (living : C → Prop)

/-- **A listed menu of configurations has a generative frontier.** On a nonempty listed menu of
a frame's configurations, where whether one extends another is weakly decided, some
configuration is extended by no member: generative extension is irreflexive and transitive. -/
theorem extension_frontier_exists (x : S) (rest : List S)
    (weakly : ∀ a b, a ∈ x :: rest → b ∈ x :: rest → WeaklyDecided (Extension F living b a)) :
    ∃ a, Undominated (x :: rest) (fun b a => Extension F living a b) a :=
  exists_undominated x rest weakly (fun _ _ => Extension.irrefl)
    (fun _ _ _ _ _ _ first second => Extension.trans second first)

end Undominated

end Courses

/-! ## One notion stated twice

`Becoming.CrossSituational` imports only `Becoming.Segmentation` and states lists without
repetition for every universe; `Becoming.Population` states them for `Type`. This module sees
both, and they agree. -/


end Becoming

section RetrodictionRuns

/-!
## Retrodiction runs: reading an earlier configuration of a run from later dated records

`Becoming.Retrodiction` states, for every type of histories, when dated records read an earlier
relation right: the actual history is always a candidate, a history fits the records another
gave exactly when it gives the same records, an agreed reading is the actual one where the actual
history is in the family, and a change seen only at both ends is not located. `Becoming.Courses`
reads the histories as the runs of a process, the relation at a date as the configuration then,
and every course of configurations as a run of the process in which every change is admitted
(`Courses.anyChange`, `Courses.anyRun`). This section states those laws of runs.

* **A run fits the records another run gave exactly when it gives the same records**
  (`runs_fits_iff_same`).
* **An agreed reading of a run is the actual one.** Where the actual run is in the family and its
  source admitted, a content on which every explanation of the packet by a fitting run of the
  family agrees is the actual content (`runs_agreed_reading_actual`).
* **Controls at both ends do not locate a change.** Where two configurations differ, there are two
  runs of the process in which every change is admitted, each changing once over the span, that
  agree at both ends and differ at a date strictly between (`runs_change_unlocated`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

universe u v x y z p q

namespace RetrodictionRuns

variable {S : Type u} {A : Type v} {P : Process S A} {Q : Type x} {O : Type y}

/-- **A run fits the dated records another run gave exactly when it gives the same records.** -/
theorem runs_fits_iff_same (emit : S → Q → O) (g r : Run P) (ps : List (Nat × Q)) :
    Retrodiction.Fits (fun g : Run P => g.state) emit g
        (Retrodiction.acquire (fun g : Run P => g.state) emit r ps) ↔
      Retrodiction.acquire (fun g : Run P => g.state) emit g ps =
        Retrodiction.acquire (fun g : Run P => g.state) emit r ps :=
  Retrodiction.fits_iff_same (fun g : Run P => g.state) emit g r ps

/-- **An agreed reading of a run is the actual one.** The packet at date `d` was produced by the
actual run's configuration and the hidden source `s`. Where the actual run is in the family and
`s` admitted, a content on which every explanation of the packet by a run of the family fitting
the dated records and an admitted source agrees is the content of `s`. -/
theorem runs_agreed_reading_actual {X : Type z} {Pk : Type p} {V : Type q} (emit : S → Q → O)
    (packet : S → X → Pk) (content : X → V) (F : Run P → Prop) (Admitted : X → Prop) (d : Nat)
    (r : Run P) (s : X) (ps : List (Nat × Q)) (v : V) (inF : F r) (admitted : Admitted s)
    (agree : ∀ g t, F g → Retrodiction.Fits (fun g : Run P => g.state) emit g
        (Retrodiction.acquire (fun g : Run P => g.state) emit r ps) → Admitted t →
      packet (g.state d) t = packet (r.state d) s → content t = v) :
    content s = v :=
  Retrodiction.agreed_reading_actual (fun g : Run P => g.state) emit packet content F Admitted d r
    s ps v inF admitted agree

/-- **Controls at both ends do not locate a change.** Where `s` and `s'` differ, two runs of the
process in which every change is admitted each change once over the span from `a`, are at `s` at
`a` and at `s'` at the end, and are at `s'` and at `s` at the date `a + j + 1` strictly between. -/
theorem runs_change_unlocated [DecidableEq S] {s s' : S} (two : s ≠ s') (a j m : Nat) :
    ∃ g g' : Run (Courses.anyChange S),
      Retrodiction.changes g.state a (j + 1 + (m + 1)) = 1 ∧
      Retrodiction.changes g'.state a (j + 1 + (m + 1)) = 1 ∧
      g.state a = s ∧ g'.state a = s ∧
      g.state (a + (j + 1 + (m + 1))) = s' ∧ g'.state (a + (j + 1 + (m + 1))) = s' ∧
      g.state (a + j + 1) = s' ∧ g'.state (a + j + 1) = s :=
  match Retrodiction.change_unlocated two a j m with
  | ⟨c, c', e, e', b, b', at_g, at_g'⟩ =>
    have span : j + 1 + 1 + m = j + 1 + (m + 1) := Nat.add_right_comm (j + 1) 1 m
    ⟨Courses.anyRun (Retrodiction.stepAt s s' (a + j + 1)),
     Courses.anyRun (Retrodiction.stepAt s s' (a + (j + 1) + 1)),
     c,
     Eq.subst (motive := fun k =>
       Retrodiction.changes (Retrodiction.stepAt s s' (a + (j + 1) + 1)) a k = 1) span c',
     e, e', b,
     Eq.subst (motive := fun k => Retrodiction.stepAt s s' (a + (j + 1) + 1) (a + k) = s') span b',
     at_g, at_g'⟩

end RetrodictionRuns

end Becoming

end RetrodictionRuns

section CandidateRuns

/-!
## Candidate runs: cross-situational resolution step by step along a run

`Becoming.CrossSituational` states what a form names when read across the records of the
occasions it was met: a record bearing on the form keeps exactly the candidates it offers, one not
bearing on it changes nothing, and under coverage a unique candidate is the target, while one
record omitting the target can leave a wrong meaning as the only candidate. `Becoming.Courses`
reads the moves of a run as its records (`Courses.run_candidates_append`,
`Courses.run_resolves_iff`). This section states those laws step by step along a run.

* **Each move of a run narrows the candidates by itself.** The record after `n + 1` moves is the
  record after `n` and the move at `n` (`window_succ`); a move bearing on the form keeps exactly the
  candidates it offers (`run_step_bearing`), and a move not bearing on it leaves them as they were
  (`run_step_other`).
* **Coverage along a run.** Where the target is in the repertoire and every bearing move of the
  first `n` offers it, a unique candidate after `n` moves is the target
  (`run_resolved_is_target`). Coverage cannot be dropped: on every run of a process with one move,
  the first move, read as the record that offers only `1`, omits the target `0` and leaves `1` the
  only candidate (`run_omitted`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative CrossSituational

universe u v w

namespace CandidateRuns

variable {S : Type u} {A : Type v} {P : Process S A} {M : Type w}

/-- **The record of a run after `n + 1` moves is its record after `n` and the move at `n`.** -/
theorem window_succ (run : Run P) (n : Nat) :
    run.window 0 (n + 1) = run.window 0 n ++ [run.act n] :=
  (Courses.window_append run n 0 1).trans
    (congrArg (fun i => run.window 0 n ++ run.window i 1) (Nat.zero_add n))

/-- **A move of a run bearing on the form keeps exactly the candidates it offers.** -/
theorem run_step_bearing (bears : A → Bool) (offers : A → M → Bool) (run : Run P) (rep : List M)
    (n : Nat) (bearing : bears (run.act n) = true) :
    candidates bears offers rep (run.window 0 (n + 1)) =
      List.filter (offers (run.act n)) (candidates bears offers rep (run.window 0 n)) :=
  (congrArg (candidates bears offers rep) (window_succ run n)).trans
    (candidates_snoc_bearing rep (run.window 0 n) bearing)

/-- **A move of a run not bearing on the form leaves its candidates as they were.** -/
theorem run_step_other (bears : A → Bool) (offers : A → M → Bool) (run : Run P) (rep : List M)
    (n : Nat) (other : bears (run.act n) = false) :
    candidates bears offers rep (run.window 0 (n + 1)) =
      candidates bears offers rep (run.window 0 n) :=
  (congrArg (candidates bears offers rep) (window_succ run n)).trans
    (candidates_snoc_other rep (run.window 0 n) other)

/-- **Under coverage along a run, a unique candidate is the target.** Where the target is in the
repertoire and every bearing move of the first `n` offers it, the only candidate after `n` moves,
if there is one, is the target. -/
theorem run_resolved_is_target {bears : A → Bool} {offers : A → M → Bool} (run : Run P) (n : Nat)
    {rep : List M} {t e : M} (available : t ∈ rep)
    (covered : ∀ a, a ∈ run.window 0 n → bears a = true → offers a t = true)
    (resolved : candidates bears offers rep (run.window 0 n) = [e]) : e = t :=
  resolved_is_target available covered resolved

/-- **Coverage cannot be dropped.** On every run of a process with one move, the first move, read
as the record bearing on the form that offers only `1`, does not offer the target `0`, and leaves
`1` the only candidate of the repertoire `[0, 1]`. -/
theorem run_omitted {P : Process S Unit} (run : Run P) :
    Omitted.offers (run.act 0) 0 = false ∧
      candidates (fun _ : Unit => true) Omitted.offers [0, 1] (run.window 0 1) = [1] :=
  ⟨Omitted.target_uncovered, Omitted.wrong_unique⟩

end CandidateRuns

end Becoming

end CandidateRuns

section ReducedRuns

/-!
## Reduced runs: what a reduction keeps of the courses and runs of a law

`Becoming.Readout` states, for every reduction `π : S → K`, when an observable can be decoded from
what `π` keeps (`decodes_iff_of_section`, where `π` has a section) and that a reduced law commuting
with every move commutes with every course of moves (`foldl_semiconj`). `Becoming.Courses` reads
what a reduction keeps of a run as a run of the law read through it (`Courses.reducedRun`), and
every course of configurations as a run of the process in which every change is admitted
(`Courses.anyChange`, `Courses.anyRun`). A law of change with moves is a process
(`Assurance.ofMap`). This section states those laws of runs and courses.

* **Decoding every run's reduced run.** Where the reduction has a section, one decoder reads an
  observable from the reduced run at every date of every course of configurations exactly where
  the observable goes alike across what the reduction merges (`runs_decoder_iff_of_section`).
* **The reduced law carries every course.** A course of a law of change ends where its moves take
  the start (`trace_foldl`). Where a reduced law commutes with every move, what the reduction
  keeps at the end of every course is the reduced law's fold of the course's moves from the
  reduced start (`course_reduced`), and the reduced run of every run of the law is so at every date
  (`run_reduced`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative Assurance Readout

universe u v w x

namespace ReducedRuns

variable {S : Type u} {K : Type v} {V : Type w} {A : Type x}

/-- **Decoding every run's reduced run.** Where the reduction has a section, some decoder reads the
observable from the reduced run at every date of every course of configurations exactly where the
observable goes alike across what the reduction merges. -/
theorem runs_decoder_iff_of_section {π : S → K} {f : S → V} (sec : K → S)
    (back : ∀ k, π (sec k) = k) :
    (∃ g : K → V, ∀ (r : Run (Courses.anyChange S)) (n : Nat),
        f (r.state n) = g ((Courses.reducedRun π r).state n)) ↔ Learning.Lumped π f :=
  ⟨fun ⟨g, decodes⟩ =>
    (decodes_iff_of_section sec back).mp ⟨g, fun s => decodes (Courses.anyRun fun _ => s) 0⟩,
   fun lumped => match (decodes_iff_of_section sec back).mpr lumped with
    | ⟨g, decodes⟩ => ⟨g, fun r n => decodes (r.state n)⟩⟩

/-- A course of a law of change ends where its moves, taken in turn, take the start. -/
theorem trace_foldl {f : S → A → S} :
    ∀ {s t : S} {plan : List A}, Trace (ofMap f) s plan t → t = plan.foldl f s
  | _, _, [], .nil _ => rfl
  | _, _, _ :: rest, .cons moved tail =>
    (trace_foldl tail).trans (congrArg (fun y => rest.foldl f y) moved)

/-- **The reduced law carries every course.** Where a reduced law commutes with every move, what
the reduction keeps at the end of a course of the law is the reduced law's fold of the course's
moves from what it keeps of the start. -/
theorem course_reduced (next : S → A → S) (π : S → K) (reduced : K → A → K)
    (commutes : ∀ s a, π (next s a) = reduced (π s) a) {s t : S} {plan : List A}
    (path : Trace (ofMap next) s plan t) : π t = plan.foldl reduced (π s) :=
  (congrArg π (trace_foldl path)).trans (foldl_semiconj next π reduced commutes plan s)

/-- **The reduced run of every run of the law is the reduced law's fold of its moves**, where the
reduced law commutes with every move. -/
theorem run_reduced (next : S → A → S) (π : S → K) (reduced : K → A → K)
    (commutes : ∀ s a, π (next s a) = reduced (π s) a) (r : Run (ofMap next)) (n : Nat) :
    (Courses.reducedRun π r).state n = (r.window 0 n).foldl reduced (π (r.state 0)) :=
  Eq.subst (motive := fun k => π (r.state k) = (r.window 0 n).foldl reduced (π (r.state 0)))
    (Nat.zero_add n) (course_reduced next π reduced commutes (r.window_trace n 0))

end ReducedRuns

end Becoming

end ReducedRuns
