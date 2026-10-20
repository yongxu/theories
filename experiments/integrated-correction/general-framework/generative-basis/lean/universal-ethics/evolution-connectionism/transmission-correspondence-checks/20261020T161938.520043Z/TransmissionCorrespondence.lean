import Becoming.Copying
import Becoming.Stock
import Becoming.Evolution
import Becoming.Reordering
import LearnedProcedureTransmission

/-!
# Learned procedures reconstructed through performance, as instances of the core

`LearnedProcedureTransmission` states, for its declared construction, that every exposure
followed by a faithful reconstruction passes on the network and the procedure bit, builds as many
successors as the capacity allows and conserves material and support (`cycle_transmits`), and in
its history two families with the two procedure bits reconstruct different numbers of successors
(`both_reconstruct_and_counts_differ`). This periphery module reads three of these on the core's
general laws.

* **Capacity is the longest lineage one shared pool releases.** Read a successor's thirteen
  precursor units as a word of one kind of token, the precursor held as the pool, and its twenty
  support units (nine record writes, ten apparatus steps and one procedure-bit setting) as drawn
  at its release. `Copying.lineage_all_iff` then says that `n` successors are released in turn
  from the one pool and support exactly when `n` is within the capacity (`lineage_released_iff`),
  and so a reconstruction builds exactly the longest lineage released
  (`reconstruction_builds_longest_lineage`).
* **Every course conserves material and support.** Exposures and reconstructions are the moves
  of one process (`process`); across each move material and support stand as before
  (`Stock.Balanced` with nothing drawn or replenished: `material_balanced`,
  `support_balanced`), so `Stock.trace_balance` gives conservation along every course of
  exposures and reconstructions, not one cycle only (`course_conserves`).
* **Faithful reconstruction in Price's counting form.** Over any families each reconstructed
  faithfully, every successor carries its family's procedure bit, so transmission raises and lowers
  nothing and, by `Becoming.price`, the successors' total of the procedure is the families' bits
  weighted by their successor counts, each count the family's capacity (`faithful_selects`). In
  the history, the responsive family reconstructs two successors and the continual one one, so
  two of the three successors carry the responsive procedure where one of the two parents did
  (`history_selects`). The counts come from the support each family's actual task success made
  available.

The construction keeps its scope: exact real-valued copying, supplied local recipes and
homogeneous families with separate matched stocks remain idealized premises, and Price's form is
an arithmetic identity, not a measure of fitness. The core does not import this module.
-/

noncomputable section

namespace Becoming.TransmissionCorrespondence

open Generative LearnedProcedureTransmission CalibratedUpdater UpdaterConsequences

/-! ## Capacity is the longest lineage one shared pool releases -/

/-- A successor's thirteen precursor units, as a word of one kind of token. -/
def kitWord : List Unit := List.replicate 13 ()

/-- The precursor held, as a pool of units. -/
def pool (s : State) : List Unit := List.replicate s.precursor ()

/-- Attaching a unit draws no support; a successor's twenty support units are drawn at its
release. -/
def attach : Option Unit → Unit → Nat := fun _ _ => 0

theorem countOf_replicate : ∀ k : Nat, Copying.countOf () (List.replicate k ()) = k
  | 0 => rfl
  | k + 1 => by
    show (if () = () then Copying.countOf () (List.replicate k ()) + 1
      else Copying.countOf () (List.replicate k ())) = k + 1
    rw [if_pos rfl, countOf_replicate k]

theorem use_kitWord : Copying.use attach none kitWord = 0 := rfl

