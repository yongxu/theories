import Becoming.PartialReadout

/-!
# Code acquisition: reading a compositional code off three probes

A small compositional law: expressions are built from two atoms by joining and doubling (`Expr`),
and a code (`Code`) gives each atom a value and fixes the order in which a join puts its parts
(`eval`). Three probes, the two atoms and one join, show a code's primitive values and its order
(`observe`), and the code read off them (`acquire`) is the code itself wherever its primitives
differ (`acquired_exact`), so it evaluates every expression as the code does, with no bound on
depth (`acquired_every_expression`). This module states, on the core's processes and its
`PartialReadout`, what `CompositionalAcquisition` (6 October) proved, and what the join
`TrainingProcessesInherited` (17 October) read through the core, with every proof constructive
(board item F3Q, 18 October 2026). The grammar, the probes, the training schedule and the draw of
each operation are supplied, not derived.

* **What the probes carry.** The atoms' probes read the primitive values (`probe_readings`). Read
  through the primitive values alone, the order is not lumped on codes with different primitives
  (`primitives_not_lumped`), so no reading of the primitives alone is exact for it
  (`primitives_no_exact`): the composite probe is needed. Where the primitives are equal, the
  order changes the code but no expression's value (`equal_primitives_unresolved`); renaming the
  atoms and the code together keeps every value (`renaming_keeps_values`).
* **Training as a process.** A learner holds an optional code, a stock and its records. Training
  under a code draws seven units where the stock covers them, appends the three probe records and
  installs the code read from them (`train`); read as a law of change it is a process of the spine
  (`trainProcess`, `step_iff`). A step appends the records (`step_records`), draws seven units
  (`step_stock`), installs the code where its primitives differ (`step_installs`), and leaves a
  learner whose stock is short as it was (`step_rests_when_short`); the installed code evaluates
  every expression as the code does (`step_code_transfers`), and from no records the step's records
  read back as the code's probes (`step_evidence`). Executing an expression after a step returns
  the code's value and leaves the stock that, with both draws, makes up the stock before
  (`step_then_execute`).
* **The examples.** From eleven units a step under the usual code executes a novel expression
  with nothing left, and from seven it installs the code but cannot execute it
  (`novel_after_step`, `installed_without_execution`); records missing the composite probe give no
  code, and a reversed composite record gives the switched code (`missing_composite_no_code`,
  `reversed_composite_switches`); a code read with the order wrong answers a novel expression
  wrongly (`wrong_order_fails_transfer`); a law agreeing on the three probes and reversing every
  other value is not excluded by them and fails on the novel expression
  (`nonuniform_agrees_on_probes`, `nonuniform_fails_transfer`); choosing which probe to run by a
  preferred value does not change what the code says (`choice_keeps_content`).

The model is a supplied, finite law family; it defines no cognition or language. No ethical
predicate or ranking occurs, and every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

namespace CodeAcquisition

/-! ## Arithmetic used below -/

theorem sub_add_of_le : ∀ {n m : Nat}, n ≤ m → m - n + n = m
  | 0, _, _ => rfl
  | n + 1, 0, le => absurd le (Nat.not_succ_le_zero n)
  | n + 1, m + 1, le =>
    (congrArg (· + (n + 1)) (Nat.succ_sub_succ m n)).trans
      (congrArg Nat.succ (sub_add_of_le (Nat.le_of_succ_le_succ le)))

/-! ## Expressions and codes -/

/-- Expressions: two atoms, joining two expressions, doubling one. -/
inductive Expr where
  | atom : Bool → Expr
  | join : Expr → Expr → Expr
  | twice : Expr → Expr
  deriving DecidableEq

/-- A code: the value of each atom, and whether a join reverses its parts. -/
structure Code where
  first : Bool
  second : Bool
  reversed : Bool
  deriving DecidableEq

/-- The value of an expression under a code. -/
def eval (c : Code) : Expr → List Bool
  | .atom false => [c.first]
  | .atom true => [c.second]
  | .join p q => bif c.reversed then eval c q ++ eval c p else eval c p ++ eval c q
  | .twice p => eval c p ++ eval c p

