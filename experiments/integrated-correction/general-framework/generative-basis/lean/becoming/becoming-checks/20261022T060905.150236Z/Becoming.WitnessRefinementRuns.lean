import Becoming.WitnessRefinement

/-!
# Inspection by fallible witnesses as a process, for every roster

`Becoming.WitnessRefinement` states the laws of a roster of witnesses, the fault sets each model
admits and the reports they give, for every roster, and reads them as a process (`audit`) only on
the computed situations of four or five witnesses. Here the process is stated for every roster,
fault sets and answers: a transcript of reports steps a list of candidate models to the models it
leaves compatible (`inspection`); an answer to a test steps it to the models agreeing with the
answer (`testing`). The audit's candidates move by `inspection` (`WitnessRefinement.step_candidates`) and the
inquiry's by `testing` (`inquiry_step_testing`), so every law below holds of those processes too.
The certificate of a state is taken over the pool of the fault sets its candidates admit.

* **What a step keeps.** A step keeps exactly the candidates some admitted fault set of which
  explains the reports (`mem_step`); a silent transcript keeps exactly the candidates admitting
  some fault set (`silent_step`, `WitnessRefinement.silence_keeps_models`), and a candidate
  admitting none is removed by every step (`step_admits`); so after a step the pool is empty
  exactly where no candidate remains, and a certificate after a step needs a candidate
  (`step_certificate_candidate`, `FaultEnvelopes.empty_envelope_rejects`). Candidates only narrow
  along every run (`run_narrows`).
* **What a complete transcript distinguishes.** After a step on a complete transcript, two
  remaining candidates whose envelopes are cross-separated give the same answer
  (`complete_step_agrees`, `WitnessRefinement.cross_separation_excludes`), and so at every later
  state of the run (`complete_run_agrees`); witnesses responding with one answer outside a fault
  set remove every candidate with the other answer each of whose fault sets leaves one of them
  outside (`responsive_step_excludes`); two candidates with fault sets covering the roster are
  both kept by one complete transcript, after which the support of the witnesses outside the
  first fault set certifies nothing (`covering_step_keeps_both`,
  `WitnessRefinement.covering_faults_same_transcript`, `FaultEnvelopes.covering_faults_reject`);
  and two candidates with different answers are told apart by every step on a complete transcript
  exactly where their envelopes are cross-separated (`diagnosable_iff`,
  `WitnessRefinement.complete_diagnosability_iff_cross_separation`).
* **No warrant from multiplicity, none from a model admitting every failure.** Listing the roster
  twice changes no step and no certificate (`doubled_roster_same`,
  `FaultEnvelopes.duplicated_roster_same`); a candidate admitting the failure of the whole roster
  is kept by every step, and no certificate over the pool holds at any later state of a run it is
  in (`total_fault_kept`, `total_fault_blocks`, `FaultEnvelopes.total_fault_rejects`).
* **Testing.** A test answer leaving no candidate was no candidate's answer and certifies nothing
  (`test_emptied`, `PooledEnvelopes.empty_family_rejects`); a separated pool after a faithful test
  step completes a guarded transaction with faithful members (`test_step_completes`,
  `PooledEnvelopes.pooled_completes`).

The roster, the fault sets, the answers and the faithfulness of the witnesses outside the actual
fault set are supplied, as in the modules read. No premise; every declaration has an empty axiom
report.
* **Copied witnesses change nothing.** Where each added witness copies one on the roster, in its
  reports, its support and every fault set it is inside, inspection takes the same steps and gives
  the same certificate (`copied_witnesses_same`; `doubled_roster_same` its case).
-/

namespace Becoming

open Generative ListTests Naturals FaultEnvelopes Transactions Reconfiguration PooledEnvelopes
  WitnessRefinement

namespace WitnessRefinementRuns

variable {H : Type}

/-! ## The processes -/

