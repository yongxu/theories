import Becoming.Transactions
import Becoming.OpenComposition

/-!
# Reconfiguration: fault envelopes induced by causes, and the step that installs a new roster

Each member of a roster fails according to a formula over root causes (`FaultFormula`, `fails`);
supplied bounds on the root causes that may occur together then induce the fault sets of the
roster (`induced`, `envelope`), so the envelope of `FaultEnvelopes` is derived from causes rather
than listed. An arrangement is ready where its bounds are not empty and every two of them leave
a member working under both (`ready`). A reconfiguration installs a candidate arrangement where
the step is opened, the candidate is ready, and the reserve and time cover the step's own draw
together with the candidate's response load; it renews the epoch and the serial and draws its
amount (`reconfigure`).

* **Induced envelopes.** Failure is monotone in the root causes (`fails_mono`,
  `survives_of_included`, `induced_mono`), so a member outside the faults a bound induces works
  under every covered set of causes (`outside_bound_survives`). A certificate over the induced
  envelope is sound for covered causes (`induced_certificate_sound`); readiness is exactly a
  nonempty separated induced envelope (`ready_separates`, `ready_iff_nonempty_separated`), which
  makes the certificate available (`induced_certificate_available`) and, with faithful members,
  completes a guarded transaction within the scope (`induced_completes`).
* **The step.** Every step installs the candidate, keeps scope and tree, renews epoch and serial,
  unsigns, draws its amount and leaves reserve and time for the response
  (`reconfigure_renews`); it keeps what the scope permits (`reconfigure_keeps_scope`), stales the
  previous epoch's requests (`reconfigure_stales_epoch`), covers every shorter route
  (`reconfigure_covers_shorter`) and, with faithful members, completes the requested change
  (`reconfigure_then_completes`); a closed step or an unready candidate has none
  (`closed_rejected`, `unready_rejected`).
* **As a process.** The step is a process on managed installations whose actions are
  rearrangements (`process`, `step_iff`, `enabled_iff`); the laws above are its laws
  (`closed_no_step`, `unready_no_step`, `step_renews`, `step_separated`, `step_keeps_scope`,
  `step_stales_old_epoch`, `step_certificate_available`, `step_then_completes`).
* **Computed cases.** Envelopes induced by separate, merged and repaired causes; two members of one
  cause are not redundant; a stale envelope accepts support a shared cause controls; the process
  has no step to a roster sharing a cause and a step to the repaired roster, after which the old
  approvals fail and the surviving members complete the shutdown; the step's own draw alone is not
  enough, the combined draw is; and a cause the formulas omit still breaks the model.

The formulas are supplied upper bounds, not discovered causal laws; the protected monitor, the
opening of the step and the correspondence remain premises; no network agreement, physical
migration or warrant of the rearrangement is derived. This states `CorrectionReconfiguration`
(8 October) and its joins `ReconfigurationProcesses` and `ReconfigurationProcessesInherited` in
the core (board item F3C, 18 October 2026), with the words of exchange replaced: `authorized` is
`opened`, `cost` is `amount`, `responseCost` is `responseLoad`, `mandate` is `scope`. No premise;
every declaration has an empty axiom report.
-/

namespace Becoming

open Generative ListTests Naturals Actuation TreeSearch FaultEnvelopes Transactions

namespace Reconfiguration

/-! ## Induced envelopes -/

/-- A fault formula over root causes. -/
inductive FaultFormula where
  | cause : Nat → FaultFormula
  | any : FaultFormula → FaultFormula → FaultFormula
  | all : FaultFormula → FaultFormula → FaultFormula
  deriving DecidableEq

/-- Whether a formula fails under a set of root causes. -/
def fails : FaultFormula → List Nat → Bool
  | .cause r, roots => roots.contains r
  | .any a b, roots => fails a roots || fails b roots
  | .all a b, roots => fails a roots && fails b roots

/-- Inclusion of lists of causes. -/
def Subset (a b : List Nat) : Prop := ∀ r, r ∈ a → r ∈ b

/-- **Failure is monotone in the root causes.** -/
theorem fails_mono (a b : List Nat) (included : Subset a b) :
    ∀ (e : FaultFormula), fails e a = true → fails e b = true
  | .cause r, failed => contains_true_iff.mpr (included r (contains_true_iff.mp failed))
  | .any x y, failed => or_true_iff.mpr ((or_true_iff.mp failed).elim
      (fun h => .inl (fails_mono a b included x h)) (fun h => .inr (fails_mono a b included y h)))
  | .all x y, failed => and_true_iff.mpr ⟨fails_mono a b included x (and_true_iff.mp failed).1,
      fails_mono a b included y (and_true_iff.mp failed).2⟩

/-- **A formula working under more causes works under fewer.** -/
theorem survives_of_included (e : FaultFormula) (a b : List Nat) (included : Subset a b)
    (safe : fails e b = false) : fails e a = false :=
  false_iff_not.mpr fun h => nomatch safe.symm.trans (fails_mono a b included e h)

/-- An arrangement: a roster, each member's fault formula, and the bounds on root causes. -/
structure Arrangement where
  roster : List Domain
  vulnerability : Domain → FaultFormula
  rootFaults : List (List Nat)

/-- The members a set of root causes makes fail. -/
def induced (a : Arrangement) (roots : List Nat) : List Domain :=
  a.roster.filter (fun d => fails (a.vulnerability d) roots)

/-- The envelope induced by the bounds. -/
def envelope (a : Arrangement) : Envelope := a.rootFaults.map (induced a)

/-- Some bound covers the actual causes. -/
def Covered (a : Arrangement) (actual : List Nat) : Prop :=
  ∃ bound, bound ∈ a.rootFaults ∧ Subset actual bound

theorem mem_induced_iff (a : Arrangement) (roots : List Nat) (d : Domain) :
    d ∈ induced a roots ↔ d ∈ a.roster ∧ fails (a.vulnerability d) roots = true :=
  mem_filter_iff

/-- **The induced faults are monotone in the causes.** -/
theorem induced_mono (a : Arrangement) (x y : List Nat) (h : Subset x y) :
    Subset (induced a x) (induced a y) :=
  fun d hd => match (mem_induced_iff a x d).mp hd with
    | ⟨member, failed⟩ => (mem_induced_iff a y d).mpr ⟨member, fails_mono x y h _ failed⟩

/-- **A member outside the faults a bound induces works under every set of causes it covers.** -/
theorem outside_bound_survives (a : Arrangement) (actual bound : List Nat)
    (included : Subset actual bound) (d : Domain) (member : d ∈ a.roster)
    (outside : ¬ d ∈ induced a bound) : fails (a.vulnerability d) actual = false :=
  survives_of_included _ actual bound included
    (false_iff_not.mpr fun hf => outside ((mem_induced_iff a bound d).mpr ⟨member, hf⟩))

theorem induced_mem_envelope {a : Arrangement} {bound : List Nat} (member : bound ∈ a.rootFaults) :
    induced a bound ∈ envelope a :=
  mem_map_of member

/-- **A certificate over the induced envelope is sound for covered causes.** -/
theorem induced_certificate_sound (a : Arrangement) (actual : List Nat)
    (covered : Covered a actual) (supports : Domain → Bool) (P : Prop)
    (faithful : ∀ d, d ∈ a.roster → fails (a.vulnerability d) actual = false →
      supports d = true → P)
    (accepted : certificate a.roster (envelope a) supports = true) : P :=
  match covered with
  | ⟨bound, member, included⟩ =>
    certificate_sound a.roster (envelope a) supports (induced a bound)
      (induced_mem_envelope member) P
      (fun d hd outside supported =>
        faithful d hd (outside_bound_survives a actual bound included d hd outside) supported)
      accepted

/-- Readiness: the bounds are not empty, and every two leave a member working under both. -/
def ready (a : Arrangement) : Bool :=
  !a.rootFaults.isEmpty && a.rootFaults.all (fun x => a.rootFaults.all (fun y =>
    a.roster.any (fun d => !(fails (a.vulnerability d) x) && !(fails (a.vulnerability d) y))))

theorem not_induced {a : Arrangement} {roots : List Nat} {d : Domain}
    (works : fails (a.vulnerability d) roots = false) : ¬ d ∈ induced a roots :=
  fun m => nomatch works.symm.trans ((mem_induced_iff a roots d).mp m).2