/-- The first atom. -/
def p0 : Expr := .atom false
/-- The second atom. -/
def p1 : Expr := .atom true
/-- The composite probe: the two atoms joined. -/
def orderProbe : Expr := .join p0 p1

/-- What the three probes show. -/
structure Evidence where
  first : Bool
  second : Bool
  ordered : List Bool
  deriving DecidableEq

/-- The probes' values under a code. -/
def observe (c : Code) : Evidence := ⟨c.first, c.second, eval c orderProbe⟩

/-- The code read off the probes: reversed where the composite does not show the atoms in order. -/
def acquire (e : Evidence) : Code := ⟨e.first, e.second, !(e.ordered == [e.first, e.second])⟩

/-- **The atoms' probes read the primitive values.** -/
theorem probe_readings (c : Code) :
    eval c p0 = [(observe c).first] ∧ eval c p1 = [(observe c).second] := ⟨rfl, rfl⟩

/-- **The code read off the probes is the code**, where its primitives differ. -/
theorem acquired_exact : ∀ c : Code, c.first ≠ c.second → acquire (observe c) = c
  | ⟨false, false, _⟩, distinct => absurd rfl distinct
  | ⟨true, true, _⟩, distinct => absurd rfl distinct
  | ⟨false, true, false⟩, _ => rfl
  | ⟨false, true, true⟩, _ => rfl
  | ⟨true, false, false⟩, _ => rfl
  | ⟨true, false, true⟩, _ => rfl

/-- **The code read off the probes evaluates every expression as the code does**, with no bound on
depth. -/
theorem acquired_every_expression (c : Code) (distinct : c.first ≠ c.second) (e : Expr) :
    eval (acquire (observe c)) e = eval c e :=
  congrArg (fun d => eval d e) (acquired_exact c distinct)

/-- Swap the atoms throughout an expression. -/
def rename : Expr → Expr
  | .atom b => .atom (!b)
  | .join p q => .join (rename p) (rename q)
  | .twice p => .twice (rename p)

/-- Swap the atoms' values in a code. -/
def renamed (c : Code) : Code := ⟨c.second, c.first, c.reversed⟩

/-- **Renaming the atoms and the code together keeps every value.** -/
theorem renaming_keeps_values (c : Code) : ∀ e, eval (renamed c) (rename e) = eval c e
  | .atom false => rfl
  | .atom true => rfl
  | .join p q => by
    show (bif c.reversed then eval (renamed c) (rename q) ++ eval (renamed c) (rename p)
      else eval (renamed c) (rename p) ++ eval (renamed c) (rename q)) = _
    rw [renaming_keeps_values c p, renaming_keeps_values c q]
    rfl
  | .twice p => by
    show eval (renamed c) (rename p) ++ eval (renamed c) (rename p) = _
    rw [renaming_keeps_values c p]
    rfl

/-! ## The draw of an operation, and training -/

/-- An operation draws one unit and one for each value it gives. -/
def operationDraw (c : Code) (e : Expr) : Nat := 1 + (eval c e).length

/-- Running the three probes. -/
def acquisitionDraw (c : Code) : Nat :=
  operationDraw c p0 + operationDraw c p1 + operationDraw c orderProbe

/-- **The probes draw seven units**, whatever the code. -/
theorem acquisition_draw : ∀ c : Code, acquisitionDraw c = 7
  | ⟨_, _, false⟩ => rfl
  | ⟨_, _, true⟩ => rfl

/-- A learner: an installed code or none, a stock, and the records it holds. -/
structure Learner where
  code : Option Code
  stock : Nat
  records : List (Expr × List Bool)
  deriving DecidableEq

/-- The three probe records of a code. -/
def trialRecords (c : Code) : List (Expr × List Bool) :=
  [(p0, eval c p0), (p1, eval c p1), (orderProbe, eval c orderProbe)]

/-- The one value of a list holding exactly one. -/
def single : List Bool → Option Bool
  | [] => none
  | [a] => some a
  | _ :: _ :: _ => none

/-- A record of the expression `e` with one value: that value. -/
def valueOf (e : Expr) (record : Expr × List Bool) : Option Bool :=
  if record.1 = e then single record.2 else none