/-- **Inspection by witnesses**, for every roster, fault sets and answers: a transcript of reports
steps the candidates to the candidates it leaves compatible. -/
def inspection (roster : List Domain) (faults : H → Envelope) (answer : H → Bool) :
    Process (List H) Reports where
  step ms reports ns := ns = refine roster faults answer ms reports

/-- **Testing**: an answer to the test steps the candidates to those agreeing with it. -/
def testing (test : H → Bool) : Process (List H) Bool where
  step ms a ns := ns = retain ms test a

/-- A transcript is complete where every witness of the roster reports. -/
def Complete (roster : List Domain) (reports : Reports) : Prop :=
  ∀ d, d ∈ roster → reports d ≠ none

/-- The pool of a state: every fault set a candidate admits. -/
def pool (faults : H → Envelope) (ms : List H) : Envelope := ms.flatMap faults

variable {roster : List Domain} {faults : H → Envelope} {answer : H → Bool}

/-- **A step keeps exactly the candidates some admitted fault set of which explains the
reports.** -/
theorem mem_step {ms ns : List H} {reports : Reports}
    (step : (inspection roster faults answer).step ms reports ns) (h : H) :
    h ∈ ns ↔ h ∈ ms ∧ compatible roster (faults h) (answer h) reports = true :=
  Eq.subst (motive := fun l => h ∈ l ↔ _) step.symm mem_filter_iff

/-- **Candidates only narrow along every run.** -/
theorem run_narrows (r : Run (inspection roster faults answer)) (n : Nat) :
    ∀ k h, h ∈ r.state (n + k) → h ∈ r.state n
  | 0, _, member => member
  | k + 1, h, member =>
    run_narrows r n k h ((mem_step (r.step (n + k)) h).mp member).1

/-! ## What a step keeps -/

/-- **A silent transcript keeps exactly the candidates admitting some fault set.** -/
theorem silent_step {ms ns : List H}
    (step : (inspection roster faults answer).step ms (fun _ => none) ns) (h : H) :
    h ∈ ns ↔ h ∈ ms ∧ faults h ≠ [] :=
  (mem_step step h).trans
    ⟨fun ⟨m, c⟩ => ⟨m, not_isEmpty_true_iff.mp
        ((silence_keeps_models roster (faults h) (answer h)).symm.trans c)⟩,
     fun ⟨m, n⟩ => ⟨m, (silence_keeps_models roster (faults h) (answer h)).trans
        (not_isEmpty_true_iff.mpr n)⟩⟩

/-- **A candidate admitting no fault set is removed by every step.** -/
theorem step_admits {ms ns : List H} {reports : Reports}
    (step : (inspection roster faults answer).step ms reports ns) {h : H} (member : h ∈ ns) :
    faults h ≠ [] :=
  fun none => match (compatible_iff roster (faults h) (answer h) reports).mp
      ((mem_step step h).mp member).2 with
    | ⟨_, admitted, _⟩ => not_mem_nil (Eq.subst (motive := fun l => _ ∈ l) none admitted)

/-- After a step the pool is empty exactly where no candidate remains. -/
theorem step_pool_empty_iff {ms ns : List H} {reports : Reports}
    (step : (inspection roster faults answer).step ms reports ns) :
    pool faults ns = [] ↔ ns = [] :=
  ⟨fun empty => match ns, step, empty with
    | [], _, _ => rfl
    | h :: _, step, empty =>
      have admits := step_admits step (.head _)
      match e : faults h with
      | [] => absurd e admits
      | bad :: _ =>
        have inPool : bad ∈ pool faults (h :: _) :=
          mem_flatMap_iff.mpr ⟨h, .head _, Eq.subst (motive := fun l => bad ∈ l) e.symm (.head _)⟩
        absurd (Eq.subst (motive := fun l => bad ∈ l) empty inPool) not_mem_nil,
   fun e => Eq.subst (motive := fun l => pool faults l = []) e.symm rfl⟩