/-- **A ready arrangement has a separated envelope.** -/
theorem ready_separates (a : Arrangement) (h : ready a = true) :
    separated a.roster (envelope a) :=
  fun _ hx _ hy => match mem_map_iff.mp hx, mem_map_iff.mp hy with
    | ⟨rx, hrx, ex⟩, ⟨ry, hry, ey⟩ =>
      match any_true_iff.mp (all_true_iff.mp (all_true_iff.mp (and_right h) rx hrx) ry hry) with
      | ⟨d, member, good⟩ =>
        ⟨d, member, ex ▸ not_induced (not_true_iff.mp (and_left good)),
          ey ▸ not_induced (not_true_iff.mp (and_right good))⟩

/-- **Readiness is exactly a nonempty separated induced envelope.** -/
theorem ready_iff_nonempty_separated (a : Arrangement) :
    ready a = true ↔ a.rootFaults ≠ [] ∧ separated a.roster (envelope a) :=
  ⟨fun h => ⟨not_isEmpty_true_iff.mp (and_left h), ready_separates a h⟩,
   fun ⟨hne, sep⟩ => and_true_iff.mpr ⟨not_isEmpty_true_iff.mpr hne,
     all_true_iff.mpr fun x hx => all_true_iff.mpr fun y hy =>
       match sep (induced a x) (induced_mem_envelope hx) (induced a y) (induced_mem_envelope hy) with
       | ⟨d, hd, nx, ny⟩ => any_true_iff.mpr ⟨d, hd, and_true_iff.mpr
           ⟨not_true_iff.mpr (outside_bound_survives a x x (fun _ h => h) d hd nx),
            not_true_iff.mpr (outside_bound_survives a y y (fun _ h => h) d hd ny)⟩⟩⟩⟩

/-- **A ready arrangement makes the certificate available to members working under covered
causes.** -/
theorem induced_certificate_available (a : Arrangement) (actual : List Nat)
    (covered : Covered a actual) (checked : ready a = true) (supports : Domain → Bool)
    (responsive : ∀ d, d ∈ a.roster → fails (a.vulnerability d) actual = false →
      supports d = true) :
    certificate a.roster (envelope a) supports = true :=
  match covered with
  | ⟨bound, member, included⟩ =>
    certificate_available a.roster (envelope a) (induced a bound) (induced_mem_envelope member)
      (ready_separates a checked) supports
      (fun d hd outside => responsive d hd (outside_bound_survives a actual bound included d hd outside))

/-- **A ready arrangement, covered causes, and faithful, responsive members working under them
complete a guarded transaction within the scope.** -/
theorem induced_completes (a : Arrangement) (actual : List Nat)
    (covered : Covered a actual) (checked : ready a = true)
    (w : Installation) (p : Request) (reads : Readings) (approvals : Approvals)
    (current : fresh w p = true)
    (readResponses : ∀ d, d ∈ a.roster → fails (a.vulnerability d) actual = false →
      reads d = some (expected p))
    (issueResponses : ∀ d, d ∈ a.roster → fails (a.vulnerability d) actual = false →
      approvals d = some p)
    (readFaithful : ∀ d, d ∈ a.roster → fails (a.vulnerability d) actual = false →
      ∀ o, reads d = some o → o = observed w p.address)
    (issueFaithful : ∀ d, d ∈ a.roster → fails (a.vulnerability d) actual = false →
      approvals d = some p → withinScope w p = true)
    (stocked : load a.roster p + 3 ≤ w.state.reserve)
    (timely : w.state.time + load a.roster p + 3 ≤ w.state.deadline) :
    (guardedExecute a.roster (envelope a) (envelope a) w p reads approvals).succeeded = true ∧
    (guardedExecute a.roster (envelope a) (envelope a) w p reads approvals).installation.state.completed
      = true ∧
    withinScope w p = true :=
  match covered with
  | ⟨bound, member, included⟩ =>
    have safe := outside_bound_survives a actual bound included
    match certified_completes a.roster (envelope a) (envelope a) w p reads approvals
        (induced a bound) (induced a bound) (induced_mem_envelope member)
        (induced_mem_envelope member) (ready_separates a checked) (ready_separates a checked)
        current (fun d hd hn => readResponses d hd (safe d hd hn))
        (fun d hd hn => issueResponses d hd (safe d hd hn))
        (fun d hd hn => readFaithful d hd (safe d hd hn))
        (fun d hd hn => issueFaithful d hd (safe d hd hn)) stocked timely with
    | ⟨succeeded, completed, within⟩ =>
      match guard_keeps_success a.roster (envelope a) (envelope a) w p reads approvals within
          ⟨succeeded, completed⟩ with
      | ⟨s, c⟩ => ⟨s, c, within⟩

/-! ## The step -/

/-- A managed installation: its arrangement and its installation. -/
structure Managed where
  arrangement : Arrangement
  installation : Installation

/-- The load of a response at a depth under an arrangement. -/
def responseLoad (a : Arrangement) (depth : Nat) : Nat := a.roster.length * (depth + 2) + 3

/-- Whether a reconfiguration is admitted: opened, a ready candidate, and reserve and time
covering the step's amount together with the response load. -/
def admits (opened : Bool) (amount depth : Nat) (candidate : Arrangement) (old : Managed) : Bool :=
  opened && ready candidate &&
    decide (amount + responseLoad candidate depth ≤ old.installation.state.reserve) &&
    decide (old.installation.state.time + amount + responseLoad candidate depth ≤
      old.installation.state.deadline)

/-- The installation after a reconfiguration: epoch and serial renewed, unsigned, the amount
drawn. -/
def renewedBy (amount : Nat) (old : Managed) : Installation :=
  {old.installation with
    state := {old.installation.state with
      epoch := old.installation.state.epoch + 1
      signed := false
      issued := false
      delivered := false
      completed := false
      reserve := old.installation.state.reserve - amount
      time := old.installation.state.time + amount
      drawn := old.installation.state.drawn + amount}
    serial := old.installation.serial + 1}

/-- **A reconfiguration**: where admitted, install the candidate and renew the installation;
otherwise there is none. The amount is a supplied reservation for the review and installation;
this is an atomic local model. -/
def reconfigure (opened : Bool) (amount depth : Nat) (candidate : Arrangement) (old : Managed) :
    Option Managed :=
  match admits opened amount depth candidate old with
  | true => some ⟨candidate, renewedBy amount old⟩
  | false => none

theorem admits_true_iff {opened : Bool} {amount depth : Nat} {candidate : Arrangement}
    {old : Managed} :
    admits opened amount depth candidate old = true ↔
      opened = true ∧ ready candidate = true ∧
        amount + responseLoad candidate depth ≤ old.installation.state.reserve ∧
        old.installation.state.time + amount + responseLoad candidate depth ≤
          old.installation.state.deadline :=
  ⟨fun h => ⟨and_left (and_left (and_left h)), and_right (and_left (and_left h)),
      decide_true_iff.mp (and_right (and_left h)), decide_true_iff.mp (and_right h)⟩,
   fun ⟨o, r, s, t⟩ => and_true_iff.mpr ⟨and_true_iff.mpr ⟨and_true_iff.mpr ⟨o, r⟩,
      decide_true_iff.mpr s⟩, decide_true_iff.mpr t⟩⟩

theorem reconfigure_some {opened : Bool} {amount depth : Nat} {candidate : Arrangement}
    {old next : Managed} (h : reconfigure opened amount depth candidate old = some next) :
    admits opened amount depth candidate old = true ∧ next = ⟨candidate, renewedBy amount old⟩ := by
  unfold reconfigure at h
  cases c : admits opened amount depth candidate old with
  | false => rw [c] at h; exact nomatch h
  | true => rw [c] at h; exact ⟨rfl, (Option.some.inj h).symm⟩