/-- **`n` successors are released in turn from the one pool and support exactly when `n` is within
the capacity**: `Copying.lineage_all_iff`. -/
theorem lineage_released_iff (s : State) (used n : Nat) :
    Copying.Every
        (Copying.batch attach 20 (List.replicate n kitWord) (pool s) s.available used).1 ↔
      n ≤ capacity s := by
  rw [Copying.lineage_all_iff, use_kitWord, Nat.zero_add]
  constructor
  · rintro ⟨units, support⟩
    have units := units ()
    rw [kitWord, pool, countOf_replicate, countOf_replicate] at units
    unfold capacity
    exact Nat.le_min.mpr ⟨(Nat.le_div_iff_mul_le (by norm_num)).mpr units,
      (Nat.le_div_iff_mul_le (by norm_num)).mpr support⟩
  · intro within
    have ⟨units, support⟩ := capacity_bounds s
    refine ⟨fun _ => ?_, ?_⟩
    · rw [kitWord, pool, countOf_replicate, countOf_replicate]
      exact Nat.le_trans (Nat.mul_le_mul_right 13 within) (Nat.mul_comm 13 _ ▸ units)
    · exact Nat.le_trans (Nat.mul_le_mul_right 20 within) (Nat.mul_comm 20 _ ▸ support)

/-- **A reconstruction builds exactly the longest lineage of the kit that the precursor and the
available support release.** -/
theorem reconstruction_builds_longest_lineage {channels : Fin 3 → Channel} {t : Transfer}
    {s out : State} (actual : reconstruct channels t s = some out) (used : Nat) :
    Copying.Every
        (Copying.batch attach 20 (List.replicate out.active kitWord) (pool s) s.available used).1 ∧
      ∀ n, Copying.Every
          (Copying.batch attach 20 (List.replicate n kitWord) (pool s) s.available used).1 →
        n ≤ out.active := by
  have count := (reconstructed_accounts actual).2.2
  refine ⟨(lineage_released_iff s used _).mpr (Nat.le_of_eq count), fun n released => ?_⟩
  rw [count]
  exact (lineage_released_iff s used n).mp released

/-! ## Every course conserves material and support -/

/-- The moves of the construction: an exposure to a list of tasks, or a reconstruction by a
transfer. -/
inductive Move where
  | expose (tasks : List Task)
  | rebuild (t : Transfer)

/-- The construction as one process: each move leads where the construction takes it. -/
def process (channels : Fin 3 → Channel) : Process State Move :=
  ⟨fun s m t => match m with
    | .expose tasks => expose channels tasks s = some t
    | .rebuild tr => reconstruct channels tr s = some t⟩

/-- Across each move, material stands as before. -/
theorem material_balanced (channels : Fin 3 → Channel) :
    Stock.Balanced (process channels) material (fun _ => 0) (fun _ => 0) := by
  intro s m t step
  cases m with
  | expose tasks => exact congrArg (· + 0) (exposed_accounts step).1
  | rebuild tr => exact congrArg (· + 0) (reconstructed_accounts step).1

/-- Across each move, support stands as before. -/
theorem support_balanced (channels : Fin 3 → Channel) :
    Stock.Balanced (process channels) support (fun _ => 0) (fun _ => 0) := by
  intro s m t step
  cases m with
  | expose tasks => exact congrArg (· + 0) (exposed_accounts step).2
  | rebuild tr => exact congrArg (· + 0) (reconstructed_accounts step).2.1

/-- **Every course of exposures and reconstructions conserves material and support**:
`Stock.trace_balance` with nothing drawn or replenished. -/
theorem course_conserves {channels : Fin 3 → Channel} {s t : State} {moves : List Move}
    (course : Trace (process channels) s moves t) :
    material t = material s ∧ support t = support s := by
  have m := Stock.trace_balance (material_balanced channels) course
  have u := Stock.trace_balance (support_balanced channels) course
  exact ⟨Nat.add_right_cancel m, Nat.add_right_cancel u⟩

/-! ## Faithful reconstruction in Price's counting form -/

/-- The procedure bit a formation's apparatus carries, counted. -/
def procedure (s : State) : Nat := if s.kit.apparatus.inhibit then 1 else 0

/-- A family's successors: as many as its reconstruction builds, each the reconstructed state. -/
def successors (out : State → State) (s : State) : List State :=
  List.replicate (out s).active (out s)

theorem total_replicate {α : Type} (f : α → Nat) (x : α) :
    ∀ c, total (List.replicate c x) f = c * f x
  | 0 => (Nat.zero_mul _).symm
  | c + 1 => by
    show f x + total (List.replicate c x) f = (c + 1) * f x
    rw [total_replicate f x c, Nat.succ_mul, Nat.add_comm]