/-- **A certificate after a step needs a remaining candidate**: an empty pool certifies nothing. -/
theorem step_certificate_candidate {ms ns : List H} {reports : Reports}
    (step : (inspection roster faults answer).step ms reports ns) (supports : Domain → Bool)
    (accepted : certificate roster (pool faults ns) supports = true) : ns ≠ [] :=
  fun empty =>
    nomatch (empty_envelope_rejects roster supports).symm.trans
      (Eq.subst (motive := fun l => certificate roster l supports = true)
        ((step_pool_empty_iff step).mpr empty) accepted)

/-! ## What a complete transcript distinguishes -/

/-- **After a step on a complete transcript, remaining candidates with cross-separated envelopes
give the same answer.** -/
theorem complete_step_agrees {ms ns : List H} {reports : Reports}
    (step : (inspection roster faults answer).step ms reports ns)
    (complete : Complete roster reports) {h h' : H} (kept : h ∈ ns) (kept' : h' ∈ ns)
    (apart : CrossSeparated roster (faults h) (faults h')) : answer h = answer h' :=
  match decEq (answer h) (answer h') with
  | isTrue same => same
  | isFalse different =>
    absurd ((mem_step step h').mp kept').2
      (false_iff_not.mp (cross_separation_excludes roster (faults h) (faults h') apart
        (answer h) (answer h') different reports complete ((mem_step step h).mp kept).2))

/-- **Once a complete transcript has been read, remaining candidates with cross-separated
envelopes give the same answer at every later state of the run.** -/
theorem complete_run_agrees (r : Run (inspection roster faults answer)) {n : Nat}
    (complete : Complete roster (r.act n)) (k : Nat) {h h' : H}
    (kept : h ∈ r.state (n + 1 + k)) (kept' : h' ∈ r.state (n + 1 + k))
    (apart : CrossSeparated roster (faults h) (faults h')) : answer h = answer h' :=
  complete_step_agrees (r.step n) complete (run_narrows r (n + 1) k h kept)
    (run_narrows r (n + 1) k h' kept') apart

/-- **Witnesses responding with one answer outside a fault set remove every candidate with the
other answer each of whose fault sets leaves one of them outside.** -/
theorem responsive_step_excludes {ms ns : List H} {reports : Reports}
    (step : (inspection roster faults answer).step ms reports ns) (bad : List Domain) (x : Bool)
    (responses : ∀ d, d ∈ roster → ¬ d ∈ bad → reports d = some x) {h : H}
    (other : answer h ≠ x)
    (apart : ∀ b, b ∈ faults h → ∃ d, d ∈ roster ∧ ¬ d ∈ bad ∧ ¬ d ∈ b) : ¬ h ∈ ns :=
  fun kept => false_iff_not.mp
    (responsive_survivors_exclude roster bad (faults h) x (answer h) (fun e => other e.symm)
      reports responses apart)
    ((mem_step step h).mp kept).2

/-- **Two candidates with fault sets covering the roster are both kept by one complete
transcript, after which the support of the witnesses outside the first fault set certifies
nothing.** -/
theorem covering_step_keeps_both {ms : List H} {h h' : H} (member : h ∈ ms) (member' : h' ∈ ms)
    {a b : List Domain} (ha : a ∈ faults h) (hb : b ∈ faults h')
    (cover : ∀ d, d ∈ roster → d ∈ a ∨ d ∈ b) :
    ∃ reports, Complete roster reports ∧
      ∀ ns, (inspection roster faults answer).step ms reports ns →
        h ∈ ns ∧ h' ∈ ns ∧ certificate roster (pool faults ns) (fun d => !(a.contains d)) = false :=
  match covering_faults_same_transcript roster a b (answer h) (answer h') cover with
  | ⟨first, second, complete⟩ =>
    ⟨_, complete, fun _ step =>
      have kept := (mem_step step h).mpr ⟨member, any_true_iff.mpr ⟨a, ha, first⟩⟩
      have kept' := (mem_step step h').mpr ⟨member', any_true_iff.mpr ⟨b, hb, second⟩⟩
      ⟨kept, kept', covering_faults_reject roster _ a b
        (mem_flatMap_iff.mpr ⟨h', kept', hb⟩) cover⟩⟩

/-- **Two candidates with different answers are told apart by every step on a complete transcript
exactly where their envelopes are cross-separated.** -/
theorem diagnosable_iff {h h' : H} (different : answer h ≠ answer h') :
    (∀ ms reports ns, Complete roster reports →
      (inspection roster faults answer).step ms reports ns → h ∈ ns → ¬ h' ∈ ns) ↔
    CrossSeparated roster (faults h) (faults h') :=
  (Iff.intro
    (fun told reports complete first => false_iff_not.mpr fun second =>
      told [h, h'] reports _ complete rfl
        (mem_filter_iff.mpr ⟨.head _, first⟩)
        (mem_filter_iff.mpr ⟨.tail _ (.head _), second⟩))
    (fun excludes _ reports _ complete step kept kept' =>
      absurd ((mem_step step h').mp kept').2
        (false_iff_not.mp (excludes reports complete ((mem_step step h).mp kept).2)))).trans
    (complete_diagnosability_iff_cross_separation roster (faults h) (faults h') (answer h)
      (answer h') different)

/-! ## No warrant from multiplicity, none from a model admitting every failure -/

theorem all_append {α : Type} (p : α → Bool) :
    ∀ (l m : List α), (l ++ m).all p = (l.all p && m.all p)
  | [], _ => rfl
  | a :: l, m => (congrArg (p a && ·) (all_append p l m)).trans (Bool.and_assoc (p a) _ _).symm

theorem and_self' (b : Bool) : (b && b) = b := match b with | true => rfl | false => rfl

theorem any_congr {α : Type} {p q : α → Bool} (same : ∀ x, p x = q x) :
    ∀ l : List α, l.any p = l.any q
  | [] => rfl
  | a :: l => by
    show (p a || l.any p) = (q a || l.any q)
    rw [same a, any_congr same l]

theorem filter_congr {α : Type} {p q : α → Bool} (same : ∀ x, p x = q x) :
    ∀ l : List α, l.filter p = l.filter q
  | [] => rfl
  | a :: l => by
    show (match p a with | true => a :: l.filter p | false => l.filter p) =
      (match q a with | true => a :: l.filter q | false => l.filter q)
    rw [same a, filter_congr same l]

theorem any_congr_on {α : Type} {p q : α → Bool} :
    ∀ {l : List α}, (∀ x, x ∈ l → p x = q x) → l.any p = l.any q
  | [], _ => rfl
  | a :: l, same => by
    show (p a || l.any p) = (q a || l.any q)
    rw [same a (.head l), any_congr_on fun x m => same x (.tail a m)]

/-- A test both of whose terms agree where the second is true adds the first nothing. -/
theorem and_absorbed {a b : Bool} (absorbed : b = true → a = true) : (a && b) = b :=
  match a, b with
  | true, false => rfl
  | false, false => rfl
  | true, true => rfl
  | false, true => absurd (absorbed rfl) (fun h => Bool.noConfusion h)

/-- A witness with another's report and membership of a fault set is witnessed alike. -/
theorem witnessed_copy {bad : List Domain} {x : Bool} {reports : Reports} {e d : Domain}
    (report : reports e = reports d) (alike : e ∈ bad ↔ d ∈ bad) :
    witnessed bad x reports e = witnessed bad x reports d := by
  unfold witnessed
  rw [report]
  cases hd : bad.contains d with
  | true => rw [contains_true_iff.mpr (alike.mpr (contains_true_iff.mp hd))]
  | false => rw [contains_false_iff.mpr fun within => (contains_false_iff.mp hd) (alike.mp within)]

/-- **Witnesses copying witnesses on the roster change no step and no certificate.** Where each
added witness reports as some witness on the roster does, supports as it does and lies in exactly
the fault sets it lies in among those any candidate admits, inspection over the longer roster
takes the same steps, and the certificate over every pool is the same: a witness whose report is
another's and whose failures go with it is no second check, however many are added. -/
theorem copied_witnesses_same {extra : List Domain} {reports : Reports} {supports : Domain → Bool}
    (copies : ∀ e, e ∈ extra → ∃ d, d ∈ roster ∧ reports e = reports d ∧ supports e = supports d ∧
      ∀ h bad, bad ∈ faults h → (e ∈ bad ↔ d ∈ bad)) (ms ns : List H) :
    ((inspection (extra ++ roster) faults answer).step ms reports ns ↔
      (inspection roster faults answer).step ms reports ns) ∧
    certificate (extra ++ roster) (pool faults ns) supports =
      certificate roster (pool faults ns) supports :=
  have explains_same : ∀ h bad x, bad ∈ faults h →
      explains (extra ++ roster) bad x reports = explains roster bad x reports :=
    fun h bad _ inside => (all_append _ extra roster).trans (and_absorbed fun all => all_true_iff.mpr
      fun e member => match copies e member with
        | ⟨d, onRoster, report, _, alike⟩ => (witnessed_copy report (alike h bad inside)).trans
            (all_true_iff.mp all d onRoster))
  have same : refine (extra ++ roster) faults answer ms reports =
      refine roster faults answer ms reports :=
    filter_congr (fun h => any_congr_on fun bad inside => explains_same h bad (answer h) inside) ms
  ⟨⟨fun e => e.trans same, fun e => e.trans same.symm⟩,
   copied_roster_same fun e member => match copies e member with
    | ⟨d, onRoster, _, support, alike⟩ => ⟨d, onRoster, support, fun bad pooled =>
        match mem_flatMap_iff.mp pooled with
        | ⟨h, _, inside⟩ => alike h bad inside⟩⟩

/-- **Listing the roster twice changes no step and no certificate**: each witness listed again
copies itself. -/
theorem doubled_roster_same (ms ns : List H) (reports : Reports) (supports : Domain → Bool) :
    ((inspection (roster ++ roster) faults answer).step ms reports ns ↔
      (inspection roster faults answer).step ms reports ns) ∧
    certificate (roster ++ roster) (pool faults ns) supports =
      certificate roster (pool faults ns) supports :=
  copied_witnesses_same (fun e member => ⟨e, member, rfl, rfl, fun _ _ _ => Iff.rfl⟩) ms ns

/-- **A candidate admitting the failure of the whole roster is kept by every step.** -/
theorem total_fault_kept {ms ns : List H} {reports : Reports}
    (step : (inspection roster faults answer).step ms reports ns) {h : H} (member : h ∈ ms)
    (total : roster ∈ faults h) : h ∈ ns :=
  (mem_step step h).mpr ⟨member, (compatible_iff roster (faults h) (answer h) reports).mpr
    ⟨roster, total, fun _ inside outside => absurd inside outside⟩⟩

/-- **While a candidate admitting the failure of the whole roster is in a run, it stays, and no
certificate over the pool holds at any later state.** -/
theorem total_fault_blocks (r : Run (inspection roster faults answer)) {n : Nat} {h : H}
    (member : h ∈ r.state n) (total : roster ∈ faults h) (supports : Domain → Bool) :
    ∀ k, h ∈ r.state (n + k) ∧ certificate roster (pool faults (r.state (n + k))) supports = false
  | 0 => ⟨member, total_fault_rejects roster _ supports (mem_flatMap_iff.mpr ⟨h, member, total⟩)⟩
  | k + 1 =>
    have kept := total_fault_kept (r.step (n + k)) (total_fault_blocks r member total supports k).1
      total
    ⟨kept, total_fault_rejects roster _ supports (mem_flatMap_iff.mpr ⟨h, kept, total⟩)⟩

/-! ## Testing -/

/-- **A test answer leaving no candidate was no candidate's answer, and certifies nothing.** -/
theorem test_emptied {test : H → Bool} {ms : List H} {a : Bool}
    (step : (testing test).step ms a []) (describe : H → Arrangement) (roster' : List Domain)
    (supports : Domain → Bool) :
    (∀ h, h ∈ ms → test h ≠ a) ∧ certificate roster' (pooled describe []) supports = false :=
  ⟨fun h member same => not_mem_nil (Eq.subst (motive := fun l => h ∈ l) step.symm
      (Eq.subst (motive := fun x => h ∈ retain ms test x) same (retained_truth ms test h member))),
   empty_family_rejects roster' describe supports⟩

/-- **A separated pool after a faithful test step, with faithful, responsive members working under
covered causes, completes a guarded transaction within the scope.** -/
theorem test_step_completes {test : H → Bool} (describe : H → Arrangement) {ms ns : List H}
    {actual : H} (step : (testing test).step ms (test actual) ns) (known : actual ∈ ms)
    (roots : List Nat) (covered : Covered (describe actual) roots)
    (apart : separated (describe actual).roster (pooled describe ns))
    (w : Installation) (p : Request) (reads : Readings) (approvals : Approvals)
    (current : fresh w p = true)
    (readResponses : ∀ d, d ∈ (describe actual).roster →
      fails ((describe actual).vulnerability d) roots = false → reads d = some (expected p))
    (issueResponses : ∀ d, d ∈ (describe actual).roster →
      fails ((describe actual).vulnerability d) roots = false → approvals d = some p)
    (readFaithful : ∀ d, d ∈ (describe actual).roster →
      fails ((describe actual).vulnerability d) roots = false →
      ∀ o, reads d = some o → o = observed w p.address)
    (issueFaithful : ∀ d, d ∈ (describe actual).roster →
      fails ((describe actual).vulnerability d) roots = false →
      approvals d = some p → withinScope w p = true)
    (stocked : load (describe actual).roster p + 3 ≤ w.state.reserve)
    (timely : w.state.time + load (describe actual).roster p + 3 ≤ w.state.deadline) :
    (guardedExecute (describe actual).roster (pooled describe ns) (pooled describe ns) w p reads
      approvals).succeeded = true ∧
    (guardedExecute (describe actual).roster (pooled describe ns) (pooled describe ns) w p reads
      approvals).installation.state.completed = true ∧
    withinScope w p = true :=
  Eq.subst (motive := fun l =>
      (guardedExecute (describe actual).roster (pooled describe l) (pooled describe l) w p reads
        approvals).succeeded = true ∧
      (guardedExecute (describe actual).roster (pooled describe l) (pooled describe l) w p reads
        approvals).installation.state.completed = true ∧
      withinScope w p = true) step.symm
    (pooled_completes describe ms test actual known roots covered
      (Eq.subst (motive := fun l => separated (describe actual).roster (pooled describe l)) step
        apart)
      w p reads approvals current readResponses issueResponses readFaithful issueFaithful stocked
      timely)

/-! ## The computed processes are instances -/

/-- **The inquiry's candidates move by testing**: an inspection step of `inquiry` is a step of
`testing` on the candidates, for the inspection's law. -/
theorem inquiry_step_testing {q : Inspection} {s t : PooledEnvelopes.Situation}
    (step : PooledEnvelopes.inquiry.step s (some q) t) :
    ∃ a, (testing (queryLaw q)).step s.candidates a t.candidates :=
  match step with
  | ⟨a, h⟩ => ⟨a, (probe_some h).2.2⟩

end WitnessRefinementRuns

end Becoming