/-- **Every reconfiguration renews the installation**: opened, to a ready candidate, installing
it, keeping scope and tree, advancing epoch and serial by one, unsigning, drawing its amount, and
leaving reserve and time for the response at the depth provided for. -/
theorem reconfigure_renews (opened : Bool) (amount depth : Nat) (candidate : Arrangement)
    (old next : Managed) (h : reconfigure opened amount depth candidate old = some next) :
    opened = true ∧ ready candidate = true ∧ next.arrangement = candidate ∧
    next.installation.scope = old.installation.scope ∧
    next.installation.root = old.installation.root ∧
    next.installation.state.epoch = old.installation.state.epoch + 1 ∧
    next.installation.serial = old.installation.serial + 1 ∧
    next.installation.state.signed = false ∧
    next.installation.state.drawn = old.installation.state.drawn + amount ∧
    next.installation.state.reserve + amount = old.installation.state.reserve ∧
    responseLoad candidate depth ≤ next.installation.state.reserve ∧
    next.installation.state.time + responseLoad candidate depth ≤
      next.installation.state.deadline := by
  obtain ⟨admitted, rfl⟩ := reconfigure_some h
  obtain ⟨o, r, s, t⟩ := admits_true_iff.mp admitted
  exact ⟨o, r, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    sub_add_cancel (le_of_add_le_right s), le_sub_of_add_le s, t⟩

/-- **A reconfiguration keeps what the scope permits.** -/
theorem reconfigure_keeps_scope (opened : Bool) (amount depth : Nat) (candidate : Arrangement)
    (old next : Managed) (h : reconfigure opened amount depth candidate old = some next)
    (command : Command) :
    permits next.installation.scope command = permits old.installation.scope command :=
  congrArg (permits · command) (reconfigure_renews opened amount depth candidate old next h).2.2.2.1

/-- **A request of the previous epoch is stale after a reconfiguration.** -/
theorem reconfigure_stales_epoch (opened : Bool) (amount depth : Nat) (candidate : Arrangement)
    (old next : Managed) (h : reconfigure opened amount depth candidate old = some next)
    (p : Request) (oldEpoch : p.epoch = old.installation.state.epoch) :
    fresh next.installation p = false :=
  false_iff_not.mpr fun current =>
    succ_ne_self old.installation.state.epoch
      ((reconfigure_renews opened amount depth candidate old next h).2.2.2.2.2.1.symm.trans
        ((fresh_iff.mp current).1.symm.trans oldEpoch))

/-- **The response load is monotone in the depth.** -/
theorem responseLoad_mono (a : Arrangement) {short long : Nat} (within : short ≤ long) :
    responseLoad a short ≤ responseLoad a long :=
  Nat.add_le_add_right (Nat.mul_le_mul_left _ (Nat.add_le_add_right within 2)) 3

/-- **A reconfiguration covers every shorter route.** -/
theorem reconfigure_covers_shorter (opened : Bool) (amount depth : Nat) (candidate : Arrangement)
    (old next : Managed) (h : reconfigure opened amount depth candidate old = some next)
    (actualDepth : Nat) (within : actualDepth ≤ depth) :
    responseLoad candidate actualDepth ≤ next.installation.state.reserve ∧
    next.installation.state.time + responseLoad candidate actualDepth ≤
      next.installation.state.deadline :=
  have admitted := reconfigure_renews opened amount depth candidate old next h
  have small := responseLoad_mono candidate within
  ⟨Nat.le_trans small admitted.2.2.2.2.2.2.2.2.2.2.1,
   Nat.le_trans (Nat.add_le_add_left small _) admitted.2.2.2.2.2.2.2.2.2.2.2⟩

/-- **After a reconfiguration, faithful members working under covered causes complete a
guarded transaction of a current request within the depth provided for, within the scope.** -/
theorem reconfigure_then_completes (opened : Bool) (amount depth : Nat) (candidate : Arrangement)
    (old next : Managed) (installed : reconfigure opened amount depth candidate old = some next)
    (actual : List Nat) (covered : Covered candidate actual)
    (p : Request) (reads : Readings) (approvals : Approvals)
    (depthBound : p.address.length ≤ depth) (current : fresh next.installation p = true)
    (readResponses : ∀ d, d ∈ candidate.roster → fails (candidate.vulnerability d) actual = false →
      reads d = some (expected p))
    (issueResponses : ∀ d, d ∈ candidate.roster → fails (candidate.vulnerability d) actual = false →
      approvals d = some p)
    (readFaithful : ∀ d, d ∈ candidate.roster → fails (candidate.vulnerability d) actual = false →
      ∀ o, reads d = some o → o = observed next.installation p.address)
    (issueFaithful : ∀ d, d ∈ candidate.roster → fails (candidate.vulnerability d) actual = false →
      approvals d = some p → withinScope next.installation p = true) :
    (guardedExecute next.arrangement.roster (envelope next.arrangement) (envelope next.arrangement)
      next.installation p reads approvals).succeeded = true ∧
    (guardedExecute next.arrangement.roster (envelope next.arrangement) (envelope next.arrangement)
      next.installation p reads approvals).installation.state.completed = true ∧
    withinScope next.installation p = true :=
  have admitted := reconfigure_renews opened amount depth candidate old next installed
  have room := reconfigure_covers_shorter opened amount depth candidate old next installed
    p.address.length depthBound
  admitted.2.2.1 ▸ induced_completes candidate actual covered admitted.2.1 next.installation p reads
    approvals current readResponses issueResponses readFaithful issueFaithful room.1
    (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc _ _ _)) room.2)

theorem and_false (b : Bool) : (b && false) = false := match b with | true => rfl | false => rfl

/-- **An unready candidate is not installed.** -/
theorem unready_rejected (opened : Bool) (amount depth : Nat) (candidate : Arrangement)
    (old : Managed) (unready : ready candidate = false) :
    reconfigure opened amount depth candidate old = none := by
  unfold reconfigure admits
  rw [unready, and_false]
  rfl

/-- **A closed step installs nothing.** -/
theorem closed_rejected (amount depth : Nat) (candidate : Arrangement) (old : Managed) :
    reconfigure false amount depth candidate old = none := rfl

/-! ## As a process -/

/-- A rearrangement: whether the step is opened, its amount, the depth of response it provides
for, and the candidate arrangement. -/
structure Rearrangement where
  opened : Bool
  amount : Nat
  depth : Nat
  candidate : Arrangement

/-- **The reconfiguration process**: a managed installation steps by a rearrangement to the
configuration `reconfigure` gives. -/
def process : Process Managed Rearrangement where
  step old m new := reconfigure m.opened m.amount m.depth m.candidate old = some new

/-- **The steps of the process are the transitions of `reconfigure`.** -/
theorem step_iff {old new : Managed} {m : Rearrangement} :
    process.step old m new ↔ reconfigure m.opened m.amount m.depth m.candidate old = some new :=
  Iff.rfl

/-- **A rearrangement is enabled exactly where `reconfigure` gives a configuration.** -/
theorem enabled_iff {old : Managed} {m : Rearrangement} :
    Enabled process old m ↔ (reconfigure m.opened m.amount m.depth m.candidate old).isSome = true :=
  ⟨fun ⟨_, h⟩ => (congrArg Option.isSome h).trans rfl,
   fun h => match e : reconfigure m.opened m.amount m.depth m.candidate old with
    | some new => ⟨new, e⟩
    | none => nomatch (congrArg Option.isSome e).symm.trans h⟩

/-- **A rearrangement that is not opened is enabled nowhere.** -/
theorem closed_no_step {old : Managed} {m : Rearrangement} (closed : m.opened = false) :
    ¬ Enabled process old m :=
  fun ⟨_, h⟩ => nomatch (Eq.subst
    (motive := fun b => reconfigure b m.amount m.depth m.candidate old = none) closed.symm
    (closed_rejected m.amount m.depth m.candidate old)).symm.trans h

/-- **A rearrangement to an unready candidate is enabled nowhere.** -/
theorem unready_no_step {old : Managed} {m : Rearrangement} (unready : ready m.candidate = false) :
    ¬ Enabled process old m :=
  fun ⟨_, h⟩ => nomatch
    (unready_rejected m.opened m.amount m.depth m.candidate old unready).symm.trans h

/-- **Every step renews the installation.** -/
theorem step_renews {old new : Managed} {m : Rearrangement} (step : process.step old m new) :
    m.opened = true ∧ ready m.candidate = true ∧ new.arrangement = m.candidate ∧
      new.installation.scope = old.installation.scope ∧
      new.installation.root = old.installation.root ∧
      new.installation.state.epoch = old.installation.state.epoch + 1 ∧
      new.installation.serial = old.installation.serial + 1 ∧
      new.installation.state.signed = false ∧
      new.installation.state.drawn = old.installation.state.drawn + m.amount ∧
      new.installation.state.reserve + m.amount = old.installation.state.reserve ∧
      responseLoad m.candidate m.depth ≤ new.installation.state.reserve ∧
      new.installation.state.time + responseLoad m.candidate m.depth ≤
        new.installation.state.deadline :=
  reconfigure_renews m.opened m.amount m.depth m.candidate old new step

