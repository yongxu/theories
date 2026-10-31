import Becoming.U4BoundaryCheck

/-!
# U4, the boundary record (scratch): the check's negative controls

Each control runs `checkForm` on a form that must fail. A control passes only when:
- `checkForm` raises an error; and
- the error is the expected test's, matched by a fragment of its message.

The name test is controlled apart: some constants must be admitted and some must not.

`../run_check.sh` runs this file after it compiles the check. Its report is `../controls-run.log`.

The controls:
1. **A row checked as a form.** Row 17's own statement names the model.
2. **A repeated countermodel.** Row 17's descent countermodel stands for its gate too.
3. **A countermodel reaching the form.** It names the form in its proof.
4. **The prelude's `total` as a hypothesis.** It names amounts.
5. **A vacuous countermodel.** It ends in `False`, not in the form's conclusion; the second review
   found the earlier check passed it.
6. **A form with an inline amount hypothesis** beside the three named ones; the second review found
   the earlier check passed it.
7. **A fact reaching the form.** A fit's fact names the form in its proof.
8. **Row 5's recovery claimed to discharge by definitions.** It uses `Flow.descends_of_comes`.
9. **A degenerate form, its one hypothesis its conclusion** (the second review's `Holds`). It passes
   every test but the discharge condition, since its recovery meets the hypothesis with the row's
   own proof.
-/

open Lean Meta

namespace Becoming.U4BoundaryControls

open U4Boundary U4BoundaryCheck

/-- Control 3: a countermodel for the gate whose proof names the form. -/
theorem needs_gate_through_form :
    ¬ ∀ {X : Type} {region : X → Prop} {gives : «际» X} {ps : List X} {kids : X → List X},
      ListedWithin ps kids gives → Outside region ps → (ps.flatMap kids).length = 0 :=
  have _form := @outside_leaves_no_offspring
  outside_leaves_no_offspring.needs_gate

set_option linter.unusedVariables false in
/-- Control 5: the second review's vacuous countermodel for "given to". It leaves `comes` unused,
which is its fault. -/
theorem needs_given_vacuous :
    ¬ ∀ {X : Type} {comes before after : X → Prop} {descends : «际» X},
      Inherits descends before after → UndependedFrom descends before → False :=
  fun h => @h Unit everywhere nowhere everywhere noneRelated inherits_vacuous undepended_vacuous

/-- Control 6: row 5's form with the second review's inline amount hypothesis. -/
theorem bounded_form {X : Type} {comes before after : X → Prop} {descends : «际» X} {q : X → Nat}
    (given : GivenTo comes descends) (inherits : Inherits descends before after)
    (undepended : UndependedFrom descends before) (_bound : ∀ x, comes x → q x ≤ 0) :
    ¬ ∃ x, comes x ∧ after x :=
  descent_forms_no_dependence given inherits undepended

/-- Control 7: a fact whose proof names the form. -/
theorem one_offspring_through_form : ¬ (oneListed.flatMap oneOffspring).length = 0 :=
  have _form := @outside_leaves_no_offspring
  one_offspring

/-- Control 7: a fit through that fact. -/
theorem gate_needed_through_fact : ¬ GivesFrom nowhere allRelated :=
  fun gate => one_offspring_through_form
    (outside_leaves_no_offspring gate listed_within_all outside_nowhere)

/-- Control 9: a hypothesis that is the conclusion itself. -/
def Holds (a : Prop) : Prop := a

/-- Control 9: the degenerate form. -/
theorem holds_form {a : Prop} (holds : Holds a) : a := holds

/-- Control 9: its countermodel. -/
theorem holds_form.needs_holds : ¬ ∀ {a : Prop}, a := fun h => @h False

/-- Control 9: its fit. -/
theorem holds_form.holds_needed : ¬ Holds False := fun holds => holds_form holds

/-- Control 9: row 17 recovered through the degenerate form, by the row's own proof. -/
theorem all_end_by_holds : type_of% @GroupEnding.Flow.all_end := by
  intro X L W acting G descended t inactive
  exact holds_form (@GroupEnding.Flow.all_end X L W acting G descended t inactive)

/-- Control 9: its certificate. -/
theorem all_end_by_holds_certified : @GroupEnding.Flow.all_end = @all_end_by_holds := rfl

/-- A «» name declared off the grammar, for the name test. -/
theorem «不在文法» : True := trivial

def row5 : Form := forms[0]!
def row17 : Form := forms[1]!

/-- A form with its first hypothesis's entry changed. -/
def firstChanged (f : Form) (change : Hyp → Hyp) : Form :=
  { f with hypotheses := f.hypotheses.set 0 (change f.hypotheses[0]!) }

def controls : List (String × Form × String) := [
  ("a row checked as a form", { row17 with form := ``GroupEnding.Flow.all_end },
    "the form Becoming.GroupEnding.Flow.all_end names"),
  ("a repeated countermodel",
    firstChanged row17 ({ · with countermodel := ``outside_leaves_no_offspring.needs_descent }),
    "is not ¬ Becoming.U4Boundary.outside_leaves_no_offspring without Becoming.U4Boundary.GivesFrom"),
  ("a countermodel reaching the form",
    firstChanged row17 ({ · with countermodel := ``needs_gate_through_form }),
    "reaches Becoming.U4Boundary.outside_leaves_no_offspring"),
  ("the prelude's total as a hypothesis",
    firstChanged row17 ({ · with hypothesis := ``Becoming.total }),
    "the hypothesis Becoming.total names amounts"),
  ("a vacuous countermodel",
    firstChanged row5 ({ · with countermodel := ``needs_given_vacuous }),
    "is not ¬ Becoming.U4Boundary.descent_forms_no_dependence without Becoming.U4Boundary.GivenTo"),
  ("a form with an inline amount hypothesis", { row5 with form := ``bounded_form },
    "is not a listed hypothesis"),
  ("a fact reaching the form",
    firstChanged row17 ({ · with fit := ``gate_needed_through_fact }),
    "the fact Becoming.U4BoundaryControls.one_offspring_through_form reaches"),
  ("row 5's recovery claimed to discharge by definitions", { row5 with discharged := true },
    "the discharge condition fails, the record expects it to hold"),
  ("a degenerate form, its one hypothesis its conclusion",
    { form := ``holds_form, hypotheses := [⟨``Holds, ``holds_form.needs_holds, ``holds_form.holds_needed⟩],
      row := ``GroupEnding.Flow.all_end, recovery := ``all_end_by_holds,
      certificate := ``all_end_by_holds_certified, discharged := true },
    "the discharge condition fails, the record expects it to hold (other theorems: [Becoming.GroupEnding.Flow.all_end])")]

/-- Constants the name test must admit, and constants it must not. -/
def admittedExpected : List (Name × Bool) := [
  (``Nat, true), (``Becoming.total, true), (``Becoming.«际», true), (``Becoming.«则», true),
  (``Generative.Process, false), (``Becoming.Flow.taken, false), (``U4Boundary.GivenTo, false),
  (``«不在文法», false)]

#eval show MetaM Unit from do
  let env ← getEnv
  let mut out := ""
  for (name, f, expected) in controls do
    let failed ← try
        discard <| checkForm f
        pure none
      catch e => pure (some (← e.toMessageData.toString))
    match failed with
    | none => throwError "control '{name}' passed the check; it must fail"
    | some msg =>
      unless (msg.splitOn expected).length > 1 do
        throwError "control '{name}' failed on another test: {msg}"
      out := out ++ s!"control '{name}' fails as expected: {msg}\n"
  for (c, expected) in admittedExpected do
    unless admitted env c == expected do
      throwError "the name test {if expected then "refuses" else "admits"} {c}"
    out := out ++ s!"the name test {if expected then "admits" else "refuses"} {c}, as expected\n"
  logInfo out

end Becoming.U4BoundaryControls