/-- A record of the composite probe: its values. -/
def orderValues (record : Expr × List Bool) : Option (List Bool) :=
  if record.1 = orderProbe then some record.2 else none

/-- The probes read off three records in probe order, or none. -/
def readEvidence : List (Expr × List Bool) → Option Evidence
  | [] => none
  | [_] => none
  | [_, _] => none
  | [x, y, z] => (valueOf p0 x).bind fun a => (valueOf p1 y).bind fun b =>
      (orderValues z).map fun xs => ⟨a, b, xs⟩
  | _ :: _ :: _ :: _ :: _ => none

/-- The code read off records. -/
def interpretationFromRecords (records : List (Expr × List Bool)) : Option Code :=
  (readEvidence records).map acquire

/-- **The probe records of a code read back as its probes.** -/
theorem records_supply_evidence (c : Code) : readEvidence (trialRecords c) = some (observe c) := rfl

/-- **The code read off a code's probe records is the code read off its probes.** -/
theorem records_form_interpretation (c : Code) :
    interpretationFromRecords (trialRecords c) = some (acquire (observe c)) := rfl

/-- Training under a code: where the stock covers the probes, draw them, install the code read off
their records and keep the records; otherwise nothing changes. -/
def train (c : Code) (s : Learner) : Learner :=
  if acquisitionDraw c ≤ s.stock then
    ⟨interpretationFromRecords (trialRecords c), s.stock - acquisitionDraw c, s.records ++ trialRecords c⟩
  else s

theorem train_of_le {c : Code} {s : Learner} (enough : 7 ≤ s.stock) :
    train c s = ⟨some (acquire (observe c)), s.stock - 7, s.records ++ trialRecords c⟩ :=
  have afford : acquisitionDraw c ≤ s.stock := (acquisition_draw c).symm ▸ enough
  (if_pos afford).trans (congrArg (fun k => (⟨some (acquire (observe c)), s.stock - k,
    s.records ++ trialRecords c⟩ : Learner)) (acquisition_draw c))

/-- **Training appends the probe records.** -/
theorem training_records (c : Code) (s : Learner) (enough : 7 ≤ s.stock) :
    (train c s).records = s.records ++ trialRecords c :=
  congrArg Learner.records (train_of_le enough)

/-- **Training installs the code**, where its primitives differ. -/
theorem training_installs (c : Code) (s : Learner) (enough : 7 ≤ s.stock)
    (distinct : c.first ≠ c.second) : (train c s).code = some c :=
  (congrArg Learner.code (train_of_le enough)).trans (congrArg some (acquired_exact c distinct))

/-- **Training draws seven units.** -/
theorem training_stock (c : Code) (s : Learner) (enough : 7 ≤ s.stock) :
    (train c s).stock + 7 = s.stock :=
  (congrArg (fun l : Learner => l.stock + 7) (train_of_le enough)).trans (sub_add_of_le enough)

/-- **A learner whose stock is short is left as it was.** -/
theorem training_short (c : Code) (s : Learner) (short : s.stock < 7) : train c s = s :=
  if_neg fun afford => Nat.not_le_of_lt short ((acquisition_draw c) ▸ afford)

/-- Execute an expression with the installed code, where the stock covers its draw. -/
def execute (s : Learner) (e : Expr) : Option (List Bool × Nat) :=
  match s.code with
  | none => none
  | some c => if operationDraw c e ≤ s.stock then some (eval c e, s.stock - operationDraw c e) else none

/-- **After training, an expression the stock covers is executed with the code's value.** -/
theorem trained_execution (c : Code) (s : Learner) (e : Expr) (distinct : c.first ≠ c.second)
    (enough : 7 + operationDraw c e ≤ s.stock) :
    execute (train c s) e = some (eval c e, s.stock - 7 - operationDraw c e) := by
  rw [train_of_le (Naturals.le_of_add_le_right enough), acquired_exact c distinct]
  exact if_pos (Naturals.le_sub_of_add_le enough)