/-- **Every step installs a nonempty, separated envelope.** -/
theorem step_separated {old new : Managed} {m : Rearrangement} (step : process.step old m new) :
    new.arrangement.rootFaults ≠ [] ∧ separated new.arrangement.roster (envelope new.arrangement) :=
  have admitted := step_renews step
  Eq.subst (motive := fun a : Arrangement => a.rootFaults ≠ [] ∧ separated a.roster (envelope a))
    admitted.2.2.1.symm ((ready_iff_nonempty_separated m.candidate).mp admitted.2.1)

/-- **No step widens what the scope permits.** -/
theorem step_keeps_scope {old new : Managed} {m : Rearrangement} (step : process.step old m new)
    (command : Command) :
    permits new.installation.scope command = permits old.installation.scope command :=
  reconfigure_keeps_scope m.opened m.amount m.depth m.candidate old new step command

/-- **A request of the epoch before a step is stale after it.** -/
theorem step_stales_old_epoch {old new : Managed} {m : Rearrangement}
    (step : process.step old m new) (p : Request)
    (oldEpoch : p.epoch = old.installation.state.epoch) : fresh new.installation p = false :=
  reconfigure_stales_epoch m.opened m.amount m.depth m.candidate old new step p oldEpoch

/-- **After every step, responsive supports give an accepted certificate.** -/
theorem step_certificate_available {old new : Managed} {m : Rearrangement}
    (step : process.step old m new) (actual : List Nat) (covered : Covered new.arrangement actual)
    (supports : Domain → Bool)
    (responsive : ∀ d, d ∈ new.arrangement.roster →
      fails (new.arrangement.vulnerability d) actual = false → supports d = true) :
    certificate new.arrangement.roster (envelope new.arrangement) supports = true :=
  have admitted := step_renews step
  induced_certificate_available new.arrangement actual covered
    (Eq.subst (motive := fun a => ready a = true) admitted.2.2.1.symm admitted.2.1) supports
    responsive

/-- **After every step, faithful responses complete within the scope.** -/
theorem step_then_completes {old new : Managed} {m : Rearrangement} (step : process.step old m new)
    (actual : List Nat) (covered : Covered m.candidate actual)
    (p : Request) (reads : Readings) (approvals : Approvals)
    (depthBound : p.address.length ≤ m.depth) (current : fresh new.installation p = true)
    (readResponses : ∀ d, d ∈ m.candidate.roster →
      fails (m.candidate.vulnerability d) actual = false → reads d = some (expected p))
    (issueResponses : ∀ d, d ∈ m.candidate.roster →
      fails (m.candidate.vulnerability d) actual = false → approvals d = some p)
    (readFaithful : ∀ d, d ∈ m.candidate.roster →
      fails (m.candidate.vulnerability d) actual = false →
      ∀ o, reads d = some o → o = observed new.installation p.address)
    (issueFaithful : ∀ d, d ∈ m.candidate.roster →
      fails (m.candidate.vulnerability d) actual = false →
      approvals d = some p → withinScope new.installation p = true) :
    (guardedExecute new.arrangement.roster (envelope new.arrangement) (envelope new.arrangement)
      new.installation p reads approvals).succeeded = true ∧
    (guardedExecute new.arrangement.roster (envelope new.arrangement) (envelope new.arrangement)
      new.installation p reads approvals).installation.state.completed = true ∧
    withinScope new.installation p = true :=
  reconfigure_then_completes m.opened m.amount m.depth m.candidate old new step actual covered p
    reads approvals depthBound current readResponses issueResponses readFaithful issueFaithful

/-! ## Computed cases -/

/-- Three members, each failing by its own cause. -/
def separate3 : Arrangement := ⟨[0, 1, 2], FaultFormula.cause, [[0], [1], [2]]⟩
/-- Three members, the first two failing by one cause. -/
def merged3 : Arrangement :=
  ⟨[0, 1, 2], fun d => .cause (if d < 2 then 0 else 2), [[0], [1], [2]]⟩
/-- Four members, the first two sharing a cause, the others separate. -/
def repaired4 : Arrangement :=
  ⟨[0, 1, 2, 3], fun d => .cause (if d < 2 then 0 else d), [[0], [1], [2], [3]]⟩
/-- Four members in two shared causes. -/
def duplicated4 : Arrangement :=
  ⟨[0, 1, 2, 3], fun d => .cause (if d < 2 then 0 else 2), [[0], [2]]⟩
/-- The original managed installation. -/
def original : Managed := ⟨separate3, initial⟩

/-- **The induced envelopes.** -/
theorem envelopes_compute :
    envelope separate3 = [[0], [1], [2]] ∧
    envelope merged3 = [[0, 1], [], [2]] ∧
    envelope repaired4 = [[0, 1], [], [2], [3]] := by decide

/-- **Readiness of the arrangements.** -/
theorem readiness_cases :
    ready separate3 = true ∧ ready merged3 = false ∧
    ready repaired4 = true ∧ ready duplicated4 = false := by decide

/-- **Two members of one cause are not redundant.** -/
theorem same_cause_not_redundant :
    fails (.all (.cause 0) (.cause 0)) [0] = true ∧
    fails (.all (.cause 0) (.cause 1)) [0] = false ∧
    fails (.any (.cause 0) (.cause 1)) [0] = true := by decide

/-- **A stale envelope accepts support that a shared cause controls.** -/
theorem stale_envelope_accepts_shared :
    certificate merged3.roster (envelope separate3) (fun d => decide (d < 2)) = true ∧
    certificate merged3.roster (envelope merged3) (fun d => decide (d < 2)) = false := by decide

/-- **No reconfiguration to a roster sharing a cause.** -/
theorem shared_cause_rejected : reconfigure true 2 0 merged3 original = none := by decide

/-- The installation after the repaired reconfiguration. -/
def renewed : Managed := (reconfigure true 2 0 repaired4 original).getD original

/-- A shutdown request of the renewed epoch and serial. -/
def renewedRequest : Request := ⟨8, 1, [], true, .shutdown⟩
/-- Readings of the members outside the shared cause. -/
def survivingReads : Readings :=
  fun d => if d < 2 then none else some (observed renewed.installation [])
/-- Approvals of the members outside the shared cause. -/
def survivingApprovals : Approvals := fun d => if d < 2 then none else some renewedRequest

/-- **The repaired roster is installed**, leaving reserve 18, two drawn, epoch 8 and serial 1. -/
theorem repaired_installs :
    (reconfigure true 2 0 repaired4 original).isSome = true ∧
    renewed.installation.state.reserve = 18 ∧ renewed.installation.state.drawn = 2 ∧
    renewed.installation.state.epoch = 8 ∧ renewed.installation.serial = 1 := by decide

/-- **The surviving members complete the shutdown**, leaving 13 drawn, reserve 7 and serial 2. -/
theorem repaired_completes :
    (guardedExecute repaired4.roster (envelope repaired4) (envelope repaired4)
        renewed.installation renewedRequest survivingReads survivingApprovals).succeeded = true ∧
    (guardedExecute repaired4.roster (envelope repaired4) (envelope repaired4)
        renewed.installation renewedRequest survivingReads survivingApprovals).installation.state.running
      = false ∧
    (guardedExecute repaired4.roster (envelope repaired4) (envelope repaired4)
        renewed.installation renewedRequest survivingReads survivingApprovals).installation.state.drawn
      = 13 ∧
    (guardedExecute repaired4.roster (envelope repaired4) (envelope repaired4)
        renewed.installation renewedRequest survivingReads survivingApprovals).installation.state.reserve
      = 7 ∧
    (guardedExecute repaired4.roster (envelope repaired4) (envelope repaired4)
        renewed.installation renewedRequest survivingReads survivingApprovals).installation.serial
      = 2 := by decide

