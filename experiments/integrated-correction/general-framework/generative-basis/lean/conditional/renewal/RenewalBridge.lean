import Becoming.KeepableStep
import RenewalConfigurations

/-!
# RenewalBridge: October's renewability is keepability of being live

AI-written (Wave U5-C, 24 November 2026), landed from board row DJ / FM's `ScratchRenewalBridge`
(Claude, 21 November 2026, batch 23). It imports both sides: the package's `Keepable`
(`Becoming.JointKeeping`) with its one-step characterization (`Becoming.KeepableStep`), and
October's renewal module `RenewalConfigurations` (`conditional/renewal/`).

Both sides are stated over the one `Process` of `GenerativeCore`. October's `History law` and the
package's `Run (channelProcess law)` hold the same three things under other field names
(`states`, `ticks`, `steps`; `state`, `act`, `step`).

* **The same sequences.** `historyRun` and `runHistory` rename the fields; each way round returns
  what it was given, by `rfl` (`runHistory_historyRun`, `historyRun_runHistory`).
* **The bridge.** A configuration is renewable under a channel law exactly when being live is
  keepable from it under the law's process (`renewable_iff_keepable`). No premise.
* **October's viability statement, as a case.** `renewable_iff_step` has October's statement
  (`renewable_iff_step_same`, by `rfl`) and is proved from `keepable_step_iff` through the
  bridge. October's theorem is not called.
* **October's "not gained from within", as a case.** `renewability_not_generated` has October's
  statement (`renewability_not_generated_same`, by `rfl`) and is proved from `not_keepable_run`
  through the bridge, its premise met by October's `dead_stays_dead` (a configuration that is not
  live steps only to configurations that are not live). October's theorem is not called, and
  being live is not decided.

No premise is added beyond what each statement names.
-/

namespace Becoming

open Generative Generative.Conditional.Renewal

universe u

namespace Viability

namespace RenewalBridge

variable {Kind : Type u}

/-! ## The same sequences -/

/-- A history of a channel law, read as a run of the law's process: the same configurations,
the same births, the same steps. -/
def historyRun {law : ChannelLaw Kind} (H : History law) : Run (channelProcess law) :=
  ⟨H.states, H.ticks, H.steps⟩

/-- A run of a channel law's process, read as a history of the law. -/
def runHistory {law : ChannelLaw Kind} (r : Run (channelProcess law)) : History law :=
  ⟨r.state, r.act, r.step⟩

/-- A history read as a run and back is the history. No premise. -/
theorem runHistory_historyRun {law : ChannelLaw Kind} (H : History law) :
    runHistory (historyRun H) = H := rfl

/-- A run of a channel law's process read as a history and back is the run. No premise. -/
theorem historyRun_runHistory {law : ChannelLaw Kind} (r : Run (channelProcess law)) :
    historyRun (runHistory r) = r := rfl

/-! ## The bridge -/

/-- **The bridge.** For every channel law `law` and configuration `c`, with no further premise:
`c` is renewable under `law` (some history of `law` from `c` is live at every tick,
`Generative.Conditional.Renewal.Renewable`) exactly when being live is keepable from `c` under
`channelProcess law` (some run of that process from `c` stays live, `Keepable`). The two sides
name one sequence by other field names (`historyRun`, `runHistory`). -/
theorem renewable_iff_keepable {law : ChannelLaw Kind} {c : Config Kind} :
    Renewable law c ↔ Keepable (channelProcess law) Live c :=
  ⟨fun ⟨H, start, alive⟩ => ⟨historyRun H, start, alive⟩,
   fun ⟨r, start, held⟩ => ⟨runHistory r, start, held⟩⟩

/-! ## October's two statements, as cases -/

/-- **Viability, as a case of one step of keeping.** For every channel law `law` and
configuration `c`, with no further premise: `c` is renewable exactly when it is live and some
step of `channelProcess law` from `c` leads to a renewable configuration. The statement is
October's `Generative.Conditional.Renewal.renewable_iff_step` (`renewable_iff_step_same`); the
proof is `keepable_step_iff` at the process `channelProcess law` and the guard `Live`, carried
across `renewable_iff_keepable` on both sides. -/
theorem renewable_iff_step {law : ChannelLaw Kind} {c : Config Kind} :
    Renewable law c ↔
      Live c ∧ ∃ births c', (channelProcess law).step c births c' ∧ Renewable law c' :=
  ⟨fun renewable =>
    match keepable_step_iff.mp (renewable_iff_keepable.mp renewable) with
    | ⟨live, births, c', step, keepable⟩ =>
      ⟨live, births, c', step, renewable_iff_keepable.mpr keepable⟩,
   fun ⟨live, births, c', step, renewable⟩ =>
    renewable_iff_keepable.mpr
      (keepable_step_iff.mpr ⟨live, births, c', step, renewable_iff_keepable.mp renewable⟩)⟩

/-- **Renewability is not gained from within, as a case of keepability not gained along a
run.** Premises: `H` is a history of the channel law `law`; the configuration at its start is
not renewable (`start`). Conclusion: no configuration of `H` is renewable. The statement is
October's `Generative.Conditional.Renewal.renewability_not_generated`
(`renewability_not_generated_same`); the proof is `not_keepable_run` at the process
`channelProcess law`, the guard `Live` and the run `historyRun H`, its premise that every step
keeps the guard's complement being October's `dead_stays_dead`, carried across
`renewable_iff_keepable`. Being live is not decided. -/
theorem renewability_not_generated {law : ChannelLaw Kind} (H : History law)
    (start : ¬ Renewable law (H.states 0)) : ∀ n, ¬ Renewable law (H.states n) :=
  fun n renewable =>
    not_keepable_run (P := channelProcess law) (g := Live)
      (fun _ _ _ step dead => dead_stays_dead dead step) (historyRun H)
      (fun keepable => start (renewable_iff_keepable.mpr keepable)) n
      (renewable_iff_keepable.mp renewable)

/-! ## The statements are October's -/

/-- The statement of `renewable_iff_step` here is that of October's
`Generative.Conditional.Renewal.renewable_iff_step`: proofs of one proposition being equal, the
equation type-checks only where the two statements are the same. No premise. -/
theorem renewable_iff_step_same :
    @Becoming.Viability.RenewalBridge.renewable_iff_step.{u} =
      @Generative.Conditional.Renewal.renewable_iff_step.{u} := rfl

/-- The statement of `renewability_not_generated` here is that of October's
`Generative.Conditional.Renewal.renewability_not_generated`: proofs of one proposition being
equal, the equation type-checks only where the two statements are the same. No premise. -/
theorem renewability_not_generated_same :
    @Becoming.Viability.RenewalBridge.renewability_not_generated.{u} =
      @Generative.Conditional.Renewal.renewability_not_generated.{u} := rfl

end RenewalBridge

end Viability

end Becoming