/-- **What the step and the execution leave makes up the stock before.** -/
theorem trained_execution_stock (c : Code) (s : Learner) (e : Expr)
    (enough : 7 + operationDraw c e ≤ s.stock) :
    (s.stock - 7 - operationDraw c e) + operationDraw c e + 7 = s.stock :=
  (congrArg (· + 7) (sub_add_of_le (Naturals.le_sub_of_add_le enough))).trans
    (sub_add_of_le (Naturals.le_of_add_le_right enough))

/-! ## What the primitives alone carry -/

/-- The primitive values of a code. -/
def primitiveEvidence (c : Code) : Bool × Bool := (c.first, c.second)

/-- Codes with different primitives. -/
def separated (c : Code) : Prop := c.first ≠ c.second

/-- **Read through the primitives alone, the order is not lumped**, even on codes with different
primitives. -/
theorem primitives_not_lumped :
    ¬ PartialReadout.LumpedWithin separated primitiveEvidence Code.reversed :=
  fun lumped => Bool.noConfusion (lumped ⟨false, true, false⟩ ⟨false, true, true⟩
    Bool.noConfusion Bool.noConfusion rfl)

/-- **No reading of the primitives alone is exact for the order**: the composite probe is
needed. -/
theorem primitives_no_exact :
    ¬ ∃ answer, PartialReadout.ExactWithin separated primitiveEvidence Code.reversed answer :=
  fun ⟨_, exact⟩ => primitives_not_lumped exact.lumped

/-! ## The examples -/

/-- The usual code: atoms `false`, `true`, joins in order. -/
def usual : Code := ⟨false, true, false⟩
/-- The switched code: the usual one with joins reversed. -/
def switched : Code := ⟨false, true, true⟩
/-- An expression no probe is: the first atom doubled, joined to the second. -/
def novel : Expr := .join (.twice p0) p1
/-- A learner with no code, a stock of `n` and no records. -/
def initial (n : Nat) : Learner := ⟨none, n, []⟩

/-- **The novel expression is none of the probes.** -/
theorem novel_not_probe : novel ≠ p0 ∧ novel ≠ p1 ∧ novel ≠ orderProbe := by decide

/-- **From eleven units, training under the usual code then executes the novel expression with
nothing left.** -/
theorem novel_execution : execute (train usual (initial 11)) novel = some ([false, false, true], 0) := by
  decide

/-- **From seven units the code is installed and the novel expression cannot be executed.** -/
theorem installed_not_executed :
    (train usual (initial 7)).code = some usual ∧ execute (train usual (initial 7)) novel = none := by
  decide

/-- **Records missing the composite probe give no code.** -/
theorem missing_composite_no_code : interpretationFromRecords [(p0, [false]), (p1, [true])] = none := by
  decide

/-- **A reversed composite record gives the switched code.** -/
theorem reversed_composite_switches :
    interpretationFromRecords [(p0, [false]), (p1, [true]), (orderProbe, [true, false])] =
      some switched := by decide

/-- **A code read with the order wrong answers the novel expression wrongly.** -/
theorem wrong_order_fails_transfer : eval (acquire (observe usual)) novel ≠ eval switched novel := by
  decide

/-- **Where the primitives are equal, the order changes the code and not the novel value.** -/
theorem equal_primitives_unresolved :
    observe ⟨false, false, false⟩ = observe ⟨false, false, true⟩ ∧
    eval (acquire (observe ⟨false, false, true⟩)) novel = eval ⟨false, false, true⟩ novel := by
  decide

/-- A law agreeing with the usual code on the three probes and reversing every other value. -/
def nonuniform (e : Expr) : List Bool :=
  if e = p0 ∨ e = p1 ∨ e = orderProbe then eval usual e else (eval usual e).map Bool.not

/-- **The nonuniform law agrees with the usual code on the probes.** -/
theorem nonuniform_agrees_on_probes :
    nonuniform p0 = eval usual p0 ∧ nonuniform p1 = eval usual p1 ∧
    nonuniform orderProbe = eval usual orderProbe := by decide

/-- **The nonuniform law fails on the novel expression**: the probes do not exclude it. -/
theorem nonuniform_fails_transfer : nonuniform novel ≠ eval usual novel := by decide