/-- **The previous epoch's approvals fail after the reconfiguration.** -/
theorem old_approvals_fail :
    Transactions.gate repaired4.roster (envelope repaired4) (envelope repaired4) renewed.installation request
      (faithfulReads initial request) (faithfulApprovals initial request) = false := by decide

/-- The original installation with reserve 12. -/
def lowReserve : Managed := ⟨separate3, {initial with state := {initial.state with reserve := 12}}⟩
/-- The original installation with reserve and deadline 13. -/
def combinedReserve : Managed :=
  ⟨separate3, {initial with state := {initial.state with reserve := 13, deadline := 13}}⟩

/-- **The step's own draw alone is not enough.** -/
theorem own_draw_short :
    2 ≤ lowReserve.installation.state.reserve ∧ reconfigure true 2 0 repaired4 lowReserve = none := by
  decide

/-- **The combined draw is enough.** -/
theorem combined_draw_suffices : (reconfigure true 2 0 repaired4 combinedReserve).isSome = true := by
  decide

/-- An arrangement whose formulas omit a cause shared by every member. -/
def omitted : Arrangement := ⟨[0, 1, 2], fun d => .any (.cause d) (.cause 9), [[0], [1], [2]]⟩

/-- **A cause the formulas omit still breaks the model**: the arrangement is ready, yet the
omitted cause fails every member. -/
theorem omitted_cause_breaks : ready omitted = true ∧ induced omitted [9] = [0, 1, 2] := by decide

/-- The rearrangement to the merged arrangement. -/
def toMerged : Rearrangement := ⟨true, 2, 0, merged3⟩
/-- The rearrangement to the repaired arrangement. -/
def toRepaired : Rearrangement := ⟨true, 2, 0, repaired4⟩

/-- **No step to a roster sharing a cause.** -/
theorem shared_cause_no_step : ¬ Enabled process original toMerged :=
  fun ⟨_, h⟩ => nomatch shared_cause_rejected.symm.trans h

theorem renewed_of_step {next : Managed} (step : process.step original toRepaired next) :
    renewed = next :=
  congrArg (fun o => Option.getD o original) (step_iff.mp step)

/-- **A step to the repaired roster**, and every such step leaves reserve 18, two drawn, epoch 8
and serial 1. -/
theorem separated_repair_steps :
    Enabled process original toRepaired ∧
      ∀ next, process.step original toRepaired next →
        next.installation.state.reserve = 18 ∧ next.installation.state.drawn = 2 ∧
          next.installation.state.epoch = 8 ∧ next.installation.serial = 1 :=
  ⟨enabled_iff.mpr repaired_installs.1, fun _ h => renewed_of_step h ▸ repaired_installs.2⟩

/-- **The step's own draw alone gives no step; the combined draw gives one.** -/
theorem own_draw_alone_no_step :
    toRepaired.amount ≤ lowReserve.installation.state.reserve ∧
      ¬ Enabled process lowReserve toRepaired :=
  ⟨own_draw_short.1, fun ⟨_, h⟩ => nomatch own_draw_short.2.symm.trans h⟩

/-- **The combined draw gives a step.** -/
theorem combined_draw_steps : Enabled process combinedReserve toRepaired :=
  enabled_iff.mpr combined_draw_suffices

/-- **After the repaired step, the earlier epoch's approvals fail the gate.** -/
theorem repaired_step_rejects_old {next : Managed} (step : process.step original toRepaired next) :
    Transactions.gate repaired4.roster (envelope repaired4) (envelope repaired4) next.installation request
      (faithfulReads initial request) (faithfulApprovals initial request) = false :=
  renewed_of_step step ▸ old_approvals_fail

/-- **After the repaired step, the surviving members complete the shutdown.** -/
theorem repaired_step_completes {next : Managed} (step : process.step original toRepaired next) :
    (guardedExecute repaired4.roster (envelope repaired4) (envelope repaired4)
        next.installation renewedRequest survivingReads survivingApprovals).succeeded = true ∧
    (guardedExecute repaired4.roster (envelope repaired4) (envelope repaired4)
        next.installation renewedRequest survivingReads survivingApprovals).installation.state.running
      = false ∧
    (guardedExecute repaired4.roster (envelope repaired4) (envelope repaired4)
        next.installation renewedRequest survivingReads survivingApprovals).installation.state.drawn
      = 13 ∧
    (guardedExecute repaired4.roster (envelope repaired4) (envelope repaired4)
        next.installation renewedRequest survivingReads survivingApprovals).installation.state.reserve
      = 7 ∧
    (guardedExecute repaired4.roster (envelope repaired4) (envelope repaired4)
        next.installation renewedRequest survivingReads survivingApprovals).installation.serial = 2 :=
  renewed_of_step step ▸ repaired_completes

/-! ## Bridge to `Becoming.OpenComposition`: Fault-Envelope Channels, Live Swaps & Narrowing -/

section OpenCompositionBridge

/-- An alarm channel gated by a reconfiguration arrangement's fault-envelope certificate. -/
def envelopeChannel {Env : Type} (a : Arrangement)
    (report : Bool → Nat → Env → Domain → Bool)
    (em : Bool) (load : Nat) (env : Env) : Bool :=
  certificate a.roster (envelope a) (report em load env)

/-- **B1 (Viability & Alarm Soundness):** Whenever arrangement `a` is ready and covers actual
root causes `actual env`, responsive surviving witnesses certify closed-loop `Viability.Kernel`
via `induced_certificate_available` and simultaneously enforce envelope alarm soundness via
`induced_certificate_sound`. -/
theorem faultEnvelope_channel_viable {S Obs Dist Int Ext Env : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) {init : S}
    (c : OpenComposition.InterfaceContract C init)
    (a : Arrangement) (actual : Env → List Nat)
    (report : Bool → Nat → Env → Domain → Bool)
    (obs : (Ext → Nat) → Obs)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (isReady : ready a = true)
    (covered : ∀ env, jointAdm env → Covered a (actual env))
    (report_faithful : ∀ load env d, jointAdm env → load ≤ c.maxSilence → d ∈ a.roster →
      fails (a.vulnerability d) (actual env) = false → report true load env d = true)
    (obs_detects : ∀ x k, x k < warnLevel k → c.warnObs (obs x))
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_budget : ∀ k, c.postBudgetExt k + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k + (c.maxLag + 1) * (c.preCapExt k + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k + c.eta init * (c.preCapExt k + envCap k) ≤ x₀ k) :
    Viability.Kernel
      (OpenComposition.closedProcess C c obs (envelopeChannel a report) G envDraw jointAdm)
      (OpenComposition.closedGuard C c x_crit) (x₀, init) ∧
    (∀ em load env (P : Prop), jointAdm env →
      (∀ d, d ∈ a.roster → fails (a.vulnerability d) (actual env) = false →
        report em load env d = true → P) →
      envelopeChannel a report em load env = true → P) :=
  ⟨OpenComposition.close_contract_kernel C c obs (envelopeChannel a report) G envDraw envCap
      jointAdm env_within x_crit warnLevel H_safe x₀ obs_detects
      (fun load env adm hLoad =>
        induced_certificate_available a (actual env) (covered env adm) isReady
          (report true load env) (fun d mem ok => report_faithful load env d adm hLoad mem ok))
      G_rises post_viable post_budget warn_margin init_margin,
   fun em load env P adm faithful acc =>
     induced_certificate_sound a (actual env) (covered env adm) (report em load env) P faithful acc⟩

private theorem mem_append_or {α : Type} {x : α} :
    ∀ {xs ys : List α}, x ∈ xs ++ ys → x ∈ xs ∨ x ∈ ys
  | [], _, h => Or.inr h
  | _ :: _, _, .head _ => Or.inl (.head _)
  | _ :: _, _, .tail _ h => match mem_append_or h with
    | Or.inl h1 => Or.inl (.tail _ h1)
    | Or.inr h2 => Or.inr h2