/-- A faithful reconstruction keeps the procedure bit. -/
theorem faithful_procedure {channels : Fin 3 → Channel} {s out : State}
    (actual : reconstruct channels .faithful s = some out) : procedure out = procedure s := by
  unfold procedure
  rw [(reconstruct_inherits actual).2.1]
  rfl

theorem family_unchanged {channels : Fin 3 → Channel} {out : State → State} :
    ∀ (families : List State), (∀ s ∈ families, reconstruct channels .faithful s = some (out s)) →
      total families (fun p => total (successors out p) fun k => excess (procedure k) (procedure p)) = 0 ∧
      total families (fun p => total (successors out p) fun k => excess (procedure p) (procedure k)) = 0
  | [], _ => ⟨rfl, rfl⟩
  | s :: rest, rebuilt => by
    have same := faithful_procedure (rebuilt s (List.Mem.head rest))
    have tail := family_unchanged rest fun x mem => rebuilt x (List.Mem.tail s mem)
    refine ⟨?_, ?_⟩
    · show total (successors out s) (fun k => excess (procedure k) (procedure s)) +
          total rest (fun p => total (successors out p) fun k => excess (procedure k) (procedure p)) = 0
      rw [tail.1, successors, total_replicate, same, excess_self, Nat.mul_zero]
    · show total (successors out s) (fun k => excess (procedure s) (procedure k)) +
          total rest (fun p => total (successors out p) fun k => excess (procedure p) (procedure k)) = 0
      rw [tail.2, successors, total_replicate, same, excess_self, Nat.mul_zero]

/-- **Faithful reconstruction raises and lowers nothing, so the successors' procedures are the
families' weighted by their successor counts** (`Becoming.price`), each count the family's
capacity. -/
theorem faithful_selects {channels : Fin 3 → Channel} (families : List State)
    (out : State → State)
    (rebuilt : ∀ s ∈ families, reconstruct channels .faithful s = some (out s)) :
    raised families (successors out) procedure procedure = 0 ∧
      lowered families (successors out) procedure procedure = 0 ∧
      offspring families (successors out) procedure = selected families (successors out) procedure ∧
      ∀ s ∈ families, (successors out s).length = capacity s := by
  have ⟨up, down⟩ := family_unchanged families rebuilt
  have identity := price families (successors out) procedure procedure
  refine ⟨up, down, ?_, fun s mem => ?_⟩
  · unfold raised at identity
    unfold lowered at identity
    rw [up, down] at identity
    exact identity
  · rw [successors, List.length_replicate]
    exact (reconstructed_accounts (rebuilt s mem)).2.2

/-- The history's reconstructions, by each family's procedure bit. -/
def historyOut (s : State) : State := daughterState s.kit.apparatus.inhibit .faithful

/-- **In the history, two of the three successors carry the responsive procedure where one of the
two parents did**: the responsive family reconstructs two successors, the continual one one. -/
theorem history_selects :
    offspring [parentAfter true, parentAfter false] (successors historyOut) procedure = 2 ∧
      total [parentAfter true, parentAfter false] (fun p => (successors historyOut p).length) = 3 ∧
      total [parentAfter true, parentAfter false] procedure = 1 ∧
      offspring [parentAfter true, parentAfter false] (successors historyOut) procedure =
        selected [parentAfter true, parentAfter false] (successors historyOut) procedure := by
  have rebuilt : ∀ s ∈ [parentAfter true, parentAfter false],
      reconstruct identityChannels .faithful s = some (historyOut s) := by
    intro s mem
    rcases List.mem_pair.mp mem with same | same <;> subst same
    · exact actual_reconstruction true .faithful
    · exact actual_reconstruction false .faithful
  refine ⟨?_, ?_, ?_, (faithful_selects _ _ rebuilt).2.2.1⟩
  · rfl
  · rfl
  · rfl

end Becoming.TransmissionCorrespondence
