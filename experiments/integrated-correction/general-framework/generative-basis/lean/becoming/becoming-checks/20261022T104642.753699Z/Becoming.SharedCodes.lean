import Becoming.Commuting
import Becoming.CrossSituational
import Becoming.IdentificationRuns
import Becoming.Mechanism

/-!
# Shared codes: a code formed between formations, imposed on them, and written back

The spine reads a code off a code that is given (`Becoming.CodeAcquisition`), off a teacher
(`Becoming.ResponseLearning`, `Becoming.LearnedGrouping`), or off finitely many labels of a given
feature (`Becoming.Labels`, `Becoming.Learnable`), and it keeps an installed encoding across a
change of channel (`References.stays_iff`). In each the code is supplied to one side. This module
states, with no premise beyond what each law names, how a code forms within the relation of the
formations that use it. A code is a map from senses to forms; each formation holds one
(`I → M → F`); and the codes change only by hearing: a hearer takes the form a speaker gives a
sense, where a supplied rule reading the two codes says so (`hearBy`; `hear` always takes it).
Hearing is a process of the spine (`process`), a stretch of its run is an order of hearings
(`window_runBy`, `state_hearings`), and every start and sequence of hearings has its run
(`hearingRun`).

* **Hearing makes no form, and agreement keeps itself.** Every form held after a hearing, an order
  of hearings or a stretch of a run was held at the start, at the same sense, by some formation
  (`hearBy_held`, `runBy_held`, `run_held`); a hearing changes a form exactly at the hearer, at the
  sense heard, where the rule takes the form and the speaker's form differs (`changes_iff`, along a
  run `run_changes_iff`). A group agreeing at a sense keeps agreeing through every hearing in which
  a member hears that sense only from a member (`agreement_kept`); exactly, with a second member, it
  keeps agreeing unless a member hears the sense, the rule takes the form and the speaker's form is
  not the group's (`kept_iff`, `run_kept_iff`). Along every run whose hearings are so closed, no
  member's form at the sense changes (`run_kept`, `run_agreement_kept`); two formations hearing only
  each other keep agreement once they agree (`pair_kept`); and agreement of all is a rest under
  every rule (`all_agree_rest`).
* **The start and the order fix the form reached.** After hearings that take the form heard, each
  formation holds at `m` the start's form of its origin, the formation reached by stepping back
  through the order (`run_origin`, along a run `run_origin_window`). So an order forms agreement at
  `m` from every start exactly where it gives every formation one origin, where two forms differ
  (`agrees_every_start_iff`, on runs `run_agrees_every_start_iff`); where a list holds every
  formation, each form in use is reached under some order (`broadcast_reaches`), and the forms an
  order can make shared are exactly the forms in use (`shared_iff_in_use`, on runs
  `run_shared_iff_in_use`). Along runs of one hearing between two formations, the two orders reach
  each of the two forms (`TwoFormations.order_decides`). Where every formation takes at once the
  code of the formation a pointer gives it (`follow`), it holds the start's code of where the
  pointer leads (`follow_state`), and every start agrees at a step exactly where the pointer's paths
  from any two formations have met (`follow_agrees_iff`). Being joined through couplings is not
  enough: on the path `a – c – b`, each following the least-indexed of itself and its couplings, `a`
  and `b` never agree (`Path.never_agree`).
* **Reading across.** A code reads its own forms back as their senses exactly where it tells the
  senses apart (`self_reads_iff`). A formation whose code tells senses apart reads another's form
  for a sense as that sense, and only it, exactly where their codes agree there (`reads_iff`, the
  form between formations of `References.stays_iff`); where they disagree it reads another sense,
  not nothing (`reads_other`; both at every step of a run, `run_reads_iff`); along a run, formations
  that keep agreeing keep reading each other (`run_reads_kept`). Agreement formed sense by sense can
  merge senses: a hearing keeps the hearer's code telling senses apart exactly where the form it
  takes is not one the hearer gives another sense (`keeps_apart_iff`, `run_keeps_apart_iff`), and
  along runs two codes that each tell two senses apart, one hearing the other at one sense, leave
  the hearer with one form for both (`TwoFormations.homonym`).
* **The course of forms.** Through a code, the course of forms of every course of senses is one
  state at the moments the course of senses is, exactly where the code tells the senses apart
  (`course_states_iff`). Where grouping recovers the words of every encoded sequence and
  resolution reads every encoded sequence as its meanings (`CrossSituational.reads_every_iff`),
  resolution reads the course of forms of every course of words as its course of meanings, step
  by step, so two moments that are one state of the forms are one state of the meanings
  (`course_read`); a code whose every sequence of forms resolution reads back tells the senses
  apart, and its course of forms is one state exactly where the course of senses is
  (`code_read_every`).
* **No form is privileged.** Hearing under a rule that reads codes alike after a renaming keeps the
  renaming (`hearBy_keeps_renaming`, `hear_keeps_renaming`), so runs through one order from starts
  that differ by a renaming differ by it at every step (`run_renamed`), and their forms agree
  exactly where the renaming fixes the form reached (`reached_differ_iff`). A renaming that tells
  forms apart keeps what a code tells apart (`renamed_tells_apart_iff`, along runs
  `run_renamed_tells_apart_iff`), and a renamed description carries a law of a process exactly where
  the description does (`renamed_goAlike_iff`, `renamed_carries_iff`, through `carries_law_iff`).
* **Agreement needs a broken symmetry.** A law keeping a relation keeps it along its runs
  (`Law.KeepsRelation.run`); a law commuting with `σ` keeps the relation of a configuration to its
  image (`Law.Commutes.keepsRelation`), and from a configuration `σ` fixes the run stays fixed. A
  law of codes that keeps the exchange of formations by `π` (`KeepsExchange`) and the renaming of
  forms by `τ` (`KeepsRenaming`) keeps the two together (`keeps_both`), so a start symmetric under
  them stays symmetric (`Law.KeepsRelation.run`), formations they exchange agree only on a form the
  renaming fixes (`agrees_only_fixed`), and where the renaming moves every form at `m` they never
  agree there (`never_agrees`, `never_agrees_of_both`). For pairs of forms and a law commuting with
  exchanging the two formations together with the forms, this is the relational form of
  `Law.Commutes.keeps_fixed` (`pair_agrees_only_fixed`, `pair_never_agrees`). In `TwoFormations`,
  each taking the other's form at once never agrees (`crossing_never_agrees`); a centre (every
  formation takes one formation's form), a preferred form and one hearing in order each bring the
  two to agree in one step (`three_agree`), and so each breaks one symmetry: the centre and the
  order break the exchange of formations and keep every renaming, the preferred form breaks the
  renaming and keeps the exchange (`centre_breaks_exchange`, `ordered_breaks_exchange`,
  `preferred_breaks_renaming`).
* **An imposed code.** Imposing one code on every formation makes all agree at every sense
  (`impose_agrees`) and every formation read every other exactly where the imposed code tells the
  senses apart (`SharedCodes.self_reads_iff`). By definition each formation loses exactly the distinctions its
  code made that the imposed code merges (`impose_loses_iff`); the formation whose code is imposed
  loses none (`source_loses_nothing`); along every run of hearing from an imposition all of this
  stays (`run_from_imposition`). A form every formation holds at a sense stays under every later
  order of hearings and every rule (`held_stays`), so along every run from an imposition the imposed
  code stays (`run_imposed_stays`) and what it merges stays merged. Imposed on a group, a merged
  distinction comes back only from a form kept outside it (`outside_needed`), and along runs of
  hearing from any such form at once (`outside_returns`).
* **A reading written back.** Generations read a form off the previous generation's records by
  `CrossSituational`'s candidates (`resolve`); each writes a record offering exactly what it
  resolved (`WritesExactly`, `nextCohort`). A resolution written back rests from the next generation
  on (`written_rests`, `every_cohort_resolves`). Two histories resolving alike are merged and
  stay merged (`resolved_alike_merged`, by `Law.merged_stays`; `nextCohort_merges`), so no reading
  of later records recovers what came before (`no_reading_recovers`). Under coverage the rest is the
  target (`covered_rest`, by `CrossSituational.resolved_is_target`); where the records resolve to
  another sense, the target is no candidate at any later generation and the resolved sense is
  (`omitted_rest`). Where the earlier records are kept, later records resolve the form only to what
  they resolved it to, or not at all (`kept_bars`, by `CrossSituational.narrows`), and keeping them
  with each generation's record rests the resolution with the first records readable at every
  generation (`kept_rests`). Along every run that only adds records (`adding`), uptakes of outside
  readings included, a resolution can be lost but never replaced (`added_never_replaced`). In
  `Gloss`, the earlier record written back rests (`earlier_rests`); a record of the reading taken up
  in its place locks and the earlier sense is never a candidate again (`taken_up_locks`); and the
  reading added beside the kept earlier record loses the resolution without replacing it
  (`uptake_loses`).

**Readings (the AI's; the second gap of RO's chapter on the Chinese sources, decided from the
work by D45).**
- 名无固宜，约定俗成谓之宜. No form is privileged by any order of exchange, and the form a group
  comes to share is fixed by the start and the order of hearing, any form in use being possible.
  A law privileging neither form nor formation cannot settle a symmetric disagreement; what
  settles it breaks a symmetry. A centre does so beforehand (荀子's 王者制名), a preferred form
  does so by a fit in the form, and the order of hearing does so through the relation's own
  history. 约定俗成 is read as the last: the fit of a name is formed in the course of use, not
  given by the thing or by a centre.
- 同则同之，异则异之. Renaming forms changes neither what a code tells apart nor whether it carries
  a law: the fit (宜) is conventional, while what a code carries (实) depends on which senses it
  groups. Agreement formed sense by sense can group senses that had been told apart, so forming a
  convention can cost a code its distinctions.
- 书同文. An imposed code is a centre's code made everyone's at once. Its source loses nothing;
  every other formation loses what its code told apart and the imposed code merges; and no later
  exchange among those it was imposed on recovers it. A merged distinction comes back only from a
  form kept outside the imposition (“古文由此絕” where nothing outside kept the old forms).
- 止戈为武 in the 說文. A reading written into the records that later generations read rests at
  once and confirms itself: later records do not recover what came before, and under omission the
  rest is a sense the earlier records did not resolve. Only records kept from before, the dated
  controls of `Becoming.Retrodiction`, bar it.
- None of these is a value. The laws do not say whether a shared code, an imposed one or a kept
  difference supports or damages 生生 (chapter §6.15).

**Classical sources.** Hearing by adoption is the voter model and the naming game, and the codes
are those of Lewis signalling systems; the symmetry argument is equivariance (Curie's principle);
origins are time-respecting paths in a temporal graph. What is the spine's own is stating them on
its processes, runs and laws (`Law.Commutes`, `Law.merged_stays`, `carries_law_iff`,
`CrossSituational`) with the exact conditions.

What is not derived: which order actual exchange takes (probabilities over orders are not
modelled), the time agreement takes, codes holding several forms for a sense (inventories), rules
reading more than the two codes, adoption of whole codes, and whether actual conventions form
this way. No ethical predicate or ranking occurs, and every declaration has an empty axiom report.
* **Synonyms, a coined form, majority and imposing.** A code letting a sense hold several forms
  reads back exactly where no two senses hold one form (`synonyms_read_iff`; `one_form_reads_iff`
  the case of one form a sense). Coining a form (`coin`) is the step hearing lacks: a form coined at
  `m` and heard by all brings back a distinction an imposed code merged (`coined_returns`). Taking
  what most hold (`majority`) makes no form (`majority_held`); two of three agree at once and one of
  two rests (`Majority.odd_agrees`, `Majority.even_rests`). Imposing a code keeps every exchange of
  formations (`impose_keeps_exchange`) and privileges its forms (`impose_privileges_forms`), the
  symmetry it breaks.
-/

namespace Becoming

open Generative

universe u v w

/-! ## A law that keeps a relation -/

namespace Law

variable {S : Type u}

/-! `KeepsRelation` and `KeepsRelation.run` moved, unchanged, to `Becoming.IdentificationRuns`
(board item WL2). -/

/-- A law commuting with `σ` keeps the relation of a configuration to its image under `σ`. -/
theorem Commutes.keepsRelation {T σ : S → S} (commutes : Commutes T σ) :
    KeepsRelation T (fun x y => y = σ x) :=
  fun x _ image => (congrArg T image).trans (commutes x)

end Law

namespace SharedCodes

/-! ## Hearing -/

/-- One hearing: `hearer` hears the form `speaker` gives `sense`. -/
structure Hearing (I : Type u) (M : Type v) where
  hearer : I
  speaker : I
  sense : M

theorem bool_false_ne_true {b : Bool} (f : b = false) : b ≠ true := fun t => Bool.noConfusion (f.symm.trans t)

section Hearing

variable {I : Type u} {M : Type v} {F : Type w} [DecidableEq I] [DecidableEq M]

/-- A hearing under a rule `adopt`, which reads the hearer's code, the speaker's code and the
sense heard: where the rule says so, the hearer takes the speaker's form for that sense; nothing
else changes. -/
def hearBy (adopt : (M → F) → (M → F) → M → Bool) (e : Hearing I M) (X : I → M → F) :
    I → M → F := fun i m =>
  if i = e.hearer then
    if m = e.sense then
      if adopt (X e.hearer) (X e.speaker) e.sense = true then X e.speaker m else X i m
    else X i m
  else X i m

/-- The rule that always takes the form heard. -/
def always (_ _ : M → F) (_ : M) : Bool := true

/-- A hearing in which the hearer takes the form heard. -/
abbrev hear (e : Hearing I M) (X : I → M → F) : I → M → F := hearBy always e X

variable {adopt : (M → F) → (M → F) → M → Bool}

/-- A hearing changes nothing at another formation or another sense. -/
theorem hearBy_other {e : Hearing I M} {X : I → M → F} {i : I} {m : M}
    (other : i ≠ e.hearer ∨ m ≠ e.sense) : hearBy adopt e X i m = X i m :=
  match decEq i e.hearer with
  | isFalse ne => if_neg ne
  | isTrue h =>
    match other with
    | .inl ne => absurd h ne
    | .inr ne => (if_pos h).trans (if_neg ne)

/-- Where the rule takes the form, the hearer gives the sense heard the speaker's form. -/
theorem hearBy_taken {e : Hearing I M} {X : I → M → F}
    (adopts : adopt (X e.hearer) (X e.speaker) e.sense = true) :
    hearBy adopt e X e.hearer e.sense = X e.speaker e.sense :=
  (if_pos rfl).trans ((if_pos rfl).trans (if_pos adopts))

/-- Where the rule does not take the form, the hearing changes nothing. -/
theorem hearBy_refused {e : Hearing I M} {X : I → M → F}
    (refuses : adopt (X e.hearer) (X e.speaker) e.sense = false) (i : I) (m : M) :
    hearBy adopt e X i m = X i m :=
  match decEq i e.hearer, decEq m e.sense with
  | isTrue h, isTrue h' => (if_pos h).trans ((if_pos h').trans (if_neg (bool_false_ne_true refuses)))
  | isTrue _, isFalse h' => hearBy_other (.inr h')
  | isFalse h, _ => hearBy_other (.inl h)

