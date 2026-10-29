import Becoming.GuardHorizon
import Becoming.Revision

/-!
# A revision of a reading that opens a correction

A formation correcting through a fixed reading chooses its act from what the reading tells apart:
where two configurations needing different acts are read alike, no choice through the reading serves
both. Revising the reading itself changes what can be chosen. This module states when a revision
opens a correction (board item RF, round 2: RF6.1), keeping three things apart: what the new reading
tells apart, whether the revision and the correction are executable, and what counts as acceptable.

* **What a reading lets be chosen.** A correction through a reading is a choice of act from each
  reading, acceptable and executable at every configuration giving it
  (`GuardHorizon.UniformPolicy`). Given choice over the readings, it exists exactly where each reading
  has one act acceptable and executable at every configuration giving it (`chosen_iff`, from
  `GuardHorizon.uniform_policy_iff_fiber_feasible`).
* **Opening.** A revision opens a correction where none is chosen through the old reading and one is
  through the new (`Opens`, `opens_iff`). A revision to a reading the old one refines opens nothing
  (`coarser_opens_nothing`, from `GuardHorizon.uniform_finer`), so an opening tells apart what the old
  reading read alike; a revision to a finer reading closes nothing (`finer_closes_nothing`).
* **What counts as acceptable stays fixed.** Widening what counts as acceptable to everything opens a
  correction through every reading, the coarsest included (`widened_opens`): an opening is one where
  the acceptability is the same before and after.
* **A witness: reading which member reports** (`Reports`). Two configurations, a fault at the first
  line or at the second, each needing the repair of its own line: read by the count of reports, both
  read alike and no repair is chosen through the count (`Reports.count_chooses_none`); read by which
  line reports, the repair is chosen (`Reports.line_chooses`); so revising the reading from the count
  to the line opens the correction (`Reports.opens`). Whether the revision and the correction are
  executable is a further question, stated on `Revising`'s process, where a rebuilt reading can
  consume the last support for using it (`Revising.opens_without_correction`) and a remaining unit
  connects it to an enabled correction (`Revising.opens_with_correction`).

**Readings** [AI reading]. Double-loop learning (Argyris and Schön 1978): correcting through a
fixed reading is the single loop, revising the reading the double; the double loop is needed exactly
where a reading lumps configurations needing different acts, and it opens a correction only by
telling them apart, with what counts as acceptable held fixed. Replacing a finer reading by a coarser
one, as by a summary measure, can close corrections and never opens one. These are readings, not
containments.

**Modelling choices.** Readings as maps; acceptability and executability as one predicate on
configurations and acts; the revision's own executability on `Revising`'s process, with natural-number
stock. Every declaration has an empty axiom report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace OpenedCorrection

variable {S A O O' : Type}

/-- **Through a reading, a correction is chosen exactly where each reading has one act acceptable
and executable at every configuration giving it**, given choice over the readings. -/
theorem chosen_iff (choice : Viability.ChoiceOver O A) (read : S → O) (fit : S → A → Prop) :
    GuardHorizon.UniformPolicy read fit ↔ GuardHorizon.FiberFeasible read fit :=
  GuardHorizon.uniform_policy_iff_fiber_feasible choice read fit

/-- **A revision opens a correction**: none is chosen through the old reading, one is through the
new. -/
def Opens (old : S → O) (new : S → O') (fit : S → A → Prop) : Prop :=
  ¬ GuardHorizon.UniformPolicy old fit ∧ GuardHorizon.UniformPolicy new fit

/-- **A revision opens a correction exactly where none is chosen through the old reading and each new
reading has one fitting act**, given choice over the new readings. -/
theorem opens_iff (choice : Viability.ChoiceOver O' A) (old : S → O) (new : S → O')
    (fit : S → A → Prop) :
    Opens old new fit ↔ ¬ GuardHorizon.UniformPolicy old fit ∧ GuardHorizon.FiberFeasible new fit :=
  ⟨fun ⟨closed, opened⟩ => ⟨closed, (chosen_iff choice new fit).mp opened⟩,
   fun ⟨closed, feasible⟩ => ⟨closed, (chosen_iff choice new fit).mpr feasible⟩⟩

/-- **A revision to a finer reading closes nothing**: a correction chosen through the old reading is
chosen through every reading the old one is read off. -/
theorem finer_closes_nothing {old : S → O} {new : S → O'} (forget : O' → O)
    (refines : ∀ s, forget (new s) = old s) {fit : S → A → Prop}
    (chosen : GuardHorizon.UniformPolicy old fit) : GuardHorizon.UniformPolicy new fit :=
  GuardHorizon.uniform_finer old new forget refines fit chosen

/-- **A revision to a reading the old one refines opens nothing**: an opening needs the new reading
to tell apart what the old read alike. -/
theorem coarser_opens_nothing {old : S → O} {new : S → O'} (forget : O → O')
    (refines : ∀ s, forget (old s) = new s) (fit : S → A → Prop) : ¬ Opens old new fit :=
  fun ⟨closed, opened⟩ => closed (GuardHorizon.uniform_finer new old forget refines fit opened)

/-- **Widening what counts as acceptable to everything opens a correction through every reading**,
the coarsest included, given an act: an opening counts only with the acceptability fixed. -/
theorem widened_opens (read : S → O) (a : A) :
    GuardHorizon.UniformPolicy read (fun (_ : S) (_ : A) => True) :=
  ⟨fun _ => a, fun _ => trivial⟩

/-! ## A witness: reading which member reports -/

namespace Reports

/-- Two configurations: a fault at the first line, or at the second. -/
inductive Fault where
  | first
  | second

/-- Two repairs. -/
inductive Repair where
  | first
  | second

/-- A repair fits a fault where it repairs that line. -/
def fit : Fault → Repair → Prop
  | .first, .first => True
  | .first, .second => False
  | .second, .first => False
  | .second, .second => True

/-- The old reading: how many lines report, one in either configuration. -/
def count (_ : Fault) : Nat := 1

/-- The new reading: which line reports. -/
def line : Fault → Bool
  | .first => true
  | .second => false

/-- **Through the count no repair is chosen**: both faults read alike and need different repairs. -/
theorem count_chooses_none : ¬ GuardHorizon.UniformPolicy count fit :=
  fun ⟨policy, fits⟩ =>
    have at_first : fit .first (policy 1) := fits .first
    have at_second : fit .second (policy 1) := fits .second
    match h : policy 1 with
    | .first => Eq.mp (congrArg (fit .second) h) at_second
    | .second => Eq.mp (congrArg (fit .first) h) at_first

/-- **Through which line reports, the repair is chosen.** -/
theorem line_chooses : GuardHorizon.UniformPolicy line fit :=
  ⟨fun b => match b with
    | true => .first
    | false => .second,
   fun s => match s with
    | .first => trivial
    | .second => trivial⟩

/-- **Revising the reading from the count to the line opens the correction.** -/
theorem opens : Opens count line fit := ⟨count_chooses_none, line_chooses⟩

end Reports

end OpenedCorrection

end Becoming