private theorem merged3_copied_certificate_false {extra : List Domain}
    {vuln : Domain → FaultFormula} {s : Domain → Bool}
    (vuln_roster : ∀ d, d ∈ merged3.roster → vuln d = merged3.vulnerability d)
    (copied_vuln : ∀ e, e ∈ extra → ∃ d, d ∈ merged3.roster ∧ s e = s d ∧
      vuln e = merged3.vulnerability d)
    (h0 : s 0 = false) (h1 : s 1 = false) :
    certificate (extra ++ merged3.roster)
      (envelope ⟨extra ++ merged3.roster, vuln, merged3.rootFaults⟩) s = false := by
  let a' : Arrangement := ⟨extra ++ merged3.roster, vuln, merged3.rootFaults⟩
  cases hc : certificate (extra ++ merged3.roster) (envelope a') s with
  | false => rfl
  | true =>
    have hmem : induced a' [2] ∈ envelope a' :=
      induced_mem_envelope (.tail _ (.tail _ (.head _)) : [2] ∈ merged3.rootFaults)
    obtain ⟨w, hw, hs, hout⟩ :=
      certificate_witness (extra ++ merged3.roster) (envelope a') s hc (induced a' [2]) hmem
    have hfail_false : fails (vuln w) [2] = false := by
      cases hf : fails (vuln w) [2] with
      | false => rfl
      | true => exact absurd ((mem_induced_iff a' [2] w).mpr ⟨hw, hf⟩) hout
    have hcheck : ∀ d, d ∈ merged3.roster → s d = true → fails (vuln d) [2] = false → False := by
      intro d hd hsd hfd
      cases hd with
      | head => rw [h0] at hsd; exact Bool.noConfusion hsd
      | tail _ h => cases h with
        | head => rw [h1] at hsd; exact Bool.noConfusion hsd
        | tail _ h => cases h with
          | head =>
            rw [vuln_roster 2 (.tail _ (.tail _ (.head _)) : (2 : Domain) ∈ merged3.roster)] at hfd
            exact Bool.noConfusion hfd
          | tail _ h => exact nomatch h
    cases mem_append_or hw with
    | inl hwe =>
      obtain ⟨d, hd, hse, hve⟩ := copied_vuln w hwe
      have hfd : fails (vuln d) [2] = false := by
        rw [vuln_roster d hd, ← hve]; exact hfail_false
      exact False.elim (hcheck d hd (hse ▸ hs) hfd)
    | inr hwr => exact False.elim (hcheck w hwr hs hfail_false)

private theorem widened_orbit_trace (channel : Bool → Nat → Unit → Bool) :
    ∀ n st, Trace
      (OpenComposition.closedProcess
        (OpenComposition.OpenComponent.compose
          OpenComposition.WideningWitness.widenedAgent OpenComposition.WideningWitness.widenedAgent)
        (OpenComposition.composeContract
          (OpenComposition.WideningWitness.widenedContract true)
          (OpenComposition.WideningWitness.widenedContract true))
        (fun x => (Nat.blt (x ()) 8, Nat.blt (x ()) 8)) channel
        OpenComposition.WideningWitness.gShared (fun (_ : Unit) (_ : Unit) => 0) (fun _ => True))
      st (List.replicate n ((), ((), ())))
      (Law.orbit (fun s => OpenComposition.closedStep
        (OpenComposition.OpenComponent.compose
          OpenComposition.WideningWitness.widenedAgent OpenComposition.WideningWitness.widenedAgent)
        (fun x => (Nat.blt (x ()) 8, Nat.blt (x ()) 8)) channel
        OpenComposition.WideningWitness.gShared (fun (_ : Unit) (_ : Unit) => 0) s ((), ((), ()))) st n)
  | 0, st => .nil st
  | n + 1, st =>
    .cons ⟨⟨trivial, fun _ => ⟨trivial, trivial⟩⟩, rfl⟩
      ((Law.orbit_shift _ st n).symm ▸ widened_orbit_trace channel n _)

/-- **B1 Sharpness (`correlated_faults_break_envelope_channel`):** On `widenedAgent ⊕ widenedAgent`
over `gShared` from `x₀ = 6`, `repaired4` sustains a certified `Viability.Kernel` even under root
cause `[0]`, whereas replacing it with `merged3` — or ANY copied extension `extra ++ merged3.roster` —
silences the channel whenever failed domains `{0, 1}` do not fire, driving `closedProcess` to `0` at
step `6` and refuting `Viability.Kernel`. -/
theorem correlated_faults_break_envelope_channel (extra : List Domain)
    (vuln : Domain → FaultFormula)
    (report : Bool → Nat → Unit → Domain → Bool)
    (vuln_roster : ∀ d, d ∈ merged3.roster → vuln d = merged3.vulnerability d)
    (copies : ∀ e, e ∈ extra → ∃ d, d ∈ merged3.roster ∧
      (∀ em, report em 0 () e = report em 0 () d) ∧
      vuln e = merged3.vulnerability d)
    (silent_failed : ∀ em d, d ∈ merged3.roster →
      fails (merged3.vulnerability d) [0] = true → report em 0 () d = false) :
    let comp := OpenComposition.OpenComponent.compose
      OpenComposition.WideningWitness.widenedAgent OpenComposition.WideningWitness.widenedAgent
    let cont := OpenComposition.composeContract
      (OpenComposition.WideningWitness.widenedContract true)
      (OpenComposition.WideningWitness.widenedContract true)
    let obs := fun (x : Unit → Nat) => (Nat.blt (x ()) 8, Nat.blt (x ()) 8)
    let mergedCopied : Arrangement := ⟨extra ++ merged3.roster, vuln, merged3.rootFaults⟩
    let stepBad := fun st => OpenComposition.closedStep comp obs
      (envelopeChannel mergedCopied report) OpenComposition.WideningWitness.gShared
      (fun (_ : Unit) (_ : Unit) => 0) st ((), ((), ()))
    Viability.Kernel
      (OpenComposition.closedProcess comp cont obs
        (envelopeChannel repaired4 (fun em _ _ d => em && decide (2 ≤ d)))
        OpenComposition.WideningWitness.gShared (fun (_ : Unit) (_ : Unit) => 0) (fun _ => True))
      (OpenComposition.closedGuard comp cont (fun _ => 3))
      (fun _ => 6, (true, true)) ∧
    (Law.orbit stepBad (fun _ => 6, (true, true)) 6).1 () = 0 ∧
    ¬ Viability.Kernel
      (OpenComposition.closedProcess comp cont obs
        (envelopeChannel mergedCopied report) OpenComposition.WideningWitness.gShared
        (fun (_ : Unit) (_ : Unit) => 0) (fun _ => True))
      (OpenComposition.closedGuard comp cont (fun _ => 3))
      (fun _ => 6, (true, true)) := by
  dsimp only
  have hViable := faultEnvelope_channel_viable
    (OpenComposition.OpenComponent.compose
      OpenComposition.WideningWitness.widenedAgent OpenComposition.WideningWitness.widenedAgent)
    (OpenComposition.composeContract
      (OpenComposition.WideningWitness.widenedContract true)
      (OpenComposition.WideningWitness.widenedContract true))
    repaired4 (fun _ => [0]) (fun em _ _ d => em && decide (2 ≤ d))
    (fun x => (Nat.blt (x ()) 8, Nat.blt (x ()) 8))
    OpenComposition.WideningWitness.gShared (fun (_ : Unit) (_ : Unit) => 0)
    (fun _ => 0) (fun _ => True) (fun _ _ _ => Nat.zero_le 0)
    (fun _ => 3) (fun _ => 8) (fun _ => 0) (fun _ => 6)
    (by decide) (fun _ _ => ⟨[0], .head _, fun _ h => h⟩)
    (fun _ _ d _ _ mem ok => by
      cases mem with
      | head => exact Bool.noConfusion ok
      | tail _ h => cases h with
        | head => exact Bool.noConfusion ok
        | tail _ h => cases h with
          | head => rfl
          | tail _ h => cases h with
            | head => rfl
            | tail _ h => exact nomatch h)
    (fun x k lt => by cases k; exact Or.inl (CoreHelpers.natBlt_true_iff.mpr lt))
    OpenComposition.WideningWitness.gShared_rises
    (fun k => by cases k; show 3 ≤ 3 - 0 + OpenComposition.WideningWitness.gShared () (fun _ => 3 - 0); exact by decide)
    (fun k => by cases k; exact Nat.le_refl 0)
    (fun k => by cases k; show 3 + (CoreHelpers.natMax 1 1 + 1) * (1 + 1 + 0) ≤ 8; exact by decide)
    (fun k => by cases k; show 3 + CoreHelpers.natMax 1 1 * (1 + 1 + 0) ≤ 6; exact by decide)
  have h0f : ∀ em, report em 0 () 0 = false := fun em =>
    silent_failed em 0 (.head _) (by decide)
  have h1f : ∀ em, report em 0 () 1 = false := fun em =>
    silent_failed em 1 (.tail _ (.head _)) (by decide)
  have chFalse : ∀ em, envelopeChannel
      ⟨extra ++ merged3.roster, vuln, merged3.rootFaults⟩ report em 0 () = false := fun em =>
    merged3_copied_certificate_false vuln_roster
      (fun e he => match copies e he with | ⟨d, hd, hrep, hv⟩ => ⟨d, hd, hrep em, hv⟩)
      (h0f em) (h1f em)
  let stepBad := fun st => OpenComposition.closedStep
    (OpenComposition.OpenComponent.compose
      OpenComposition.WideningWitness.widenedAgent OpenComposition.WideningWitness.widenedAgent)
    (fun x => (Nat.blt (x ()) 8, Nat.blt (x ()) 8))
    (envelopeChannel ⟨extra ++ merged3.roster, vuln, merged3.rootFaults⟩ report)
    OpenComposition.WideningWitness.gShared (fun (_ : Unit) (_ : Unit) => 0) st ((), ((), ()))
  have hStay : ∀ t, (Law.orbit stepBad (fun _ => 6, (true, true)) t).2 = (true, true) := by
    intro t
    induction t with
    | zero => rfl
    | succ t ih =>
      show (stepBad (Law.orbit stepBad (fun _ => 6, (true, true)) t)).2 = (true, true)
      have h1 : (Law.orbit stepBad (fun _ => 6, (true, true)) t).2.1 = true := congrArg Prod.fst ih
      have h2 : (Law.orbit stepBad (fun _ => 6, (true, true)) t).2.2 = true := congrArg Prod.snd ih
      dsimp only [stepBad, OpenComposition.closedStep, OpenComposition.closedStepWith,
        OpenComposition.OpenComponent.compose, OpenComposition.WideningWitness.widenedAgent] at h1 h2 ⊢
      rw [h1, h2]
      rw [show (0 : Nat) + 0 = 0 from rfl, chFalse]
      rfl
  have hEq : ∀ t, (Law.orbit stepBad (fun _ => 6, (true, true)) t).1 () =
      (Law.run (RegimeMargin.step (fun z => OpenComposition.WideningWitness.gShared () (fun _ => z)) 2) 6).state t := by
    intro t
    induction t with
    | zero => rfl
    | succ t ih =>
      show (stepBad (Law.orbit stepBad (fun _ => 6, (true, true)) t)).1 () = _
      have ht := hStay t
      have hdraw : OpenComposition.WideningWitness.widenedAgent.drawExt
            (Law.orbit stepBad (fun _ => 6, (true, true)) t).2.1 () +
          OpenComposition.WideningWitness.widenedAgent.drawExt
            (Law.orbit stepBad (fun _ => 6, (true, true)) t).2.2 () = 2 := by
        rw [ht]; rfl
      show RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
          OpenComposition.WideningWitness.gShared
          (fun _ =>
            OpenComposition.WideningWitness.widenedAgent.drawExt
              (Law.orbit stepBad (fun _ => 6, (true, true)) t).2.1 () +
            OpenComposition.WideningWitness.widenedAgent.drawExt
              (Law.orbit stepBad (fun _ => 6, (true, true)) t).2.2 () + 0)
          (Law.orbit stepBad (fun _ => 6, (true, true)) t).1 () =
        RegimeMargin.step (fun z => OpenComposition.WideningWitness.gShared () (fun _ => z)) 2
          ((Law.run (RegimeMargin.step (fun z => OpenComposition.WideningWitness.gShared () (fun _ => z)) 2) 6).state t)
      dsimp only [RegimeMargin.Coupled.Indexed.step, RegimeMargin.Coupled.Indexed.left,
        RegimeMargin.step, RegimeMargin.Drawn.whole, Amounts.whole,
        OpenComposition.WideningWitness.gShared]
      rw [hdraw, Nat.add_zero]
      exact congrArg (fun z => (z - 2) + if 3 ≤ z - 2 then 1 else 0) ih
  have hCrash : (Law.orbit stepBad (fun _ => 6, (true, true)) 6).1 () = 0 :=
    (hEq 6).trans (by decide)
  refine ⟨hViable.1, hCrash, fun kern => ?_⟩
  have h6 := kern _ ⟨_, widened_orbit_trace (envelopeChannel ⟨extra ++ merged3.roster, vuln, merged3.rootFaults⟩ report) 6 (fun _ => 6, (true, true))⟩
  have hle : 3 ≤ (Law.orbit stepBad (fun _ => 6, (true, true)) 6).1 () := h6.1 ()
  rw [hCrash] at hle
  exact Nat.not_succ_le_zero 2 hle

/-- Guard an `OpenComponent` by requiring envelope certificate validation alongside `C.emitAlarm`. -/
def guardedByEnvelope {S Obs Dist Int Ext : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext)
    (roster : List Domain) (env : Envelope) :
    OpenComposition.OpenComponent S (Obs × (Domain → Bool)) Dist Int Ext where
  next s oa d := C.next s (oa.1.1, oa.2) d
  drawInt := C.drawInt
  drawExt := C.drawExt
  emitAlarm s o := C.emitAlarm s o.1 && certificate roster env o.2
  silenceLoad := C.silenceLoad
  favours := C.favours

/-- Guard an `OpenComponent` by a reconfiguration arrangement's roster and induced envelope. -/
def guardedByArrangement {S Obs Dist Int Ext : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) (a : Arrangement) :
    OpenComposition.OpenComponent S (Obs × (Domain → Bool)) Dist Int Ext :=
  guardedByEnvelope C a.roster (envelope a)

/-- Lift any `InterfaceContract` onto `guardedByEnvelope` (`warnObs` requires envelope acceptance). -/
def guardedEnvelopeContract {S Obs Dist Int Ext : Type}
    {C : OpenComposition.OpenComponent S Obs Dist Int Ext} {init : S}
    (c : OpenComposition.InterfaceContract C init)
    (roster : List Domain) (env : Envelope) :
    OpenComposition.InterfaceContract (guardedByEnvelope C roster env) init where
  tol oa d := c.tol (oa.1.1, oa.2) d
  warnObs o := c.warnObs o.1 ∧ certificate roster env o.2 = true
  preCapInt := c.preCapInt
  preCapExt := c.preCapExt
  postBudgetInt := c.postBudgetInt
  postBudgetExt := c.postBudgetExt
  maxSilence := c.maxSilence
  maxLag := c.maxLag
  K := c.K
  eta := c.eta
  init_in := c.init_in
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨c.cert.within, fun s m adm hs => c.cert.closed s ((m.1.1.1, m.1.2), m.2) _ ⟨adm, rfl⟩ hs⟩
  eta_bound := c.eta_bound
  emits_on_warn s o hK hw := by
    show (C.emitAlarm s o.1 && certificate roster env o.2) = true
    rw [c.emits_on_warn s o.1 hK hw.1, hw.2]
    rfl
  eta_alarm_step s o d htol := c.eta_alarm_step s o.1 d htol
  eta_alarm_zero s o d htol := c.eta_alarm_zero s o.1 d htol

/-- **B2 (Live `Reconfiguration.process` transitions drive `OpenComposition.ReconfigProcess`):**
Any transition `step : process.step old m new` guarantees readiness and separated induced
envelope on `new.arrangement`, lifts both components via `induced_certificate_available`, and
certifies permanent `Viability.Kernel` of `ReconfigProcess` across arbitrary swap timing alongside
epoch staling and scope preservation. -/
theorem reconfig_step_induces_live_swap
    {S₁ S₁' Obs₁ Obs₁' Dist₁ Dist₁' Int₁ Int₁' Ext Env : Type}
    {old new : Managed} {m : Rearrangement}
    (step : process.step old m new) (oldReady : ready old.arrangement = true)
    (A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (A' : OpenComposition.OpenComponent S₁' Obs₁' Dist₁' Int₁' Ext)
    {init₁ : S₁} {init₁' : S₁'}
    (cA : OpenComposition.InterfaceContract A init₁)
    (cA' : OpenComposition.InterfaceContract A' init₁')
    (obs₁ : (Ext → Nat) → Obs₁) (obs₁' : (Ext → Nat) → Obs₁')
    (actual : List Nat) (cov₁ : Covered old.arrangement actual) (cov₂ : Covered new.arrangement actual)
    (rep₁ rep₂ : (Ext → Nat) → Domain → Bool)
    (resp₁ : ∀ x d, d ∈ old.arrangement.roster →
      fails (old.arrangement.vulnerability d) actual = false → rep₁ x d = true)
    (resp₂ : ∀ x d, d ∈ new.arrangement.roster →
      fails (new.arrangement.vulnerability d) actual = false → rep₂ x d = true)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (cap_le : ∀ k, cA'.preCapExt k ≤ cA.preCapExt k)
    (post_le : ∀ k, cA'.postBudgetExt k ≤ cA.postBudgetExt k)
    (sil_le : cA'.maxSilence ≤ cA.maxSilence)
    (lag_le : cA'.maxLag ≤ cA.maxLag)
    (obs_detects₁ : ∀ x k, x k < warnLevel k → cA.warnObs (obs₁ x))
    (obs_detects₂ : ∀ x k, x k < warnLevel k → cA'.warnObs (obs₁' x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ cA.maxSilence →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_budget : ∀ k, cA.postBudgetExt k + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k + (cA.maxLag + 1) * (cA.preCapExt k + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k + cA.eta init₁ * (cA.preCapExt k + envCap k) ≤ x₀ k) :
    ready new.arrangement = true ∧
    separated new.arrangement.roster (envelope new.arrangement) ∧
    (∀ p, p.epoch = old.installation.state.epoch → fresh new.installation p = false) ∧
    Viability.Kernel
      (OpenComposition.ReconfigProcess
        (guardedByArrangement A old.arrangement) (guardedByArrangement A' new.arrangement)
        (guardedEnvelopeContract cA old.arrangement.roster (envelope old.arrangement))
        (guardedEnvelopeContract cA' new.arrangement.roster (envelope new.arrangement))
        (fun x => (obs₁ x, rep₁ x)) (fun x => (obs₁' x, rep₂ x))
        channel G envDraw jointAdm)
      (fun st => match st with
        | .inl st₁ => OpenComposition.closedGuard (guardedByArrangement A old.arrangement)
            (guardedEnvelopeContract cA old.arrangement.roster (envelope old.arrangement)) x_crit st₁
        | .inr st₂ => OpenComposition.closedGuard (guardedByArrangement A' new.arrangement)
            (guardedEnvelopeContract cA' new.arrangement.roster (envelope new.arrangement)) x_crit st₂)
      (.inl (x₀, init₁)) := by
  have hren := step_renews step
  have newReady : ready new.arrangement = true := hren.2.2.1 ▸ hren.2.1
  have hkern := OpenComposition.rewrite_step_viable
    (guardedByArrangement A old.arrangement) (guardedByArrangement A' new.arrangement)
    (guardedEnvelopeContract cA old.arrangement.roster (envelope old.arrangement))
    (guardedEnvelopeContract cA' new.arrangement.roster (envelope new.arrangement))
    (fun x => (obs₁ x, rep₁ x)) (fun x => (obs₁' x, rep₂ x))
    channel G envDraw envCap jointAdm env_within
    x_crit warnLevel H_safe x₀
    cap_le post_le sil_le lag_le
    (fun x k lt => ⟨obs_detects₁ x k lt,
      induced_certificate_available old.arrangement actual cov₁ oldReady (rep₁ x) (resp₁ x)⟩)
    (fun x k lt => ⟨obs_detects₂ x k lt,
      induced_certificate_available new.arrangement actual cov₂ newReady (rep₂ x) (resp₂ x)⟩)
    channel_fires G_rises post_viable post_budget warn_margin init_margin
  exact ⟨newReady, (step_separated step).2, fun p hp => step_stales_old_epoch step p hp, hkern⟩

/-- **B3 (`stronger_envelope_contract_refines`):** Whenever `env₁` covers every fault set of
nonempty `env₂` (`∀ b ∈ env₂, ∃ f ∈ env₁, ∀ d ∈ b, d ∈ f`), `stronger_envelope_no_new_acceptance`
makes `guardedEnvelopeContract c roster env₂` refine `guardedEnvelopeContract c roster env₁`. -/
theorem stronger_envelope_contract_refines
    {S Obs Dist Int Ext : Type}
    {C : OpenComposition.OpenComponent S Obs Dist Int Ext} {init : S}
    (c : OpenComposition.InterfaceContract C init)
    (roster : List Domain) (env₁ env₂ : Envelope)
    (nonempty : env₂ ≠ [])
    (covers : ∀ b, b ∈ env₂ → ∃ f, f ∈ env₁ ∧ ∀ d, d ∈ b → d ∈ f)
    (obs : (Ext → Nat) → Obs)
    (rep : (Ext → Nat) → Domain → Bool)
    (warnLevel : Ext → Nat) :
    OpenComposition.ContractRefines
      (guardedEnvelopeContract c roster env₁)
      (guardedEnvelopeContract c roster env₂)
      (fun x => (obs x, rep x))
      (fun x => (obs x, rep x))
      warnLevel where
  preCapExt_le _ := Nat.le_refl _
  postBudgetExt_le _ := Nat.le_refl _
  maxSilence_le := Nat.le_refl _
  maxLag_le := Nat.le_refl _
  init_eta_le := Nat.le_refl _
  warn_preserved x hw _ :=
    ⟨hw.1, stronger_envelope_no_new_acceptance roster env₂ env₁ (rep x) nonempty covers hw.2⟩

/-- **B3 Corollary:** Narrowing an envelope (`env₁ ↝ env₂`) upgrades `A ⊕_K B` via
`OpenComposition.replace_left_viable` without re-checking `B`. -/
theorem stronger_envelope_replace_left_viable
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext Env : Type}
    (A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext)
    {init₁ : S₁} {init₂ : S₂}
    (cA : OpenComposition.InterfaceContract A init₁)
    (cB : OpenComposition.InterfaceContract B init₂)
    (roster : List Domain) (env₁ env₂ : Envelope)
    (nonempty : env₂ ≠ [])
    (covers : ∀ b, b ∈ env₂ → ∃ f, f ∈ env₁ ∧ ∀ d, d ∈ b → d ∈ f)
    (obs₁ : (Ext → Nat) → Obs₁) (rep : (Ext → Nat) → Domain → Bool)
    (obs₂ : (Ext → Nat) → Obs₂)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (obs_detects_orig : ∀ x k, x k < warnLevel k →
      (cA.warnObs (obs₁ x) ∧ certificate roster env₁ (rep x) = true) ∨ cB.warnObs (obs₂ x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ cA.maxSilence + cB.maxSilence →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_budget : ∀ k, (cA.postBudgetExt k + cB.postBudgetExt k) + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k +
      (CoreHelpers.natMax cA.maxLag cB.maxLag + 1) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k +
      CoreHelpers.natMax (cA.eta init₁) (cB.eta init₂) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ x₀ k) :
    Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.OpenComponent.compose (guardedByEnvelope A roster env₂) B)
        (OpenComposition.composeContract (guardedEnvelopeContract cA roster env₂) cB)
        (fun x => ((obs₁ x, rep x), obs₂ x)) channel G envDraw jointAdm)
      (OpenComposition.closedGuard
        (OpenComposition.OpenComponent.compose (guardedByEnvelope A roster env₂) B)
        (OpenComposition.composeContract (guardedEnvelopeContract cA roster env₂) cB) x_crit)
      (x₀, (init₁, init₂)) :=
  OpenComposition.replace_left_viable
    (guardedByEnvelope A roster env₁) (guardedByEnvelope A roster env₂) B
    (guardedEnvelopeContract cA roster env₁) (guardedEnvelopeContract cA roster env₂) cB
    (fun x => (obs₁ x, rep x)) (fun x => (obs₁ x, rep x)) obs₂
    channel G envDraw envCap jointAdm env_within x_crit warnLevel H_safe x₀
    (stronger_envelope_contract_refines cA roster env₁ env₂ nonempty covers obs₁ rep warnLevel)
    obs_detects_orig channel_fires G_rises post_viable post_budget warn_margin init_margin

end OpenCompositionBridge

end Reconfiguration

end Becoming