/-- **A hearing makes no form**: after it, each formation gives each sense the form the speaker
or the formation itself gave it. -/
theorem hearBy_held (e : Hearing I M) (X : I → M → F) (i : I) (m : M) :
    hearBy adopt e X i m = X e.speaker m ∨ hearBy adopt e X i m = X i m :=
  match decEq i e.hearer, decEq m e.sense with
  | isTrue h, isTrue h' =>
    match hb : adopt (X e.hearer) (X e.speaker) e.sense with
    | true => .inl ((if_pos h).trans ((if_pos h').trans (if_pos hb)))
    | false => .inr ((if_pos h).trans ((if_pos h').trans (if_neg (bool_false_ne_true hb))))
  | isTrue _, isFalse h' => .inr (hearBy_other (.inr h'))
  | isFalse h, _ => .inr (hearBy_other (.inl h))

/-- **Exactly where a hearing changes a form**: at the hearer, at the sense heard, where the rule
takes the form and the speaker's form differs. -/
theorem changes_iff {e : Hearing I M} {X : I → M → F} {i : I} {m : M} :
    hearBy adopt e X i m ≠ X i m ↔
      i = e.hearer ∧ m = e.sense ∧ adopt (X e.hearer) (X e.speaker) e.sense = true ∧
        X e.speaker m ≠ X i m :=
  ⟨fun changed =>
    match decEq i e.hearer, decEq m e.sense with
    | isTrue h, isTrue h' =>
      match hb : adopt (X e.hearer) (X e.speaker) e.sense with
      | true => ⟨h, h', rfl, fun same =>
          changed (((if_pos h).trans ((if_pos h').trans (if_pos hb))).trans same)⟩
      | false => absurd (hearBy_refused hb i m) changed
    | isTrue _, isFalse h' => absurd (hearBy_other (.inr h')) changed
    | isFalse h, _ => absurd (hearBy_other (.inl h)) changed,
   fun ⟨h, h', hb, differs⟩ same =>
    differs ((((if_pos h).trans ((if_pos h').trans (if_pos hb))).symm).trans same)⟩

/-! ### Agreement within a group -/

/-- The formations of a group give the sense `m` one form. -/
def AgreeAt (G : I → Prop) (X : I → M → F) (m : M) : Prop := ∀ i j, G i → G j → X i m = X j m

/-- A hearing is closed for the group at `m` where, if a member hears `m`, the speaker is a
member. -/
def Closed (G : I → Prop) (m : M) (e : Hearing I M) : Prop := G e.hearer → e.sense = m → G e.speaker

variable {G : I → Prop}

/-- **Within an agreeing group, a closed hearing changes no member's form at the sense.** -/
theorem kept_at {X : I → M → F} {m : M} {e : Hearing I M} (agree : AgreeAt G X m)
    (closed : Closed G m e) {i : I} (member : G i) : hearBy adopt e X i m = X i m :=
  match hearBy_held (adopt := adopt) e X i m with
  | .inr same => same
  | .inl taken =>
    match decEq i e.hearer, decEq m e.sense with
    | isTrue h, isTrue h' =>
      taken.trans (agree e.speaker i (closed (h ▸ member) h'.symm) member)
    | isTrue _, isFalse h' => hearBy_other (.inr h')
    | isFalse h, _ => hearBy_other (.inl h)

/-- **Agreement within a group is kept through every hearing closed for it.** -/
theorem agreement_kept {X : I → M → F} {m : M} {e : Hearing I M} (agree : AgreeAt G X m)
    (closed : Closed G m e) : AgreeAt G (hearBy adopt e X) m :=
  fun i j gi gj => (kept_at agree closed gi).trans ((agree i j gi gj).trans (kept_at agree closed gj).symm)

/-- **Exactly when a hearing keeps a group's agreement.** For a group agreeing at `m` with a
member other than the hearer, the members still agree after the hearing exactly where, if the
hearer is a member hearing `m` and the rule takes the form, the speaker's form is the hearer's. -/
theorem kept_iff {X : I → M → F} {m : M} {e : Hearing I M} (agree : AgreeAt G X m) {j : I}
    (gj : G j) (other : j ≠ e.hearer) :
    AgreeAt G (hearBy adopt e X) m ↔
      (G e.hearer → e.sense = m → adopt (X e.hearer) (X e.speaker) e.sense = true →
        X e.speaker m = X e.hearer m) :=
  ⟨fun after gh sense adopts =>
    calc X e.speaker m = hearBy adopt e X e.hearer m := by
          subst sense; exact (hearBy_taken adopts).symm
      _ = hearBy adopt e X j m := after e.hearer j gh gj
      _ = X j m := hearBy_other (.inl other)
      _ = X e.hearer m := agree j e.hearer gj gh,
   fun same => by
    have each : ∀ i, G i → hearBy adopt e X i m = X i m := fun i gi =>
      match decEq i e.hearer, decEq m e.sense with
      | isTrue h, isTrue h' =>
        match hb : adopt (X e.hearer) (X e.speaker) e.sense with
        | true => by
          subst h; subst h'
          exact (hearBy_taken hb).trans (same gi rfl hb)
        | false => hearBy_refused hb i m
      | isTrue _, isFalse h' => hearBy_other (.inr h')
      | isFalse h, _ => hearBy_other (.inl h)
    exact fun i k gi gk => (each i gi).trans ((agree i k gi gk).trans (each k gk).symm)⟩

/-! ### Orders of exchange -/

/-- Hearings in order, the first first. -/
def runBy (adopt : (M → F) → (M → F) → M → Bool) : List (Hearing I M) → (I → M → F) → I → M → F
  | [], X => X
  | e :: es, X => runBy adopt es (hearBy adopt e X)

/-- **An order of exchange makes no form**: every form held after it was held at the start, at
the same sense, by some formation. -/
theorem runBy_held : ∀ (es : List (Hearing I M)) (X : I → M → F) (i : I) (m : M),
    ∃ j, runBy adopt es X i m = X j m
  | [], _, i, _ => ⟨i, rfl⟩
  | e :: es, X, i, m =>
    match runBy_held es (hearBy adopt e X) i m with
    | ⟨j, held⟩ =>
      match hearBy_held (adopt := adopt) e X j m with
      | .inl taken => ⟨e.speaker, held.trans taken⟩
      | .inr same => ⟨j, held.trans same⟩

/-- One step back through a hearing: whose form at `m` the formation `j` holds after it. -/
def back (m : M) (e : Hearing I M) (j : I) : I :=
  if j = e.hearer then (if m = e.sense then e.speaker else j) else j

/-- The origin of a formation's form at `m` after an order of hearings: the formation whose form
at the start it then holds. -/
def origin (m : M) : List (Hearing I M) → I → I
  | [], i => i
  | e :: es, i => back m e (origin m es i)

theorem back_held (m : M) (e : Hearing I M) (j : I) : back m e j = e.speaker ∨ back m e j = j :=
  match decEq j e.hearer, decEq m e.sense with
  | isTrue h, isTrue h' => .inl ((if_pos h).trans (if_pos h'))
  | isTrue h, isFalse h' => .inr ((if_pos h).trans (if_neg h'))
  | isFalse h, _ => .inr (if_neg h)

/-- After a hearing that takes the form heard, a formation gives `m` the form its step back gave
it. -/
theorem hear_back (e : Hearing I M) (X : I → M → F) (j : I) (m : M) :
    hear e X j m = X (back m e j) m :=
  match decEq j e.hearer, decEq m e.sense with
  | isTrue h, isTrue h' =>
    ((if_pos h).trans ((if_pos h').trans (if_pos rfl))).trans
      (congrArg (fun k => X k m) ((if_pos h).trans (if_pos h')).symm)
  | isTrue h, isFalse h' =>
    (hearBy_other (.inr h')).trans (congrArg (fun k => X k m) ((if_pos h).trans (if_neg h')).symm)
  | isFalse h, _ =>
    (hearBy_other (.inl h)).trans (congrArg (fun k => X k m) (if_neg h).symm)

/-- **The form reached is fixed by the start and the order**: after hearings that take the form
heard, each formation holds at `m` the start's form of its origin. -/
theorem run_origin : ∀ (es : List (Hearing I M)) (X : I → M → F) (i : I) (m : M),
    runBy always es X i m = X (origin m es i) m
  | [], _, _, _ => rfl
  | e :: es, X, i, m => (run_origin es (hear e X) i m).trans (hear_back e X (origin m es i) m)

/-- The start that gives `o` the form `a` at every sense and every other formation `b`. -/
def marked (o : I) (a b : F) : I → M → F := fun k _ => if k = o then a else b

/-- **An order forms agreement from every start exactly where it gives every formation one
origin.** Where two forms differ, an order of hearings that take the form heard brings every
start to agreement at `m` exactly where all formations have one origin at `m`. -/
theorem agrees_every_start_iff {a b : F} (apart : a ≠ b) (es : List (Hearing I M)) (m : M) :
    (∀ (X : I → M → F) i j, runBy always es X i m = runBy always es X j m) ↔
      ∀ i j, origin m es i = origin m es j :=
  ⟨fun agree i j =>
    match decEq (origin m es i) (origin m es j) with
    | isTrue same => same
    | isFalse differ =>
      have reached : marked (M := M) (origin m es i) a b (origin m es i) m =
          marked (M := M) (origin m es i) a b (origin m es j) m :=
        ((run_origin es _ i m).symm.trans (agree _ i j)).trans (run_origin es _ j m)
      absurd ((if_pos rfl).symm.trans (reached.trans (if_neg fun h => differ h.symm))) apart,
   fun one X i j =>
    (run_origin es X i m).trans ((congrArg (fun k => X k m) (one i j)).trans (run_origin es X j m).symm)⟩

/-- Every formation of a list hears `o`'s form for `m`, in the list's order. -/
def broadcast (o : I) (m : M) (l : List I) : List (Hearing I M) := l.map fun i => ⟨i, o, m⟩

theorem back_to (o k : I) (m : M) : back m ⟨k, o, m⟩ k = o := (if_pos rfl).trans (if_pos rfl)

theorem back_from (o k : I) (m : M) : back m ⟨k, o, m⟩ o = o :=
  match decEq o k with
  | isTrue h => (if_pos h).trans (if_pos rfl)
  | isFalse h => if_neg h

/-- Through a broadcast from `o`, `o` keeps its form at `m`, and every formation that held it or
hears it holds it. -/
theorem broadcast_holds (o : I) (m : M) : ∀ (l : List I) (Y : I → M → F) (Q : I → Prop),
    (∀ k, Q k → Y k m = Y o m) →
      runBy always (broadcast o m l) Y o m = Y o m ∧
        ∀ k, (Q k ∨ k ∈ l) → runBy always (broadcast o m l) Y k m = Y o m
  | [], _, _, held => ⟨rfl, fun k h => match h with
      | .inl q => held k q
      | .inr mem => nomatch mem⟩
  | k₀ :: l, Y, Q, held =>
    have keeps : hear ⟨k₀, o, m⟩ Y o m = Y o m :=
      (hear_back _ Y o m).trans (congrArg (fun k => Y k m) (back_from o k₀ m))
    have gets : hear ⟨k₀, o, m⟩ Y k₀ m = Y o m :=
      (hear_back _ Y k₀ m).trans (congrArg (fun k => Y k m) (back_to o k₀ m))
    have held' : ∀ k, (Q k ∨ k = k₀) → hear ⟨k₀, o, m⟩ Y k m = hear ⟨k₀, o, m⟩ Y o m := fun k h =>
      match h with
      | .inr e => (congrArg (fun j => hear ⟨k₀, o, m⟩ Y j m) e).trans (gets.trans keeps.symm)
      | .inl q =>
        (hear_back _ Y k m).trans (match back_held m ⟨k₀, o, m⟩ k with
          | .inl to => (congrArg (fun j => Y j m) to).trans keeps.symm
          | .inr same => (congrArg (fun j => Y j m) same).trans ((held k q).trans keeps.symm))
    match broadcast_holds o m l (hear ⟨k₀, o, m⟩ Y) (fun k => Q k ∨ k = k₀) held' with
    | ⟨stays, all⟩ =>
      ⟨stays.trans keeps, fun k h =>
        (all k (match h with
          | .inl q => .inl (.inl q)
          | .inr (.head _) => .inl (.inr rfl)
          | .inr (.tail _ mem) => .inr mem)).trans keeps⟩

/-- **Each form in use is reached under some order.** Where a list holds every formation, the
order in which each hears `o` brings every formation to `o`'s form at `m`. -/
theorem broadcast_reaches {all : List I} (every : ∀ i, i ∈ all) (o : I) (m : M) (X : I → M → F)
    (i : I) : runBy always (broadcast o m all) X i m = X o m :=
  (broadcast_holds o m all X (fun _ => False) (fun _ f => f.elim)).2 i (.inr (every i))

/-- **The forms an order can make shared are exactly the forms in use.** Where a list holds every
formation, some order brings every formation to the form `x` at `m` exactly where some formation
holds `x` at `m` at the start. -/
theorem shared_iff_in_use {all : List I} (every : ∀ i, i ∈ all) (i₀ : I) (X : I → M → F) (m : M)
    (x : F) : (∃ es : List (Hearing I M), ∀ i, runBy always es X i m = x) ↔ ∃ o, X o m = x :=
  ⟨fun ⟨es, shared⟩ => match runBy_held (adopt := always) es X i₀ m with
    | ⟨j, held⟩ => ⟨j, held.symm.trans (shared i₀)⟩,
   fun ⟨o, holds⟩ => ⟨broadcast o m all, fun i => (broadcast_reaches every o m X i).trans holds⟩⟩

/-! ### Hearing along runs -/

/-- Hearing under a rule as a process of the spine: each step is one hearing. -/
def process (adopt : (M → F) → (M → F) → M → Bool) : Process (I → M → F) (Hearing I M) :=
  ⟨fun X e Y => Y = hearBy adopt e X⟩

theorem step_at (r : Run (process adopt)) (n : Nat) (i : I) (m : M) :
    r.state (n + 1) i m = hearBy adopt (r.act n) (r.state n) i m :=
  congrFun (congrFun (r.step n) i) m

/-- A step of a run from a known configuration and hearing. -/
theorem step_from (r : Run (process adopt)) {n : Nat} {X : I → M → F} {e : Hearing I M}
    (at_n : r.state n = X) (heard : r.act n = e) (i : I) (m : M) :
    r.state (n + 1) i m = hearBy adopt e X i m :=
  (step_at r n i m).trans ((congrArg (fun e' => hearBy adopt e' (r.state n) i m) heard).trans
    (congrArg (fun Y => hearBy adopt e Y i m) at_n))

/-- **A stretch of a run is its order of hearings.** -/
theorem window_runBy (r : Run (process adopt)) :
    ∀ (k n : Nat) (i : I) (m : M), r.state (n + k) i m = runBy adopt (r.window n k) (r.state n) i m
  | 0, _, _, _ => rfl
  | k + 1, n, i, m =>
    have shift : r.state (n + (k + 1)) = r.state (n + 1 + k) :=
      congrArg r.state (Nat.succ_add n k).symm
    (congrFun (congrFun shift i) m).trans ((window_runBy r k (n + 1) i m).trans
      (congrArg (fun Y => runBy adopt (r.window (n + 1) k) Y i m) (r.step n)))

/-- **Agreement within a group is kept along every run whose hearings are closed for it**: from a
step at which the group agrees at `m`, no member's form at `m` changes. -/
theorem run_kept (r : Run (process adopt)) {n : Nat} {m : M} (agree : AgreeAt G (r.state n) m)
    (closed : ∀ k, Closed G m (r.act (n + k))) : ∀ k i, G i → r.state (n + k) i m = r.state n i m
  | 0, _, _ => rfl
  | k + 1, i, gi =>
    have prev := run_kept r agree closed k
    have agreeK : AgreeAt G (r.state (n + k)) m := fun a b ga gb =>
      (prev a ga).trans ((agree a b ga gb).trans (prev b gb).symm)
    (step_at r (n + k) i m).trans ((kept_at agreeK (closed k) gi).trans (prev i gi))

/-- **Once a group agrees, it keeps agreeing** along every run whose hearings are closed for it. -/
theorem run_agreement_kept (r : Run (process adopt)) {n : Nat} {m : M}
    (agree : AgreeAt G (r.state n) m) (closed : ∀ k, Closed G m (r.act (n + k))) :
    ∀ k, AgreeAt G (r.state (n + k)) m
  | 0 => agree
  | k + 1 => Eq.subst (motive := fun Y => AgreeAt G Y m) (r.step (n + k)).symm
      (agreement_kept (run_agreement_kept r agree closed k) (closed k))

/-- **Exactly where a step of a run changes a form**: at the hearer of that step, at the sense
heard, where the rule takes the form and the speaker's form differs. -/
theorem run_changes_iff (r : Run (process adopt)) (n : Nat) (i : I) (m : M) :
    r.state (n + 1) i m ≠ r.state n i m ↔
      i = (r.act n).hearer ∧ m = (r.act n).sense ∧
        adopt (r.state n (r.act n).hearer) (r.state n (r.act n).speaker) (r.act n).sense = true ∧
          r.state n (r.act n).speaker m ≠ r.state n i m :=
  ⟨fun ne => changes_iff.mp (fun e => ne ((step_at r n i m).trans e)),
   fun c e => changes_iff.mpr c ((step_at r n i m).symm.trans e)⟩

/-- **Exactly when a step of a run keeps a group's agreement**: for a group agreeing at `m` with a
member other than the step's hearer, the members agree after the step exactly where, if the hearer
is a member hearing `m` and the rule takes the form, the speaker's form is the hearer's. -/
theorem run_kept_iff (r : Run (process adopt)) {n : Nat} {m : M} (agree : AgreeAt G (r.state n) m)
    {j : I} (gj : G j) (other : j ≠ (r.act n).hearer) :
    AgreeAt G (r.state (n + 1)) m ↔
      (G (r.act n).hearer → (r.act n).sense = m →
        adopt (r.state n (r.act n).hearer) (r.state n (r.act n).speaker) (r.act n).sense = true →
          r.state n (r.act n).speaker m = r.state n (r.act n).hearer m) :=
  Eq.subst (motive := fun Y => AgreeAt G Y m ↔
      (G (r.act n).hearer → (r.act n).sense = m →
        adopt (r.state n (r.act n).hearer) (r.state n (r.act n).speaker) (r.act n).sense = true →
          r.state n (r.act n).speaker m = r.state n (r.act n).hearer m))
    (r.step n).symm (kept_iff agree gj other)

/-- **Agreement of all is a rest**: once every formation gives `m` one form, no form at `m`
changes again on any run, under every rule. -/
theorem all_agree_rest (r : Run (process adopt)) {n : Nat} {m : M}
    (agree : ∀ i j, r.state n i m = r.state n j m) (k : Nat) (i : I) :
    r.state (n + k) i m = r.state n i m :=
  run_kept (G := fun _ => True) r (fun i j _ _ => agree i j) (fun _ _ _ => trivial) k i trivial

/-- **Two formations hearing only each other keep agreement once they agree.** -/
theorem pair_kept (r : Run (process adopt)) {n : Nat} {m : M} {f g : I}
    (agree : r.state n f m = r.state n g m)
    (between : ∀ k, (r.act (n + k)).sense = m →
      ((r.act (n + k)).hearer = f ∨ (r.act (n + k)).hearer = g) →
        (r.act (n + k)).speaker = f ∨ (r.act (n + k)).speaker = g) (k : Nat) :
    r.state (n + k) f m = r.state (n + k) g m :=
  have pairAgree : AgreeAt (fun i => i = f ∨ i = g) (r.state n) m := fun _ _ gi gj =>
    match gi, gj with
    | .inl hi, .inl hj => hi ▸ hj ▸ rfl
    | .inl hi, .inr hj => hi ▸ hj ▸ agree
    | .inr hi, .inl hj => hi ▸ hj ▸ agree.symm
    | .inr hi, .inr hj => hi ▸ hj ▸ rfl
  run_agreement_kept r pairAgree (fun k gh sense => between k sense gh) k f g (.inl rfl) (.inr rfl)

/-- **Every form held along a run was held at its start**, at the same sense. -/
theorem run_held (r : Run (process adopt)) (n k : Nat) (i : I) (m : M) :
    ∃ j, r.state (n + k) i m = r.state n j m :=
  match runBy_held (adopt := adopt) (r.window n k) (r.state n) i m with
  | ⟨j, held⟩ => ⟨j, (window_runBy r k n i m).trans held⟩

/-- **Along a run of hearings that take the form heard, each formation holds the start's form of
its origin** through the run's own order. -/
theorem run_origin_window (r : Run (process (I := I) (M := M) (F := F) always)) (n k : Nat) (i : I)
    (m : M) : r.state (n + k) i m = r.state n (origin m (r.window n k) i) m :=
  (window_runBy r k n i m).trans (run_origin (r.window n k) (r.state n) i m)

/-- The hearings `acts` from `n` on, `k` of them. -/
def hearings (acts : Nat → Hearing I M) : Nat → Nat → List (Hearing I M)
  | _, 0 => []
  | n, k + 1 => acts n :: hearings acts (n + 1) k

omit [DecidableEq I] [DecidableEq M] in
theorem hearings_congr {acts acts' : Nat → Hearing I M} (same : ∀ t, acts t = acts' t) :
    ∀ n k, hearings acts n k = hearings acts' n k
  | _, 0 => rfl
  | n, k + 1 => show acts n :: hearings acts (n + 1) k = acts' n :: hearings acts' (n + 1) k from
      congr (congrArg List.cons (same n)) (hearings_congr same (n + 1) k)

omit [DecidableEq I] [DecidableEq M] in
theorem hearings_shift (acts : Nat → Hearing I M) :
    ∀ n k, hearings acts (n + 1) k = hearings (fun t => acts (t + 1)) n k
  | _, 0 => rfl
  | n, k + 1 => congrArg (acts (n + 1) :: ·) (hearings_shift acts (n + 1) k)

/-- A run's window is its hearings. -/
theorem window_hearings {r : Run (process adopt)} {acts : Nat → Hearing I M}
    (heard : ∀ t, r.act t = acts t) : ∀ k n, r.window n k = hearings acts n k
  | 0, _ => rfl
  | k + 1, n => show r.act n :: r.window (n + 1) k = acts n :: hearings acts (n + 1) k from
      congr (congrArg List.cons (heard n)) (window_hearings heard k (n + 1))

/-- A run whose hearings are `acts` holds at step `k` what its first `k` hearings make of its
start. -/
theorem state_hearings (r : Run (process adopt)) {acts : Nat → Hearing I M}
    (heard : ∀ t, r.act t = acts t) (k : Nat) (i : I) (m : M) :
    r.state k i m = runBy adopt (hearings acts 0 k) (r.state 0) i m :=
  (congrArg (fun t => r.state t i m) (Nat.zero_add k).symm).trans ((window_runBy r k 0 i m).trans
    (congrArg (fun es => runBy adopt es (r.state 0) i m) (window_hearings heard k 0)))

/-- The configurations reached from `X` through the hearings `acts`. -/
def heardFrom (adopt : (M → F) → (M → F) → M → Bool) (X : I → M → F) (acts : Nat → Hearing I M) :
    Nat → I → M → F
  | 0 => X
  | n + 1 => hearBy adopt (acts n) (heardFrom adopt X acts n)

/-- The run of the hearings `acts` from `X`. -/
def hearingRun (adopt : (M → F) → (M → F) → M → Bool) (X : I → M → F) (acts : Nat → Hearing I M) :
    Run (process (I := I) adopt) :=
  ⟨heardFrom adopt X acts, acts, fun _ => rfl⟩

/-- **Along runs, an order of hearing forms agreement from every start exactly where it gives
every formation one origin.** Where two forms differ, every run whose hearings are `acts`, from
whatever start, agrees at `m` at step `k` exactly where the first `k` hearings give all
formations one origin at `m`. -/
theorem run_agrees_every_start_iff {a b : F} (apart : a ≠ b) (acts : Nat → Hearing I M) (k : Nat)
    (m : M) :
    (∀ r : Run (process (I := I) (M := M) (F := F) always), (∀ t, r.act t = acts t) →
        ∀ i j, r.state k i m = r.state k j m) ↔
      ∀ i j, origin m (hearings acts 0 k) i = origin m (hearings acts 0 k) j :=
  ⟨fun agree => (agrees_every_start_iff apart (hearings acts 0 k) m).mp fun X i j =>
      (state_hearings (hearingRun always X acts) (fun _ => rfl) k i m).symm.trans
        ((agree _ (fun _ => rfl) i j).trans (state_hearings (hearingRun always X acts) (fun _ => rfl) k j m)),
   fun one r heard i j => (state_hearings r heard k i m).trans
     (((agrees_every_start_iff apart (hearings acts 0 k) m).mpr one (r.state 0) i j).trans
       (state_hearings r heard k j m).symm)⟩

/-- The list `es` as hearings, `fill` after it. -/
def listed (fill : Hearing I M) : List (Hearing I M) → Nat → Hearing I M
  | [], _ => fill
  | e :: _, 0 => e
  | _ :: es, n + 1 => listed fill es n

omit [DecidableEq I] [DecidableEq M] in
theorem hearings_listed (fill : Hearing I M) :
    ∀ es : List (Hearing I M), hearings (listed fill es) 0 es.length = es
  | [] => rfl
  | e :: es => congrArg (e :: ·) ((hearings_shift (listed fill (e :: es)) 0 es.length).trans
      ((hearings_congr (fun _ => rfl) 0 es.length).trans (hearings_listed fill es)))

/-- **Along runs, the forms that can become shared are exactly the forms in use.** Where a list
holds every formation, some run of hearing from `X` brings every formation to the form `x` at `m`
at some step exactly where some formation holds `x` at `m` in `X`. -/
theorem run_shared_iff_in_use {all : List I} (every : ∀ i, i ∈ all) (i₀ : I) (X : I → M → F)
    (m : M) (x : F) :
    (∃ (r : Run (process (I := I) (M := M) (F := F) always)) (k : Nat),
        r.state 0 = X ∧ ∀ i, r.state k i m = x) ↔ ∃ o, X o m = x :=
  ⟨fun ⟨r, k, start, shared⟩ => (shared_iff_in_use every i₀ X m x).mp
      ⟨r.window 0 k, Eq.subst (motive := fun Y => ∀ i, runBy always (r.window 0 k) Y i m = x) start
        fun i => (window_runBy r k 0 i m).symm.trans
          ((congrArg (fun t => r.state t i m) (Nat.zero_add k)).trans (shared i))⟩,
   fun used => match (shared_iff_in_use every i₀ X m x).mpr used with
    | ⟨es, shared⟩ =>
      ⟨hearingRun always X (listed ⟨i₀, i₀, m⟩ es), es.length, rfl, fun i =>
        (state_hearings (hearingRun always X (listed ⟨i₀, i₀, m⟩ es)) (fun _ => rfl) es.length i m).trans
          ((congrArg (fun es' => runBy always es' X i m) (hearings_listed ⟨i₀, i₀, m⟩ es)).trans
            (shared i))⟩⟩

end Hearing

/-! ## Taking a code at once through a pointer -/

section Following

variable {I : Type u} {M : Type v} {F : Type w}

/-- Every formation takes at once the code of the formation `p` points it to (for instance the
least-indexed formation it couples with, itself included). -/
def follow (p : I → I) (X : I → M → F) : I → M → F := fun i => X (p i)

/-- **Following, each formation holds the start's code of where its pointer leads**: at step `n`
of the law's run, the code the start gave the formation `n` steps along `p`. -/
theorem follow_state (p : I → I) (X : I → M → F) :
    ∀ n i, (Law.run (follow p) X).state n i = X (Law.orbit p i n)
  | 0, _ => rfl
  | n + 1, i => (follow_state p X n (p i)).trans (congrArg X (Law.orbit_shift p i n).symm)

/-- **Following brings every start to agreement exactly where the pointer's paths have met.**
Where two forms differ, the run from every start agrees at `m` at step `n` exactly where any two
formations lead, `n` steps along `p`, to one formation. -/
theorem follow_agrees_iff [DecidableEq I] [DecidableEq M] {a b : F} (apart : a ≠ b) (p : I → I)
    (n : Nat) (m : M) :
    (∀ (X : I → M → F) i j,
        (Law.run (follow p) X).state n i m = (Law.run (follow p) X).state n j m) ↔
      ∀ i j, Law.orbit p i n = Law.orbit p j n :=
  ⟨fun agree i j =>
    match decEq (Law.orbit p i n) (Law.orbit p j n) with
    | isTrue same => same
    | isFalse differ =>
      have reached : marked (M := M) (Law.orbit p i n) a b (Law.orbit p i n) m =
          marked (M := M) (Law.orbit p i n) a b (Law.orbit p j n) m :=
        (congrFun (follow_state p _ n i) m).symm.trans
          ((agree _ i j).trans (congrFun (follow_state p _ n j) m))
      absurd ((if_pos rfl).symm.trans (reached.trans (if_neg fun h => differ h.symm))) apart,
   fun met X i j => (congrFun (follow_state p X n i) m).trans
     ((congrArg (fun k => X k m) (met i j)).trans (congrFun (follow_state p X n j) m).symm)⟩

end Following

/-! ## Reading across -/

section Reading

variable {M : Type v} {F : Type w}

/-- A code tells the senses apart: no two senses share a form. -/
def TellsApart (c : M → F) : Prop := ∀ n n', c n = c n' → n = n'

/-- A formation with code `c` reads the form `x` as the sense `n` where `c` gives `n` the form
`x`. -/
def ReadsAs (c : M → F) (x : F) (n : M) : Prop := c n = x

/-- **A code reads its own forms back as their senses exactly where it tells the senses
apart.** -/
theorem self_reads_iff (c : M → F) : (∀ m n, ReadsAs c (c m) n ↔ n = m) ↔ TellsApart c :=
  ⟨fun reads n n' same => ((reads n' n).mp same),
   fun tells m n => ⟨fun r => tells n m r, fun e => congrArg c e⟩⟩

/-- **One formation reads another's form for a sense as that sense, and only it, exactly where
their codes agree there**, given that the reader's code tells the senses apart. -/
theorem reads_iff {cf cg : M → F} (tells : TellsApart cg) (m : M) :
    (∀ n, ReadsAs cg (cf m) n ↔ n = m) ↔ cf m = cg m :=
  ⟨fun reads => ((reads m).mpr rfl).symm,
   fun same n => ⟨fun r => tells n m (r.trans same), fun e => (congrArg cg e).trans same.symm⟩⟩

/-- **A form read as another sense.** Where the reader's code tells the senses apart and gives
another sense `n` the form the speaker gives `m`, the reader reads it as `n` and not as `m`. -/
theorem reads_other {cf cg : M → F} (tells : TellsApart cg) {m n : M} (ne : n ≠ m)
    (crossed : cg n = cf m) : ReadsAs cg (cf m) n ∧ ¬ ReadsAs cg (cf m) m :=
  ⟨crossed, fun r => ne (tells n m (crossed.trans r.symm))⟩

/-- **A renaming that tells forms apart keeps which senses a code tells apart**: the forms are
free, the grouping of senses is not. -/
theorem renamed_tells_apart_iff {F' : Type w} {σ : F → F'} (injective : ∀ x y, σ x = σ y → x = y)
    (c : M → F) : TellsApart (fun n => σ (c n)) ↔ TellsApart c :=
  ⟨fun tells n n' same => tells n n' (congrArg σ same),
   fun tells n n' same => tells n n' (injective _ _ same)⟩

/-- **Renaming the forms of a description changes nothing of what goes alike under it**: for
every process and every renaming that tells forms apart, configurations alike under the renamed
description go alike under it exactly where they do under the description. -/
theorem renamed_goAlike_iff {S : Type u} {A : Type v} {K : Type w} {K' : Type w} {P : Process S A}
    {π : S → K} {σ : K → K'} (injective : ∀ x y, σ x = σ y → x = y) :
    GoAlike P (fun s => σ (π s)) ↔ GoAlike P π :=
  ⟨fun alike s s' a u u' same step step' =>
    injective _ _ (alike s s' a u u' (congrArg σ same) step step'),
   fun alike s s' a u u' same step step' =>
    congrArg σ (alike s s' a u u' (injective _ _ same) step step')⟩

/-- **The forms are free; the carrying is not.** A description renamed by a renaming that tells
forms apart carries a law of the process exactly where the description does
(`carries_law_iff`). -/
theorem renamed_carries_iff {S : Type u} {A : Type v} {K : Type w} {K' : Type w} {P : Process S A}
    {π : S → K} {σ : K → K'} (injective : ∀ x y, σ x = σ y → x = y) :
    (∃ Q : Process K' A, Determined Q ∧ FactorsThrough P (fun s => σ (π s)) Q) ↔
      ∃ Q : Process K A, Determined Q ∧ FactorsThrough P π Q :=
  carries_law_iff.trans ((renamed_goAlike_iff injective).trans carries_law_iff.symm)


/-! ### The course of forms -/

/-- The course taking `a` at the first step and `b` at every later one. -/
def firstThen (a b : M) : Nat → M
  | 0 => a
  | _ + 1 => b

/-- **A code's course of forms has the states of every course of senses exactly where the code
tells the senses apart.** Two moments are one state of the course of forms of a course of senses
through `c` exactly where they are one state of the course of senses, for every course, exactly
where no two senses share a form; where two do, the course of forms of `firstThen` merges two
moments its senses tell apart. -/
theorem course_states_iff (c : M → F) :
    (∀ (m : Nat → M) t t', SameAhead (fun n => c (m n)) t t' ↔ SameAhead m t t') ↔
      TellsApart c :=
  ⟨fun every a b same =>
    have merged : SameAhead (fun n => c (firstThen a b n)) 0 1 := fun n =>
      match n with
      | 0 => same
      | _ + 1 => rfl
    (every (firstThen a b) 0 1).mp merged 0,
   fun tells _ _ _ => ⟨fun same n => tells _ _ (same n), fun same n => congrArg c (same n)⟩⟩

open Segmentation CrossSituational in
/-- **A course of meanings read off a course of forms.** Where grouping by `r` recovers the words
of every encoded sequence and resolution among the repertoire reads every encoded sequence as
the meanings of its words, resolution reads the form of every course of words as its meaning at
each step (by `CrossSituational.reads_every_iff`, each word's bearing records separate its
meaning): the course of meanings is the course of forms read through the resolution. So two
moments that are one state of the course of forms are one state of the course of meanings. -/
theorem course_read [DecidableEq M] {α : Type u} {W : Type v} {R : Type w} (r : α → α → Bool)
    (word : W → List α) (meaning : W → M) (bears : List α → R → Bool) (offers : R → M → Bool)
    {rep : List M} (distinct : Distinct rep) (rs : List R)
    (segments : ∀ ws, chunks r (encode word ws) = ws.map word)
    (every : ∀ ws, readAll (fun f => unique (candidates (bears f) offers rep rs))
      (chunks r (encode word ws)) = some (ws.map meaning))
    (ws : Nat → W) :
    (∀ n, unique (candidates (bears (word (ws n))) offers rep rs) = some (meaning (ws n))) ∧
      ∀ t t', SameAhead (fun n => word (ws n)) t t' → SameAhead (fun n => meaning (ws n)) t t' :=
  have read : ∀ w, unique (candidates (bears (word w)) offers rep rs) = some (meaning w) :=
    fun w => (resolves_iff distinct).mpr
      ((CrossSituational.reads_every_iff r word meaning bears offers distinct rs segments).mp
        every w)
  ⟨fun n => read (ws n),
   fun _ _ same n => Option.some.inj ((read _).symm.trans
     ((congrArg (fun f => unique (candidates (bears f) offers rep rs)) (same n)).trans
       (read _)))⟩

open Segmentation CrossSituational in
/-- **A code whose every sequence of forms resolution reads back tells the senses apart, and its
course of forms has the states of every course of senses.** Where grouping recovers the forms of
every encoded sequence of senses and resolution reads every such sequence as its senses, no two
senses share a form, so through the code the course of forms and the course of senses are one
state at the same moments. -/
theorem code_read_every [DecidableEq M] {α : Type w} {R : Type w} (r : α → α → Bool)
    (c : M → List α) (bears : List α → R → Bool) (offers : R → M → Bool) {rep : List M}
    (distinct : Distinct rep) (rs : List R)
    (segments : ∀ ms, chunks r (encode c ms) = ms.map c)
    (every : ∀ ms, readAll (fun f => unique (candidates (bears f) offers rep rs))
      (chunks r (encode c ms)) = some (ms.map fun m => m)) :
    TellsApart c ∧ ∀ (m : Nat → M) t t', SameAhead (fun n => c (m n)) t t' ↔ SameAhead m t t' :=
  have tells : TellsApart c := fun a b same =>
    (course_read r c (fun m => m) bears offers distinct rs segments every (firstThen a b)).2 0 1
      (fun n => match n with
        | 0 => same
        | _ + 1 => rfl) 0
  ⟨tells, (course_states_iff c).mpr tells⟩

variable {I : Type u} [DecidableEq I] [DecidableEq M]

/-- **A hearing keeps the hearer's code telling senses apart exactly where the form it takes is
not one the hearer gives another sense.** -/
theorem keeps_apart_iff {e : Hearing I M} {X : I → M → F} (tells : TellsApart (X e.hearer)) :
    TellsApart (hear e X e.hearer) ↔ ∀ n, n ≠ e.sense → X e.hearer n ≠ X e.speaker e.sense :=
  have heard : hear e X e.hearer e.sense = X e.speaker e.sense := hearBy_taken rfl
  have other : ∀ n, n ≠ e.sense → hear e X e.hearer n = X e.hearer n := fun _ ne =>
    hearBy_other (.inr ne)
  ⟨fun after n ne clash => ne (after n e.sense ((other n ne).trans (clash.trans heard.symm))),
   fun free n n' same =>
    match decEq n e.sense, decEq n' e.sense with
    | isTrue h, isTrue h' => h.trans h'.symm
    | isTrue h, isFalse h' =>
      absurd ((other n' h').symm.trans (same.symm.trans (h ▸ heard))) (free n' h')
    | isFalse h, isTrue h' =>
      absurd ((other n h).symm.trans (same.trans (h' ▸ heard))) (free n h)
    | isFalse h, isFalse h' => tells n n' ((other n h).symm.trans (same.trans (other n' h')))⟩

/-- **Along a run of hearings that take the form heard, a step keeps the hearer's code telling
senses apart exactly where the form it takes is not one the hearer gives another sense.** -/
theorem run_keeps_apart_iff (r : Run (process (I := I) (M := M) (F := F) always)) (n : Nat)
    (tells : TellsApart (r.state n (r.act n).hearer)) :
    TellsApart (r.state (n + 1) (r.act n).hearer) ↔
      ∀ m, m ≠ (r.act n).sense →
        r.state n (r.act n).hearer m ≠ r.state n (r.act n).speaker (r.act n).sense :=
  Eq.subst (motive := fun Y : I → M → F => TellsApart (Y (r.act n).hearer) ↔
      ∀ m, m ≠ (r.act n).sense →
        r.state n (r.act n).hearer m ≠ r.state n (r.act n).speaker (r.act n).sense)
    (r.step n).symm (keeps_apart_iff tells)

/-- **Along a run, formations that keep agreeing keep reading each other.** Where `f` and `g`
agree at `m` from step `n` under hearings closed for them, at every later step at which `g`'s
code tells the senses apart, `g` reads `f`'s form for `m` as `m` and only `m`. -/
theorem run_reads_kept {adopt : (M → F) → (M → F) → M → Bool} (r : Run (process adopt)) {n : Nat}
    {m : M} {f g : I} (agree : r.state n f m = r.state n g m)
    (between : ∀ k, (r.act (n + k)).sense = m →
      ((r.act (n + k)).hearer = f ∨ (r.act (n + k)).hearer = g) →
        (r.act (n + k)).speaker = f ∨ (r.act (n + k)).speaker = g) (k : Nat)
    (tells : TellsApart (r.state (n + k) g)) :
    ∀ n', ReadsAs (r.state (n + k) g) (r.state (n + k) f m) n' ↔ n' = m :=
  (reads_iff tells m).mpr (pair_kept r agree between k)

/-- **At every step of a run, a formation reads another's form for a sense as that sense, and
only it, exactly where their codes agree there; where the reader gives another sense that form,
it reads that sense.** -/
theorem run_reads_iff {adopt : (M → F) → (M → F) → M → Bool} (r : Run (process (I := I) adopt))
    (n : Nat) {f g : I} (tells : TellsApart (r.state n g)) (m : M) :
    ((∀ n', ReadsAs (r.state n g) (r.state n f m) n' ↔ n' = m) ↔ r.state n f m = r.state n g m) ∧
      ∀ n', n' ≠ m → r.state n g n' = r.state n f m →
        ReadsAs (r.state n g) (r.state n f m) n' ∧ ¬ ReadsAs (r.state n g) (r.state n f m) m :=
  ⟨reads_iff tells m, fun _ ne crossed => reads_other tells ne crossed⟩

end Reading

/-! ## Symmetry: no form and no formation privileged -/

section Symmetry

variable {I : Type u} {M : Type v} {F : Type w}

/-- `Y` is `X` with the formations exchanged by `π` and, at each sense, the forms renamed by
`τ`. -/
def Relabels (π : I → I) (τ : M → F → F) (X Y : I → M → F) : Prop := ∀ i m, Y i m = τ m (X (π i) m)

/-- A law of codes keeps the exchange of formations by `π`: it privileges none of the formations
`π` exchanges. -/
def KeepsExchange (T : (I → M → F) → I → M → F) (π : I → I) : Prop :=
  Law.KeepsRelation T (Relabels π fun _ x => x)

/-- A law of codes keeps the renaming of forms by `τ`: it privileges none of the forms `τ`
exchanges. -/
def KeepsRenaming (T : (I → M → F) → I → M → F) (τ : M → F → F) : Prop :=
  Law.KeepsRelation T (Relabels (fun i => i) τ)

variable {T : (I → M → F) → I → M → F} {π : I → I} {τ : M → F → F}

/-- **Keeping both, a law keeps the two together.** -/
theorem keeps_both (exchanges : KeepsExchange T π) (renames : KeepsRenaming T τ) :
    Law.KeepsRelation T (Relabels π τ) :=
  fun X Y image =>
    have exchanged : Relabels π (fun _ x => x) X (fun i m => X (π i) m) := fun _ _ => rfl
    have renamed : Relabels (fun i => i) τ (fun i m => X (π i) m) Y := image
    fun i m => (renames _ _ renamed i m).trans (congrArg (τ m) (exchanges _ _ exchanged i m))

/-- **Formations that a kept symmetry exchanges agree only on a form the renaming fixes.** -/
theorem agrees_only_fixed (keeps : Law.KeepsRelation T (Relabels π τ)) {X : I → M → F}
    (symmetric : Relabels π τ X X) (n : Nat) (i : I) (m : M)
    (agree : (Law.run T X).state n i m = (Law.run T X).state n (π i) m) :
    τ m ((Law.run T X).state n i m) = (Law.run T X).state n i m :=
  (congrArg (τ m) agree).trans (Law.KeepsRelation.run keeps symmetric n i m).symm

/-- **Agreement needs a broken symmetry.** Where the renaming moves every form at `m`, a law
keeping the exchange of formations by `π` together with that renaming never brings formations it
exchanges, from a start symmetric under them, to agree at `m`. -/
theorem never_agrees (keeps : Law.KeepsRelation T (Relabels π τ)) {X : I → M → F}
    (symmetric : Relabels π τ X X) {m : M} (moves : ∀ x, τ m x ≠ x) (n : Nat) (i : I) :
    (Law.run T X).state n i m ≠ (Law.run T X).state n (π i) m :=
  fun agree => moves _ (agrees_only_fixed keeps symmetric n i m agree)

/-- **A law that privileges neither formation nor form does not form agreement from a symmetric
disagreement.** -/
theorem never_agrees_of_both (exchanges : KeepsExchange T π) (renames : KeepsRenaming T τ)
    {X : I → M → F} (symmetric : Relabels π τ X X) {m : M} (moves : ∀ x, τ m x ≠ x) (n : Nat)
    (i : I) : (Law.run T X).state n i m ≠ (Law.run T X).state n (π i) m :=
  never_agrees (keeps_both exchanges renames) symmetric moves n i

/-- The exchange of two formations' forms at one sense, the forms renamed by `τ`. -/
def exchange (τ : F → F) (p : F × F) : F × F := (τ p.2, τ p.1)

/-- **The same, for a law commuting with the exchange** (`Law.Commutes.keepsRelation`, the
relational form of `Law.Commutes.keeps_fixed`): from a pair the exchange fixes, the two agree only
on a form `τ` fixes. -/
theorem pair_agrees_only_fixed {T : F × F → F × F} {τ : F → F}
    (commutes : Law.Commutes T (exchange τ)) {p : F × F} (fixed : exchange τ p = p) (n : Nat)
    (agree : ((Law.run T p).state n).1 = ((Law.run T p).state n).2) :
    τ ((Law.run T p).state n).1 = ((Law.run T p).state n).1 :=
  (congrArg τ agree).trans (congrArg Prod.fst (commutes.keepsRelation.run fixed.symm n)).symm

/-- With two forms exchanged, a law commuting with exchanging the formations together with the
forms never resolves a disagreement. -/
theorem pair_never_agrees {T : Bool × Bool → Bool × Bool} (commutes : Law.Commutes T (exchange not))
    {p : Bool × Bool} (fixed : exchange not p = p) (n : Nat) :
    ((Law.run T p).state n).1 ≠ ((Law.run T p).state n).2 :=
  fun agree => match ((Law.run T p).state n).1, pair_agrees_only_fixed commutes fixed n agree with
    | false, h => Bool.noConfusion h
    | true, h => Bool.noConfusion h

variable [DecidableEq I] [DecidableEq M]

/-- **Hearing under a rule that reads codes alike after a renaming keeps the renaming**: no form
is privileged by hearing. -/
theorem hearBy_keeps_renaming {adopt : (M → F) → (M → F) → M → Bool}
    (reads : ∀ X Y : I → M → F, Relabels (fun i => i) τ X Y → ∀ e : Hearing I M,
      adopt (Y e.hearer) (Y e.speaker) e.sense = adopt (X e.hearer) (X e.speaker) e.sense)
    (e : Hearing I M) : KeepsRenaming (hearBy adopt e) τ :=
  fun X Y renamed i m =>
    match decEq i e.hearer, decEq m e.sense with
    | isTrue h, isTrue h' =>
      match hb : adopt (X e.hearer) (X e.speaker) e.sense with
      | true =>
        have hb' : adopt (Y e.hearer) (Y e.speaker) e.sense = true := (reads X Y renamed e).trans hb
        ((if_pos h).trans ((if_pos h').trans (if_pos hb'))).trans
          ((renamed e.speaker m).trans
            (congrArg (τ m) ((if_pos h).trans ((if_pos h').trans (if_pos hb))).symm))
      | false =>
        have hb' : adopt (Y e.hearer) (Y e.speaker) e.sense = false :=
          (reads X Y renamed e).trans hb
        (hearBy_refused hb' i m).trans
          ((renamed i m).trans (congrArg (τ m) (hearBy_refused hb i m).symm))
    | isTrue _, isFalse h' =>
      (hearBy_other (.inr h')).trans ((renamed i m).trans (congrArg (τ m) (hearBy_other (.inr h')).symm))
    | isFalse h, _ =>
      (hearBy_other (.inl h)).trans ((renamed i m).trans (congrArg (τ m) (hearBy_other (.inl h)).symm))

/-- Hearing that takes the form heard keeps every renaming of forms. -/
theorem hear_keeps_renaming (e : Hearing I M) : KeepsRenaming (hear (F := F) e) τ :=
  hearBy_keeps_renaming (fun _ _ _ _ => rfl) e

/-- **No form is privileged by an order of exchange.** Two runs of hearing through the same order
from starts that differ by a renaming of forms differ by that renaming at every step. -/
theorem run_renamed {adopt : (M → F) → (M → F) → M → Bool}
    (reads : ∀ X Y : I → M → F, Relabels (fun i => i) τ X Y → ∀ e : Hearing I M,
      adopt (Y e.hearer) (Y e.speaker) e.sense = adopt (X e.hearer) (X e.speaker) e.sense)
    (r r' : Run (process (I := I) adopt)) (same : ∀ n, r'.act n = r.act n)
    (renamed : Relabels (fun i => i) τ (r.state 0) (r'.state 0)) :
    ∀ n, Relabels (fun i => i) τ (r.state n) (r'.state n)
  | 0 => renamed
  | n + 1 => fun i m =>
    (step_at r' n i m).trans
      ((congrArg (fun e => hearBy adopt e (r'.state n) i m) (same n)).trans
        ((hearBy_keeps_renaming reads (r.act n) _ _ (run_renamed reads r r' same renamed n) i m).trans
          (congrArg (τ m) (step_at r n i m).symm)))

/-- **The form reached is not fixed by the sense.** Through one order, starts differing by a
renaming reach forms that agree exactly where the renaming fixes the form reached. -/
theorem reached_differ_iff {adopt : (M → F) → (M → F) → M → Bool}
    (reads : ∀ X Y : I → M → F, Relabels (fun i => i) τ X Y → ∀ e : Hearing I M,
      adopt (Y e.hearer) (Y e.speaker) e.sense = adopt (X e.hearer) (X e.speaker) e.sense)
    (r r' : Run (process (I := I) adopt)) (same : ∀ n, r'.act n = r.act n)
    (renamed : Relabels (fun i => i) τ (r.state 0) (r'.state 0)) (n : Nat) (i : I) (m : M) :
    r'.state n i m = r.state n i m ↔ τ m (r.state n i m) = r.state n i m :=
  have at_n := run_renamed reads r r' same renamed n i m
  ⟨fun e => at_n.symm.trans e, fun e => at_n.trans e⟩

/-- **Along runs from starts that differ by a renaming telling forms apart, each code tells apart,
at every step, exactly what the other tells apart**: the forms are free, the grouping of senses
is not. -/
theorem run_renamed_tells_apart_iff {adopt : (M → F) → (M → F) → M → Bool} {σ : F → F}
    (injective : ∀ x y, σ x = σ y → x = y)
    (reads : ∀ X Y : I → M → F, Relabels (fun i => i) (fun _ => σ) X Y → ∀ e : Hearing I M,
      adopt (Y e.hearer) (Y e.speaker) e.sense = adopt (X e.hearer) (X e.speaker) e.sense)
    (r r' : Run (process (I := I) adopt)) (same : ∀ n, r'.act n = r.act n)
    (renamed : Relabels (fun i => i) (fun _ => σ) (r.state 0) (r'.state 0)) (n : Nat) (i : I) :
    TellsApart (r'.state n i) ↔ TellsApart (r.state n i) :=
  have at_n := run_renamed (τ := fun _ => σ) reads r r' same renamed n i
  ⟨fun tells => (renamed_tells_apart_iff injective (r.state n i)).mp fun m m' e =>
      tells m m' ((at_n m).trans (e.trans (at_n m').symm)),
   fun tells m m' e => (renamed_tells_apart_iff injective (r.state n i)).mpr tells m m'
      ((at_n m).symm.trans (e.trans (at_n m')))⟩

end Symmetry

/-! ## Imposed codes -/

section Imposed

variable {I : Type u} {M : Type v} {F : Type w}

/-- The code `c` imposed: every formation's code replaced by `c`. -/
def impose (c : M → F) (_ : I → M → F) : I → M → F := fun _ => c

/-- From `X` to `Y`, the formation `i` loses the distinction between `m` and `m'`: its code told
them apart at `X` and gives them one form at `Y`. -/
def Loses (X Y : I → M → F) (i : I) (m m' : M) : Prop := X i m ≠ X i m' ∧ Y i m = Y i m'

/-- **An imposed code makes every formation agree**, at every sense. -/
theorem impose_agrees (c : M → F) (X : I → M → F) (i j : I) (m : M) :
    impose c X i m = impose c X j m := rfl

/-- **Imposing a code privileges no formation**: it keeps every exchange of formations. -/
theorem impose_keeps_exchange (c : M → F) (π : I → I) : KeepsExchange (impose (I := I) c) π :=
  fun _ _ _ _ _ => rfl

/-- **Imposing a code privileges its forms.** Where a renaming moves the form the code gives a
sense, imposing does not keep it: from a symmetric disagreement agreement comes only through a law
privileging a form or a formation (`never_agrees_of_both`), and imposing privileges forms. -/
theorem impose_privileges_forms {c : M → F} {τ : M → F → F} {m : M} (moves : τ m (c m) ≠ c m)
    (X : I → M → F) (i : I) : ¬ KeepsRenaming (impose (I := I) c) τ :=
  fun keeps => moves (keeps X (fun j n => τ n (X j n)) (fun _ _ => rfl) i m).symm

/-- **Each formation loses exactly the distinctions its code made that the imposed code
merges.** -/
theorem impose_loses_iff {c : M → F} {X : I → M → F} {i : I} {m m' : M} :
    Loses X (impose c X) i m m' ↔ X i m ≠ X i m' ∧ c m = c m' := Iff.rfl

/-- **The formation whose code is imposed loses nothing.** -/
theorem source_loses_nothing {X : I → M → F} (q : I) (m m' : M) : ¬ Loses X (impose (X q) X) q m m' :=
  fun ⟨told, merged⟩ => told merged

variable [DecidableEq I] [DecidableEq M]

/-- **A form every formation holds at a sense stays under every later order of exchange**, under
every rule. -/
theorem held_stays (adopt : (M → F) → (M → F) → M → Bool) {X : I → M → F} {m : M} {x : F}
    (held : ∀ j, X j m = x) (es : List (Hearing I M)) (i : I) : runBy adopt es X i m = x :=
  match runBy_held (adopt := adopt) es X i m with
  | ⟨j, h⟩ => h.trans (held j)

/-- **Along every run from an imposition, the imposed code stays**, and with it every merge. -/
theorem run_imposed_stays {adopt : (M → F) → (M → F) → M → Bool} (r : Run (process adopt)) {n : Nat}
    {c : M → F} (imposed : ∀ i m, r.state n i m = c m) (k : Nat) (i : I) (m : M) :
    r.state (n + k) i m = c m :=
  (window_runBy r k n i m).trans (held_stays adopt (fun j => imposed j m) (r.window n k) i)

/-- **A merged distinction comes back only from a form kept outside the imposition.** Along a run,
from a step at which the members of a group hold the imposed form at `m` and every formation
outside the group holds it too, every formation holds it at `m` at every later step, under every
rule. -/
theorem outside_needed {adopt : (M → F) → (M → F) → M → Bool} (r : Run (process adopt)) {n : Nat}
    {G : I → Bool} {c : M → F} {m : M} (imposed : ∀ i, G i = true → r.state n i m = c m)
    (kept : ∀ j, G j = false → r.state n j m = c m) (k : Nat) (i : I) : r.state (n + k) i m = c m :=
  (window_runBy r k n i m).trans (held_stays adopt (fun j => match hj : G j with
    | true => imposed j hj
    | false => kept j hj) (r.window n k) i)

/-- **From any form kept outside, the distinction comes back at once.** Where `h` holds the imposed
form at `m'` and hears, at `m`, a formation whose form at `m` is not the imposed one, `h` then
tells `m` from `m'` although the imposed code merges them. -/
theorem outside_returns (r : Run (process (I := I) (M := M) (F := F) always)) {n : Nat}
    {c : M → F} {h j : I} {m m' : M} (heard : r.act n = ⟨h, j, m⟩) (ne : m' ≠ m)
    (kept : r.state n j m ≠ c m) (imposed : r.state n h m' = c m') (merged : c m = c m') :
    r.state (n + 1) h m ≠ r.state (n + 1) h m' :=
  fun same =>
    have atm : r.state (n + 1) h m = r.state n j m :=
      (step_at r n h m).trans ((congrArg (fun e => hearBy always e (r.state n) h m) heard).trans
        (hearBy_taken (e := ⟨h, j, m⟩) (X := r.state n) rfl))
    have atm' : r.state (n + 1) h m' = c m' :=
      (step_at r n h m').trans ((congrArg (fun e => hearBy always e (r.state n) h m') heard).trans
        ((hearBy_other (e := ⟨h, j, m⟩) (.inr ne)).trans imposed))
    kept (atm.symm.trans (same.trans (atm'.trans merged.symm)))

/-- **Along every run of hearing from an imposition, what the imposition does stays.** From a step
at which every formation holds the code `c`, at every later step and under every rule all agree at
every sense; each formation reads every other at every sense exactly where `c` tells the senses
apart; against the codes `X` held before, each formation has lost exactly what its code told
apart and `c` merges; and a formation whose code was imposed has lost nothing. -/
theorem run_from_imposition {adopt : (M → F) → (M → F) → M → Bool} (r : Run (process adopt))
    {n : Nat} {c : M → F} (imposed : ∀ i m, r.state n i m = c m) (X : I → M → F) (k : Nat) :
    (∀ i j m, r.state (n + k) i m = r.state (n + k) j m) ∧
    (∀ i j, (∀ m n', ReadsAs (r.state (n + k) i) (r.state (n + k) j m) n' ↔ n' = m) ↔
      TellsApart c) ∧
    (∀ i m m', Loses X (r.state (n + k)) i m m' ↔ X i m ≠ X i m' ∧ c m = c m') ∧
    (∀ q, (∀ m, c m = X q m) → ∀ m m', ¬ Loses X (r.state (n + k)) q m m') :=
  have stays : ∀ i m, r.state (n + k) i m = impose c X i m := run_imposed_stays r imposed k
  have loses : ∀ i m m', Loses X (r.state (n + k)) i m m' ↔ Loses X (impose c X) i m m' :=
    fun i m m' => ⟨fun ⟨told, merged⟩ => ⟨told, (stays i m).symm.trans (merged.trans (stays i m'))⟩,
      fun ⟨told, merged⟩ => ⟨told, (stays i m).trans (merged.trans (stays i m').symm)⟩⟩
  ⟨fun i j m => (stays i m).trans ((impose_agrees c X i j m).trans (stays j m).symm),
   fun i j =>
    have same : ∀ m n', ReadsAs (r.state (n + k) i) (r.state (n + k) j m) n' ↔
        ReadsAs (impose c X i) (impose c X j m) n' :=
      fun m n' => ⟨fun h => (stays i n').symm.trans (h.trans (stays j m)),
        fun h => (stays i n').trans (h.trans (stays j m).symm)⟩
    (⟨fun h m n' => (same m n').symm.trans (h m n'), fun h m n' => (same m n').trans (h m n')⟩ :
      (∀ m n', ReadsAs (r.state (n + k) i) (r.state (n + k) j m) n' ↔ n' = m) ↔
        ∀ m n', ReadsAs (impose c X i) (impose c X j m) n' ↔ n' = m).trans (SharedCodes.self_reads_iff c),
   fun i m m' => (loses i m m').trans impose_loses_iff,
   fun q source m m' lost => match (loses q m m').mp lost with
    | ⟨told, merged⟩ => source_loses_nothing q m m' ⟨told, (source m).symm.trans (merged.trans (source m'))⟩⟩

end Imposed

/-! ## Readings written back -/

section WrittenBack

open CrossSituational

variable {R : Type u} {M : Type v}

/-- What the records resolve the form to: their unique candidate, if there is one. -/
def resolve (bears : R → Bool) (offers : R → M → Bool) (rep : List M) (rs : List R) : Option M :=
  unique (candidates bears offers rep rs)

/-- One generation reading the previous generation's records: it resolves the form from them and
writes a record of what it resolved; where they leave the form unresolved, they pass on as they
were. -/
def nextCohort (bears : R → Bool) (offers : R → M → Bool) (rep : List M) (writes : M → R)
    (rs : List R) : List R :=
  match resolve bears offers rep rs with
  | some e => [writes e]
  | none => rs

/-- One generation keeping the records it read: it adds a record of what it resolved. -/
def keep (bears : R → Bool) (offers : R → M → Bool) (rep : List M) (writes : M → R)
    (rs : List R) : List R :=
  match resolve bears offers rep rs with
  | some e => rs ++ [writes e]
  | none => rs

/-- The record `writes e` bears on the form and offers `e` and nothing else. -/
def WritesExactly (bears : R → Bool) (offers : R → M → Bool) (writes : M → R) : Prop :=
  ∀ e, bears (writes e) = true ∧ offers (writes e) e = true ∧ ∀ n, n ≠ e → offers (writes e) n = false

variable {bears : R → Bool} {offers : R → M → Bool} {rep : List M} {writes : M → R}

theorem resolve_mem {rs : List R} {e : M} (h : resolve bears offers rep rs = some e) : e ∈ rep :=
  mem_candidates.mp ((unique_eq_some_iff.mp h) ▸ List.Mem.head []) |>.1

theorem nextCohort_of_resolved {rs : List R} {e : M} (h : resolve bears offers rep rs = some e) :
    nextCohort bears offers rep writes rs = [writes e] := by
  unfold nextCohort
  rw [h]

/-- **A record of `e` alone resolves the form to `e`.** -/
theorem resolve_written [DecidableEq M] (exact : WritesExactly bears offers writes) (distinct : Distinct rep)
    {e : M} (mem : e ∈ rep) : resolve bears offers rep [writes e] = some e :=
  (resolves_iff distinct).mpr
    ⟨mem, fun _ inr _ => (mem_singleton inr) ▸ (exact e).2.1,
     fun m _ ne => ⟨writes e, .head [], (exact e).1, (exact e).2.2 m ne⟩⟩

/-- **A resolution written back rests.** Where the records resolve the form to `e`, every later
generation's records are the record of `e`. -/
theorem written_rests [DecidableEq M] (exact : WritesExactly bears offers writes) (distinct : Distinct rep)
    {rs : List R} {e : M} (h : resolve bears offers rep rs = some e) :
    ∀ n, (Law.run (nextCohort bears offers rep writes) rs).state (n + 1) = [writes e]
  | 0 => nextCohort_of_resolved h
  | n + 1 =>
    (congrArg (nextCohort bears offers rep writes) (written_rests exact distinct h n)).trans
      (nextCohort_of_resolved (resolve_written exact distinct (resolve_mem h)))

/-- **The decision locks**: every generation from the first resolution on resolves the form
alike. -/
theorem every_cohort_resolves [DecidableEq M] (exact : WritesExactly bears offers writes)
    (distinct : Distinct rep) {rs : List R} {e : M} (h : resolve bears offers rep rs = some e) :
    ∀ n, resolve bears offers rep ((Law.run (nextCohort bears offers rep writes) rs).state n) = some e
  | 0 => h
  | n + 1 => (congrArg (resolve bears offers rep) (written_rests exact distinct h n)).trans
      (resolve_written exact distinct (resolve_mem h))

/-- **What came before the resolution is not recovered.** Two histories whose records resolve
the form alike are merged by one generation and stay merged (`Law.merged_stays`). -/
theorem resolved_alike_merged {rs rs' : List R} {e : M} (h : resolve bears offers rep rs = some e)
    (h' : resolve bears offers rep rs' = some e) (n : Nat) :
    (Law.run (nextCohort bears offers rep writes) rs).state (n + 1) =
      (Law.run (nextCohort bears offers rep writes) rs').state (n + 1) :=
  Law.merged_stays ((nextCohort_of_resolved h).trans (nextCohort_of_resolved h').symm) n

/-- **No reading of later records recovers the earlier ones**: every reading of a later
generation's records reads the two histories alike. -/
theorem no_reading_recovers {K : Type w} (reading : List R → K) {rs rs' : List R} {e : M}
    (h : resolve bears offers rep rs = some e) (h' : resolve bears offers rep rs' = some e)
    (n : Nat) :
    reading ((Law.run (nextCohort bears offers rep writes) rs).state (n + 1)) =
      reading ((Law.run (nextCohort bears offers rep writes) rs').state (n + 1)) :=
  congrArg reading (resolved_alike_merged h h' n)

/-- **Writing back merges records**: two different record lists resolving alike are taken to
one (`Law.Merges`), and their runs are one from the next generation on. -/
theorem nextCohort_merges {rs rs' : List R} (apart : rs ≠ rs') {e : M}
    (h : resolve bears offers rep rs = some e) (h' : resolve bears offers rep rs' = some e) :
    Law.Merges (nextCohort bears offers rep writes) ∧
      ∀ n, (Law.run (nextCohort bears offers rep writes) rs).state (n + 1) =
        (Law.run (nextCohort bears offers rep writes) rs').state (n + 1) :=
  ⟨Law.merges_iff.mpr ⟨rs, rs', apart, (nextCohort_of_resolved h).trans (nextCohort_of_resolved h').symm⟩,
   resolved_alike_merged h h'⟩

/-- **Under coverage, the rest is the target**: where every first record bearing on the form
offers the target, the resolution written back is the target. -/
theorem covered_rest [DecidableEq M] (exact : WritesExactly bears offers writes) (distinct : Distinct rep)
    {rs : List R} {t e : M} (available : t ∈ rep)
    (covered : ∀ r, r ∈ rs → bears r = true → offers r t = true)
    (h : resolve bears offers rep rs = some e) (n : Nat) :
    (Law.run (nextCohort bears offers rep writes) rs).state (n + 1) = [writes t] :=
  (written_rests exact distinct h n).trans
    (congrArg (fun x => [writes x]) (resolved_is_target available covered (unique_eq_some_iff.mp h)))

/-- **Under omission, the rest excludes the target for good.** Where the records resolve the form
to `e` other than `t`, at every later generation `t` is no candidate and `e` is: no later record
excludes `e` or offers `t`. -/
theorem omitted_rest [DecidableEq M] (exact : WritesExactly bears offers writes) (distinct : Distinct rep)
    {rs : List R} {t e : M} (ne : t ≠ e) (h : resolve bears offers rep rs = some e) (n : Nat) :
    t ∉ candidates bears offers rep ((Law.run (nextCohort bears offers rep writes) rs).state (n + 1)) ∧
      e ∈ candidates bears offers rep ((Law.run (nextCohort bears offers rep writes) rs).state (n + 1)) :=
  have rest := written_rests (writes := writes) exact distinct h n
  ⟨fun mem =>
    have offered := (mem_candidates.mp (rest ▸ mem)).2 (writes e) (.head []) (exact e).1
    bool_false_ne_true ((exact e).2.2 t ne) offered,
   rest ▸ mem_candidates.mpr ⟨resolve_mem h, fun _ inr _ => (mem_singleton inr) ▸ (exact e).2.1⟩⟩

/-- **Records kept from before bar a different resolution.** Where earlier records resolve the
form to `e` and are kept, the records with any later ones resolve it to `e` or not at all. -/
theorem kept_bars {rs more : List R} {e e' : M} (h : resolve bears offers rep rs = some e)
    (h' : resolve bears offers rep (rs ++ more) = some e') : e' = e :=
  mem_singleton ((unique_eq_some_iff.mp h) ▸
    narrows (more := more) ((unique_eq_some_iff.mp h') ▸ List.Mem.head []))

/-- Records only added to: each step appends the records it adds. -/
def adding : Process (List R) (List R) := ⟨fun rs more rs' => rs' = rs ++ more⟩

/-- Along a run that only adds records, every later list begins with the first. -/
theorem adding_prefix (r : Run (adding (R := R))) : ∀ n, ∃ more, r.state n = r.state 0 ++ more
  | 0 => ⟨[], (ListTests.append_nil _).symm⟩
  | n + 1 =>
    match adding_prefix r n with
    | ⟨more, pre⟩ =>
      ⟨more ++ r.act n, (r.step n).trans ((congrArg (· ++ r.act n) pre).trans (ListTests.append_assoc _ _ _))⟩

/-- **Where records are only added, a resolution can be lost but never replaced.** Along every run
that only adds records, uptakes of outside readings included, no later records resolve the form
to a sense other than the one the first records resolved it to. -/
theorem added_never_replaced (r : Run (adding (R := R))) {e : M}
    (h : resolve bears offers rep (r.state 0) = some e) (n : Nat) {e' : M}
    (h' : resolve bears offers rep (r.state n) = some e') : e' = e :=
  match adding_prefix r n with
  | ⟨_, pre⟩ => kept_bars h (pre ▸ h')

theorem keep_of_resolved {rs : List R} {e : M} (h : resolve bears offers rep rs = some e) :
    keep bears offers rep writes rs = rs ++ [writes e] := by
  unfold keep
  rw [h]

/-- A record of `e` added to records resolving to `e` keeps the resolution. -/
theorem resolve_kept (exact : WritesExactly bears offers writes) {rs : List R} {e : M}
    (h : resolve bears offers rep rs = some e) :
    resolve bears offers rep (rs ++ [writes e]) = some e :=
  have single : candidates bears offers rep rs = [e] := unique_eq_some_iff.mp h
  unique_eq_some_iff.mpr
    ((candidates_snoc_bearing rep rs (exact e).1).trans
      ((congrArg (List.filter (offers (writes e))) single).trans
        (filter_true [] (exact e).2.1)))

/-- **With the records kept, the resolution rests and the first records stay readable**: every
later generation resolves the form alike, and its records begin with the first ones. -/
theorem kept_rests (exact : WritesExactly bears offers writes) {rs : List R} {e : M}
    (h : resolve bears offers rep rs = some e) :
    ∀ n, resolve bears offers rep ((Law.run (keep bears offers rep writes) rs).state n) = some e ∧
      ∃ more, (Law.run (keep bears offers rep writes) rs).state n = rs ++ more
  | 0 => ⟨h, [], (ListTests.append_nil rs).symm⟩
  | n + 1 =>
    match kept_rests exact h n with
    | ⟨resolved, more, pre⟩ =>
      have next : (Law.run (keep bears offers rep writes) rs).state (n + 1) =
          (Law.run (keep bears offers rep writes) rs).state n ++ [writes e] :=
        keep_of_resolved resolved
      ⟨next ▸ resolve_kept exact resolved,
       more ++ [writes e], next.trans ((congrArg (· ++ [writes e]) pre).trans
        (ListTests.append_assoc rs more [writes e]))⟩

end WrittenBack

/-! ## Witnesses -/

/-! Two formations (`true` and `false`) and one sense; the form `true` and the form `false`. -/
/-! ## Synonyms, a coined form, and taking what most hold -/

section Synonyms

variable {M : Type v} {F : Type w}

/-- **Synonyms do no harm, homonyms do.** A code letting a sense hold several forms (`holds m x`:
the sense `m` holds the form `x`) reads every form held back as its sense, and only it, exactly
where no two senses hold one form; a sense may hold as many forms as it likes. -/
theorem synonyms_read_iff (holds : M → F → Prop) :
    (∀ m x, holds m x → ∀ n, holds n x ↔ n = m) ↔ ∀ m n x, holds m x → holds n x → n = m :=
  ⟨fun reads m n x hm hn => (reads m x hm n).mp hn,
   fun apart m x hm n => ⟨fun hn => apart m n x hm hn,
     fun same => Eq.subst (motive := fun k => holds k x) same.symm hm⟩⟩

/-- A code with one form a sense is the case: it reads back exactly where it tells senses apart
(`self_reads_iff`). -/
theorem one_form_reads_iff (c : M → F) :
    (∀ m n x, c m = x → c n = x → n = m) ↔ TellsApart c :=
  ⟨fun apart n n' same => apart n' n (c n') rfl same,
   fun tells m n _ hm hn => tells n m (hn.trans hm.symm)⟩

end Synonyms

section Coining

variable {I : Type u} {M : Type v} {F : Type w} [DecidableEq I] [DecidableEq M]

/-- A formation *coins* the form `x` for the sense `m`: it gives `m` the form `x`, and nothing else
changes. Hearing makes no form (`hearBy_held`); coining does. -/
def coin (i : I) (m : M) (x : F) (X : I → M → F) : I → M → F :=
  fun k n => if k = i then if n = m then x else X k n else X k n

theorem coin_at (i : I) (m : M) (x : F) (X : I → M → F) : coin i m x X i m = x :=
  (if_pos rfl).trans (if_pos rfl)

theorem coin_other_sense {i k : I} {m n : M} (x : F) (X : I → M → F) (ne : n ≠ m) :
    coin i m x X k n = X k n :=
  match decEq k i with
  | isTrue h => (if_pos h).trans (if_neg ne)
  | isFalse h => if_neg h

/-- Hearings all at the sense `m` leave every other sense as it was. -/
theorem runBy_other_sense {adopt : (M → F) → (M → F) → M → Bool} {m n : M} (ne : n ≠ m) :
    ∀ (es : List (Hearing I M)), (∀ e, e ∈ es → e.sense = m) → ∀ (X : I → M → F) (i : I),
      runBy adopt es X i n = X i n
  | [], _, _, _ => rfl
  | e :: es, at_m, X, i =>
    (runBy_other_sense ne es (fun e' mem => at_m e' (.tail e mem)) (hearBy adopt e X) i).trans
      (hearBy_other (.inr fun same => ne (same.trans (at_m e (.head es)))))

/-- **A coined form, heard by all, brings back a merged distinction.** Where every formation holds
a code that merges `m` and `m'`, a formation coining at `m` a form the code does not give `m'`,
and every formation then hearing it at `m`, every formation tells `m` from `m'` again. -/
theorem coined_returns {all : List I} (every : ∀ i, i ∈ all) {c : M → F} {m m' : M}
    (ne : m' ≠ m) (o : I) {x : F} (fresh : x ≠ c m') (X : I → M → F) (j : I) :
    runBy always (broadcast o m all) (coin o m x (impose c X)) j m ≠
      runBy always (broadcast o m all) (coin o m x (impose c X)) j m' :=
  fun same => fresh (((broadcast_reaches every o m _ j).trans (coin_at o m x _)).symm.trans
    (same.trans ((runBy_other_sense ne _ (fun _ mem => match ListTests.mem_map_iff.mp mem with
      | ⟨_, _, made⟩ => made ▸ rfl) _ j).trans (coin_other_sense x _ ne))))

end Coining

section Majority

variable {I : Type u} {M : Type v} {F : Type w} [DecidableEq F]

/-- How many formations of `all` hold the form `x` at `m`. -/
def holders (all : List I) (X : I → M → F) (m : M) (x : F) : Nat :=
  (all.filter fun k => decide (X k m = x)).length

/-- **Taking what most hold**: each formation takes, at each sense, a form more than half of `all`
hold there, where there is one, and otherwise keeps its own. -/
def majority (all : List I) (X : I → M → F) : I → M → F := fun i m =>
  match all.find? (fun j => decide (all.length < 2 * holders all X m (X j m))) with
  | some j => X j m
  | none => X i m

/-- **Taking what most hold makes no form**: every form after it was held by some formation. -/
theorem majority_held (all : List I) (X : I → M → F) (i : I) (m : M) :
    ∃ j, majority all X i m = X j m := by
  unfold majority
  cases all.find? (fun j => decide (all.length < 2 * holders all X m (X j m))) with
  | none => exact ⟨i, rfl⟩
  | some j => exact ⟨j, rfl⟩

end Majority

namespace Majority

/-- Three formations, two holding `true` and one `false`. -/
def three : Nat → Unit → Bool := fun k _ => decide (k < 2)

/-- Two formations, one holding `true` and one `false`. -/
def two : Nat → Unit → Bool := fun k _ => decide (k = 0)

/-- **An odd split agrees at once.** Two of three holding `true`, taking what most hold brings
every one of them to `true`. -/
theorem odd_agrees :
    majority [0, 1, 2] three 0 () = true ∧ majority [0, 1, 2] three 1 () = true ∧
      majority [0, 1, 2] three 2 () = true :=
  ⟨rfl, rfl, rfl⟩

/-- **An even split rests.** One of two holding `true`, taking what most hold changes nothing:
the tie is a rest, and agreement needs something that breaks the symmetry. -/
theorem even_rests : majority [0, 1] two 0 () = two 0 () ∧ majority [0, 1] two 1 () = two 1 () ∧
    two 0 () ≠ two 1 () :=
  ⟨rfl, rfl, fun same => Bool.noConfusion same⟩

end Majority

namespace TwoFormations

/-- Each formation gives the sense its own name as form: they disagree. -/
def start : Bool → Unit → Bool := fun i _ => i

/-- The start is symmetric under exchanging the formations together with the forms. -/
theorem start_symmetric : Relabels not (fun _ => not) start start := fun i _ => (ListTests.not_not i).symm

/-- **The order of exchange decides the form.** Along every run of hearing from the start, the
formation `false` hearing `true` first brings both to `true`; `true` hearing `false` first brings
both to `false`. -/
theorem order_decides (r : Run (process (I := Bool) (M := Unit) (F := Bool) always))
    (from_start : r.state 0 = start) :
    (r.act 0 = ⟨false, true, ()⟩ → r.state 1 false () = true ∧ r.state 1 true () = true) ∧
    (r.act 0 = ⟨true, false, ()⟩ → r.state 1 false () = false ∧ r.state 1 true () = false) :=
  ⟨fun heard => ⟨step_from r from_start heard false (), step_from r from_start heard true ()⟩,
   fun heard => ⟨step_from r from_start heard false (), step_from r from_start heard true ()⟩⟩

/-- Each takes the other's form at once. -/
def crossing (X : Bool → Unit → Bool) : Bool → Unit → Bool := fun i m => X (!i) m

theorem crossing_keeps_exchange : KeepsExchange crossing not :=
  fun _ _ image i m => image (!i) m

theorem crossing_keeps_renaming (τ : Unit → Bool → Bool) : KeepsRenaming crossing τ :=
  fun _ _ image i m => image (!i) m

/-- **Taking each other's form at once, they never agree**: they exchange their forms forever. -/
theorem crossing_never_agrees (n : Nat) (i : Bool) :
    (Law.run crossing start).state n i () ≠ (Law.run crossing start).state n (!i) () :=
  never_agrees_of_both crossing_keeps_exchange (crossing_keeps_renaming _) start_symmetric
    (fun x h => match x, h with | false, h => Bool.noConfusion h | true, h => Bool.noConfusion h) n i

/-- A centre: every formation takes the form of `true`. -/
def centre (X : Bool → Unit → Bool) : Bool → Unit → Bool := fun _ m => X true m

theorem bor_comm : ∀ a b : Bool, (a || b) = (b || a)
  | false, false => rfl
  | false, true => rfl
  | true, false => rfl
  | true, true => rfl

/-- A privileged form: every formation takes `true` where either holds it. -/
def preferred (X : Bool → Unit → Bool) : Bool → Unit → Bool := fun _ m => X true m || X false m

/-- One hearing as a law: the formation `false` hears `true`. -/
def ordered (X : Bool → Unit → Bool) : Bool → Unit → Bool := hear ⟨false, true, ()⟩ X

theorem centre_keeps_renaming (τ : Unit → Bool → Bool) : KeepsRenaming centre τ :=
  fun _ _ image _ m => image true m

theorem preferred_keeps_exchange : KeepsExchange preferred not :=
  fun X Y image _ m =>
    have yt : Y true m = X false m := image true m
    have yf : Y false m = X true m := image false m
    show (Y true m || Y false m) = (X true m || X false m) from
      (congr (congrArg (· || ·) yt) yf).trans (bor_comm _ _)

theorem ordered_keeps_renaming (τ : Unit → Bool → Bool) : KeepsRenaming ordered τ :=
  hear_keeps_renaming _

/-- **Three ways agreement forms, each breaking one symmetry.** A centre, a privileged form and an
order of exchange each bring the two to agree in one step. -/
theorem three_agree :
    (Law.run centre start).state 1 false () = (Law.run centre start).state 1 true () ∧
    (Law.run preferred start).state 1 false () = (Law.run preferred start).state 1 true () ∧
    (Law.run ordered start).state 1 false () = (Law.run ordered start).state 1 true () :=
  ⟨rfl, rfl, rfl⟩

/-- **A centre privileges a formation**: it keeps every renaming and breaks the exchange. -/
theorem centre_breaks_exchange : ¬ KeepsExchange centre not :=
  fun keeps => never_agrees_of_both keeps (centre_keeps_renaming (fun _ => not)) start_symmetric
    (m := ()) (fun x => ListTests.not_ne_self x) 1 false (three_agree.1)

/-- **A preferred form is privileged**: the law keeps the exchange of formations and breaks the
renaming. -/
theorem preferred_breaks_renaming : ¬ KeepsRenaming preferred (fun _ => not) :=
  fun keeps => never_agrees_of_both preferred_keeps_exchange keeps start_symmetric
    (m := ()) (fun x => ListTests.not_ne_self x) 1 false (three_agree.2.1)

/-- **An order of exchange privileges no form and breaks the exchange of formations.** -/
theorem ordered_breaks_exchange : ¬ KeepsExchange ordered not :=
  fun keeps => never_agrees_of_both keeps (ordered_keeps_renaming (fun _ => not)) start_symmetric
    (m := ()) (fun x => ListTests.not_ne_self x) 1 false (three_agree.2.2)

/-- Two senses (`false`, `true`) and two forms: the first formation's code names each sense by
itself, the second by its negation. -/
def crossed : Bool → Bool → Bool := fun i m => if i = true then m else !m

/-- **Agreement formed sense by sense can merge senses.** Along every run of hearing from the
crossed codes, both codes tell the senses apart; the second hearing the first at the sense `true`
agrees with it there and gives both senses one form. -/
theorem homonym (r : Run (process (I := Bool) (M := Bool) (F := Bool) always))
    (from_crossed : r.state 0 = crossed) (heard : r.act 0 = ⟨false, true, true⟩) :
    TellsApart (r.state 0 true) ∧ TellsApart (r.state 0 false) ∧
      r.state 1 false true = r.state 1 true true ∧ ¬ TellsApart (r.state 1 false) :=
  have step := step_from r from_crossed heard
  ⟨Eq.subst (motive := fun X : Bool → Bool → Bool => TellsApart (X true)) from_crossed.symm
      (fun _ _ same => same),
   Eq.subst (motive := fun X : Bool → Bool → Bool => TellsApart (X false)) from_crossed.symm
      (fun n n' same => match n, n', same with
        | false, false, _ => rfl
        | true, true, _ => rfl
        | false, true, h => Bool.noConfusion h
        | true, false, h => Bool.noConfusion h),
   (step false true).trans (step true true).symm,
   fun tells => Bool.noConfusion (tells false true ((step false false).trans (step false true).symm))⟩

end TwoFormations

/-! Three formations coupled on a path `a – c – b` and indexed `a < b < c`, each following the
least-indexed of itself and the formations it couples with. -/
namespace Path

inductive Node where
  | a
  | b
  | c

def rank : Node → Nat
  | .a => 0
  | .b => 1
  | .c => 2

def couples : Node → Node → Prop
  | .a, .a => False
  | .a, .b => False
  | .a, .c => True
  | .b, .a => False
  | .b, .b => False
  | .b, .c => True
  | .c, .a => True
  | .c, .b => True
  | .c, .c => False

/-- Every two formations are joined through couplings. -/
theorem joined : ∀ i j, i = j ∨ couples i j ∨ (couples i .c ∧ couples .c j)
  | .a, .a => .inl rfl
  | .a, .b => .inr (.inr ⟨trivial, trivial⟩)
  | .a, .c => .inr (.inl trivial)
  | .b, .a => .inr (.inr ⟨trivial, trivial⟩)
  | .b, .b => .inl rfl
  | .b, .c => .inr (.inl trivial)
  | .c, .a => .inr (.inl trivial)
  | .c, .b => .inr (.inl trivial)
  | .c, .c => .inl rfl

def least : Node → Node
  | .a => .a
  | .b => .b
  | .c => .a

/-- `least` points each formation to itself or a formation it couples with … -/
theorem least_coupled : ∀ i, least i = i ∨ couples i (least i)
  | .a => .inl rfl
  | .b => .inl rfl
  | .c => .inr trivial

/-- … of least index among them. -/
theorem least_least : ∀ i j, (j = i ∨ couples i j) → rank (least i) ≤ rank j
  | .a, _, _ => Nat.zero_le _
  | .c, _, _ => Nat.zero_le _
  | .b, .b, _ => Nat.le.refl
  | .b, .c, _ => Nat.le.step Nat.le.refl
  | .b, .a, .inl h => Node.noConfusion h
  | .b, .a, .inr h => False.elim h

theorem stays_a : ∀ n, Law.orbit least .a n = .a
  | 0 => rfl
  | n + 1 => congrArg least (stays_a n)

theorem stays_b : ∀ n, Law.orbit least .b n = .b
  | 0 => rfl
  | n + 1 => congrArg least (stays_b n)

/-- **Joined and following, they never agree.** Every two formations are joined through
couplings, and `least` points each to the least-indexed of itself and its couplings; yet from the
start naming each formation by itself, `a` and `b` hold different forms at every step: each is
least among its couplings and keeps its own form. -/
theorem never_agree :
    (∀ i j, i = j ∨ couples i j ∨ (couples i .c ∧ couples .c j)) ∧
    (∀ i, least i = i ∨ couples i (least i)) ∧
    (∀ i j, (j = i ∨ couples i j) → rank (least i) ≤ rank j) ∧
    ∀ n, (Law.run (follow least) (fun i (_ : Unit) => i)).state n .a () ≠
      (Law.run (follow least) (fun i (_ : Unit) => i)).state n .b () :=
  ⟨joined, least_coupled, least_least, fun n same => Node.noConfusion ((stays_a n).symm.trans
    ((congrFun (follow_state least _ n .a) ()).symm.trans
      (same.trans ((congrFun (follow_state least _ n .b) ()).trans (stays_b n)))))⟩

end Path

/-! A form whose earlier sense is `0` and a reading `1` taken up: records name one sense each. -/
namespace Gloss

/-- The record `r` bears on the form and offers the sense `r` alone. -/
def offersOne (r m : Nat) : Bool := Nat.beq m r

def rep : List Nat := [0, 1]

theorem exact : WritesExactly (fun _ : Nat => true) offersOne id :=
  fun e => ⟨rfl, beq_self e, fun n ne => show Nat.beq n e = false from
    match h : Nat.beq n e with
    | false => rfl
    | true => absurd (Nat.eq_of_beq_eq_true h) ne⟩

theorem zero_ne_one : (0 : Nat) ≠ 1 := fun h => Bool.noConfusion (congrArg (fun n => Nat.beq n 0) h)

theorem distinct : Distinct rep :=
  ⟨fun mem => zero_ne_one (CrossSituational.mem_singleton mem), (fun mem => nomatch mem), trivial⟩

/-- Records of the earlier sense resolve the form to it, and written back it rests. -/
theorem earlier_rests (n : Nat) :
    (Law.run (nextCohort (fun _ => true) offersOne rep id) [0]).state (n + 1) = [0] :=
  written_rests exact distinct (rs := [0]) rfl n

/-- **A reading taken up in place of the earlier records locks**: from the record of `1` alone,
every later generation's records are the record of `1`, and the earlier sense `0` is never a
candidate again. -/
theorem taken_up_locks (n : Nat) :
    (Law.run (nextCohort (fun _ => true) offersOne rep id) [1]).state (n + 1) = [1] ∧
      0 ∉ CrossSituational.candidates (fun _ => true) offersOne rep
        ((Law.run (nextCohort (fun _ => true) offersOne rep id) [1]).state (n + 1)) :=
  ⟨written_rests exact distinct (rs := [1]) rfl n,
   (omitted_rest exact distinct (rs := [1]) zero_ne_one rfl n).1⟩

/-- The record of the reading `1` added to the record of `0`, and nothing added after. -/
def uptake : Run (adding (R := Nat)) where
  state := fun n => match n with
    | 0 => [0]
    | _ + 1 => [0, 1]
  act := fun n => match n with
    | 0 => [1]
    | _ + 1 => []
  step := fun n => match n with
    | 0 => rfl
    | _ + 1 => rfl

/-- **Kept, the earlier records bar it**: where the record of `0` is kept and the record of `1` is
added, the resolution to `0` is lost from then on and never replaced by `1`
(`added_never_replaced` attained with loss). -/
theorem uptake_loses :
    resolve (fun _ => true) offersOne rep (uptake.state 0) = some 0 ∧
      ∀ n, resolve (fun _ => true) offersOne rep (uptake.state (n + 1)) = none :=
  ⟨rfl, fun _ => rfl⟩

end Gloss

end SharedCodes

end Becoming