/-- Choose which atom to run by a preferred value. -/
def pick (preferred : Bool) (c : Code) : Expr := if c.first = preferred then p0 else p1

/-- **Choosing which probe to run by a preferred value does not change what the code says.** -/
theorem choice_keeps_content :
    eval (acquire (observe usual)) (pick false (acquire (observe usual))) = [false] ∧
    eval (acquire (observe usual)) (pick true (acquire (observe usual))) = [true] := by decide

/-! ## Training as a process -/

/-- Training read as a process: configurations are learners, the move `c` trains under `c`. -/
def trainProcess : Process Learner Code := Assurance.ofMap fun s c => train c s

/-- **A step of the training process is training.** -/
theorem step_iff {s t : Learner} {c : Code} : trainProcess.step s c t ↔ t = train c s := Iff.rfl

/-- **A step appends the probe records.** -/
theorem step_records {s t : Learner} {c : Code} (step : trainProcess.step s c t)
    (enough : 7 ≤ s.stock) : t.records = s.records ++ trialRecords c :=
  step ▸ training_records c s enough

/-- **A step installs the code**, where the stock covers it and the primitives differ. -/
theorem step_installs {s t : Learner} {c : Code} (step : trainProcess.step s c t)
    (enough : 7 ≤ s.stock) (distinct : c.first ≠ c.second) : t.code = some c :=
  step ▸ training_installs c s enough distinct

/-- **A step draws seven units.** -/
theorem step_stock {s t : Learner} {c : Code} (step : trainProcess.step s c t)
    (enough : 7 ≤ s.stock) : t.stock + 7 = s.stock :=
  step ▸ training_stock c s enough

/-- **A step the stock does not cover leaves the learner as it was.** -/
theorem step_rests_when_short {s t : Learner} {c : Code} (step : trainProcess.step s c t)
    (short : s.stock < 7) : t = s :=
  step.trans (training_short c s short)

/-- **The installed code transfers**: after a covered step the learner holds the code read off the
probe records, which, where the primitives differ, evaluates every expression as `c` does. -/
theorem step_code_transfers {s t : Learner} {c : Code} (step : trainProcess.step s c t)
    (enough : 7 ≤ s.stock) (distinct : c.first ≠ c.second) :
    t.code = some (acquire (observe c)) ∧ ∀ e, eval (acquire (observe c)) e = eval c e :=
  ⟨(congrArg Learner.code (step.trans (train_of_le enough))), acquired_every_expression c distinct⟩

/-- **From no records, the step's records read back as the code's probes.** -/
theorem step_evidence {n : Nat} {t : Learner} {c : Code} (step : trainProcess.step (initial n) c t)
    (enough : 7 ≤ n) : readEvidence t.records = some (observe c) :=
  (congrArg readEvidence (step_records step enough)).trans (records_supply_evidence c)

/-- **Execution after a step** returns `c`'s value and leaves the stock that, with the draws of the
execution and of the step, makes up the stock before the step. -/
theorem step_then_execute {s t : Learner} {c : Code} (e : Expr) (step : trainProcess.step s c t)
    (distinct : c.first ≠ c.second) (enough : 7 + operationDraw c e ≤ s.stock) :
    ∃ left, execute t e = some (eval c e, left) ∧ left + operationDraw c e + 7 = s.stock :=
  ⟨s.stock - 7 - operationDraw c e, step ▸ trained_execution c s e distinct enough,
   trained_execution_stock c s e enough⟩

/-- **From eleven units, a step under the usual code executes the novel expression** with nothing
left. -/
theorem novel_after_step {t : Learner} (step : trainProcess.step (initial 11) usual t) :
    execute t novel = some ([false, false, true], 0) :=
  step ▸ novel_execution

/-- **From seven units, a step installs the usual code and leaves no stock to execute the novel
expression.** -/
theorem installed_without_execution {t : Learner} (step : trainProcess.step (initial 7) usual t) :
    t.code = some usual ∧ execute t novel = none :=
  step ▸ installed_not_executed

end CodeAcquisition

end Becoming
